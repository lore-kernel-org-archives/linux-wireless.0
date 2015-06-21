Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33680 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbFUVSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2015 17:18:55 -0400
Received: by wiwl6 with SMTP id l6so20604675wiw.0
        for <linux-wireless@vger.kernel.org>; Sun, 21 Jun 2015 14:18:54 -0700 (PDT)
Message-ID: <55872A3C.7030704@gmail.com> (sfid-20150621_231859_390654_7AC64FFC)
Date: Sun, 21 Jun 2015 23:18:52 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cmcgS3JhdXNl?= <joerg.krause@embedded.rocks>,
	Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: Failed to create interface p2p-dev-p2p0: -28 (No space
 left on device)
References: <1433766944.28058.16.camel@embedded.rocks>					 <55758D7E.3000603@broadcom.com>			 <1433771289.28058.24.camel@embedded.rocks>			 <5575C6FA.6030104@broadcom.com>			 <1433794640.28058.26.camel@embedded.rocks>	 <557605CC.6070907@broadcom.com>	 <1434448766.21949.9.camel@embedded.rocks>	 <55803214.2030204@broadcom.com> <1434608018.5481.4.camel@embedded.rocks>	 <55828106.7060004@broadcom.com> <1434658050.2532.6.camel@embedded.rocks>
In-Reply-To: <1434658050.2532.6.camel@embedded.rocks>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-06-15 22:07, Jörg Krause wrote:
> On Do, 2015-06-18 at 10:27 +0200, Arend van Spriel wrote:
>> On 06/18/15 08:13, Jörg Krause wrote:
>>> Hi Arend,
>>>
>>> On Di, 2015-06-16 at 16:26 +0200, Arend van Spriel wrote:
>>>> On 06/16/15 11:59, Jörg Krause wrote:
>>>>> Hi Arend,
>>>>>
>>>>> as I wrote in my previous mail ("brcmfmac: 
>>>>> brcmf_p2p_create_p2pdev:
>>>>> timeout occurred") I get a p2p0 interface when loading the 
>>>>> brcmfmac
>>>>> module with p2pon=1 (Linux kernel 4.0.5, BCM43362).
>>>>>
>>>>> Unfortunatly, if I try to use the p2p0 interface with
>>>>> wpa_supplicant
>>>>> 2.4 I get an error:
>>>>>
>>>>>       Failed to create interface p2p-dev-p2p0: -28 (No space 
>>>>> left on
>>>>>       device)
>>>>>       nl80211: Failed to create a P2P Device interface p2p-dev
>>>>> -p2p0
>>>>>       P2P: Failed to enable P2P Device interface
>>>>
>>>> Using p2pon=1 is old-school p2p, ie. it creates a regular netdev 
>>>> for
>>>> doing p2p management stuff. Problem is that brcmfmac also 
>>>> indicates
>>>> p2p
>>>> device support. We can remove p2pon parameter or not indicate p2p 
>>>> dev
>>>>
>>>> support when p2pon=1.
>>>
>>> I used p2pon because the p2p0 interface is not created without it. 
>>> It
>>> fails with the error message "brcmf_p2p_create_p2pdev: timeout
>>> occurred" as written in my previous mails. I would prefer not to 
>>> use
>>> it, so maybe we can find a solution how to get it working without 
>>> it.
>>
>> 43362 firmware may have issues with regular p2p dev support so let's 
>> stick with p2pon for now.
> 
> Okay.
> 
>>>>
>>>> Can you patch brcmfmac and give it a try. Need to start
>>>> wpa_supplicant
>>>> for two interface and if I recall correctly p2p0 must be 
>>>> specified
>>>> first.
>>>
>>> Can you give me a hint where to patch brcmfmac. Many thanks!
>>
>> Attached is patch against 4.0.5 kernel.
> 
> I applied the patch and if I load brcmfmac with p2pon=1 I get a kernel
> warning and _no_ wlan0 and p2p0 interfaces:
> 
>     [    7.577223] ------------[ cut here ]------------
>     [    7.583144] WARNING: CPU: 0 PID: 4 at net/wireless/core.c:527
>     wiphy_register+0x3a4/0x67c()
>     [    7.594652] Modules linked in: brcmfmac brcmutil
>     [    7.601507] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 4.0.5
>     -LINTECH #3
>     [    7.610809] Hardware name: Freescale MXS (Device Tree)
>     [    7.617411] Workqueue: events request_firmware_work_func
>     [    7.625110] [<c000dec8>] (unwind_backtrace) from [<c000c25c>]
>     (show_stack+0x10/0x14)
>     [    7.635541] [<c000c25c>] (show_stack) from [<c001613c>]
>     (warn_slowpath_common+0x78/0xb0)
>     [    7.645171] [<c001613c>] (warn_slowpath_common) from
>     [<c0016210>] (warn_slowpath_null+0x1c/0x24)
>     [    7.656635] [<c0016210>] (warn_slowpath_null) from [<c03b6f20>]
>     (wiphy_register+0x3a4/0x67c)
>     [    7.666657] [<c03b6f20>] (wiphy_register) from [<bf00de20>]
>     (brcmf_cfg80211_attach+0x86c/0x1124 [brcmfmac])
>     [    7.679412] [<bf00de20>] (brcmf_cfg80211_attach [brcmfmac]) from
>     [<bf018f3c>] (brcmf_bus_start+0xac/0x29c [brcmfmac])
>     [    7.690925] [<bf018f3c>] (brcmf_bus_start [brcmfmac]) from
>     [<bf01dd00>] (brcmf_sdio_firmware_callback+0x3d8/0x9e8 [brcmfmac])
>     [    7.705622] [<bf01dd00>] (brcmf_sdio_firmware_callback
>     [brcmfmac]) from [<bf0195fc>]
>     (brcmf_fw_request_nvram_done+0x134/0x1d0 [brcmfmac])
>     [    7.718916] [<bf0195fc>] (brcmf_fw_request_nvram_done
>     [brcmfmac]) from [<c020ab88>]
>     (request_firmware_work_func+0x30/0x50)
>     [    7.733292] [<c020ab88>] (request_firmware_work_func) from
>     [<c0029a98>] (process_one_work+0x184/0x418)
>     [    7.744112] [<c0029a98>] (process_one_work) from [<c002a694>]
>     (worker_thread+0x3c/0x464)
>     [    7.754977] [<c002a694>] (worker_thread) from [<c002e130>]
>     (kthread+0xc0/0xdc)
>     [    7.763730] [<c002e130>] (kthread) from [<c0009730>]
>     (ret_from_fork+0x14/0x24)
>     [    7.773568] ---[ end trace 39ec555e61fc038e ]---
>     [    7.779710] brcmfmac: brcmf_cfg80211_attach: Could not register
>     wiphy device (-22)
>     [    7.790013] brcmfmac: brcmf_bus_start: failed: -12
>     [    7.800278] brcmfmac: brcmf_sdio_firmware_callback: dongle is
>     not responding

My bad. The patch removes p2pdev from interface modes, but it is still
listed in the interface combinations and cfg80211 will complain about
it. Have to extend the patch. I better do that after a good nights sleep.

Regards,
Arend

> Best regards
> Jörg Krause
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
