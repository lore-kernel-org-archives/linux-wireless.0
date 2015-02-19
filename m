Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:49962 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbbBSXep (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 18:34:45 -0500
Received: from [145.100.231.247] (client-145-100-231-247.erdg.usor.nl [145.100.231.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mx-deb.opendmz.com (Postfix) with ESMTPSA id B23DB39
	for <linux-wireless@vger.kernel.org>; Thu, 19 Feb 2015 18:24:56 -0500 (EST)
Message-ID: <54E670C7.4070609@opendmz.com> (sfid-20150220_003450_104012_BFBB6BBA)
Date: Fri, 20 Feb 2015 00:24:55 +0100
From: Christopher van de Sande <cvandesande@opendmz.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [iwlwifi] fail to flush all tx fifo queues kernel 3.18.7
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linux-Wireless!

I've noticed that this issue has come up here a few times on this list.  
I was really hoping my searching would lead me to a fix, but it 
hasn't...so I'm asking for help.

This started happening when I moved into an apartment complex that has 
lots of wifi access points.  I don't have my own AP here, I'm using the 
ones that are shared by the building, so I have no control over them.  
The signal is on the weak side, but should be good enough to be usable.  
iwconfig says Signal level=-61 dBm currently.

I've read up on https://bugzilla.kernel.org/show_bug.cgi?id=56581 and 
took the suggested options. They seem to give me the best results. 
(Though I still get the failed to flush, and need to disable/re-enable 
to get wireless working again).

cat /etc/modprobe.d/iwlwifi.conf
#options iwlwifi 11n_disable=1
options iwlwifi swcrypto=1
options mac80211 beacon_loss_count=1000

firmware: iwlwifi 0000:03:00.0: loaded firmware version 18.168.6.1 
op_mode iwldvm

lspci -s 03:00.0 -v
03:00.0 Network controller: Intel Corporation Centrino Wireless-N 2200 
(rev c4)
     Subsystem: Intel Corporation Centrino Wireless-N 2200 BGN
     Flags: bus master, fast devsel, latency 0, IRQ 28
     Memory at f1c00000 (64-bit, non-prefetchable) [size=8K]
     Capabilities: [c8] Power Management version 3
     Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
     Capabilities: [e0] Express Endpoint, MSI 00
     Capabilities: [100] Advanced Error Reporting
     Capabilities: [140] Device Serial Number 9c-4e-36-ff-ff-cd-31-a8
     Kernel driver in use: iwlwifi
     Kernel modules: iwlwifi


Excerpt from dmesg:
[ 4689.207088] wlp3s0: authenticate with c4:01:7c:75:da:c8
[ 4689.225168] wlp3s0: send auth to c4:01:7c:75:da:c8 (try 1/3)
[ 4689.229165] wlp3s0: authenticated
[ 4689.230379] wlp3s0: associate with c4:01:7c:75:da:c8 (try 1/3)
[ 4689.276300] wlp3s0: RX AssocResp from c4:01:7c:75:da:c8 (capab=0x431 
status=0 aid=7)
[ 4689.302835] wlp3s0: associated
[ 6680.502600] iwlwifi 0000:03:00.0: fail to flush all tx fifo queues Q 0
[ 6680.502608] iwlwifi 0000:03:00.0: Current SW read_ptr 43 write_ptr 44
[ 6680.502665] iwl data: 00000000: 00 00 00 00 00 00 00 00 00 08 00 00 
00 00 00 00  ................
[ 6680.502683] iwlwifi 0000:03:00.0: FH TRBs(0) = 0x00000000
[ 6680.502701] iwlwifi 0000:03:00.0: FH TRBs(1) = 0x8010206c
[ 6680.502718] iwlwifi 0000:03:00.0: FH TRBs(2) = 0x00000000
[ 6680.502735] iwlwifi 0000:03:00.0: FH TRBs(3) = 0x8030002b
[ 6680.502752] iwlwifi 0000:03:00.0: FH TRBs(4) = 0x00000000
[ 6680.502769] iwlwifi 0000:03:00.0: FH TRBs(5) = 0x00000000
[ 6680.502786] iwlwifi 0000:03:00.0: FH TRBs(6) = 0x00000000
[ 6680.502802] iwlwifi 0000:03:00.0: FH TRBs(7) = 0x0070908d
[ 6680.502870] iwlwifi 0000:03:00.0: Q 0 is active and mapped to fifo 3 
ra_tid 0x0000 [43,44]

I've even considered changing wireless cards, but my Lenovo T430 bios 
whitelists only certain cards, so at the moment I seem to be stuck with 
this one.

I don't suppose there's another firmware I can try?

Thanks for your time,
Chris.


