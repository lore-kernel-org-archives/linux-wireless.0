Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53217 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab3BFSCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 13:02:35 -0500
Date: Wed, 6 Feb 2013 12:02:27 -0600
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
Message-ID: <20130206180227.GB6280@thinkpad-t410> (sfid-20130206_190239_099183_62F73FA4)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360172656.7910.60.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2013 at 06:44:16PM +0100, Johannes Berg wrote:
> > I haven't considered wl1251 specifically, only enough to update it so
> > that it continues to build.
> 
> Ah, wl1251 is the weird thing that wants to be told when to wake up/go
> to sleep, and then sends nulldata packets itself ... so when we send
> nulldata packets *again* for off-channel, because it also uses software
> scanning. Like I said before -- "stupidest powersave implementation on
> the planet".

Ah, I had wondered what hardware that code was there for :-)

So I think the approach I'm advocating could possibly make things better
for wl1251. If it's told about going to off-channel powersave rather
than being told it's leaving powersave, maybe it can do the right thing
with the nullfunc frames without mac80211 generating the extra nullfunc.
I don't know that for sure though because I don't understand how the
hardware works.

> > So using these definition powersave is already a mandatory feature for
> > any hardware which uses software scanning. 
> 
> Even offloaded scanning, it's just not visible to mac80211 then.

Okay, sure. I'm just thinking of things from the mac80211 perspective.

> > All I'm really doing is
> > making this explicit, and drivers would now opt in to being placed into
> > the doze state rather than opting into powersave in general. And of
> > course drivers are now told about transitions to the non-doze powersave
> > state (what I'm calling offchannel), so that drivers which need to do
> > hardware configuration for this state can do so.
> 
> Ok, so maybe just calling it offchannel makes more sense, although that
> really interacts only this way with powersave in managed mode, in P2P GO
> mode .... oh well.

I admit I've only been considering managed mode and know next to nothing
about P2P GO mode. If I'm creating problems for any other modes I'd
definitely like to know about it so I can take it into consideration.

Seth

