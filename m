Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35754 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1I0MYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 08:24:39 -0400
Received: by gyg10 with SMTP id 10so5112801gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Sep 2011 05:24:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1317109807.4082.4.camel@jlt3.sipsolutions.net>
References: <20110922154726.521122680@sipsolutions.net>
	<20110922154849.369194760@sipsolutions.net>
	<CAB=NE6UP9xYmLY3nJRMVdjPky87hB1YzFTHEzBv0Pt=qv3kAmg@mail.gmail.com>
	<CAJ-Vmo=9MUaKph=EXwF2VnE+=nHg4s=j=qhR2jnwa-xsXMno7g@mail.gmail.com>
	<1317109807.4082.4.camel@jlt3.sipsolutions.net>
Date: Tue, 27 Sep 2011 20:24:39 +0800
Message-ID: <CAJ-VmonVHyv0dqApO+0xyP=AfgmEHzG=fxb-rr69CVo21k1btw@mail.gmail.com> (sfid-20110927_142443_085961_3F3A3451)
Subject: Re: [RFC 03/15] mac80211: also expire filtered frames
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's sleep queue support in the net80211 stack but that doesn't
close the race for what failed to TX because the station went to sleep
with stuff in the hostap TX queue.
That small window is small for 11bg/11a rates but for 11n it could be
lots of frames.

That's what I have to port to FreeBSD's ath driver (and then when it's
all stable and sensible looking, migrate back into net80211.)



Adrian
