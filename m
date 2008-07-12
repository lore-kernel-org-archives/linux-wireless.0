Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:27469 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752339AbYGLM5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jul 2008 08:57:17 -0400
From: Bruno Randolf <br1@einfach.org>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 1/1] iwlwif: remove compilation warnings iwl_add_radiotap
Date: Sat, 12 Jul 2008 14:57:06 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
References: <1215689322-25017-1-git-send-email-tomas.winkler@intel.com> <1215697922.3483.18.camel@johannes.berg> <1ba2fa240807100747g285b5ff0of81bf619ad9ee3b9@mail.gmail.com>
In-Reply-To: <1ba2fa240807100747g285b5ff0of81bf619ad9ee3b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807121457.06795.br1@einfach.org> (sfid-20080712_145725_286906_720FFA43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 10 July 2008 16:47:57 Tomas Winkler wrote:
> On Thu, Jul 10, 2008 at 4:52 PM, Johannes Berg
>
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2008-07-10 at 15:25 +0300, Tomas Winkler wrote:
> >> > what about using the generic function to add the radiotap header from
> >> > mac80211? it should be flexible enough to handle all devices by now.
> >>
> >> Why not go ahead.
> >
> > I always thought you were adding 11n stuff, but if that's not the case
> > (and we may make mac80211 do that at some point) then that'd be a nice
> > code removal.
>
> I have never really looked into radio tap so I don't want to make any
> statements here. If the 11n part can be done in mac80211 why not.

hi!

i'm currently working on a patch removing iwl's own radiotap header. while 
doing that i noticed, that we currently don't have a field in 
ieee80211_rx_status for the modulation used. for example iwl knows if the 
frame was demodulated using CCK (RX_RES_PHY_FLAGS_MOD_CCK_MSK), thus it's 
able to differentiate between B and G modes. in mac80211 we can't do that 
right now.

i guess we could deduct the modulation from the rate

1, 2, 5.5, 11	-> CCK
everything else	-> OFDM

but i'm not sure if this is always true. is there any hardware that also does 
PBCC? also what about CCK-OFDM modes (b/g interoperability), do we have any 
way to identify these?

what do you think, should we explicitly make a modulation field in rx_status 
or should we implicitly deduct the modulation from the rates?

bruno
