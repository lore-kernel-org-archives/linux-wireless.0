Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:35914 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbeBZKWp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 05:22:45 -0500
Received: by mail-qt0-f169.google.com with SMTP id c7so18125249qtn.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 02:22:45 -0800 (PST)
Subject: Re: [PATCH resend] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170526105747.16874-1-hdegoede@redhat.com>
 <20170526105747.16874-2-hdegoede@redhat.com>
 <8a61e3ad-3949-68dc-bed9-09f61ab6b647@redhat.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A93DFF1.2030208@broadcom.com> (sfid-20180226_112249_571813_CCA644D2)
Date: Mon, 26 Feb 2018 11:22:41 +0100
MIME-Version: 1.0
In-Reply-To: <8a61e3ad-3949-68dc-bed9-09f61ab6b647@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/25/2018 3:52 PM, Hans de Goede wrote:
> Hi,
>
> On 26-05-17 12:57, Hans de Goede wrote:
>> The firmware responding with -EBUSY when trying to add an extra
>> virtual-if
>> is a normal thing, do not print an error for this.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
> I'm now seeing this on another device too, but this time the error
> thrown is -EBADE, this seems to be new with recent kernels:

Yup. Before we were passing firmware errors up to user-space, which was 
confusing and potentially be misinterpreted. However, looking at the 
output below it would have been good to log the firmware error as well. 
And staring at it some more I suddenly realize I broke the feature 
detection module with this change. Actually only the GSCAN feature 
detection.

> [root@localhost ~]# dmesg | grep brcmfmac
> [   34.265950] usbcore: registered new interface driver brcmfmac
> [   34.266059] brcmfmac 0000:01:00.0: enabling device (0000 -> 0002)
> [   34.376468] brcmfmac: brcmf_fw_map_chip_to_name: using
> brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
> [   34.855143] brcmfmac 0000:01:00.0: Direct firmware load for
> brcm/brcmfmac4356-pcie.clm_blob failed with error -2
> [   34.855147] brcmfmac: brcmf_c_process_clm_blob: no clm_blob
> available(err=-2), device may have limited channels available
> [   34.857029] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
> Jun  4 2017 16:50:07 version 7.35.101.6 (r702795) FWID 01-5e8eb735
> [   34.938854] brcmfmac 0000:01:00.0 wlp1s0: renamed from wlan0
> [   37.086420] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
> [   37.086431] brcmfmac: brcmf_cfg80211_add_iface: add iface
> p2p-dev-wlp1s0 type 10 failed: err=-52
>
> [root@localhost ~]# strings /lib/firmware/brcm/brcmfmac4356-pcie.bin |
> tail -n 1
> 4356a2-roml/pcie-ag-msgbuf-splitrx-p2p-pno-aoe-pktfilter-keepalive-sr-mchan-pktctx-proptxstatus-ampduhostreorder-lpc-pwropt-txbf-wl11u-mfp-tdls-amsdutx-sarctrl-proxd-hs20sta-rcc-wepso-ndoe-linkstat-gscan-hchk-logtrace-roamexp-rmon
> Version: 7.35.101.6 (r702795) CRC: 4f3f65c5 Date: Sun 2017-06-04
> 16:51:38 PDT Ucode Ver: 963.316 FWID: 01-5e8eb735
>
> It would be good if we can silence these errors, or maybe at a
> minimum lower their log-level from error to warning?

I had a look at it and it seems to be a difference in firmware api that 
we need to support in the driver. Need to do a bit more digging, but it 
seems an actual issue. You could silence it for now, but I prefer to 
wait for the fix.

Regards,
Arend

> Regards,
>
> Hans
>
>
>> ---
>>   .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14
>> ++++++++++----
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     |  5 ++++-
>>   2 files changed, 14 insertions(+), 5 deletions(-)
>>
>> diff --git
>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index cd1d6730eab7..dae88f3d041d 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -684,11 +684,17 @@ static struct wireless_dev
>> *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
>>           return ERR_PTR(-EINVAL);
>>       }
>> -    if (IS_ERR(wdev))
>> -        brcmf_err("add iface %s type %d failed: err=%d\n",
>> -              name, type, (int)PTR_ERR(wdev));
>> -    else
>> +    if (IS_ERR(wdev)) {
>> +        err = PTR_ERR(wdev);
>> +        if (err != -EBUSY)
>> +            brcmf_err("add iface %s type %d failed: err=%d\n",
>> +                  name, type, err);
>> +        else
>> +            brcmf_dbg(INFO, "add iface %s type %d failed: err=%d\n",
>> +                  name, type, err);
>> +    } else {
>>           brcmf_cfg80211_update_proto_addr_mode(wdev);
>> +    }
>>       return wdev;
>>   }
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> index aa299c47bfa2..1bb296ffb46f 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>> @@ -2090,7 +2090,10 @@ static struct wireless_dev
>> *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
>>       /* Initialize P2P Discovery in the firmware */
>>       err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
>>       if (err < 0) {
>> -        brcmf_err("set p2p_disc error\n");
>> +        if (err != -EBUSY)
>> +            brcmf_err("set p2p_disc error\n");
>> +        else
>> +            brcmf_dbg(INFO, "set p2p_disc error\n");
>>           brcmf_fweh_p2pdev_setup(pri_ifp, false);
>>           brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
>>           goto fail;
>>
