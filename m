Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35299 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685Ab2EJI6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 04:58:19 -0400
Received: by vbbff1 with SMTP id ff1so1261960vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 01:58:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201205100719.q4A7JwVl003140@mail.maya.org>
References: <201205100719.q4A7JwVl003140@mail.maya.org>
Date: Thu, 10 May 2012 10:58:18 +0200
Message-ID: <CAOZOX0VfLrqBwfcqf5qsSnA4EH00-6tmG8te3M-WVAR8NqcFSw@mail.gmail.com> (sfid-20120510_105826_808496_2489F3CF)
Subject: Re: [rt2x00-users] [PATCH][RFC/RFT] rt2800: Implement selectable
 support for 802.11w (MFP)
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, May 10, 2012 at 9:19 AM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> This patch adds support for 802.11w for rt2800. This is achieved by
> using the 802.11w implementation in mac80211.
>
> To get this working, it is necessary to disable hw encryption of
> rt2800pci / rt2800usb, because I don't know of any support in hardware
> for 802.11w and therefore let mac80211 do the whole job.
>
> The user can enable 802.11w with the new mod parameter enablemfp.
> Enabling MFP disables hw encryption.
>
> 802.11w is deactivated per default.
>
> Tested with rt2860 and rt3572.
>
> This is a workaround as long as there isn't hardware support implemented
> in the driver.
>
> Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>
> ---
> diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c
> --- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c     2012-04-26 22:10:30.000000000 +0200
> +++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c  2012-05-09 11:37:48.463278177 +0200
> @@ -4519,6 +4519,15 @@
>            IEEE80211_HW_AMPDU_AGGREGATION |
>            IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>
> +       /*
> +        * Enable support for 802.11w in mac80211. hwencryption must be disabled
> +        */
> +       if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags) && rt2x00dev->mfprequested) {
> +               INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
> +               rt2x00dev->hw->flags |=
> +                       IEEE80211_HW_MFP_CAPABLE;
> +       }

Can't the whole patch be simplified into

if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags)) {
               INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
               rt2x00dev->hw->flags |=
                       IEEE80211_HW_MFP_CAPABLE;
}

Why need a extra moduleflag when all it does is toggle the nohwcrypto
module parameter?

>        /*
>         * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
>         * unless we are capable of sending the buffered frames out after the
> diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800pci.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800pci.c
> --- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800pci.c     2012-04-26 22:10:30.000000000 +0200
> +++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800pci.c  2012-05-09 13:29:47.159979903 +0200
> @@ -54,6 +54,13 @@
>  module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
>  MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>
> +/*
> + * Enable support for 802.11w / MFP
> + */
> +static bool modparam_enablemfp = false;
> +module_param_named(enablemfp, modparam_enablemfp, bool, S_IRUGO);
> +MODULE_PARM_DESC(enablemfp, "Enable 802.11w / MFP support. Hardware encryption gets disabled.");
> +
>  static void rt2800pci_mcu_status(struct rt2x00_dev *rt2x00dev, const u8 token)
>  {
>        unsigned int i;
> @@ -989,6 +996,8 @@
>        if (retval)
>                return retval;
>
> +       rt2x00dev->mfprequested = modparam_enablemfp ? 1 : 0;

If enablemfp is already a boolean, why need the ? 1 : 0 statement?
And the changes here are really needed (see earlier comment)
can't the mfprequested bit not be a flag in the cap_flags or something?

>        /*
>         * Initialize hw specifications.
>         */
> @@ -1018,8 +1027,14 @@
>        __set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
>        __set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
>        __set_bit(REQUIRE_TASKLET_CONTEXT, &rt2x00dev->cap_flags);
> -       if (!modparam_nohwcrypt)
> +
> +       if (!modparam_nohwcrypt && !modparam_enablemfp) {
> +               INFO(rt2x00dev, "hw encryption enabled.\n");
>                __set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
> +               }
> +       else
> +               INFO(rt2x00dev, "hw encryption disabled. See modparams nohwcrypt or enablemfp.\n");
> +
>        __set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
>        __set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
>
> diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800usb.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800usb.c
> --- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800usb.c     2012-04-26 22:10:30.000000000 +0200
> +++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800usb.c  2012-05-09 13:38:26.633954818 +0200
> @@ -50,6 +50,13 @@
>  MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>
>  /*
> + * Allow support for 802.11w / MFP to be enabled
> + */
> +static bool modparam_enablemfp = false;
> +module_param_named(enablemfp, modparam_enablemfp, bool, S_IRUGO);
> +MODULE_PARM_DESC(enablemfp, "Enable 802.11w / MFP support. Hardware encryption gets disabled.");
> +
> +/*
>  * Queue handlers.
>  */
>  static void rt2800usb_start_queue(struct data_queue *queue)
> @@ -748,6 +755,8 @@
>        if (retval)
>                return retval;
>
> +       rt2x00dev->mfprequested = modparam_enablemfp ? 1 : 0;
> +
>        /*
>         * Initialize hw specifications.
>         */
> @@ -767,8 +776,14 @@
>         */
>        __set_bit(REQUIRE_FIRMWARE, &rt2x00dev->cap_flags);
>        __set_bit(REQUIRE_L2PAD, &rt2x00dev->cap_flags);
> -       if (!modparam_nohwcrypt)
> +
> +       if (!modparam_nohwcrypt && !modparam_enablemfp) {
> +               INFO(rt2x00dev, "hw encryption enabled.\n");
>                __set_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags);
> +       }
> +       else
> +               INFO(rt2x00dev, "hw encryption disabled. See modparams nohwcrypt or enablemfp.\n");
> +
>        __set_bit(CAPABILITY_LINK_TUNING, &rt2x00dev->cap_flags);
>        __set_bit(REQUIRE_HT_TX_DESC, &rt2x00dev->cap_flags);
>        __set_bit(REQUIRE_TXSTATUS_FIFO, &rt2x00dev->cap_flags);
> diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2x00.h compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2x00.h
> --- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2x00.h        2012-04-26 22:10:30.000000000 +0200
> +++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2x00.h     2012-05-09 11:10:56.733118518 +0200
> @@ -821,6 +821,11 @@
>        struct hw_mode_spec spec;
>
>        /*
> +        * 802.11w (MFP) support requested by module parameter
> +        */
> +       u8 mfprequested;
> +
> +       /*
>         * This is the default TX/RX antenna setup as indicated
>         * by the device's EEPROM.
>         */
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
