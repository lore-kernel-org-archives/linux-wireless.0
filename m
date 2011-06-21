Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab1FUNnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 09:43:39 -0400
Subject: Re: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
In-Reply-To: <20110621130305.GB32464@hertz.marvell.com>
References: <20110616102138.GA24447@hertz.marvell.com>
	 <20110616102707.GB24458@hertz.marvell.com>
	 <d38dc36c1ab9a4bd819b9bcbbda181da@secure.sipsolutions.net>
	 <20110617132527.GA27436@hertz.marvell.com>
	 <1308331485.7329.2.camel@Nokia-N900-51-1>
	 <20110620143051.GA31035@hertz.marvell.com>
	 <1308583799.4322.9.camel@jlt3.sipsolutions.net>
	 <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
	 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
	 <20110621130305.GB32464@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Jun 2011 15:43:34 +0200
Message-ID: <1308663814.4276.3.camel@jlt3.sipsolutions.net> (sfid-20110621_154345_878567_17CAF3A8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 18:33 +0530, Yogesh Ashok Powar wrote:

> Following is the implementation based on your design.
> 
> Let me know if I miss anything here.

Since your original code was reverted you should send a full patch. But
overall it looks fine. Came to think of it yesterday though, for the
0->1 case it's of course necessary to do the adjustment before the key
can be found, but also for the 1->0 case it'll be necessary to do the
counter adjustment after the key adjustments.

johannes

