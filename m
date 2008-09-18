Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:44472 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbYIRSMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 14:12:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so13643nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 11:12:22 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and rfkill->get_state()
Date: Thu, 18 Sep 2008 20:12:18 +0200
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20080918145236.GJ1583@khazad-dum.debian.net> <200809181932.58272.IvDoorn@gmail.com> <1221760328.9262.94.camel@johannes.berg>
In-Reply-To: <1221760328.9262.94.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809182012.18723.IvDoorn@gmail.com> (sfid-20080918_201227_237446_E496479C)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Johannes Berg wrote:
> On Thu, 2008-09-18 at 19:32 +0200, Ivo van Doorn wrote:
> 
> > Ideal situation would indeed be that mac80211 registers a rfkill structure
> > and listens to rfkill events. This would help drivers by only needing to
> > register a rfkill structure for state-change events without any need for
> > listeners.
> 
> Yup.
> 
> > I was considering such a patch some time ago, but needed to figure out
> > how to work with the state-override capabilities (HW_BLOCK and SOFT_BLOCK)
> > and didn't work on it any further since.
> 
> So make the struct part of the hw structure? Then drivers can just use
> that to force hard events. Or actually, no, don't do this, make a new
> mac80211 call:
> 
> 	ieee80211_inform_hardblocked(BLOCK/OPEN)
> 
> which makes sure we can also try to not associate in this case in the
> future...

Yeah, unfortunately that wasn't the probablematic part. ;)
Anyway when I have some time available I'll see if I can sort it out and
make it work. But that will not be for another week or 2.

Ivo
