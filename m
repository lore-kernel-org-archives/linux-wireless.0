Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2CSKJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 06:09:07 -0400
Subject: RE: mac80211 20/40 coexist
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20327.1220.845693.349959@gargle.gargle.HOWL>
References: <1331818214.3432.12.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3005E@aphydexd01b>
	 <1331902885.6753.10.camel@jlt3.sipsolutions.net>
	 <8F3AF1C9F856774F8C8D67AA7EDFEC8801E3040B@aphydexd01b>
	 <1332065984.3609.5.camel@jlt3.sipsolutions.net>
	 <20326.41009.17936.152095@gargle.gargle.HOWL>
	 <1332145412.3359.2.camel@jlt3.sipsolutions.net>
	 <20327.1220.845693.349959@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 11:09:03 +0100
Message-ID: <1332151743.3359.19.camel@jlt3.sipsolutions.net> (sfid-20120319_110910_758495_7A353FC0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 15:34 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > Actually, no -- that's how we got into this mess to start with :-)
> > Bandwidth here is a per-peer property, BSS_CHANGED_HT is changing the
> > operation mode (things like non-HT protection).
> > 
> > We used to change the channel bandwidth when the AP wanted to only
> > receive 20 MHz, but that seems like a bug because that doesn't even
> > necessarily mean it wants to TX 20 MHz.
> 
> 11.14.4.3 specifies that if the operating bandwidth has been changed by the AP
> to 20 MHz, then transmitting frames in an extension channel is not allowed ?

Ok, good point. Paul's case was regulatory related, where we
(voluntarily) ceased 40 MHz transmissions.

Still though, I think reconfiguring the channel type rather than the
rate control algorithm doesn't make a lot of sense in this case since
it'd make this very special and unlike the other cases (e.g. AP mode).

johannes

