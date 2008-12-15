Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:45096 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbYLOQGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 11:06:19 -0500
Subject: Re: [PATCH] ath5k: set mac address in add_interface
From: Dan Williams <dcbw@redhat.com>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, maximlevitsky@gmail.com,
	ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
References: <20081118044037.GA18983@hash.localnet>
	 <69e28c910812150747j60cf17d9nc2e24aabb991d2a9@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 15 Dec 2008 11:04:40 -0500
Message-Id: <1229357080.12163.47.camel@localhost.localdomain> (sfid-20081215_170628_081924_51DF0E35)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-15 at 16:47 +0100, Stefanik G=C3=A1bor wrote:
> This patch regressed support for aireplay-ng's "fragmentation attack"=
 feature!
>=20
> Prior to the landing of this patch (as commit
> caeb36d73b23b52a0ea2a8368502ef8230fa67b3), applying the patch @
> http://patches.aircrack-ng.org/mac80211_2.6.28-rc4-wl_frag+ack_v2.pat=
ch
> allowed aireplay-ng's fragmentation attack to work with almost all
> mac80211 drivers, including ath5k. After the landing of this patch,
> the attack fails with "No answer, repeating...". (Regression found
> using git bisect, and verified by local backout of commit
> caeb36d73b23b52a0ea2a8368502ef8230fa67b3.)

Unless I misunderstand...  but not all drivers will report their MAC
address until they have opened the device (ie, add_interface time),
because not all devices load firmware until the interface is opened, an=
d
thus some cannot read their MAC address until that time.

So aireplay-ng is broken if it relies on the device having a valid mac
address before the device is opened.

Dan

> On Tue, Nov 18, 2008 at 5:40 AM, Bob Copeland <me@bobcopeland.com> wr=
ote:
> > Hi Maxim,
> >
> > Please try this patch.  I didn't have a problem changing the mac ad=
dress
> > after it was set to something else.  I did kick it to re-associate =
with
> > the AP, though.
> >
> > Subject: [PATCH] ath5k: set mac address in add_interface
> >
> > Configure the mac address in add_interface and clear it in
> > remove_interface so that users can change the mac address
> > to something other than the one in the eeprom.  Also avoid
> > setting it at attach time so that we won't ack packets
> > until fully set up.
> >
> > Signed-off-by: Bob Copeland <me@bobcopeland.com>
> > ---
> >  drivers/net/wireless/ath5k/attach.c |   12 +++---------
> >  drivers/net/wireless/ath5k/base.c   |   13 +++++++++++--
> >  2 files changed, 14 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wire=
less/ath5k/attach.c
> > index 51d5698..49d82d7 100644
> > --- a/drivers/net/wireless/ath5k/attach.c
> > +++ b/drivers/net/wireless/ath5k/attach.c
> > @@ -106,7 +106,7 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_s=
oftc *sc, u8 mac_version)
> >  {
> >        struct ath5k_hw *ah;
> >        struct pci_dev *pdev =3D sc->pdev;
> > -       u8 mac[ETH_ALEN];
> > +       u8 mac[ETH_ALEN] =3D {};
> >        int ret;
> >        u32 srev;
> >
> > @@ -317,15 +317,9 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_=
softc *sc, u8 mac_version)
> >                goto err_free;
> >        }
> >
> > -       /* Set MAC address */
> > -       ret =3D ath5k_eeprom_read_mac(ah, mac);
> > -       if (ret) {
> > -               ATH5K_ERR(sc, "unable to read address from EEPROM: =
0x%04x\n",
> > -                       sc->pdev->device);
> > -               goto err_free;
> > -       }
> > -
> > +       /* MAC address is cleared until add_interface */
> >        ath5k_hw_set_lladdr(ah, mac);
> > +
> >        /* Set BSSID to bcast address: ff:ff:ff:ff:ff:ff for now */
> >        memset(ah->ah_bssid, 0xff, ETH_ALEN);
> >        ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
> > diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wirele=
ss/ath5k/base.c
> > index 34cd1a4..d5bf62a 100644
> > --- a/drivers/net/wireless/ath5k/base.c
> > +++ b/drivers/net/wireless/ath5k/base.c
> > @@ -707,7 +707,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee8=
0211_hw *hw)
> >  {
> >        struct ath5k_softc *sc =3D hw->priv;
> >        struct ath5k_hw *ah =3D sc->ah;
> > -       u8 mac[ETH_ALEN];
> > +       u8 mac[ETH_ALEN] =3D {};
> >        int ret;
> >
> >        ATH5K_DBG(sc, ATH5K_DEBUG_ANY, "devid 0x%x\n", pdev->device)=
;
> > @@ -777,7 +777,13 @@ ath5k_attach(struct pci_dev *pdev, struct ieee=
80211_hw *hw)
> >        tasklet_init(&sc->restq, ath5k_tasklet_reset, (unsigned long=
)sc);
> >        setup_timer(&sc->calib_tim, ath5k_calibrate, (unsigned long)=
sc);
> >
> > -       ath5k_hw_get_lladdr(ah, mac);
> > +       ret =3D ath5k_eeprom_read_mac(ah, mac);
> > +       if (ret) {
> > +               ATH5K_ERR(sc, "unable to read address from EEPROM: =
0x%04x\n",
> > +                       sc->pdev->device);
> > +               goto err_queues;
> > +       }
> > +
> >        SET_IEEE80211_PERM_ADDR(hw, mac);
> >        /* All MAC address bits matter for ACKs */
> >        memset(sc->bssidmask, 0xff, ETH_ALEN);
> > @@ -2765,6 +2771,7 @@ static int ath5k_add_interface(struct ieee802=
11_hw *hw,
> >        /* Set to a reasonable value. Note that this will
> >         * be set to mac80211's value at ath5k_config(). */
> >        sc->bintval =3D 1000;
> > +       ath5k_hw_set_lladdr(sc->ah, conf->mac_addr);
> >
> >        ret =3D 0;
> >  end:
> > @@ -2777,11 +2784,13 @@ ath5k_remove_interface(struct ieee80211_hw =
*hw,
> >                        struct ieee80211_if_init_conf *conf)
> >  {
> >        struct ath5k_softc *sc =3D hw->priv;
> > +       u8 mac[ETH_ALEN] =3D {};
> >
> >        mutex_lock(&sc->lock);
> >        if (sc->vif !=3D conf->vif)
> >                goto end;
> >
> > +       ath5k_hw_set_lladdr(sc->ah, mac);
> >        sc->vif =3D NULL;
> >  end:
> >        mutex_unlock(&sc->lock);
> > --
> > 1.5.4.2.182.gb3092
> >
> > --
> > Bob Copeland %% www.bobcopeland.com
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wir=
eless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
