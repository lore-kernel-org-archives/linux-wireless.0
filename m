Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:33188 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbYGHXKG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 19:10:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1KGMJu-0007kL-Mq
	for linux-wireless@vger.kernel.org; Tue, 08 Jul 2008 23:10:02 +0000
Received: from mnhm-590e0183.pool.einsundeins.de ([89.14.1.131])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 23:10:02 +0000
Received: from deller by mnhm-590e0183.pool.einsundeins.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 23:10:02 +0000
To: linux-wireless@vger.kernel.org
From: Helge Deller <deller@gmx.de>
Subject: Re: [PATCH] ath5k: convert LED code to use mac80211 triggers
Date: Wed, 09 Jul 2008 01:08:20 +0200
Message-ID: <g50s14$8n1$1@ger.gmane.org> (sfid-20080709_011011_326724_1FF0ECF4)
References: <20080622181134.GA26571@hash.localnet> <20080626023528.GA16068@hash.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: ath5k-devel@lists.ath5k.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:

> This change cleans up the ath5k LED code and converts it to use
> the standard LED device class along with the rx/tx LED triggers
> provided by mac80211.

=2E..
> I tested this with printk but I don't have the IBM 5212/5211/Compaq
> hardware to fully test. =C2=A0If anyone can give it a spin or has com=
ments
> please let me know.

I tested it against Linus' head version (it applied with minor
modifications) on my HP NC6000 laptop with this built-in Atheros card:

02:04.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11=
abg
NIC (rev 01)
        Subsystem: Compaq Computer Corporation Unknown device 00e5

Basically it works, but I think the sc->led_on in:

> +static int
> +ath5k_init_leds(struct ath5k_softc *sc)
> +{
> +     int ret =3D 0;
> +     struct ieee80211_hw *hw =3D sc->hw;
> +     struct pci_dev *pdev =3D sc->pdev;
> +     char name[ATH5K_LED_MAX_NAME_LEN + 1];
> +
> +     sc->led_on =3D 0;  /* active low */

needs to be:
> +     sc->led_on =3D 1;  /* active high */
for the AR5212 in the HP laptop.

See also the changes to if_ath_pci.c in:
 http://madwifi.org/attachment/ticket/1018/led.patch
and
 http://madwifi.org/ticket/1018
for an old discussion about madwifi for LEDs in the HP box.

Without this change the LED stays on after a "rmmod ath5k" as well.

Helge

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
