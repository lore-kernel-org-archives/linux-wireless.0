Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36568 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751792AbeBYOwh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Feb 2018 09:52:37 -0500
Received: by mail-wm0-f67.google.com with SMTP id 188so12095586wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Feb 2018 06:52:36 -0800 (PST)
Subject: Re: [PATCH resend] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526105747.16874-1-hdegoede@redhat.com>
 <20170526105747.16874-2-hdegoede@redhat.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <8a61e3ad-3949-68dc-bed9-09f61ab6b647@redhat.com> (sfid-20180225_155241_597552_B4842BCE)
Date: Sun, 25 Feb 2018 15:52:34 +0100
MIME-Version: 1.0
In-Reply-To: <20170526105747.16874-2-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 26-05-17 12:57, Hans de Goede wrote:
> The firmware responding with -EBUSY when trying to add an extra virtual-if
> is a normal thing, do not print an error for this.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I'm now seeing this on another device too, but this time the error
thrown is -EBADE, this seems to be new with recent kernels:

[root@localhost ~]# dmesg | grep brcmfmac
[   34.265950] usbcore: registered new interface driver brcmfmac
[   34.266059] brcmfmac 0000:01:00.0: enabling device (0000 -> 0002)
[   34.376468] brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
[   34.855143] brcmfmac 0000:01:00.0: Direct firmware load for brcm/brcmfmac4356-pcie.clm_blob failed with error -2
[   34.855147] brcmfmac: brcmf_c_process_clm_blob: no clm_blob available(err=-2), device may have limited channels available
[   34.857029] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jun  4 2017 16:50:07 version 7.35.101.6 (r702795) FWID 01-5e8eb735
[   34.938854] brcmfmac 0000:01:00.0 wlp1s0: renamed from wlan0
[   37.086420] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
[   37.086431] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlp1s0 type 10 failed: err=-52

[root@localhost ~]# strings /lib/firmware/brcm/brcmfmac4356-pcie.bin | tail -n 1
4356a2-roml/pcie-ag-msgbuf-splitrx-p2p-pno-aoe-pktfilter-keepalive-sr-mchan-pktctx-proptxstatus-ampduhostreorder-lpc-pwropt-txbf-wl11u-mfp-tdls-amsdutx-sarctrl-proxd-hs20sta-rcc-wepso-ndoe-linkstat-gscan-hchk-logtrace-roamexp-rmon Version: 7.35.101.6 (r702795) CRC: 4f3f65c5 Date: Sun 2017-06-04 16:51:38 PDT Ucode Ver: 963.316 FWID: 01-5e8eb735

It would be good if we can silence these errors, or maybe at a
minimum lower their log-level from error to warning?

Regards,

Hans


> ---
>   .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14 ++++++++++----
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     |  5 ++++-
>   2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index cd1d6730eab7..dae88f3d041d 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -684,11 +684,17 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
>   		return ERR_PTR(-EINVAL);
>   	}
>   
> -	if (IS_ERR(wdev))
> -		brcmf_err("add iface %s type %d failed: err=%d\n",
> -			  name, type, (int)PTR_ERR(wdev));
> -	else
> +	if (IS_ERR(wdev)) {
> +		err = PTR_ERR(wdev);
> +		if (err != -EBUSY)
> +			brcmf_err("add iface %s type %d failed: err=%d\n",
> +				  name, type, err);
> +		else
> +			brcmf_dbg(INFO, "add iface %s type %d failed: err=%d\n",
> +				  name, type, err);
> +	} else {
>   		brcmf_cfg80211_update_proto_addr_mode(wdev);
> +	}
>   
>   	return wdev;
>   }
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index aa299c47bfa2..1bb296ffb46f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -2090,7 +2090,10 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
>   	/* Initialize P2P Discovery in the firmware */
>   	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
>   	if (err < 0) {
> -		brcmf_err("set p2p_disc error\n");
> +		if (err != -EBUSY)
> +			brcmf_err("set p2p_disc error\n");
> +		else
> +			brcmf_dbg(INFO, "set p2p_disc error\n");
>   		brcmf_fweh_p2pdev_setup(pri_ifp, false);
>   		brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
>   		goto fail;
> 
