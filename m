Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52503 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab2C3Gqo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 02:46:44 -0400
Message-ID: <1333089999.3908.4.camel@jlt3.sipsolutions.net> (sfid-20120330_084648_169968_9F895E39)
Subject: Re: [PATCH 2/4] mac80211: remove channel type argument from
 rate_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Fri, 30 Mar 2012 08:46:39 +0200
In-Reply-To: <20341.14488.303053.16407@gargle.gargle.HOWL>
References: <20120328085835.902687300@sipsolutions.net>
	 <20120328085901.175434140@sipsolutions.net>
	 <20341.14488.303053.16407@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-30 at 10:07 +0530, Sujith Manoharan wrote:
> Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > The channel type argument to the rate_update()
> > callback isn't really the correct way to give
> > the rate control algorithm about the desired
> > RX bandwidth of the peer.
> > 
> > Remove this argument, and instead update the
> > STA capabilities with 20/40 appropriately. The
> > SMPS update done by this callback works in the
> > same way, so this makes the callback cleaner.
> 
> I think that the HT capabilities cannot be changed dynamically.
> The HT operating parameters along with ChannelSwitch frames are used to
> notify bandwidth changes. Or that is my understanding of 11.14.4.2.

Yes, that's true. However, we use the sta.ht_cap field more of a current
operating set database. For example, we also update it when the station
changes SMPS configuration. Also, we never keep it at just the station's
capabilities -- we always restrict it by our own TX capabilities (so if
for example we aren't 40 MHz capable, we already don't leave 40 MHz in).

Overall, I don't really see a problem with this. I suppose we could
rename the field to make that a bit clearer, but I see little value in
using some other struct or so?

johannes

