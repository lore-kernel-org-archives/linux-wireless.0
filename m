Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28462 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbZFHP6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 11:58:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 08:58:13 -0700
Date: Mon, 8 Jun 2009 08:58:13 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"j@w1.fi" <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: Re: [PATCH v2 11/15] ath9k: remove unnecessary
	IEEE80211_TX_CTL_NO_ACK  checks
Message-ID: <20090608155813.GB22060@tesla>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com> <1244246629-28179-12-git-send-email-lrodriguez@atheros.com> <69e28c910906071125n54128452ja77495ae5f62beed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <69e28c910906071125n54128452ja77495ae5f62beed@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 07, 2009 at 11:25:31AM -0700, Gábor Stefanik wrote:
> On Sat, Jun 6, 2009 at 2:03 AM, Luis R. Rodriguez<lrodriguez@atheros.com> wrote:
> > We check for this condition early on in our mac80211 get_rate()
> > callback ath_get_rate(), so remove this check later down the path.
> >
> > Cc: Derek Smithies <derek@indranet.co.nz>
> > Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/rc.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> > index 9907f2f..d8d2152 100644
> > --- a/drivers/net/wireless/ath/ath9k/rc.c
> > +++ b/drivers/net/wireless/ath/ath9k/rc.c
> > @@ -783,7 +783,6 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
> >         * just CTS.  Note that this is only done for OFDM/HT unicast frames.
> >         */
> >        if ((sc->sc_flags & SC_OP_PROTECT_ENABLE) &&
> > -           !(tx_info->flags & IEEE80211_TX_CTL_NO_ACK) &&
> >            (rate_table->info[rix].phy == WLAN_RC_PHY_OFDM ||
> >             WLAN_RC_PHY_HT(rate_table->info[rix].phy))) {
> >                rates[0].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
> > @@ -890,9 +889,8 @@ static void ath_rc_ratefind(struct ath_softc *sc,
> >         *
> >         * FIXME: Fix duration
> >         */
> > -       if (!(tx_info->flags & IEEE80211_TX_CTL_NO_ACK) &&
> > -           (ieee80211_has_morefrags(fc) ||
> > -            (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG))) {
> > +       if (ieee80211_has_morefrags(fc) ||
> > +           (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG)) {
> >                rates[1].count = rates[2].count = rates[3].count = 0;
> >                rates[1].idx = rates[2].idx = rates[3].idx = 0;
> >                rates[0].count = ATH_TXMAXTRY;
> > --
> > 1.6.0.6
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Is this a side effect of my NO_ACK retry count patchset accepted earlier?

Yes.

  Luis
