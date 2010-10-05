Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:3163 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756080Ab0JEBZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 21:25:02 -0400
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0702871896
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 10:25:00 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3] mac80211: Add WME information element for IBSS
Date: Tue, 5 Oct 2010 10:24:56 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20101004021730.3870.14677.stgit@tt-desk> <1286191300.3620.2.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286191300.3620.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201010051024.56936.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon October 4 2010 20:21:40 Johannes Berg wrote:
> On Mon, 2010-10-04 at 11:17 +0900, Bruno Randolf wrote:
> > Enable WME QoS in IBSS mode by adding a WME information element to
> > beacons and probe respones and by checking for it and marking stations
> > as WME capable if it is present.
> > 
> > Signed-off-by: Bruno Randolf <br1@einfach.org>
> > 
> > ---
> > v3: use GFP_ATOMIC and re-organize nesting of "if" statements. allthough
> > in practice we would probaby always have the rates element i think it's
> > more correct to code it like this.
> 
> You're probably right, but shouldn't that be a separate patch? It
> doesn't relate to WME at all, afaict.

it does. before we only looked at elems->supp_rates, so it was o.k. to combine 
that check into the first if (adhoc mode && bssid matches). now we also check 
elems->wmm_info so we should make separate cases for each. as i noted, it 
probably does not matter much in practice, since elems->supp_rates should be 
present in all proper beacons and probe responses.

bruno
