Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:40609 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZAYSm7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 13:42:59 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: Re: regulatory: Operation already in progress
Date: Sun, 25 Jan 2009 19:41:38 +0100
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <200901251422.42616.mb@bu3sch.de> <20090125182107.GG22475@tesla>
In-Reply-To: <20090125182107.GG22475@tesla>
MIME-Version: 1.0
Message-Id: <200901251941.38228.mb@bu3sch.de> (sfid-20090125_194304_480687_59B3B32D)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 25 January 2009 19:21:07 Luis R. Rodriguez wrote:
> On Sun, Jan 25, 2009 at 05:22:42AM -0800, Michael Buesch wrote:
> > mb@quimby:~/kernel$ sudo iw reg set DE
> > command failed: Operation already in progress (-114)
> > 
> > I wonder why this happens.
> > What I just did was install 2.6.28.2 and install today's compat-wireless.
> > 
> > In dmesg I can see it succeeded once but it doesn't work anymore now.
> > [  973.992710] cfg80211: Calling CRDA for country: DE
> > [  973.998576] cfg80211: Regulatory domain changed to country: DE
> > [  973.998630]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> > [  973.998691]  (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > [  973.998738]  (5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
> > [  973.998785]  (5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
> 
> Had you called twice?

yeah, once manually with iw and once with hostapd.

> If so we now tell userspace when its there by -EALREADY, 
> we were just silently accepting two consecutive calls before.

Well, but it makes hostapd fail.
I think it's a bit weird to throw and error code. In general most programs
silently return success early, if an operation was already done.

-- 
Greetings, Michael.
