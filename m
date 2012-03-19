Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2CSIXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 04:23:39 -0400
Subject: RE: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20326.41009.17936.152095@gargle.gargle.HOWL>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	 <1331902885.6753.10.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	 <1332065984.3609.5.camel@jlt3.sipsolutions.net>
	 <20326.41009.17936.152095@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 09:23:32 +0100
Message-ID: <1332145412.3359.2.camel@jlt3.sipsolutions.net> (sfid-20120319_092403_281610_43D2BB8F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 08:25 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > I'm not sure I can believe this -- surely the firmware has to have a way
> > of dealing with stations that can't do 40 MHz and stations that can, so
> > switching between the two doesn't seem like a major proposal? We also
> > don't currently handle the action frames for that, but it seems like we
> > should.
> 
> We have BSS_CHANGED_HT for doing this.

Actually, no -- that's how we got into this mess to start with :-)
Bandwidth here is a per-peer property, BSS_CHANGED_HT is changing the
operation mode (things like non-HT protection).

We used to change the channel bandwidth when the AP wanted to only
receive 20 MHz, but that seems like a bug because that doesn't even
necessarily mean it wants to TX 20 MHz.

So I think what Paul and I have changed/are changing it to makes more
sense:
 * the channel bandwidth never changes
 * the RX bandwidth for a peer has its own notification
 * BSS_CHANGED_HT changes protection mode etc.

johannes

