Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab2FHG2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:28:02 -0400
Message-ID: <1339136879.5832.1.camel@jlt3.sipsolutions.net> (sfid-20120608_082807_706668_96C17A95)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
From: Johannes Berg <johannes@sipsolutions.net>
To: Andre Heider <a.heider@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Date: Fri, 08 Jun 2012 08:27:59 +0200
In-Reply-To: <CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com> (sfid-20120607_234722_659278_D556184E)
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	 <1339014959.4523.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	 <1339053364.4517.0.camel@jlt3.sipsolutions.net>
	 <CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	 <20120607180325.7752b3c0@milhouse>
	 <1339094215.4630.7.camel@jlt3.sipsolutions.net>
	 <1339102567.4630.8.camel@jlt3.sipsolutions.net>
	 <4FD11B47.10002@lwfinger.net>
	 <CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com>
	 (sfid-20120607_234722_659278_D556184E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 23:47 +0200, Andre Heider wrote:
> On Thu, Jun 7, 2012 at 11:21 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > On 06/07/2012 03:56 PM, Johannes Berg wrote:
> >>
> >> On Thu, 2012-06-07 at 20:36 +0200, Johannes Berg wrote:
> >>
> >>> However, it's also possible to actually *use* the new mac80211 feature.
> >>> That would also help with IEEE80211_TX_CTL_SEND_AFTER_DTIM, you could
> >>> ask mac80211 to use a separate HW queue for it (for tx_ring_mcast.) This
> >>> may be quicker.
> >>
> >>
> >> This might do it, I haven't tested it at all:
> >>
> >> http://p.sipsolutions.net/3c6b003bb06e5298.txt
> >
> >
> > With that patch, the driver never loads the firmware. I have not yet found
> > the reason.
> 
> Same here.

It doesn't start any interfaces, right?

The patch was incomplete -- it has to register all 5 queues not but
might not use them, please try this:
http://p.sipsolutions.net/69a78bbb83cd6421.txt

(and if it still fails, please let me know how far it gets)

johannes

