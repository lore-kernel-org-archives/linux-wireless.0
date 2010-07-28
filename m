Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33343 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0G1PQv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 11:16:51 -0400
Received: by bwz1 with SMTP id 1so4015726bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 08:16:50 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [WIP] mac80211: AMPDU rx reorder timeout timer
Date: Wed, 28 Jul 2010 17:16:41 +0200
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
References: <201007270820.25347.chunkeey@googlemail.com> <1280219845.19098.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280219845.19098.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007281716.41612.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 July 2010 10:37:25 Johannes Berg wrote:
> On Tue, 2010-07-27 at 08:20 +0200, Christian Lamparter wrote:
> > This (rather _unfinished_ :-D ) patch adds a timer which
> > if trigger schedules the automatic release of all expired
> > A-MPDU frames. This implementation has the advantage that
> > all queued-up MPDU will now arrive in the network core
> > within a timely manner.
> > 
> > In my "experiments", the patch helped to ironed out the
> > sudden throughput drops that have been _killing_ my
> > average tcp performance ever since I can remember.
> 
> But why is your BA session so damaged to start with? This is not a
> normal situtation!

I can think of at least one possible reason:

commit 3ef83d745bf5220bef3a0fd11b96eb9ac64c8e8e
Author: Felix Fietkau <nbd@openwrt.org>
Date:   Tue May 4 09:58:57 2010 +0200

    ath9k: fix another source of corrupt frames
    
    Atheros hardware supports receiving frames that span multiple
    descriptors and buffers. In this case, the rx status of every
    descriptor except for the last one is invalid and may contain random
    data. Because the driver does not support this, it needs to drop such
    frames.
    
    Signed-off-by: Felix Fietkau <nbd@openwrt.org>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

and obviously, the HW marked the "last one" in the BA scoreboard
as successfully received. Therefore we don't get a second attempt
because the driver dropped it :(

(The same applies to ar9170, which will print "missing tags!",
 or stream corruption in such a case)

> > But there is a catch: The logs will quickly fill up with:
> > "release an RX reorder frame due to timeout on earlier frames".
> > and the package loss will goes through the roof...
> > 
> > Now, I can think of several reasons why this could happen:
> > 	1. we don't wait long enough for the HT peer to
> > 		finish their _retry_ procedure?
> > 
> > 	2. previously - when the stream simply _stopped_ - we had
> > 		to wait until the tcp retry kick in again. So we had
> > 		some "silent" periods and therefore less noise from
> > 		the reordering code?
> > 
> > 	3. ->bugs<- but where are they?
> 
> I'm having a hard time understanding this patch, can you split out the
> no-op code reorg parts or explain what it does?
 
Sure, just finished clean-up.

Regards,
	Chr
