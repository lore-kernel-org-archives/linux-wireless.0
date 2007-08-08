Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49159
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbXHHKir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 06:38:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] Fix handling of failure to create debugfs directory
Date: Wed, 8 Aug 2007 12:38:02 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <20070808051710.3902.43211.stgit@dv.roinet.com> <46B95A15.1080202@lwfinger.net>
In-Reply-To: <46B95A15.1080202@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708081238.03216.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 August 2007 07:52:21 Larry Finger wrote:
> Pavel Roskin wrote:
> > This can happen if CONFIG_BCM43XX_MAC80211_DEBUG is enabled, but
> > CONFIG_DEBUG_FS is not.
> > 
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> > ---
> > 
> With this patch installed, and the DEBUG configuration set as above, I get a kernel panic on an 
> x86_64 SMP system. The reason for the panic scrolled off the screen, but the complete stack dump 
> (hand copied) is as follows:
> 
> lock_acquire+0x85/0x31
> bcm43xx_mac80211: bcm43xx_debugfs_log_txstat+0x5a/099
> _spin_lock+0x25/0x31
> bcm43xx_mac80211: bcm43xx_interrupt_tasklet+0x21/0x723
> bcm43xx_mac80211: bcm43xx_debugfs_log_txstat+0x5a/0x99
> bcm43xx_mac80211: bcm43xx_handle_txstatsus+0x12/0x72
> bcm43xx_mac80211: bcm43xx_interrupt_tasklet+0x699/0x723
> __lock_acquire+0xca2/0xcf0
> bcm43xx_mac80211: bcm43xx_interrupt_handler+0x296/0x723
> tasklet_action+0x5e/0xb2
> __do_softirq+0x5f/0xe3
> call_softirq+0x1c/0x28
> do_softirq+0x39/0x9f
> irq_exit+0x4e/0x50
> do_IRQ+0xba/0xd8
> default_idle+0x35/0x51
> cpu_idle+0xce/0xf1
> start_secondary+0x2e0/0x2f2

Ah crap. I missed this. I'll do a patch.
But first some lunch :)

-- 
Greetings Michael.
