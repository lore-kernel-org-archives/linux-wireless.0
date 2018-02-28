Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f178.google.com ([209.85.128.178]:38410 "EHLO
        mail-wr0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752395AbeB1OwL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 09:52:11 -0500
Received: by mail-wr0-f178.google.com with SMTP id n7so2714488wrn.5
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 06:52:10 -0800 (PST)
From: Hans de Goede <hdegoede@redhat.com>
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
 <5ee4884b-5278-472b-8da1-6bef8b9c61a9@redhat.com>
 <5A949271.3090406@broadcom.com>
Message-ID: <b3322e2b-c899-bf30-077e-fb20cddc56e8@redhat.com> (sfid-20180228_155214_978732_85E98401)
Date: Wed, 28 Feb 2018 15:52:08 +0100
MIME-Version: 1.0
In-Reply-To: <5A949271.3090406@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 27-02-18 00:04, Arend van Spriel wrote:
> On 2/26/2018 12:22 PM, Hans de Goede wrote:
>> Hi,
>>
>> On 26-02-18 12:01, Arend van Spriel wrote:
>>> On 2/26/2018 11:29 AM, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 26-02-18 11:22, Arend van Spriel wrote:
>>>>> On 2/25/2018 3:52 PM, Hans de Goede wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 26-05-17 12:57, Hans de Goede wrote:
>>>>>>> The firmware responding with -EBUSY when trying to add an extra
>>>>>>> virtual-if
>>>>>>> is a normal thing, do not print an error for this.
>>>>>>>
>>>>>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>>>>>
>>>>>> I'm now seeing this on another device too, but this time the error
>>>>>> thrown is -EBADE, this seems to be new with recent kernels:
>>>>>
>>>>> Yup. Before we were passing firmware errors up to user-space, which
>>>>> was confusing and potentially be misinterpreted. However, looking at
>>>>> the output below it would have been good to log the firmware error as
>>>>> well. And staring at it some more I suddenly realize I broke the
>>>>> feature detection module with this change. Actually only the GSCAN
>>>>> feature detection.
>>>>>
>>>>>> [root@localhost ~]# dmesg | grep brcmfmac
>>>>>> [   34.265950] usbcore: registered new interface driver brcmfmac
>>>>>> [   34.266059] brcmfmac 0000:01:00.0: enabling device (0000 -> 0002)
>>>>>> [   34.376468] brcmfmac: brcmf_fw_map_chip_to_name: using
>>>>>> brcm/brcmfmac4356-pcie.bin for chip 0x004356(17238) rev 0x000002
>>>>>> [   34.855143] brcmfmac 0000:01:00.0: Direct firmware load for
>>>>>> brcm/brcmfmac4356-pcie.clm_blob failed with error -2
>>>>>> [   34.855147] brcmfmac: brcmf_c_process_clm_blob: no clm_blob
>>>>>> available(err=-2), device may have limited channels available
>>>>>> [   34.857029] brcmfmac: brcmf_c_preinit_dcmds: Firmware version =
>>>>>> wl0:
>>>>>> Jun  4 2017 16:50:07 version 7.35.101.6 (r702795) FWID 01-5e8eb735
>>>>>> [   34.938854] brcmfmac 0000:01:00.0 wlp1s0: renamed from wlan0
>>>>>> [   37.086420] brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
>>>>>> [   37.086431] brcmfmac: brcmf_cfg80211_add_iface: add iface
>>>>>> p2p-dev-wlp1s0 type 10 failed: err=-52
>>>>>>
>>>>>> [root@localhost ~]# strings /lib/firmware/brcm/brcmfmac4356-pcie.bin |
>>>>>> tail -n 1
>>>>>> 4356a2-roml/pcie-ag-msgbuf-splitrx-p2p-pno-aoe-pktfilter-keepalive-sr-mchan-pktctx-proptxstatus-ampduhostreorder-lpc-pwropt-txbf-wl11u-mfp-tdls-amsdutx-sarctrl-proxd-hs20sta-rcc-wepso-ndoe-linkstat-gscan-hchk-logtrace-roamexp-rmon
>>>>>>
>>>>>>
>>>>>> Version: 7.35.101.6 (r702795) CRC: 4f3f65c5 Date: Sun 2017-06-04
>>>>>> 16:51:38 PDT Ucode Ver: 963.316 FWID: 01-5e8eb735
>>>>>>
>>>>>> It would be good if we can silence these errors, or maybe at a
>>>>>> minimum lower their log-level from error to warning?
>>>>>
>>>>> I had a look at it and it seems to be a difference in firmware api
>>>>> that we need to support in the driver. Need to do a bit more digging,
>>>>> but it seems an actual issue. You could silence it for now, but I
>>>>> prefer to wait for the fix.
>>>>
>>>> Ok, what is the ETA of a fix for this?
>>>
>>> Actually went back to an old log you sent and noticed:
>>>
>>> [   15.714569] brcmfmac: brcmf_attach Enter
>>> [   15.714756] brcmfmac: brcmf_fweh_register event handler registered
>>> for PSM_WATCHDOG
>>> [   15.714757] brcmfmac: brcmf_proto_attach Enter
>>> [   15.716598] brcmfmac: brcmf_bus_started
>>> [   15.716603] brcmfmac: brcmf_add_if Enter, bsscfgidx=0, ifidx=0
>>> [   15.716604] brcmfmac: brcmf_add_if allocate netdev interface
>>> [   15.716622] brcmfmac: brcmf_add_if  ==== pid:2a, if:wlan%d
>>> (00:00:00:00:00:00) created ===
>>> [   15.716624] brcmfmac: brcmf_bus_change_state 0 -> 1
>>> [   15.717841] brcmfmac: brcmf_fil_iovar_data_get ifidx=0,
>>> name=cur_etheraddr, len=6
>>> [   15.717843] brcmutil: data
>>> [   15.717847] 00000000: 44 2c 05 9e c9 02   D,....
>>>
>>> So mac address of the device is 44:2c:05:9e:c9. However, further down
>>> I see:
>>>
>>> [   17.819113] brcmfmac: brcmf_netdev_set_mac_address Enter, bsscfgidx=0
>>> [   17.819122] brcmfmac: brcmf_fil_iovar_data_set ifidx=0,
>>> name=cur_etheraddr, len=6
>>> [   17.819127] brcmutil: data
>>> [   17.819135] 00000000: aa 3e 81 77 bc 40   .>.w.@
>>> [   17.819864] brcmfmac: brcmf_netdev_set_mac_address updated to
>>> aa:3e:81:77:bc:40
>>>
>>> So the mac address in a local admin variant.
>>
>> Right, this is likely NetworkManager randomizing the mac for privacy
>> reasons.
>>
>>> Now our firmware has a requirement for the p2p-dev interface that it
>>> should be different from the mac address of the primary interface, ie.
>>> wlp1s0 in this log. In brcmfmac we try to do that by setting the local
>>> admin bit, but... as it is already set we end up using the same mac
>>> address hence the -EBUSY.
>>
>> Ah, that is good to know, so how can we fix this? Can userspace specify a
>> different mac-address when it asks for the p2p-dev intf to be created? Or
>> should we do something about this in the kernel?
> 
> So this is the patch I tested. Maybe you can verify it works for you as well.

I can confirm that this fixes the errors, but I do not think that this is a good
solution, using the permanent mac address for the p2p interface has the same
privacy problem as using it regularly. IMHO it would be best to just generate
a random mac address if none is specified. This is what the kernel seems to do
in general when it needs a mac address and none is specified. You can use the
eth_random_addr(u8 *addr) function for this, which will also set the local
admin bit for you already.

Regards,

Hans

> 
> Regards,
> Arend
> ---
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index 2ee5413..ddbb386 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -462,8 +462,8 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
>    * @dev_addr: optional device address.
>    *
>    * P2P needs mac addresses for P2P device and interface. If no device
> - * address it specified, these are derived from the primary net device, ie.
> - * the permanent ethernet address of the device.
> + * address it specified, these are derived from the permanent ethernet
> + * address of the device.
>    */
>   static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
>   {
> @@ -471,12 +471,12 @@ static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
>       bool local_admin = false;
> 
>       if (!dev_addr || is_zero_ether_addr(dev_addr)) {
> -        dev_addr = pri_ifp->mac_addr;
> +        dev_addr = pri_ifp->drvr->mac;
>           local_admin = true;
>       }
> 
>       /* Generate the P2P Device Address.  This consists of the device's
> -     * primary MAC address with the locally administered bit set.
> +     * permanent ethernet address with the locally administered bit set.
>        */
>       memcpy(p2p->dev_addr, dev_addr, ETH_ALEN);
>       if (local_admin)
> @@ -486,7 +486,7 @@ static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p, u8 *dev_addr)
>        * BSSCFGs need to simultaneously co-exist, then this address must be
>        * different from the P2P Device Address, but also locally administered.
>        */
> -    memcpy(p2p->int_addr, p2p->dev_addr, ETH_ALEN);
> +    memcpy(p2p->int_addr, dev_addr, ETH_ALEN);
>       p2p->int_addr[0] |= 0x02;
>       p2p->int_addr[4] ^= 0x80;
>   }
> 
> 
