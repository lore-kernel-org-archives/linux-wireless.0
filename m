Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:45961 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbYGETTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 15:19:45 -0400
Received: by nf-out-0910.google.com with SMTP id d3so482540nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 12:19:44 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error =?iso-8859-15?q?in=09adhoc/master?= mode
Date: Sat, 5 Jul 2008 21:26:16 +0200
Cc: Bryan Batten <BryanBatten@sbcglobal.net>, linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807051511.57995.IvDoorn@gmail.com> <200807052042.47008.IvDoorn@gmail.com> <1215283415.6848.14.camel@johannes.berg>
In-Reply-To: <1215283415.6848.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807052126.16913.IvDoorn@gmail.com> (sfid-20080705_211949_061307_77AA8FE5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 July 2008, Johannes Berg wrote:
> 
> > Hmm, in that case I have to fix something in the beacondone handler
> > to prevent it requesting a beacon when mac80211 hasn't supplied anything
> > yet..
> 
> I was working in this area... Can you take a quick look at this patch
> and let me know what you think?
> http://johannes.sipsolutions.net/patches/kernel/all/2008-07-05-18%3a42/mac80211-beacon-revamp.patch

Patch looks good to me, it wouldn't change anything about the above since t2x00 would still
call ieee80211_beacon_get() when the beacon wasn't provided by mac80211 yet.

But the flags that mark what has changed is definately a good idea,
that will prevent some redundant register writes. :)

Ivo
