Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3AaRuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 12:50:17 -0500
Message-ID: <1359654634.8415.101.camel@jlt4.sipsolutions.net> (sfid-20130131_185021_480618_AEFFBAC9)
Subject: Re: [PATCH 5/7] mac80211: Expand powersave configuration flag to be
 two bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Arend van Spriel <arend@broadcom.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Date: Thu, 31 Jan 2013 18:50:34 +0100
In-Reply-To: <20130131171826.GG28799@thinkpad-t410>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
	 <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
	 <1359645648.8415.77.camel@jlt4.sipsolutions.net>
	 <20130131163355.GE28799@thinkpad-t410>
	 <1359651229.8415.99.camel@jlt4.sipsolutions.net>
	 <20130131171826.GG28799@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 11:18 -0600, Seth Forshee wrote:

> > > Actually one of the last bugs I fixed before sending these was a place
> > > where I had used disabled instead of !enabled, and the frames ended up
> > > with PM set when it shouldn't have been.
> > > 
> > > I agree though that the distinction is confusing. Maybe some better
> > > state names are needed. Perhaps awake, offchannel, and doze?
> > 
> > I think what you really want is to distinguish between "HW can go to
> > powersave" and "PM bit should be set"? That's pretty much what your
> > CONF_PS_ENABLED and CONF_PS_OFFCHANNEL means, respectively, but maybe
> 
> Correct, with the understanding that "HW can go to powersave" also
> implies "PM bit should be set."
> 
> Another approach would be to keep the CONF_PS flag the same and add a
> CONF_PM flag or similar. I didn't go with this approach because CONF_PS
> && !CONF_PM really doesn't make any sense, which really doesn't help
> with reducing confusion. The advantage is that it separates setting PM
> from PS for those driver that don't support PS but need to configure the
> hardware to set PM for off-channel.

Good point, that'd work too. PS && !PM would never be used, I guess?
It'd also have the advantage of not having to touch all the drivers?

It doesn't really matter all that much to me though, I just think what
you have right now is (too) confusing.

johannes

