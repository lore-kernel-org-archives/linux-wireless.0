Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:59258 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbZJTGgC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 02:36:02 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] libertas: monster-patch to make CFG/WEXT configurable
Date: Tue, 20 Oct 2009 08:35:35 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
References: <200910191449.18915.hs4233@mail.mn-solutions.de> <1255998802.4475.2.camel@johannes.local>
In-Reply-To: <1255998802.4475.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910200835.35747.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I really don't understand the point. Can't you just use the
> cfg80211 hooks and keep both functional at the same time? Just
> like orinoco does it uses cfg80211 only partially.

I think I can't do this in a sane way.

Oh, and please don't compare libertas all the time with orinoco.
Orinoco is FULLMAC, libertas is HALFMAC.

Because libertas firmware doesn't roam, it has to be done in 
software. Libertas does this in assoc.c, partly in scan.c, cmd.c 
and wext.c and even main.c. For example, libertas keeps its own 
list of BSS entries, has code to select the best matching BSS 
when it comes to associating ... things like this.

cfg80211 has this code too.

Having two competing implementations running in one driver is a 
way to havoc.


I could keep "old" stuff of the libertas in, e.g. monitor 
mode --- but then it's not too difficult to use .change_intf() 
to add monitor mode to cfg80211.

I can't and won't do the MESH stuff: I don't have a firmware that 
does MESH, no knowledge and usage case for MESH. It would, 
however, be possible to keep the current mesh code with WEXT and 
use cfg80211 for monitor/station mode. However, I dislike this 
more than cfg80211/wext configurability.

-- 
http://www.holgerschurig.de
