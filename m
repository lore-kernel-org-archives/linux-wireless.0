Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38323 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932203Ab3CSIS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 04:18:27 -0400
Message-ID: <1363681103.8336.0.camel@jlt4.sipsolutions.net> (sfid-20130319_091832_410963_92DA7005)
Subject: Re: BUG: problem while tracing cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, David Spinadel <dvdspndl@gmail.com>
Date: Tue, 19 Mar 2013 09:18:23 +0100
In-Reply-To: <514790A5.90004@broadcom.com>
References: <51476F35.9040909@broadcom.com>
	 <1363636984.8260.17.camel@jlt4.sipsolutions.net>
	 <51478F06.9000506@broadcom.com> <514790A5.90004@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-18 at 23:09 +0100, Arend van Spriel wrote:
> On 03/18/2013 11:02 PM, Arend van Spriel wrote:
> > On 03/18/2013 09:03 PM, Johannes Berg wrote:
> >> On Mon, 2013-03-18 at 20:47 +0100, Arend van Spriel wrote:
> >>> Hi Johannes,
> >>>
> >>> While testing David Spinadel's P2P device support functionality I got
> >>> the following blurb, which is probably caused by cfg80211 tracing given
> >>> the instruction pointer address.
> >>>
> >>> brcmfmac returns ERR_PTR(-ENOENT) and I think the trace code/macros do
> >>> not take this into account.
> >>
> >> I guess this should fix it?
> >>
> >> http://p.sipsolutions.net/fdea39f2a56aff67.txt
> >
> > Did not test it, but that would be my guess to. Just another
> > observation: Is the wdev identifier not defined as u64?

Mind testing it? :-)

> Found the answer. In nl80211 API the wdev identifier is 64 bits, which 
> got me confused.

Yes, externally it's a u64 but the high 32 bits are just the wiphy ID.
Makes it easier to look things up based on the wdev index :-)

johannes

