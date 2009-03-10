Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:34436 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbZCJG4A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 02:56:00 -0400
Received: by rv-out-0506.google.com with SMTP id g9so2193538rvb.5
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2009 23:55:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49B60061.9040409@erley.org>
References: <49B60061.9040409@erley.org>
Date: Mon, 9 Mar 2009 23:55:58 -0700
Message-ID: <45e8e6c40903092355w778d95d4sa5a7433ef6692501@mail.gmail.com> (sfid-20090310_075608_002354_C8824EB9)
Subject: Re: [patch/RFC] ath9k mesh mode
From: Andrey Yurovsky <andrey@cozybit.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, brian@cozybit.com,
	javier@cozybit.com, colin@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I would also look at the ath5k driver as (last time I looked) it is
quite similar to ath9k in how mesh beacons would be handled and the RX
filter configuration code is nearly identical.

On Mon, Mar 9, 2009 at 10:53 PM, pat-lkml <pat-lkml@erley.org> wrote:
> This patch begins the work to getting mesh mode working with ath9k. =A0=
I am
> using the b43 and rt2x00 drivers as templates on how to do this.
>
> Unfortunately it doesn't seem to work yet. =A0In attempting to set up=
 a mesh between
> an ath9k device and a b43 device, the ath9k device does not seem to b=
e enabling
> beaconing. =A0I have a third device in monitor mode that sees the b43=
 beacons,
> sees ath9k responding to them (I believe trying to establish a link),=
 and b43
> is acknowledging those responses, but no link is established. =A0On t=
he same ath9k
> device, I'm not seeing beaconing in ad-hoc mode, which leads me to be=
lieve that
> beaconing may be broken right now for my Atheros device. =A0What am I=
 doing wrong?
