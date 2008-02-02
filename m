Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:27144 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758984AbYBBXWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 18:22:14 -0500
Received: by py-out-1112.google.com with SMTP id u52so2413249pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 15:22:13 -0800 (PST)
Message-ID: <43e72e890802021522g5bffe97cg31ba57f6f1f200b9@mail.gmail.com> (sfid-20080202_232227_576995_47054CDC)
Date: Sat, 2 Feb 2008 18:22:12 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Cc: "Johannes Berg" <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <200801251701.59629.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080118125252.6455.41047.stgit@one>
	 <200801241226.28394.bruno@thinktube.com>
	 <1201193704.3454.137.camel@johannes.berg>
	 <200801251701.59629.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 25, 2008 3:01 AM, bruno randolf <bruno@thinktube.com> wrote:
> On Friday 25 January 2008 01:55:04 Johannes Berg wrote:
> > > i can see now how you could interpret this as only applying to timers,
> > > but i think that does just not make sense - why would you want to sync
> > > timers and adapt beacon intervals if you don't share the same BSSID?
> >
> > Hmm. Well I thought that was pretty much just for optimising performance
> > but now that I think about it again...
> >
> > > i agree that the standard is quite ambigious when it comes to IBSS, but
> > > practically speaking, it is necessary to merge IBSS cells most of the
> > > time if you want to have IBSS working as expected. therefore i tend to
> > > interpret the ambigious parts of the standard in a way that will improve
> > > functionality.
> >
> > I think "working as expected" is stretching it a bit ;) How do you
> > expect IBSS to work?
>
> i think it's a reasonable expectation from a users point of view that two or
> more IBSS nodes using the same ESSID on the same channel can communicate with
> each other, regardless of when and where they were configured.
>
> > I'd expect only the simplest use case from it:
> > start IBSS on one station and have another one in the vicinity find it
> > while scanning and join it. That works regardless of merging or not.
>
> this is probably a valid, but a most conservative interpretation of the
> standard, which makes IBSS practically unusable in many (or most) occasions.
>
> i guess you have never actually used IBSS much. otherwise you would know from
> experience that your simplest use case practically rarely happens. usually
> you have situations where you miss the others BSS while scanning and end up
> with 2 different BSSIDs. or what happens if there is a third station within
> station 2's reach but out of range for station 1? sta2 will adopt the BSSID
> of sta3, but sta1 will not and start a new BSSID. so not even your simplest
> use case of two newly started stations will just work (without ibss merge).
> examples and scenarios are endless, do you want me to continue? ;)
>
> also i am not inventing this "non-standard merge". it is *not* non-standard,
> it's just not directly obvious from reading the standard.
>
> IBSS merges are done like this by various cards and drivers: prism54 does the
> same (in firmware), hostap driver did it like this (probably does but i
> haven't used it in quite a while), the broadcom driver in openwrt acts like
> this, madwifi merges like this (ups, maybe i shouldn't have said that ;)) and
> so on...
>
> aren't there any other serious IBSS users out there who can support this case
> and confirm that we need IBSS merge functionality?

Sure ACK. Also as was stated, even with IBSS merge functionality
working you could up with nodes splitting up due to missing the
"leader" beacon due to interference or even strange radio node
problems. A solution to this we implemented at Orbit with MadWifi was
that instead of generating "random" BSSIDs you'd create one based on
the hash of the SSID [1]. This ensures that nodes with identical SSIDs
end up with identical BSSIDs, regardless of any strange problems.
Technically from what I have gathered this doesn't break the specs but
would prevent this split-IBSS problem. I actually like to see this
technique added into mac80211 too.

[1] http://www.orbit-lab.org/wiki/HowTo/bssidFix

  Luis
