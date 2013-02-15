Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3BOMUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 07:20:17 -0500
Message-ID: <1360930807.15040.10.camel@jlt4.sipsolutions.net> (sfid-20130215_132021_617031_E6B73DBD)
Subject: Re: [PATCH 1/4] mac80211: Convert PS configuration from a binary
 flag to a set of modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
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
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Date: Fri, 15 Feb 2013 13:20:07 +0100
In-Reply-To: <20130213170445.GC22867@thinkpad-t410>
References: <1360184478-31481-1-git-send-email-seth.forshee@canonical.com>
	 <1360184478-31481-2-git-send-email-seth.forshee@canonical.com>
	 <1360767970.8868.24.camel@jlt4.sipsolutions.net>
	 <20130213170445.GC22867@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[-ilw list, it just bothers me about putting emails into quarantine]

> > I'm not really convinced this is the right thing to do. Sooner or later,
> > multi-virtual interface support will become more relevant, and then all
> > of this is completely moot because then powersave is entirely disabled
> > and not handled right now.
> 
> Hmm, I don't recall you really going into any detail regarding
> powersave, only managing the queues for off-channel. Though I can see
> that multi-vif throws a wrench into things, even if I don't understand
> all the details.

Yeah, that must've been another time. I've evidently been kicking around
these ideas in my head for long enough to not be able to tell apart
reality and dream any more ;-)

> > Is all this really worth it? It seems a quick fix for brcmsmac might be
> > to always set the powersave bit when IEEE80211_CONF_OFFCHANNEL is
> > enabled in the config, and then go implement a real solution like I
> > described earlier with powersave being separated out of the core
> > mac80211 routines, and actually made possible for multiple interfaces?
> 
> Using IEEE80211_CONF_OFFCHANNEL won't work. When the nullfunc to enable
> PS is sent the flag won't be set, as we're still on the operating
> channel. When we're actually off-channel the value of PM doesn't matter
> for the types of frames which are being sent. 

Oh, right.

> The only quick fix I've
> found is to watch out for frames with PM set and set the powersave bit
> while they're being transmitted.

That's ugly.

> I'm going to have to spend some time trying to grok how powersave would
> work out with multiple interfaces. Honestly though I don't know that
> multiple interfaces is something that we have any interest in at the
> moment, and if not then it may be difficult for me to justify spending
> much time on it.

Yeah, I know, nobody really seems to care, but the current code is so
crappy ... do I have to _make_ people care by just removing all
powersave code? Hard to justify too ... :)

johannes

