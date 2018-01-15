Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:44417 "EHLO
        mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbeAOTsx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 14:48:53 -0500
Received: by mail-qt0-f169.google.com with SMTP id m59so15548305qte.11
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 11:48:53 -0800 (PST)
Subject: Re: brcmfmac: set p2p_disc error on BCM4350
To: William Dauchy <wdauchy@gmail.com>
References: <CAJ75kXYLOV8aVZpftBFRbMv=KCaxCoQpJFaL0m0QDjVOytq3Vg@mail.gmail.com>
 <5A533A88.1000804@broadcom.com> <20180108103012.GA1957@paf>
 <20180115102938.GA29421@paf>
Cc: linux-wireless@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A5D05A2.3010604@broadcom.com> (sfid-20180115_204858_215940_642D7CE8)
Date: Mon, 15 Jan 2018 20:48:50 +0100
MIME-Version: 1.0
In-Reply-To: <20180115102938.GA29421@paf>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1/15/2018 11:29 AM, William Dauchy wrote:
> Hello Arend,
>
> Did you had the chance to look into this?

Thanks for the ping, but no not really. I just noticed the mac address 
in the p2p-dev create request is the null address and I recall that is 
handled, but I will need to look into that. I will get back to you if I 
have done so. Feel free to ping again when it is taking to long ;-)

Now the error is only an issue if you intend to setup a P2P connection 
with some other device. For running in station or AP mode you can ignore 
this. So if you have any specific issue and suspect this to be causing 
it, please elaborate on the specific issue you see.

Regards,
Arend

> On Mon, Jan 08, 2018 at 11:30:12AM +0100, William Dauchy wrote:
>> Hello Arend,
>>
>> Thanks for your quick answer.
>>
>> On Mon, Jan 08, 2018 at 10:31:52AM +0100, Arend van Spriel wrote:
>>> This has been reported before, but not been able to look into it. Diving
>>> into firmware it seems that error can only occur if the mac address for the
>>> p2pdev interface is already used. So if possible can you rebuild the driver
>>> with the patch below applied and provide dmesg output and output of
>>> 'ifconfig -a'.
>>>
>>> Regards,
>>> Arend
>>> ---8<----------------------------------------------------------------
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>> b/drivers/n
>>> index 2ee5413..f96ad37 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
>>> @@ -2065,6 +2065,7 @@ static struct wireless_dev
>>> *brcmf_p2p_create_p2pdev(struc
>>>          int err;
>>>          u32 bsscfgidx;
>>>
>>> +       brcmf_err("enter: mac=%pM\n", addr);
>>>          if (p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
>>>                  return ERR_PTR(-ENOSPC);
>>>
>>>
>>
>> Here is my brcmfmac dmesg output with patch applied
>> (please tell me if you need complete dmesg)
>>
>> brcmfmac: brcmf_fw_map_chip_to_name: using brcm/brcmfmac4350-pcie.bin for chip 0x004350(17232) rev 0x000008
>> brcmfmac 0000:3a:00.0: Direct firmware load for brcm/brcmfmac4350-pcie.txt failed with error -2
>> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 22 2015 06:16:26 version 7.35.180.119 (r594535) FWID 01-e791c176
>> brcmfmac 0000:3a:00.0 wlp58s0: renamed from wlan0
>> brcmfmac: brcmf_p2p_create_p2pdev: enter: mac=00:00:00:00:00:00
>> brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
>> brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlp58s0 type 10 failed: err=-16
>>
>> ifconfig shows:
>>
>> wlp58s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
>>          inet 192.168.18.77  netmask 255.255.255.0  broadcast 192.168.18.255
>>          inet6 fe80::3517:e1be:5bc7:899  prefixlen 64  scopeid 0x20<link>
>>          ether 30:52:cb:83:71:33  txqueuelen 1000  (Ethernet)
>>          RX packets 26557  bytes 34149730 (32.5 MiB)
>>          RX errors 0  dropped 0  overruns 0  frame 0
>>          TX packets 14965  bytes 2298777 (2.1 MiB)
>>          TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
>
> Best,
>
