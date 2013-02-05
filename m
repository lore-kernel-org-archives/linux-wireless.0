Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48437 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3BEWvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 17:51:11 -0500
Date: Tue, 5 Feb 2013 16:51:01 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
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
Subject: Re: [PATCH 5/7] mac80211: Expand powersave configuration flag to be
 two bits
Message-ID: <20130205225101.GB29557@thinkpad-t410> (sfid-20130205_235115_434151_91299710)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
 <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
 <1359645648.8415.77.camel@jlt4.sipsolutions.net>
 <20130131163355.GE28799@thinkpad-t410>
 <1359651229.8415.99.camel@jlt4.sipsolutions.net>
 <20130131171826.GG28799@thinkpad-t410>
 <1359654634.8415.101.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359654634.8415.101.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2013 at 06:50:34PM +0100, Johannes Berg wrote:
> On Thu, 2013-01-31 at 11:18 -0600, Seth Forshee wrote:
> 
> > > > Actually one of the last bugs I fixed before sending these was a place
> > > > where I had used disabled instead of !enabled, and the frames ended up
> > > > with PM set when it shouldn't have been.
> > > > 
> > > > I agree though that the distinction is confusing. Maybe some better
> > > > state names are needed. Perhaps awake, offchannel, and doze?
> > > 
> > > I think what you really want is to distinguish between "HW can go to
> > > powersave" and "PM bit should be set"? That's pretty much what your
> > > CONF_PS_ENABLED and CONF_PS_OFFCHANNEL means, respectively, but maybe
> > 
> > Correct, with the understanding that "HW can go to powersave" also
> > implies "PM bit should be set."
> > 
> > Another approach would be to keep the CONF_PS flag the same and add a
> > CONF_PM flag or similar. I didn't go with this approach because CONF_PS
> > && !CONF_PM really doesn't make any sense, which really doesn't help
> > with reducing confusion. The advantage is that it separates setting PM
> > from PS for those driver that don't support PS but need to configure the
> > hardware to set PM for off-channel.
> 
> Good point, that'd work too. PS && !PM would never be used, I guess?
> It'd also have the advantage of not having to touch all the drivers?
> 
> It doesn't really matter all that much to me though, I just think what
> you have right now is (too) confusing.

Hi Johannes,

I've been thinking about and playing around with these ideas. I've
implemented the CONF_PM idea, and it does end up with fewer changes, but
I just don't think separating powersave from setting PM makes much
sense. In the end it just seems like a kludge to fix a problem with
Broadcom chips, and if I want a kludge I can do it entirely within the
driver.

So what I'm planning to do know is implement the awake/doze/offchannel
powersave modes like I had mentioned, but taking things a bit further.
I'd change IEEE80211_HW_SUPPORTS_PS to SUPPORTS_PS_DOZE, indicating
support for a low-power powersave state rather than support for
powersave in general. All hardware will be reconfigured for
awake<->offchannel transitions (though most drivers can simply ignore
these transitions), but hardware will only be put in the doze state if
it indicates PS_DOZE support.

This will make it compulsory for all drivers to indicate whether or not
they require IEEE802111_HW_PS_NULLFUNC_STACK. I'll simply set this flag
for any drivers not currently supporting powersave.

In practice the changes shouldn't end up much different than what I have
in these patches, but I think it's conceptually cleaner (and less
confusing!). Does this sound reasonable to you?

Thanks,
Seth

