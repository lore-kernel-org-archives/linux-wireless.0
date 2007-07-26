Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38092 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935649AbXGZQl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 12:41:57 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH 1/1] mac80211: Replace overly "sticky" averagingfiltersfor rssi, signal, noise.
Date: Thu, 26 Jul 2007 09:41:48 -0700
Message-ID: <4220499A1B034C4FA93B547BA01E1FF001746244@orsmsx413.amr.corp.intel.com>
In-Reply-To: <1185463074.4006.23.camel@johannes.berg>
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Jiri Benc" <jbenc@suse.cz>, <benmcahill@gmail.com>,
	<flamingice@sourmilk.net>, <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> > Actually, "arithmetic" right shift works for either signed 
> or unsigned.
> > Arithmetic shift looks at the most-significant bit, and 
> shifts more of 
> > that in from the left, preserving the sign.
> 
> Eh, right. And I suppose it can actually optimise /16 by an 
> arithmetic shift.

Not sure if it would or wouldn't ... my by-hand analysis (see earlier
mail on this thread) found a subtle difference between:

(n * 15 / 16) vs. (n - (n >> 16)).

As it turned out, the 15/16 approach would have been slightly more
"sticky", IIRC.

-- Ben --

> 
> johannes
> 
