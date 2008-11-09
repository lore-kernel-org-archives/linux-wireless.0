Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53695 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYKIMCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 07:02:37 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
Date: Sun, 9 Nov 2008 13:02:15 +0100
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
References: <4902DEBB.3050205@hotmail.com> <1226220992.3614.16.camel@johannes.berg> <1226221438.3614.20.camel@johannes.berg>
In-Reply-To: <1226221438.3614.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811091302.15899.mb@bu3sch.de> (sfid-20081109_130246_639951_F59785AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 09 November 2008 10:03:58 Johannes Berg wrote:
> On Sun, 2008-11-09 at 09:56 +0100, Johannes Berg wrote:
> 
> > I think you forgot to attach the patch.
> 
> Sorry, I missed your second mail. (btw, if you generate patches with -p
> in diff arguments it helps a bit reading them)
> 
> Ok so it looks like the buffer you're getting is unaligned. This is
> strange, but I'm too unfamiliar with the code. It seems that there's the
> PLCP 5 byte header in front. Well, try the printk I asked for, because
> at that point zd1211 should avoid "leaking" the alignment problem.

zd1211rw has some code to align the packet to a 4-byte boundary.
But the compare_ether_addr() and the other le16 accesses are done before
that realignment.
This these blow up if (ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc))

-- 
Greetings Michael.
