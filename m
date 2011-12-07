Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:38160 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab1LGSSD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 13:18:03 -0500
Received: by qadb15 with SMTP id b15so822174qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2011 10:18:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323257717.3404.13.camel@jlt3.sipsolutions.net>
References: <1323257717.3404.13.camel@jlt3.sipsolutions.net>
Date: Wed, 7 Dec 2011 10:18:01 -0800
Message-ID: <CAAKGvm4hYsf2RNU-fakHiN6OUMuH9jT-CHsxROgJc60snc8MSg@mail.gmail.com> (sfid-20111207_191807_599704_45A07D59)
Subject: Re: [PATCH] mac80211_hwsim: fix wmediumd_pid
From: =?ISO-8859-1?Q?Javier_L=F3pez?= <jlopex@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I agree with all the proposed changes.

Thanks Johannes

Cheers,

On Wed, Dec 7, 2011 at 3:35 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> Fix a few minor issues with wmediumd_pid:
> a) make static
> b) use u32 to match the snd_pid type
> c) use ACCESS_ONCE since we don't lock it
> d) don't explicitly initialize to 0
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  drivers/net/wireless/mac80211_hwsim.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> --- a/drivers/net/wireless/mac80211_hwsim.c     2011-12-07 09:11:40.000000000 +0100
> +++ b/drivers/net/wireless/mac80211_hwsim.c     2011-12-07 12:32:26.000000000 +0100
> @@ -37,7 +37,8 @@ MODULE_AUTHOR("Jouni Malinen");
>  MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
>  MODULE_LICENSE("GPL");
>
> -int wmediumd_pid;
> +static u32 wmediumd_pid;
> +
>  static int radios = 2;
>  module_param(radios, int, 0444);
>  MODULE_PARM_DESC(radios, "Number of simulated radios");
> @@ -665,7 +666,7 @@ static void mac80211_hwsim_tx(struct iee
>  {
>        bool ack;
>        struct ieee80211_tx_info *txi;
> -       int _pid;
> +       u32 _pid;
>
>        mac80211_hwsim_monitor_rx(hw, skb);
>
> @@ -676,7 +677,7 @@ static void mac80211_hwsim_tx(struct iee
>        }
>
>        /* wmediumd mode check */
> -       _pid = wmediumd_pid;
> +       _pid = ACCESS_ONCE(wmediumd_pid);
>
>        if (_pid)
>                return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
> @@ -764,7 +765,7 @@ static void mac80211_hwsim_beacon_tx(voi
>        struct ieee80211_hw *hw = arg;
>        struct sk_buff *skb;
>        struct ieee80211_tx_info *info;
> -       int _pid;
> +       u32 _pid;
>
>        hwsim_check_magic(vif);
>
> @@ -781,7 +782,7 @@ static void mac80211_hwsim_beacon_tx(voi
>        mac80211_hwsim_monitor_rx(hw, skb);
>
>        /* wmediumd mode check */
> -       _pid = wmediumd_pid;
> +       _pid = ACCESS_ONCE(wmediumd_pid);
>
>        if (_pid)
>                return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
> @@ -1254,7 +1255,7 @@ static void hwsim_send_ps_poll(void *dat
>        struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
>        struct sk_buff *skb;
>        struct ieee80211_pspoll *pspoll;
> -       int _pid;
> +       u32 _pid;
>
>        if (!vp->assoc)
>                return;
> @@ -1275,7 +1276,7 @@ static void hwsim_send_ps_poll(void *dat
>        memcpy(pspoll->ta, mac, ETH_ALEN);
>
>        /* wmediumd mode check */
> -       _pid = wmediumd_pid;
> +       _pid = ACCESS_ONCE(wmediumd_pid);
>
>        if (_pid)
>                return mac80211_hwsim_tx_frame_nl(data->hw, skb, _pid);
> @@ -1292,7 +1293,7 @@ static void hwsim_send_nullfunc(struct m
>        struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
>        struct sk_buff *skb;
>        struct ieee80211_hdr *hdr;
> -       int _pid;
> +       u32 _pid;
>
>        if (!vp->assoc)
>                return;
> @@ -1314,7 +1315,7 @@ static void hwsim_send_nullfunc(struct m
>        memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
>
>        /* wmediumd mode check */
> -       _pid = wmediumd_pid;
> +       _pid = ACCESS_ONCE(wmediumd_pid);
>
>        if (_pid)
>                return mac80211_hwsim_tx_frame_nl(data->hw, skb, _pid);
> @@ -1634,8 +1635,6 @@ static int hwsim_init_netlink(void)
>        int rc;
>        printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
>
> -       wmediumd_pid = 0;
> -
>        rc = genl_register_family_with_ops(&hwsim_genl_family,
>                hwsim_ops, ARRAY_SIZE(hwsim_ops));
>        if (rc)
>
>



--
Javier López
