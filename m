Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaAOOVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 09:21:13 -0500
Message-ID: <1389795668.4338.20.camel@jlt4.sipsolutions.net> (sfid-20140115_152128_663680_DA4692E6)
Subject: Re: [RFC 6/9] mac80211: track CSA globally
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 15 Jan 2014 15:21:08 +0100
In-Reply-To: <CA+BoTQkbd8UtGz3DwiL8aKDHAuVob3KZ_MYjEVmy1TeGKYB-oQ@mail.gmail.com> (sfid-20140115_151120_804532_1E6AD0CD)
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	 <1389787494-7361-7-git-send-email-michal.kazior@tieto.com>
	 <1389791963.4338.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=ppr=npj_f58Ckv4LGpMb+PSTRkzFtLh5jt1PYQCXLhg@mail.gmail.com>
	 <1389792568.4338.12.camel@jlt4.sipsolutions.net>
	 <CA+BoTQkbd8UtGz3DwiL8aKDHAuVob3KZ_MYjEVmy1TeGKYB-oQ@mail.gmail.com>
	 (sfid-20140115_151120_804532_1E6AD0CD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-15 at 15:11 +0100, Michal Kazior wrote:

> >> >> For CSA to be safe it needs to be treated the same
> >> >> way as radar detection, scanning and remain on
> >> >> channel - all of those (including CSA) must be
> >> >> mutually exclusive.
> >> >
> >> > This I don't understand. Why couldn't you do a remain-on(some
> >> > other)-channel or scan while counting down the beacons?
> >>
> >> My concern is software offchannel (be it scan or roc) involves channel
> >> context switches. I wanted to avoid any channel context mangling while
> >> CSA is in progress. Does that make sense to you?
> >
> > No, I don't really get it. Why?
> 
> Hmm. Perhaps I was a little overcautious. Offchannel stuff doesn't use
> channel contexts at all, right? It recalculates channel in hw_config()
> and doesn't touch channel contexts so it should be safe.

Software offchannel and scan are incompatible with channel contexts,
yes.

johannes

