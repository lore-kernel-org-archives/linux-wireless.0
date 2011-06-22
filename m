Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab1FVMt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 08:49:28 -0400
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <20110622123118.GA4800@hertz.marvell.com>
References: <20110620143051.GA31035@hertz.marvell.com>
	 <1308583799.4322.9.camel@jlt3.sipsolutions.net>
	 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
	 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
	 <20110621130305.GB32464@hertz.marvell.com>
	 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
	 <20110621141017.GC32464@hertz.marvell.com>
	 <1308667215.4276.7.camel@jlt3.sipsolutions.net>
	 <20110621163351.GD32464@hertz.marvell.com>
	 <20110622071743.GA4087@hertz.marvell.com>
	 <20110622123118.GA4800@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 14:49:25 +0200
Message-ID: <1308746965.29571.1.camel@jlt3.sipsolutions.net> (sfid-20110622_144931_895225_42EC18D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-22 at 18:01 +0530, Yogesh Ashok Powar wrote:
> > Will work on some other logic.
> 
> Following is the complete V2-patch
> 
> v2 changes: a) Moved counter++ before __ieee80211_key_replace in
> 		key_link()
> 	    b) Moved crypto_tx_tailroom_needed_cnt to sdata resolve
> 	        issue with multiple sdata instances in hw reset.

Looks good. Now I'm just worried about memory and compiler barriers that
may be needed so the counter update doesn't move after anything else...
Hmm.

johannes

