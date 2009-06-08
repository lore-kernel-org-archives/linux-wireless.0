Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28442 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419AbZFHP5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 11:57:37 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 08:57:40 -0700
Date: Mon, 8 Jun 2009 08:57:40 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Karl Hiramoto <karl@hiramoto.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"j@w1.fi" <j@w1.fi>, Derek Smithies <derek@indranet.co.nz>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chittajit Mitra <Chittajit.Mitra@Atheros.com>
Subject: Re: [ath9k-devel] [PATCH v2 08/15] ath9k: remove ATH9K_MODE_11B
Message-ID: <20090608155740.GA22060@tesla>
References: <1244246629-28179-1-git-send-email-lrodriguez@atheros.com> <1244246629-28179-9-git-send-email-lrodriguez@atheros.com> <4A2A19FD.3030302@hiramoto.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4A2A19FD.3030302@hiramoto.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 06, 2009 at 12:25:49AM -0700, Karl Hiramoto wrote:
> Luis R. Rodriguez wrote:
> > This saves us 2733 bytes.
> >
> >    text    data     bss     dec     hex filename
> >  252265    3628    1584  257477   3edc5 ath9k-has-b-rate.ko
> >  249905    3628    1584  255117   3e48d ath9k.ko
> >
> > Cc: Derek Smithies <derek@indranet.co.nz>
> > Cc: Chittajit Mitra <Chittajit.Mitra@Atheros.com>
> > Siged-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> >  drivers/net/wireless/ath/ath9k/hw.c |    1 -
> >  drivers/net/wireless/ath/ath9k/hw.h |    1 -
> >  drivers/net/wireless/ath/ath9k/rc.c |   23 -----------------------
> >  3 files changed, 0 insertions(+), 25 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> > index 1579c94..de2c000 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.c
> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
> > @@ -3294,7 +3294,6 @@ void ath9k_hw_fill_cap_info(struct ath_hw *ah)
> >       }
> >
> >       if (eeval & AR5416_OPFLAGS_11G) {
> > -             set_bit(ATH9K_MODE_11B, pCap->wireless_modes);
> >               set_bit(ATH9K_MODE_11G, pCap->wireless_modes);
> >               if (ah->config.ht_enable) {
> >                       if (!(eeval & AR5416_OPFLAGS_N_2G_HT20))
> > diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
> > index dd8508e..73d859e 100644
> > --- a/drivers/net/wireless/ath/ath9k/hw.h
> > +++ b/drivers/net/wireless/ath/ath9k/hw.h
> > @@ -113,7 +113,6 @@
> >
> >  enum wireless_mode {
> >       ATH9K_MODE_11A = 0,
> > -     ATH9K_MODE_11B = 2,
> >       ATH9K_MODE_11G = 3,
> >       ATH9K_MODE_11NA_HT20 = 6,
> >       ATH9K_MODE_11NG_HT20 = 7,
> > diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
> > index 01586d2..980040b 100644
> > --- a/drivers/net/wireless/ath/ath9k/rc.c
> > +++ b/drivers/net/wireless/ath/ath9k/rc.c
> > @@ -380,27 +380,6 @@ static const struct ath_rate_table ar5416_11g_ratetable = {
> >       0,   /* Phy rates allowed initially */
> >  };
> >
> > -static const struct ath_rate_table ar5416_11b_ratetable = {
> > -     4,
> > -     {
> > -             { VALID, VALID, WLAN_RC_PHY_CCK, 1000, /* 1 Mb */
> > -                     900, 0x1b,  0x00, (0x80|2),
> > -                     0, 0, 1, 0, 0 },
> > -             { VALID, VALID, WLAN_RC_PHY_CCK, 2000, /* 2 Mb */
> > -                     1800, 0x1a, 0x04, (0x80|4),
> > -                     1, 1, 1, 1, 0 },
> > -             { VALID, VALID, WLAN_RC_PHY_CCK, 5500, /* 5.5 Mb */
> > -                     4300, 0x19, 0x04, (0x80|11),
> > -                     1, 2, 2, 2, 0 },
> > -             { VALID, VALID, WLAN_RC_PHY_CCK, 11000, /* 11 Mb */
> > -                     7100, 0x18, 0x04, (0x80|22),
> > -                     1, 4, 100, 3, 0 },
> > -     },
> > -     100, /* probe interval */
> > -     100, /* rssi reduce interval */
> > -     0,   /* Phy rates allowed initially */
> > -};
> > -
> >  static inline int8_t median(int8_t a, int8_t b, int8_t c)
> >  {
> >       if (a >= b) {
> > @@ -1723,8 +1702,6 @@ static struct rate_control_ops ath_rate_ops = {
> >
> >  void ath_rate_attach(struct ath_softc *sc)
> >  {
> > -     sc->hw_rate_table[ATH9K_MODE_11B] =
> > -             &ar5416_11b_ratetable;
> >       sc->hw_rate_table[ATH9K_MODE_11A] =
> >               &ar5416_11a_ratetable;
> >       sc->hw_rate_table[ATH9K_MODE_11G] =
> >
> 
> 
> Does this mean that 802.11b will not work anymore? A lot of legacy
> equipment that only supports B is still arround.

11b rates are in the 11g rate table. AFAICT this was just legacy code
which was present due to support of old 11b only cards.

  Luis
