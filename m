Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21860 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbZEKWG0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 18:06:26 -0400
Subject: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath
 comes
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alexander Bartha <alex.xy.privat@gmx.at>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890905110040o6a87d963mf0d5a5a08b22fbfd@mail.gmail.com>
References: <20090203173228.GB9713@tesla> <20090214230618.203560@gmx.net>
	 <43e72e890902141718v544f5caejb71f53bdadbf8a8f@mail.gmail.com>
	 <20090216205115.21860@gmx.net>
	 <43e72e890902161342j23b68a4eoabddb047fb9d9084@mail.gmail.com>
	 <20090508211237.316290@gmx.net> <1241818845.6240.4.camel@mj>
	 <43e72e890905081453h2d660e6dl38b714467c8f24cb@mail.gmail.com>
	 <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	 <20090511001749.efx510zpk404owww-cebfxv@webmail.spamcop.net>
	 <43e72e890905110040o6a87d963mf0d5a5a08b22fbfd@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 11 May 2009 18:06:25 -0400
Message-Id: <1242079585.3845.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-05-11 at 00:40 -0700, Luis R. Rodriguez wrote:
> On Sun, May 10, 2009 at 9:17 PM, Pavel Roskin <proski@gnu.org> wrote:
> > Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
> >
> >> I can reproduce, and I tried without the idle patches but I still see
> >> the issue. I see this issue only after suspend. Did you suspend and
> >> get this as well? I see this using AR5416. If you are seeing this on
> >> suspend can you try with the patch I posted to linux-wireless to see
> >> if it helps a little?
> >
> > I saw this on AR9280 without any suspends.  The card doesn't support the
> > 802.11a range, so it's not a direct equivalent of the problem I bisected
> > with ath5k (invalid rates when scanning and transmitting).
> 
> Thanks for the heads up Pavel. So can you guys test with this option
> set as follows:
> 
> CONFIG_MAC80211_DEFAULT_PS_VALUE=0
> 
> If using compat-wireless just stuff it into config.mk.
> 
> This fixes my issues and points towards PS code. This could be how we
> handle PS in ath9k (more likely) or mac80211. For now please disable
> this if using ath9k until we figure out what causes this.

It looks like there are two issues, and I confused them.  One is
characterized by the kernel messages about the channel, the one
originally reported in this thread.  I have seen it, but I don't
remember the exact circumstances.

Another issue is connection loss to a WPA enabled AP after several
minutes.  That's what I have seen with AR9280.  iwconfig still shows an
association, but no traffic can flow.

I just want to tell that it's two different issues.  The later is much
more critical for me, but it would take about 15 minutes to verify every
step if bisecting.  Unfortunately, I don't have time to bisect it now,
but maybe I'll do it later during this week.

-- 
Regards,
Pavel Roskin
