Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56785
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbXHHLRG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 07:17:06 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] Fix handling of failure to create debugfs directory
Date: Wed, 8 Aug 2007 13:16:37 +0200
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <20070808051710.3902.43211.stgit@dv.roinet.com> <46B95A15.1080202@lwfinger.net> <46B95C75.8060404@lwfinger.net>
In-Reply-To: <46B95C75.8060404@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708081316.38183.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 08 August 2007 08:02:29 Larry Finger wrote:
> Larry Finger wrote:
> > Pavel Roskin wrote:
> >> This can happen if CONFIG_BCM43XX_MAC80211_DEBUG is enabled, but
> >> CONFIG_DEBUG_FS is not.
> >>
> >> Signed-off-by: Pavel Roskin <proski@gnu.org>
> >> ---
> >>
> > With this patch installed, and the DEBUG configuration set as above, I get a kernel panic on an 
> > x86_64 SMP system. The reason for the panic scrolled off the screen, but the complete stack dump 
> > (hand copied) is as follows:
> > 
> > lock_acquire+0x85/0x31
> > bcm43xx_mac80211: bcm43xx_debugfs_log_txstat+0x5a/099
> > _spin_lock+0x25/0x31
> 
> Ignore the noise above. I had failed to get the right patch. The crash confirms the problem 
> _without_ the patch. Getting it in properly fixes the problem
> 
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Yeah, I just noticed that, too :)
So, I applied it to my queue and it will soon go upstream.
http://bu3sch.de/patches/wireless-dev/LATEST/patches/

-- 
Greetings Michael.
