Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34558 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab0K3PfP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 10:35:15 -0500
Subject: Re: [PATCH 2/2 v4] mac80211: add throughput based LED blink trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1291131013.13968.1.camel@wwguy-ubuntu>
References: <1290884614.3700.3.camel@jlt3.sipsolutions.net>
	 <1290885648.3700.4.camel@jlt3.sipsolutions.net>
	 <1290947171.3467.7.camel@jlt3.sipsolutions.net>
	 <1291103925.3624.1.camel@jlt3.sipsolutions.net>
	 <1291131013.13968.1.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 16:35:12 +0100
Message-ID: <1291131312.3624.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-30 at 07:30 -0800, Guy, Wey-Yi wrote:

> > +       for (i = tpt_trig->blink_table_len - 1; i >= 0; i--) {
> > +               if (tpt_trig->blink_table[i].throughput < 0 ||
> > +                   tpt > tpt_trig->blink_table[i].throughput) {
> > +                       off = tpt_trig->blink_table[i].blink_time / 2;
> > +                       on = tpt_trig->blink_table[i].blink_time - off;
> > +                       break;
> > +               }
> > +       }
> 
> I know it is the case for iwlwifi today, but is true "on time" == "off
> time"?

Yeah, I discussed that with Felix and we decided that if somebody wants
it different at some point they can change the code themselves :-)

johannes

