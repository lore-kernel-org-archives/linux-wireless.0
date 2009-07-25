Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:55852 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbZGYSPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 14:15:00 -0400
Received: by fxm18 with SMTP id 18so1943780fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 11:14:58 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] mac80211: fix oops in ieee80211_scan_state_set_channel()
Date: Sat, 25 Jul 2009 20:15:06 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20090725051801.2965.76768.stgit@ct.roinet.com> <200907251506.34943.helmut.schaa@googlemail.com> <1248541636.2554.12.camel@ct>
In-Reply-To: <1248541636.2554.12.camel@ct>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907252015.07010.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 25. Juli 2009 schrieb Pavel Roskin:
> On Sat, 2009-07-25 at 15:06 +0200, Helmut Schaa wrote:
> 
> > Hmm, I'd prefer to keep the decision state as entry and exit point to
> > the scan state machine. The patch below should also fix this issue
> > by returning back to the decision state after every skipped channel.
> 
> The patch is working and I'm fine with it. 

Great, thanks a lot.

> We should fix that in the 
> tree as soon as possible, or it will stand in the way of bisection.

Yes, you're right.

> I forgot to mention that the oops was happening in x86_64 with rt61pci
> and US regulatory domain.  The device only works in the 2.4 GHz range.
> 
> > In the long run I would like to move the channel selection also to
> > the decision state in order to implement various improvements (like
> > scanning multiple channels in a row or reordering the channel list).
> 
> I don't know the code enough, but two things surprised me:
> 
> Lack of SCAN_DONE in mac80211_scan_state.  We exit scanning through the
> "entry point".

I also thought of a separate state SCAN_DONE or something similar but
dropped that idea as the only thing this state would have to do is the
call to ieee80211_scan_completed. So, once the scan is finished we
just stay in SCAN_DECISION as long as the scan state machine gets poked
again by a start_scan call.

> Use of "unsigned long" for bitwise fields, such as queue_stop_reasons
> and scanning.  This reminds me of the good old days where long was
> always 32 bit, but int wasn't.  I think "unsigned int" should be enough,
> and you can annotate it with __bitwise to make sparse catch some
> misuses.

No objections :)

Helmut
