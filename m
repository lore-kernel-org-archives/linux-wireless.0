Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456Ab3BFRn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 12:43:59 -0500
Message-ID: <1360172656.7910.60.camel@jlt4.sipsolutions.net> (sfid-20130206_184403_053447_0DCD9054)
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
Date: Wed, 06 Feb 2013 18:44:16 +0100
In-Reply-To: <20130206170952.GA6280@thinkpad-t410>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
	 <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
	 <1359645648.8415.77.camel@jlt4.sipsolutions.net>
	 <20130131163355.GE28799@thinkpad-t410>
	 <1359651229.8415.99.camel@jlt4.sipsolutions.net>
	 <20130131171826.GG28799@thinkpad-t410>
	 <1359654634.8415.101.camel@jlt4.sipsolutions.net>
	 <20130205225101.GB29557@thinkpad-t410>
	 <1360169290.7910.29.camel@jlt4.sipsolutions.net>
	 <20130206170952.GA6280@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 11:09 -0600, Seth Forshee wrote:

> > Does it just mean "I support actually turning off the radio"? But then
> > what's the difference to supporting powersave? Can we maybe just
> > disregard wl1251, which has the stupidest powersave implementation on
> > the planet, and solve the "normal" problems first? :)
> 
> PS_DOZE means it actually supports putting the hardware into a low-power
> state for powersave. I did take the term from the spec (802.11-2012). It
> is usually used with regard to mesh, but it also appears wrt
> infrastructure BSS (see especially 10.2.1.2 which defines both awake and
> doze in the context of infrastructure networks).
> 
> I'm open to other terms, doze just seems to be consistent with the spec.

Thanks for the reference. I had actually thought the term seemed
familiar but then only found mesh references ... need to brush up my
spec knowledge I guess :)

> I haven't considered wl1251 specifically, only enough to update it so
> that it continues to build.

Ah, wl1251 is the weird thing that wants to be told when to wake up/go
to sleep, and then sends nulldata packets itself ... so when we send
nulldata packets *again* for off-channel, because it also uses software
scanning. Like I said before -- "stupidest powersave implementation on
the planet".

> Maybe what's confusing here is that I'm making a differentiation between
> "powersave" as a mac-level feature and "powersave" as a low-power
> hardware state. Which is why I'm trying to change the mac80211
> terminology around so that "doze" now means the low-power state and
> "powersave" refers only to the state in which the AP is bufferring
> frames for us.

Right, ok. Maybe another term would be worthwhile? I mean, *all*
hardware has to support "MAC-level powersave" since you always want
background scanning. The question is how it's implemented ... I'm off
for dinner in a minute but I'll think about it a bit.

> So using these definition powersave is already a mandatory feature for
> any hardware which uses software scanning. 

Even offloaded scanning, it's just not visible to mac80211 then.

> All I'm really doing is
> making this explicit, and drivers would now opt in to being placed into
> the doze state rather than opting into powersave in general. And of
> course drivers are now told about transitions to the non-doze powersave
> state (what I'm calling offchannel), so that drivers which need to do
> hardware configuration for this state can do so.

Ok, so maybe just calling it offchannel makes more sense, although that
really interacts only this way with powersave in managed mode, in P2P GO
mode .... oh well.

> > > In practice the changes shouldn't end up much different than what I have
> > > in these patches, but I think it's conceptually cleaner (and less
> > > confusing!). Does this sound reasonable to you?
> > 
> > Not really sure I understand it enough to comment :)
> 
> I've got working patches now, so maybe those will make everything clear.
> I need to do a little more testing and give them a quick review, then
> I'll send them out.

Ok.

johannes

