Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476Ab3JNPGn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 11:06:43 -0400
Message-ID: <1381763193.13092.19.camel@jlt4.sipsolutions.net> (sfid-20131014_170647_083761_6586A114)
Subject: Re: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz
 range
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis H Jensen <dennis.h.jensen@siemens.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 14 Oct 2013 17:06:33 +0200
In-Reply-To: <1381762681.3711.36.camel@djensen-laptop>
References: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
	 <1381499778.14293.21.camel@jlt4.sipsolutions.net>
	 <1381506302.3711.10.camel@djensen-laptop>
	 <1381752176.13092.10.camel@jlt4.sipsolutions.net>
	 <1381752976.3711.14.camel@djensen-laptop>
	 <1381759370.13092.11.camel@jlt4.sipsolutions.net>
	 <1381762681.3711.36.camel@djensen-laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-14 at 16:58 +0200, Dennis H Jensen wrote:

> > > The commit 59eb21a6504731fc16db4cf9463065dd61093e08 moved those channels
> > > to 4.9 GHz but left a hole in the 5.9 Ghz range.
> > 
> > But there was no +/- 15 before, so what gives?
> 
> Well no :) but there also wasn't a special case for that particular
> channel set (182 - 196).

Yes, but then before 5910 would have been channel 182. Now you're making
it channel 197. That doesn't really make sense at all.

> So now, when you configure the frequency 5910, it is mapped to channel
> 182 which is mapped back to 4910 and nothing works, at least let the
> functions be the inverse of the other.
> 
> In case that doesn't do it. What is needed to get channel 182 to be 5910
> MHz as Annex E defines for the US and Europe? Channel to frequency
> mapping based on operating class?

Annex E is the 802.11 spec, to get something into that ...

johannes

