Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:56486 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbXHHFwZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 01:52:25 -0400
Message-ID: <46B95A15.1080202@lwfinger.net>
Date: Wed, 08 Aug 2007 00:52:21 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Fix handling of failure to create debugfs directory
References: <20070808051710.3902.43211.stgit@dv.roinet.com>
In-Reply-To: <20070808051710.3902.43211.stgit@dv.roinet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> This can happen if CONFIG_BCM43XX_MAC80211_DEBUG is enabled, but
> CONFIG_DEBUG_FS is not.
> 
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
> 
With this patch installed, and the DEBUG configuration set as above, I get a kernel panic on an 
x86_64 SMP system. The reason for the panic scrolled off the screen, but the complete stack dump 
(hand copied) is as follows:

lock_acquire+0x85/0x31
bcm43xx_mac80211: bcm43xx_debugfs_log_txstat+0x5a/099
_spin_lock+0x25/0x31
bcm43xx_mac80211: bcm43xx_interrupt_tasklet+0x21/0x723
bcm43xx_mac80211: bcm43xx_debugfs_log_txstat+0x5a/0x99
bcm43xx_mac80211: bcm43xx_handle_txstatsus+0x12/0x72
bcm43xx_mac80211: bcm43xx_interrupt_tasklet+0x699/0x723
__lock_acquire+0xca2/0xcf0
bcm43xx_mac80211: bcm43xx_interrupt_handler+0x296/0x723
tasklet_action+0x5e/0xb2
__do_softirq+0x5f/0xe3
call_softirq+0x1c/0x28
do_softirq+0x39/0x9f
irq_exit+0x4e/0x50
do_IRQ+0xba/0xd8
default_idle+0x35/0x51
cpu_idle+0xce/0xf1
start_secondary+0x2e0/0x2f2

Larry


