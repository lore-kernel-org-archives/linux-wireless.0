Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:40462 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751400Ab2BNHi6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 02:38:58 -0500
Message-ID: <20120214073855.6843.qmail@stuge.se> (sfid-20120214_083901_176440_CD79AB39)
Date: Tue, 14 Feb 2012 08:38:55 +0100
From: Peter Stuge <peter@stuge.se>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>, ath9k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [ath9k-devel] [PATCH 3/7] ath9k: Merge wiphy and misc debugfs
	files
References: <20280.43962.403799.188541@gargle.gargle.HOWL> <4F3947A1.2060103@candelatech.com> <20281.48485.409968.741657@gargle.gargle.HOWL> <4F39BF5F.3030408@candelatech.com> <20281.52354.478076.479135@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20281.52354.478076.479135@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> > Ath9k is a tricky beast to debug, and I think you should
> > not remove anything that is remotely useful to debugging
> > unless removing it has a real benefit other than just
> > decreasing lines of (conditionally compiled) code.
> 
> I am aware that you have rather unique requirements regarding ath9k,

Not really. He just wants to have HALF a chance to find issues. I'm
sure you understand that ath9k is far from bug free. Until that has
changed (don't hold your breath) the driver can not have too much
debug information!


> removing redundant code will make a difference in
> memory-constrained environments like APs. (OpenWRT has DEBUGFS
> enabled by default).

It is not very wise for ath9k to reduce debug output with the
motivation that some users leave it enabled even if they deploy
into limited systems and they would actually prefer to have less
debugging.

If ath9k users have an issue with debugging being too big then THEY
can disable it. It seems senseless to delete debugging when the
driver is clearly still buggy.

It also seems senseless to try to punt to mac80211. It is amazing
that Ben's point is not absolutely obvious.

One purpose of debugging is to allow and enable consistency checking.
Redundant information is by definition neccessary for that.


As a compromise, you could suggest a move to a two-level compile time
option for debugging. You would enable only what you believe to be
adequate for debugging in production systems (wait, what did I just
write? oh well..) with the first option, and you would allow the rest
of the world to enable complete debugging with the second option.

I would support such a scheme.


//Peter
