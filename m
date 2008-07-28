Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:44645 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYG1JKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 05:10:00 -0400
Received: by wf-out-1314.google.com with SMTP id 27so5603800wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 02:09:59 -0700 (PDT)
Message-ID: <1197ff4c0807280209x754f3a15j9dca3e60e99c69cb@mail.gmail.com> (sfid-20080728_111006_605060_E928616F)
Date: Mon, 28 Jul 2008 17:09:59 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Andrey Yurovsky" <andrey@cozybit.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: add Mesh Point support
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <487fa7a8.14da600a.1aae.48b1@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <487fa7a8.14da600a.1aae.48b1@mx.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2008 at 4:12 AM, Andrey Yurovsky <andrey@cozybit.com> wrote:
> This enables draft-802.11s Mesh Point operation.  For that we need mesh
> beaconing.  Tested with AR5212/AR5213 PCI card against Zydas and b43 mesh
> nodes.
>
> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> ---
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 217d506..6d9f4e1 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1425,7 +1425,8 @@ ath5k_beaconq_config(struct ath5k_softc *sc)
>        ret = ath5k_hw_get_tx_queueprops(ah, sc->bhalq, &qi);
>        if (ret)
>                return ret;
> -       if (sc->opmode == IEEE80211_IF_TYPE_AP) {
> +       if (sc->opmode == IEEE80211_IF_TYPE_AP ||
> +               sc->opmode == IEEE80211_IF_TYPE_MESH_POINT) {
>                /*
>                 * Always burst out beacon and CAB traffic
>                 * (aifs = cwmin = cwmax = 0)
> @@ -2911,6 +2912,7 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>        if (sc->opmode != IEEE80211_IF_TYPE_STA)
>                rfilt |= AR5K_RX_FILTER_PROBEREQ;
>        if (sc->opmode != IEEE80211_IF_TYPE_AP &&
> +               sc->opmode != IEEE80211_IF_TYPE_MESH_POINT &&
>                test_bit(ATH_STAT_PROMISC, sc->status))
>                rfilt |= AR5K_RX_FILTER_PROM;
>        if (sc->opmode == IEEE80211_IF_TYPE_STA ||
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index c6d12c5..8854820 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -2326,6 +2326,7 @@ int ath5k_hw_set_opmode(struct ath5k_hw *ah)
>                break;
>
>        case IEEE80211_IF_TYPE_AP:
> +       case IEEE80211_IF_TYPE_MESH_POINT:
>                pcu_reg |= AR5K_STA_ID1_AP | AR5K_STA_ID1_RTS_DEF_ANTENNA |
>                        (ah->ah_version == AR5K_AR5210 ?
>                                AR5K_STA_ID1_NO_PSPOLL : 0);
>
>

Hi Andrey

First of all, Thanks for your works to enable the ath5k support
80211s.  I just testing them with the newest wireless-testing tree and
meet some problems:

The Atheros chipset what I used is one AR2413 cardbus card and one
AR5414(the lspci show it as AR5413 but debug message show is as
AR5414) , after apply the patch, I  waked the up them by follow
commands:

iw dev wmaster0 interface add mesh type mp mesh_id 12345
iwconfig mesh channel 1
ifconfig mesh 192.168.3.80/192.168.3.81

but there is no  beacon was send from any of them, after input "iw dev
mesh station dump"
it also no station was found,(PS:the two PC are very close), ping each
other also no response.

After roughly browse the ath5k code and the patch, I have below questions:
1. From the patch, there is no any place to set the  sc->opmode's
value to IEEE80211_IF_TYPE_MESH_POINT.
2. it also haven't found code to enable/trigger "beacon send" in
MESH_POINT mode.

So I think maybe this patch can make ath5k work in mesh mode if some
mesh point(with b43 or zd1211rw) has been waked up early. because it
can correctly deal with the RX mesh packet. but it can't work
independent in a pure ath5k mesh network, cause none can send beacon
correctly, and hence they can't set up link each other.

BR
yanbo
