Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52534 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab3LEPxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 10:53:53 -0500
Message-ID: <1386258827.4182.12.camel@jlt4.sipsolutions.net> (sfid-20131205_165356_240116_36FB4E03)
Subject: Re: [PATCH 4/4] cfg80211: prevent race condition on scan request
 cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 05 Dec 2013 16:53:47 +0100
In-Reply-To: <CA+XVXffcA+TKAaH6MuybncUAe7jgaWEFdo5nL7+FnTR-7pc1+g@mail.gmail.com> (sfid-20131205_165233_922106_BD55352E)
References: <1386235289-27278-1-git-send-email-eliad@wizery.com>
	 <1386235289-27278-4-git-send-email-eliad@wizery.com>
	 <1386253879.4182.4.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcpM9PAQCGQ99X2A-bqYXoPEmE=Cg29CDKY7=s8QquwUA@mail.gmail.com>
	 <1386254607.4182.5.camel@jlt4.sipsolutions.net>
	 <CAB3XZEc4pikahyAmPCh_pCjFEiRvFgAyZgxGrbH9A6hLP2nhFw@mail.gmail.com>
	 <1386258330.4182.11.camel@jlt4.sipsolutions.net>
	 <CA+XVXffcA+TKAaH6MuybncUAe7jgaWEFdo5nL7+FnTR-7pc1+g@mail.gmail.com>
	 (sfid-20131205_165233_922106_BD55352E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 17:52 +0200, Arik Nemtsov wrote:

> >> > But the whole thing was intended to catch buggy drivers :)
> >> >
> >> yeah, you have a point here :)
> >> anyway, i guess it's either leaking scan_req and hoping the driver
> >> really forgot about it, or keeping it and hoping the driver will
> >> finally indicate completion.
> >>
> >> since i don't think this is a real-world scenario, i'm ok with
> >> dropping this patch.
> >
> > Well, it can be made to crash, so ...
> >
> > Can we maybe avoid the crash in a different way? Disallow a new scan
> > somehow?
> 
> Maybe we should drop the whole netdev-notified doing ___cfg80211_scan_done?
> I mean if a workaround for buggy drivers is causing bugs for
> legitimate drivers..
> 
> Something simple for buggy drivers would be doing this in the notifier
> - BUG_ON(!rdev->scan_req->notified)

BUG_ON is probably a bit heavy-handed, but yeah, I suppose we can drop
this. We used to have more bugs with drivers and even mac80211, but that
should be a thing of the past.

johannes

