Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42419 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab2JISn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2012 14:43:59 -0400
Message-ID: <1349808259.4683.17.camel@jlt4.sipsolutions.net> (sfid-20121009_204418_998095_9A6E3DD7)
Subject: Re: [PATCH v3 5/7] nl80211/cfg80211: add ap channel switch command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Tue, 09 Oct 2012 20:44:19 +0200
In-Reply-To: <CAK80WHarUE=6tne+BD=cvMHVT7Yyq+kK2ce=cHvfuapxqyo35w@mail.gmail.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-6-git-send-email-victorg@ti.com>
	 <1347276227.4272.17.camel@jlt4.sipsolutions.net>
	 <CAK80WHarUE=6tne+BD=cvMHVT7Yyq+kK2ce=cHvfuapxqyo35w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-03 at 15:53 +0200, Goldenshtein, Victor wrote:
> >> @@ -720,6 +728,8 @@ enum nl80211_commands {
> >>
> >>       NL80211_CMD_CH_SWITCH_NOTIFY,
> >>
> >> +     NL80211_CMD_AP_CH_SWITCH,
> >> +
> >>       NL80211_CMD_RADAR_DETECT,
> >>
> >>       NL80211_CMD_DFS_ENABLE_TX,
> >
> > Ahem.
> >
> 
> just thought to put the channel switch stuff together.
> don't might to move it down.

Yeah but you can *never* insert anything in the middle.


> >>   * @NL80211_FEATURE_DFS: Radar detection is supported in the HW/driver.
> >> + * @NL80211_FEATURE_AP_CH_SWITCH: This driver supports AP channel switch.
> >
> > I have a nagging feeling I keep asking this, but what's the point of
> > radar detection without channel switch? Or is it the other way around
> > that's interesting? Maybe should verify that if you have DFS you also
> > have chanswitch?
> 
> one might support a channel switch without DFS, but the one who sets
> the "NL80211_FEATURE_DFS" must support channel switch.
> I don't might to check both these flags, but then I think it would be
> cleaner (more readable) to leave the "dfs_supported" flag.
> something like:
> bool dfs_supported = ((local->hw.wiphy->features & NL80211_FEATURE_DFS) &&
> (local->hw.wiphy->features & NL80211_FEATURE_AP_CH_SWITCH));


fair enough. makes sense for p2p I guess

> >> + * @block_tx: Indicates whether transmission must be blocked before the
> >> + *   scheduled channel switch, as indicated by the AP.

> > Bogus documentation.
> 
> can you please elaborate on this one.

for example the only thing I quoted above now ... clearly can't be right

> note that it's almost identical to "ieee80211_channel_switch" struct,

and that's the problem

johannes

