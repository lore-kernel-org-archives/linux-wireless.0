Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0FLRrh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 13:47:37 -0400
Subject: Re: [PATCH v2] mac80211: Use a separate CCMP PN receive counter
 for management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1276364067.2625.12.camel@ct>
References: <20100611024625.GB3985@jm.kir.nu>
	 <20100611172733.GA21347@jm.kir.nu>  <1276364067.2625.12.camel@ct>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 19:47:19 +0200
Message-ID: <1276364839.7894.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-06-12 at 13:34 -0400, Pavel Roskin wrote:
> On Fri, 2010-06-11 at 10:27 -0700, Jouni Malinen wrote:
> 
> > -		for (i = 0; i < NUM_RX_DATA_QUEUES; i++) {
> > +		for (i = 0; i < NUM_RX_DATA_QUEUES + 1; i++) {
> 
> Perhaps we could have a define for NUM_RX_DATA_QUEUES + 1, e.g.
> NUM_RX_ALL_QUEUES

I kinda disagree. Yes, this is tricky code, but adding a define wouldn't
make it clearer. In fact, it isn't really related to queues to start
with, and ALL_QUEUES would just strengthen that mostly wrong notion.

I guess it really should be renamed to TIDs with the last two being
special for non-QoS (so no TID) traffic + mgmt traffic. But then
sequence numbers are allocated from the same counter (so there we just
have 17 possibilities) while PNs have 18 counters...

johannes

