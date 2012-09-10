Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2IJKxx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 06:53:53 -0400
Message-ID: <1347274468.4272.9.camel@jlt4.sipsolutions.net> (sfid-20120910_125355_965165_2B0FD669)
Subject: Re: [PATCH v3 2/7] mac80211: add radar detection command/event
From: Johannes Berg <johannes@sipsolutions.net>
To: "Goldenshtein, Victor" <victorg@ti.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Mon, 10 Sep 2012 12:54:28 +0200
In-Reply-To: <CAK80WHb2Cu_3AfEt5cUa8uX=3FriCdbbTZfqmgaPU-jLrreNJg@mail.gmail.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
	 <1344426823-1795-3-git-send-email-victorg@ti.com>
	 <20120810162810.GB17559@redhat.com>
	 <CAK80WHa1ae7jA6BxOA+1Xx0bTx2_0+0GuDa=UrJ+qsC9_sYZ7g@mail.gmail.com>
	 <20120813073637.GB2272@redhat.com>
	 <CAK80WHb2Cu_3AfEt5cUa8uX=3FriCdbbTZfqmgaPU-jLrreNJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-20 at 10:21 +0300, Goldenshtein, Victor wrote:
> On Mon, Aug 13, 2012 at 10:36 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Sun, Aug 12, 2012 at 10:31:40AM +0300, Goldenshtein, Victor wrote:
> >> On Fri, Aug 10, 2012 at 7:28 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> > On Wed, Aug 08, 2012 at 02:53:38PM +0300, Victor Goldenshtein wrote:
> >> >> --- a/include/net/mac80211.h
> >> >> +++ b/include/net/mac80211.h
> >> >> @@ -2262,6 +2262,10 @@ enum ieee80211_rate_control_changed {
> >> >>   *   The callback will be called before each transmission and upon return
> >> >>   *   mac80211 will transmit the frame right away.
> >> >>   *   The callback is optional and can (should!) sleep.
> >> >> + *
> >> >> +* @start_radar_detection: Start radar detection on current operational
> >> >> + *   channel, once started it will continuously monitor for radars as long
> >> >> + *   as the channel active.
> >> >>   */
> >> >>  struct ieee80211_ops {
> >> >>       void (*tx)(struct ieee80211_hw *hw, struct sk_buff *skb);
> >> >> @@ -2404,6 +2408,10 @@ struct ieee80211_ops {
> >> >>
> >> >>       void    (*mgd_prepare_tx)(struct ieee80211_hw *hw,
> >> >>                                 struct ieee80211_vif *vif);
> >> >> +
> >> >> +     int (*start_radar_detection)(struct ieee80211_hw *hw,
> >> >> +                                  struct ieee80211_vif *vif,
> >> >> +                                  struct ieee80211_channel *chan);
> >> >
> >> > Why we need new callback? I.e. why this can be done by ->config ?
> >> >
> >>
> >> See proposed RFC and previous threads.
> >
> > I can not find mail where this is explained, could you please provide
> > link.
> >
> 
> http://article.gmane.org/gmane.linux.kernel.wireless.general/83760/match=

Well, that doesn't really explain it, but I do think that it's easier
for drivers to implement as a separate callback and we can then also
tell whether it's supported or not.

johannes

