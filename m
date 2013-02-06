Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f176.google.com ([209.85.210.176]:38743 "EHLO
	mail-ia0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab3BFQE3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 11:04:29 -0500
Received: by mail-ia0-f176.google.com with SMTP id i18so1730551iac.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 08:04:29 -0800 (PST)
MIME-Version: 1.0
From: Robert Shade <robert.shade@gmail.com>
Date: Wed, 6 Feb 2013 11:04:08 -0500
Message-ID: <CAMgrJ3adwOW2skPAJtEkJ5sbKV0OCv4YRyFzLGHp5ouVnTY7eA@mail.gmail.com> (sfid-20130206_170441_865542_1CC07AD9)
Subject: PCI FATAL interrupt
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have several client devices that use the same AR9160 card that are
receiving PCI FATAL interrupts several times a day.

The pattern is the same in all cases I've been able to capture logs for:

kernel: ath: phy1: transmitting packet, skb: ffff88013b5cc0c0
kernel: ath: phy1: qnum: 2, txq depth: 0
kernel: ath: phy1: link[2] (ffff88003786a1b0)=3786bc18 (ffff88003786bc18)
kernel: ath: phy1: Enable TXE on queue: 2
kernel: ath: phy1: disable IER
kernel: ath: phy1: tx queue 0 (37860dd0), link ffff880037860dd0
kernel: ath: phy1: tx queue 2 (3786bc18), link ffff88003786bc18
kernel: ath: phy1: enable IER
kernel: ath: phy1: AR_IMR 0x918404b0 IER 0x1
kernel: ath: phy1: received PCI FATAL interrupt
kernel: ath: phy1: disable IER
kernel: ath: phy1: enable IER
kernel: ath: phy1: AR_IMR 0x918404b0 IER 0x1
kernel: ath: phy1: Stopping ANI
... snip (lots of "disable IER" msgs) ...
kernel: Failed to stop TX DMA, queues=0x004!
kernel: ath: phy1:
kernel: ath: phy1: disable IER
kernel: TX complete: skb: ffff88013b5cc0c0   <--- same skb from right
before the PCI FATAL interrupt
kernel: ath: phy1: disable IER
kernel: ath: phy1: disable IER
kernel: ath: phy1: Disable MIB counters
... snip (lots of "disable IER" msgs) ...
 kernel: DMA failed to stop in 10 ms AR_CR=0x00000024
AR_DIAG_SW=0x42000020 DMADBG_7=0x000062c0
... snip (lots of "disable IER" msgs) ...
kernel: Could not stop RX, we could be confusing the DMA engine when
we start RX up
... snip (lots of "disable IER" msgs) ...
kernel: ath: phy1: Reset to 2462 MHz, HT40: 0 fastcc: 0

Is there any way to get the reason for the fatal interrupt?
