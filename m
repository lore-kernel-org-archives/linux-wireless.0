Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:58496 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbYGRSwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 14:52:50 -0400
Received: by fk-out-0910.google.com with SMTP id 18so311268fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jul 2008 11:52:48 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/6] rt2x00: Fix EIFS timing value
Date: Fri, 18 Jul 2008 21:07:08 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Olivier Cornu <o.cornu@gmail.com>
References: <200807182043.08990.IvDoorn@gmail.com> <200807182043.52015.IvDoorn@gmail.com> <1216406699.27738.42.camel@johannes.berg>
In-Reply-To: <1216406699.27738.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807182107.08540.IvDoorn@gmail.com> (sfid-20080718_205253_743027_519501C6)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 18 July 2008, Johannes Berg wrote:
> On Fri, 2008-07-18 at 20:43 +0200, Ivo van Doorn wrote:
> 
> >  #define SHORT_PIFS		( SIFS + SHORT_SLOT_TIME )
> >  #define DIFS			( PIFS + SLOT_TIME )
> >  #define SHORT_DIFS		( SHORT_PIFS + SHORT_SLOT_TIME )
> > -#define EIFS			( SIFS + (8 * (IEEE80211_HEADER + ACK_SIZE)) )
> > +#define EIFS			364
> 
> Haven't checked what it comes out to be, but it should be SIFS + DIFS +
> AckTxTime.

For normal slot time: 364
For short slot time: 	342

So for normal slot time this would be correct, but it wouldn't for short slot time,
legacy driver seems to have hardcoded the value to 364. So for now I think it is
best to keep it hardcoded like that, and experiment a bit later to see what the
impact will for short slot time.

(Note that rt61/rt73 will use 364 as EIFS and always uses a short slot time)

Ivo
