Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab3BFV3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 16:29:54 -0500
Message-ID: <1360186206.7910.75.camel@jlt4.sipsolutions.net> (sfid-20130206_222958_319448_C8B5FFAD)
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
Date: Wed, 06 Feb 2013 22:30:06 +0100
In-Reply-To: <20130206180227.GB6280@thinkpad-t410>
References: <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
	 <1359645648.8415.77.camel@jlt4.sipsolutions.net>
	 <20130131163355.GE28799@thinkpad-t410>
	 <1359651229.8415.99.camel@jlt4.sipsolutions.net>
	 <20130131171826.GG28799@thinkpad-t410>
	 <1359654634.8415.101.camel@jlt4.sipsolutions.net>
	 <20130205225101.GB29557@thinkpad-t410>
	 <1360169290.7910.29.camel@jlt4.sipsolutions.net>
	 <20130206170952.GA6280@thinkpad-t410>
	 <1360172656.7910.60.camel@jlt4.sipsolutions.net>
	 <20130206180227.GB6280@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 12:02 -0600, Seth Forshee wrote:

> > Ah, wl1251 is the weird thing that wants to be told when to wake up/go
> > to sleep, and then sends nulldata packets itself ... so when we send
> > nulldata packets *again* for off-channel, because it also uses software
> > scanning. Like I said before -- "stupidest powersave implementation on
> > the planet".
> 
> Ah, I had wondered what hardware that code was there for :-)

I was actually wrong -- wl1251 has HW scan so it doesn't matter.
However, iwlegacy does this...

> So I think the approach I'm advocating could possibly make things better
> for wl1251. If it's told about going to off-channel powersave rather
> than being told it's leaving powersave, maybe it can do the right thing
> with the nullfunc frames without mac80211 generating the extra nullfunc.
> I don't know that for sure though because I don't understand how the
> hardware works.

Probably not. For iwlegacy anyway it won't help.

> > > So using these definition powersave is already a mandatory feature for
> > > any hardware which uses software scanning. 
> > 
> > Even offloaded scanning, it's just not visible to mac80211 then.
> 
> Okay, sure. I'm just thinking of things from the mac80211 perspective.

Right, sure.

> > > All I'm really doing is
> > > making this explicit, and drivers would now opt in to being placed into
> > > the doze state rather than opting into powersave in general. And of
> > > course drivers are now told about transitions to the non-doze powersave
> > > state (what I'm calling offchannel), so that drivers which need to do
> > > hardware configuration for this state can do so.
> > 
> > Ok, so maybe just calling it offchannel makes more sense, although that
> > really interacts only this way with powersave in managed mode, in P2P GO
> > mode .... oh well.
> 
> I admit I've only been considering managed mode and know next to nothing
> about P2P GO mode. If I'm creating problems for any other modes I'd
> definitely like to know about it so I can take it into consideration.

No no, I'm just saying there "powersave" could have even more
meanings ...

johannes

