Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:34188 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936243AbcIOO1f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 10:27:35 -0400
Received: by mail-lf0-f43.google.com with SMTP id u14so39437323lfd.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2016 07:27:34 -0700 (PDT)
Subject: Re: AMPDU stalls with brcmfmac4366b-pcie.bin triggering WARNINGs
To: Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        brcm80211-dev-list@broadcom.com
References: <3220e8ef-ee12-0b98-832a-819f980634c7@broadcom.com>
 <20160915114836.12364-1-zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <e4a13355-a25f-e1cf-5078-4effa11c5e37@gmail.com> (sfid-20160915_163023_765848_A62CB72C)
Date: Thu, 15 Sep 2016 16:27:29 +0200
MIME-Version: 1.0
In-Reply-To: <20160915114836.12364-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/15/2016 01:48 PM, Rafał Miłecki wrote:
> On 09/14/2016 08:28 PM, Arend Van Spriel wrote:
>> It would be great to have a timestamp for these skb when they arrive in
>> brcmfmac or transferred to firmware (or both).
>
> You ask and you have it :) I saved kernel's local time and printed it the same
> way print_time function does it. Let me paste the most important lines:
> [ 1876.496770] brcmfmac: CONSOLE: 028605.731 wl0: wlc_ampdu_watchdog: cleaning up ini tid 0 due to no progress for 2 secs tx_in_transit 1
> [ 1877.958898] brcmfmac: [brcmf_cfg80211_add_key -> __send_key_to_dongle] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1
> [ 1878.923359] WARNING: CPU: 1 PID: 1140 at compat-wireless-2016-06-20/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c:1256 brcmf_netdev_wait_pend8021x+0xbc/0x184 [brcmfmac]()
> [ 1880.659840] brcmfmac: [brcmf_netdev_wait_pend8021x] ifp:c71c5480 brcmf_ifname(ifp):wlan1-1 brcmf_get_pend_8021x_cnt(ifp):3
> [ 1880.670922] brcmfmac: [brcmf_netdev_wait_pend8021x] List of pending 802.1x skbs:
> [ 1880.678333] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18d80 skb->dev:c71c5000 skb->dev->name:wlan1-1
> [ 1880.687935] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c6b18900 skb->dev:c71c5000 skb->dev->name:wlan1-1
> [ 1880.697530] brcmfmac: [brcmf_netdev_wait_pend8021x] skb:c721fc00 skb->dev:c71c5000 skb->dev->name:wlan1-1
> [ 1881.439614] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6b18d80 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1874.928858]; commit_time:[ 1874.928994])
> [ 1881.457852] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c6b18900 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1875.938806]; commit_time:[ 1875.938858])
> [ 1881.476074] brcmfmac: [brcmf_msgbuf_process_txstatus -> __brcmf_txfinalize] Finally finalizing skb:c721fc00 skb->dev:c71c5000 skb->dev->name:wlan1-1 (start_time:[ 1876.948805]; commit_time:[ 1876.948855])
>
> For the first skb brcmf_netdev_start_xmit was called at 1874.928858.
> It was commited to firmware with brcmf_msgbuf_txflow at 1874.928994.
> Then there was A-MPDU hang in firmware.
> Finally brcmf_msgbuf_process_txstatus was called and it called
> brcmf_txfinalize and this one logged everything at 1881.439614.
>
> You'll find full log at the end.

I kept thinking about this. Some more timing info:
1) wlc_ampdu_watchdog probably started with ampdu_dbg, so we can assume the
    beginning was about 1876.423494.
2) brcmf_netdev_wait_pend8021x waits for 950 ms, so it probably started about
    1877.973359

So the closest timeline I can guess/restore is:
1874.423494: A-MPDU stalls
1874.928994: Passing 802.1x packet #1 to the firmware
1875.938858: Passing 802.1x packet #2 to the firmware
1876.423494: A-MPDU stall detected
1876.508943: Firmware sends DELBA
1876.948855: Passing 802.1x packet #3 to the firmware
1877.973359: brcmf_netdev_wait_pend8021x starts waiting
1881.439614: TX status of 802.1x packet #1
1881.457852: TX status of 802.1x packet #2
1881.476074: TX status of 802.1x packet #3

Now I'm more thinking about this, maybe this A-MPDU stall wasn't any firmware
bug at all? Could it be firmware wasn't getting BA reply e.g. because STA simply
lost the signal?
5 seconds of firmware delay between noticing A-MPDU stall and finally sending
802.1x packets still sound like a big one, but maybe it's not *that* critical?

What's the real problem then is brcmfmac waiting for too long in
brcmf_netdev_wait_pend8021x. It prevents keys from updating and current timeout
of 950 ms sounds like quite a lot. Increasing it to few seconds would stop
WARNINGs from appearing, but would make keys update take even more time.

I guess ideally we should:
1) Have firmware quickly recover from A-MPDU stall (currently: 2 + 5 seconds)
2) Don't have to wait for so long to update keys