>
> Atheros HW: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: mem=3D0xf92=
80000, irq=3D17
> b43 HW: BCM4306 802.11b/g (rev 5)
>
> ---
> diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wirele=
ss/ath9k/beacon.c
> index 039c781..cbd94dd 100644
> --- a/drivers/net/wireless/ath9k/beacon.c
> +++ b/drivers/net/wireless/ath9k/beacon.c
> @@ -70,7 +70,8 @@ static void ath_beacon_setup(struct ath_softc *sc, =
struct ath_vif *avp,
> =A0 =A0 =A0 =A0ds =3D bf->bf_desc;
> =A0 =A0 =A0 =A0flags =3D ATH9K_TXDESC_NOACK;
>
> - =A0 =A0 =A0 if (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_ADHOC &&
> + =A0 =A0 =A0 if (((sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_ADHOC) ||
> + =A0 =A0 =A0 =A0 =A0 =A0(sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_MES=
H_POINT)) &&
> =A0 =A0 =A0 =A0 =A0 =A0(ah->caps.hw_caps & ATH9K_HW_CAP_VEOL)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ds->ds_link =3D bf->bf_daddr; /* self-=
linked */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D ATH9K_TXDESC_VEOL;
> @@ -727,6 +728,8 @@ void ath_beacon_config(struct ath_softc *sc, stru=
ct ieee80211_vif *vif)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case NL80211_IFTYPE_AP:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ath_beacon_config_ap(s=
c, &conf, avp);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case NL80211_IFTYPE_MESH_POINT:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Handle mesh beaconin=
g just like ad-hoc */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case NL80211_IFTYPE_ADHOC:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ath_beacon_config_adho=
c(sc, &conf, avp, vif);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/a=
th9k/hw.c
> index c10b33b..06376aa 100644
> --- a/drivers/net/wireless/ath9k/hw.c
> +++ b/drivers/net/wireless/ath9k/hw.c
> @@ -1430,6 +1430,8 @@ static void ath9k_hw_set_operating_mode(struct =
ath_hw *ah, int opmode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| AR_STA_ID1_KSRCH=
_MODE);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_CLR_BIT(ah, AR_CFG, AR_CFG_AP_ADHO=
C_INDICATION);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 case NL80211_IFTYPE_MESH_POINT:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Configure HW same as ADHOC */
> =A0 =A0 =A0 =A0case NL80211_IFTYPE_ADHOC:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_WRITE(ah, AR_STA_ID1, val | AR_STA=
_ID1_ADHOC
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| AR_STA_ID1_KSRCH=
_MODE);
> @@ -3135,6 +3137,8 @@ void ath9k_hw_beaconinit(struct ath_hw *ah, u32=
 next_beacon, u32 beacon_period)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_WRITE(ah, AR_NEXT_SWBA, 0x7ffff);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D AR_TBTT_TIMER_EN;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> + =A0 =A0 =A0 case NL80211_IFTYPE_MESH_POINT:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Should IBSS style beaconing be used =
for mesh point? */
> =A0 =A0 =A0 =A0case NL80211_IFTYPE_ADHOC:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_SET_BIT(ah, AR_TXCFG,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0AR_TXCFG_ADHOC=
_BEACON_ATIM_TX_POLICY);
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless=
/ath9k/main.c
> index 5268697..e76e0de 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -1590,6 +1590,7 @@ void ath_set_hw_capab(struct ath_softc *sc, str=
uct ieee80211_hw *hw)
> =A0 =A0 =A0 =A0hw->wiphy->interface_modes =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BIT(NL80211_IFTYPE_AP) |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BIT(NL80211_IFTYPE_STATION) |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BIT(NL80211_IFTYPE_MESH_POINT) |
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BIT(NL80211_IFTYPE_ADHOC);
>
> =A0 =A0 =A0 =A0hw->wiphy->reg_notifier =3D ath9k_reg_notifier;
> @@ -2198,18 +2199,13 @@ static int ath9k_add_interface(struct ieee802=
11_hw *hw,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ic_opmode =3D NL80211_IFTYPE_STATION;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0case NL80211_IFTYPE_ADHOC:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sc->nbcnvifs >=3D ATH_BCBUF) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOBUFS;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ic_opmode =3D NL80211_IFTYPE_ADHOC;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> =A0 =A0 =A0 =A0case NL80211_IFTYPE_AP:
> + =A0 =A0 =A0 case NL80211_IFTYPE_MESH_POINT:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sc->nbcnvifs >=3D ATH_BCBUF) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D -ENOBUFS;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ic_opmode =3D NL80211_IFTYPE_AP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ic_opmode =3D conf->type;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DPRINTF(sc, ATH_DBG_FATAL,
> @@ -2242,10 +2238,11 @@ static int ath9k_add_interface(struct ieee802=
11_hw *hw,
>
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * Enable MIB interrupts when there are hardware phy c=
ounters.
> - =A0 =A0 =A0 =A0* Note we only do this (at the moment) for station m=
ode.
> + =A0 =A0 =A0 =A0* Note we only do this (at the moment) for non AP mo=
des.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0if ((conf->type =3D=3D NL80211_IFTYPE_STATION) ||
> - =A0 =A0 =A0 =A0 =A0 (conf->type =3D=3D NL80211_IFTYPE_ADHOC)) {
> + =A0 =A0 =A0 =A0 =A0 (conf->type =3D=3D NL80211_IFTYPE_ADHOC) ||
> + =A0 =A0 =A0 =A0 =A0 (conf->type =3D=3D NL80211_IFTYPE_MESH_POINT)) =
{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ath9k_hw_phycounters(sc->sc_ah))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sc->imask |=3D ATH9K_I=
NT_MIB;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sc->imask |=3D ATH9K_INT_TSFOOR;
> @@ -2292,8 +2289,9 @@ static void ath9k_remove_interface(struct ieee8=
0211_hw *hw,
> =A0 =A0 =A0 =A0del_timer_sync(&sc->ani.timer);
>
> =A0 =A0 =A0 =A0/* Reclaim beacon resources */
> - =A0 =A0 =A0 if (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_AP ||
> - =A0 =A0 =A0 =A0 =A0 sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_ADHOC) =
{
> + =A0 =A0 =A0 if ((sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_AP) ||
> + =A0 =A0 =A0 =A0 =A0 (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_ADHOC)=
 ||
> + =A0 =A0 =A0 =A0 =A0 (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_MESH_P=
OINT)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ath9k_hw_stoptxdma(sc->sc_ah, sc->beac=
on.beaconq);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ath_beacon_return(sc, avp);
> =A0 =A0 =A0 =A0}
> @@ -2446,10 +2444,31 @@ static int ath9k_config_interface(struct ieee=
80211_hw *hw,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 } else if ((vif->type =3D=3D NL80211_IFTYPE_MESH_POINT)=
 && (conf->bssid)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Both b43 and rt2x00 set the bssid in=
 the case that one
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* is passed durint interface config,=
 irregardless of the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* status of conf->changed */
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Set BSSID */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(sc->curbssid, conf->bssid, ETH_A=
LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(avp->bssid, conf->bssid, ETH_ALE=
N);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sc->curaid =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ath9k_hw_write_associd(sc);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Set aggregation protection mode para=
meters */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sc->config.ath_aggr_prot =3D 0;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DPRINTF(sc, ATH_DBG_CONFIG,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "RX filter 0x%x bssid %=
pM aid 0x%x\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rfilt, sc->curbssid, sc=
->curaid);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* need to reconfigure the beacon */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sc->sc_flags &=3D ~SC_OP_BEACONS ;
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if ((vif->type =3D=3D NL80211_IFTYPE_ADHOC) ||
> - =A0 =A0 =A0 =A0 =A0 (vif->type =3D=3D NL80211_IFTYPE_AP)) {
> + =A0 =A0 =A0 =A0 =A0 (vif->type =3D=3D NL80211_IFTYPE_AP) ||
> + =A0 =A0 =A0 =A0 =A0 (vif->type =3D=3D NL80211_IFTYPE_MESH_POINT)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((conf->changed & IEEE80211_IFCC_BE=
ACON) ||
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(conf->changed & IEEE80211_IFC=
C_BEACON_ENABLED &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 conf->enable_beacon)) {
> @@ -2482,8 +2501,9 @@ static int ath9k_config_interface(struct ieee80=
211_hw *hw,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sc->curbssid);
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /* Only legacy IBSS for now */
> - =A0 =A0 =A0 if (vif->type =3D=3D NL80211_IFTYPE_ADHOC)
> + =A0 =A0 =A0 /* Only legacy IBSS and Mesh Point for now */
> + =A0 =A0 =A0 if ((vif->type =3D=3D NL80211_IFTYPE_ADHOC) ||
> + =A0 =A0 =A0 =A0 =A0 (vif->type =3D=3D NL80211_IFTYPE_MESH_POINT))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ath_update_chainmask(sc, 0);
>
> =A0 =A0 =A0 =A0mutex_unlock(&sc->mutex);
> diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/a=
th9k/rc.c
> index 8327356..61f8334 100644
> --- a/drivers/net/wireless/ath9k/rc.c
> +++ b/drivers/net/wireless/ath9k/rc.c
> @@ -1615,7 +1615,8 @@ static void ath_rate_init(void *priv, struct ie=
ee80211_supported_band *sband,
> =A0 =A0 =A0 =A0/* Choose rate table first */
>
> =A0 =A0 =A0 =A0if ((sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_STATION) =
||
> - =A0 =A0 =A0 =A0 =A0 (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_ADHOC)=
) {
> + =A0 =A0 =A0 =A0 =A0 (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_ADHOC)=
 ||
> + =A0 =A0 =A0 =A0 =A0 (sc->sc_ah->opmode =3D=3D NL80211_IFTYPE_MESH_P=
OINT)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rate_table =3D ath_choose_rate_table(s=
c, sband->band,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sta->ht_cap.ht_supported,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 is_cw40);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
