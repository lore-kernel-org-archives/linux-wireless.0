Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:45365 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbeBZLWR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 06:22:17 -0500
Received: by mail-wr0-f176.google.com with SMTP id p104so20763258wrc.12
        for <linux-wireless@vger.kernel.org>; Mon, 26 Feb 2018 03:22:16 -0800 (PST)
Subject: Re: [PATCH resend] brcmfmac: p2p and normal ap access are not always
 possible at the same time
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <20170526105747.16874-1-hdegoede@redhat.com>
 <20170526105747.16874-2-hdegoede@redhat.com>
 <8a61e3ad-3949-68dc-bed9-09f61ab6b647@redhat.com>
 <5A93DFF1.2030208@broadcom.com>
 <e204e0a3-4001-0d55-86ef-fb1afc1c6d4b@redhat.com>
 <5A93E8FC.10606@broadcom.com>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <5ee4884b-5278-472b-8da1-6bef8b9c61a9@redhat.com> (sfid-20180226_122237_470270_67270C1B)
Date: Mon, 26 Feb 2018 12:22:14 +0100
MIME-Version: 1.0
In-Reply-To: <5A93E8FC.10606@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 26-02-18 12:01, Arend van Spriel wrote:
> On 2/26/2018 11:29 AM, Hans de Goede wrote:
>> Hi,
>>
>> On 26-02-18 11:22, Arend van Spriel wrote:
>>> On 2/25/2018 3:52 PM, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 26-05-17 12:57, Hans de Goede wrote:
>>>>> The firmware responding with -EBUSY when trying to add an extra
>>>>> virtual-if
>>>>> is a normal thing, do not print an error for this.
>>>>>
>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>
>>>> I'm now seeing this on another device too, but this time the error
>>>> thrown is -EBADE, this seems to be new with recent kernels:
>>>
>>> Yup. Before we were passing firmware errors up to user-space, which
>>> was confusing and potentially be misinterpreted. However, looking at
>>> the output below it would have been good to log the firmware error as
>>> well. And staring at it some more I suddenly realize I broke the
>>> feature detection module with this change. Actually only the GSCAN
>>> feature detection.
>>>
>>>> [root@localhost ~]# dmesg | grep brcmfmac
>>>> [   34.265950] usbcore: registered new interface driver brcmfmac
>>>> [   34.266059] brcmfmac 0000:01:00.0: enabling device (0000 -> 0002)
>>>> [   34.376468] brcmfmac: brcmf_fw_map_chip_to_name: using
>>>> brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
>>>> [   34.855143] brcmfmac 0000:01:00.0: Direct firmware load for
>>>> brcm/brcmfmac4356-pcie.clm_blob failed with error -2
>>>> [   34.855147] brcmfmac: brcmf_c_process_clm_blob: no clm_blob
>>>> available(err=-2), device may have limited channels available
>>>> [   34.857029] brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0:
>>>> Jun  4 2017 16:50:07 version 7.35.101.6 (r702795) FWID 01-5e8eb735
>>>> [   34.938854] brcmfmac 0000:01:00.0 wlp1s0: renamed from wlan0
>>>> [   37.086420] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
>>>> [   37.086431] brcmfmac: brcmf_cfg80211_add_iface: add iface
>>>> p2p-dev-wlp1s0 type 10 failed: err=-52
>>>>
>>>> [root@localhost ~]# strings /lib/firmware/brcm/brcmfmac4356-pcie.bin |
>>>> tail -n 1
>>>> 4356a2-roml/pcie-ag-msgbuf-splitrx-p2p-pno-aoe-pktfilter-keepalive-sr-mchan-pktctx-proptxstatus-ampduhostreorder-lpc-pwropt-txbf-wl11u-mfp-tdls-amsdutx-sarctrl-proxd-hs20sta-rcc-wepso-ndoe-linkstat-gscan-hchk-logtrace-roamexp-rmon
>>>>
>>>> Version: 7.35.101.6 (r702795) CRC: 4f3f65c5 Date: Sun 2017-06-04
>>>> 16:51:38 PDT Ucode Ver: 963.316 FWID: 01-5e8eb735
>>>>
>>>> It would be good if we can silence these errors, or maybe at a
>>>> minimum lower their log-level from error to warning?
>>>
>>> I had a look at it and it seems to be a difference in firmware api
>>> that we need to support in the driver. Need to do a bit more digging,
>>> but it seems an actual issue. You could silence it for now, but I
>>> prefer to wait for the fix.
>>
>> Ok, what is the ETA of a fix for this?
> 
> Actually went back to an old log you sent and noticed:
> 
> [   15.714569] brcmfmac: brcmf_attach Enter
> [   15.714756] brcmfmac: brcmf_fweh_register event handler registered for PSM_WATCHDOG
> [   15.714757] brcmfmac: brcmf_proto_attach Enter
> [   15.716598] brcmfmac: brcmf_bus_started
> [   15.716603] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
> [   15.716604] brcmfmac: brcmf_add_if allocate netdev interface
> [   15.716622] brcmfmac: brcmf_add_if  ==== pid:2a, if:wlan%d (00:00:00:00:00:00) created ===
> [   15.716624] brcmfmac: brcmf_bus_change_state 0 -> 1
> [   15.717841] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=cur_etheraddr, len=6
> [   15.717843] brcmutil: data
> [   15.717847] 00000000: 44 2c 05 9e c9 02   D,....
> 
> So mac address of the device is 44:2c:05:9e:c9. However, further down I see:
> 
> [   17.819113] brcmfmac: brcmf_netdev_set_mac_address Enter, bsscfgidx=0
> [   17.819122] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=cur_etheraddr, len=6
> [   17.819127] brcmutil: data
> [   17.819135] 00000000: aa 3e 81 77 bc 40   .>.w.@
> [   17.819864] brcmfmac: brcmf_netdev_set_mac_address updated to aa:3e:81:77:bc:40
> 
> So the mac address in a local admin variant.

