Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43131 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab1CIQ00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 11:26:26 -0500
Received: by qwd7 with SMTP id 7so508252qwd.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 08:26:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D77A06E.3050902@lwfinger.net>
References: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
	<4D77A06E.3050902@lwfinger.net>
Date: Wed, 9 Mar 2011 17:26:26 +0100
Message-ID: <AANLkTinYp64QZ5o1-=xP_ehVhLPwDLR+gQnQk7MADHFA@mail.gmail.com>
Subject: Re: Problem with BCM943224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 marca 2011 16:44 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 03/09/2011 04:59 AM, Rafał Miłecki wrote:
>>
>> I've 14e4:4353 labeled as BCM943224HMS / DW1520
>>
>> [  199.009268] brcm80211: module is from the staging directory, the
>> quality is unknown, you have been warned.
>> [  199.022493] brcm80211 0000:03:00.0: enabling device (0000 ->  0002)
>> [  199.022529] brcm80211 0000:03:00.0: PCI INT A ->  GSI 28 (level,
>> low) ->  IRQ 28
>> [  199.022543] brcm80211 0000:03:00.0: setting latency timer to 64
>> [  199.050090] cfg80211: World regulatory domain updated:
>> [  199.050096] cfg80211:     (start_freq - end_freq @ bandwidth),
>> (max_antenna_gain, max_eirp)
>> [  199.050101] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [  199.050105] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
>> (300 mBi, 2000 mBm)
>> [  199.050109] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
>> (300 mBi, 2000 mBm)
>> [  199.050113] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [  199.050117] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
>> (300 mBi, 2000 mBm)
>> [  199.297803] Found chip of unknown type (0xffffffff)
>> [  199.297808] wl0: wlc_bmac_attach: si_attach failed
>> [  199.297813] wl0: wlc_bmac_attach: failed with err 11
>> [  199.297818] wl0: wlc_attach: failed with err 11
>> [  199.297856] brcm80211: wlc_attach() failed with code 11
>> [  199.297882] brcm80211: wl_pci_probe: wl_attach failed!
>>
>> [  343.223842] wl: module license 'unspecified' taints kernel.
>> [  343.223849] Disabling lock debugging due to kernel taint
>> [  343.256069] wl 0000:03:00.0: setting latency timer to 64
>> [  343.258760] eth%d: 5.100.82.38 driver failed with code 11
>>
>> It seems all reads are 1 (0xffffffff). Can this be some bug in driver?
>> Can this be because I use adapter mini PCIe to PCIe x1? I remember
>> such a situation when I connected adapter to PCIe x16 and used N-PHY
>> card SSB based.
>
> A read of all 1's is a symptom of reading a non-existent register. I would
> certainly suspect the adapter.
>
> I have a PCI Express extender for my HP laptop. Although it avoids the
> problem of the white-listed WLAN modules in the BIOS, not all cards work
> with it. Perhaps there is a critical timing issue.
>
> I just tested again. My BCM4322 (14e4:432b) works with both b43 and wl in
> the extender. For the record, the upload speeds are 8 Mbps with b43 and 15
> Mbps with wl in the 2.4 GHz band (router max 54 Mbps). In the 5 GHz band,
> the router is set for 270 Mbps max and wl gets 80 Mbps. Of course, the 5 GHz
> band in b43 is inactive.

BCM4322 is not a problem for me as well. I can use BCM4312, BCM4321,
BCM4322 with my adapter without problem.

It's BCM943224 that I hit this problem with.

AFAIR you have some AI based card. Could you test this with your
extender for me?

-- 
Rafał