Right, this is likely NetworkManager randomizing the mac for privacy reasons.

> Now our firmware has a requirement for the p2p-dev interface that it should be different from the mac address of the primary interface, ie. wlp1s0 in this log. In brcmfmac we try to do that by setting the local admin bit, but... as it is already set we end up using the same mac address hence the -EBUSY.

Ah, that is good to know, so how can we fix this? Can userspace specify a
different mac-address when it asks for the p2p-dev intf to be created? Or
should we do something about this in the kernel?

Regards,

Hans


> [   17.947704] brcmfmac: brcmf_cfg80211_add_iface enter: p2p-dev-wlp1s0 type 10
> [   17.947714] brcmfmac: brcmf_p2p_add_vif adding vif "p2p-dev-wlp1s0" (type=10, addr=00:00:00:00:00:00)
> [   17.947716] brcmfmac: brcmf_alloc_vif allocating virtual interface (size=3920)
> [   17.947720] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=3, value=1
> [   17.948749] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=apsta, len=4
> [   17.948752] brcmutil: data
> [   17.948756] 00000000: 01 00 00 00   ....
> [   17.949620] brcmfmac: brcmf_fil_cmd_int_set ifidx=0, cmd=2, value=1
> [   17.984420] brcmfmac: brcmf_fweh_event_worker event IF (54) ifidx 0 bsscfg 0 addr aa:3e:81:77:bc:40
> [   17.984424] brcmfmac: brcmf_fweh_event_worker   version 2 flags 0 status 0 reason 0
> [   17.984427] brcmutil: event payload, len=5
> [   17.984430] 00000000: 00 01 00 00 00   .....
> [   17.984433] brcmfmac: brcmf_fweh_handle_if_event action: 1 ifidx: 0 bsscfgidx: 0 flags: 0 role: 0
> [   17.984435] brcmfmac: brcmf_fweh_handle_if_event adding wl0 (aa:3e:81:77:bc:40)
> [   17.984437] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
> [   17.984439] brcmfmac: brcmf_add_if netdev:wlp1s0 ignore IF event
> [   17.984646] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=p2p_disc, len=4
> [   17.984657] brcmutil: data
> [   17.984669] 00000000: 00 00 00 00   ....
> [   17.985123] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=p2p_da_override, len=6
> [   17.985131] brcmutil: data
> [   17.985140] 00000000: aa 3e 81 77 bc 40   .>.w.@
> [   17.985580] brcmfmac: brcmf_fil_iovar_data_set ifidx=0, name=p2p_disc, len=4
> [   17.985588] brcmutil: data
> [   17.985598] 00000000: 01 00 00 00   ....
> [   17.985975] brcmfmac: brcmf_fil_cmd_data Failed: BCME_BUSY (-16)
> [   17.985985] brcmfmac: brcmf_p2p_create_p2pdev set p2p_disc error
> [   17.985999] brcmfmac: brcmf_cfg80211_add_iface add iface p2p-dev-wlp1s0 type 10 failed: err=-16
> 
> Sorry that I missed that earlier :-(
> 
> Regards,
> Arend
> 
>> Regards,
>>
>> Hans
>>
>>
>>
>>
>>>>> ---
>>>>>   .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    | 14
>>>>> ++++++++++----
>>>>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c     |  5 ++++-
>>>>>   2 files changed, 14 insertions(+), 5 deletions(-)
>>>>>
>>>>> diff --git
>>>>> a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>>>> index cd1d6730eab7..dae88f3d041d 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>>>> @@ -684,11 +684,17 @@ static struct wireless_dev
>>>>> *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
>>>>>           return ERR_PTR(-EINVAL);
>>>>>       }
>>>>> -    if (IS_ERR(wdev))
>>>>> -        brcmf_err("add iface %s type %d failed: err=%d\n",
>>>>> -              name, type, (int)PTR_ERR(wdev));
>>>>> -    else
>>>>> +    if (IS_ERR(wdev)) {
>>>>> +        err = PTR_ERR(wdev);
>>>>> +        if (err != -EBUSY)
>>>>> +            brcmf_err("add iface %s type %d failed: err=%d\n",
>>>>> +                  name, type, err);
>>>>> +        else
>>>>> +            brcmf_dbg(INFO, "add iface %s type %d failed: err=%d\n",
>>>>> +                  name, type, err);
>>>>> +    } else {
>>>>>           brcmf_cfg80211_update_proto_addr_mode(wdev);
>>>>> +    }
>>>>>       return wdev;
>>>>>   }
>>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>>>> index aa299c47bfa2..1bb296ffb46f 100644
>>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>>>> @@ -2090,7 +2090,10 @@ static struct wireless_dev
>>>>> *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
>>>>>       /* Initialize P2P Discovery in the firmware */
>>>>>       err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
>>>>>       if (err < 0) {
>>>>> -        brcmf_err("set p2p_disc error\n");
>>>>> +        if (err != -EBUSY)
>>>>> +            brcmf_err("set p2p_disc error\n");
>>>>> +        else
>>>>> +            brcmf_dbg(INFO, "set p2p_disc error\n");
>>>>>           brcmf_fweh_p2pdev_setup(pri_ifp, false);
>>>>>           brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
>>>>>           goto fail;
>>>>>
>>>
> 
