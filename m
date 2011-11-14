Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49741 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab1KNKmq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 05:42:46 -0500
Received: by bke11 with SMTP id 11so5757526bke.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2011 02:42:45 -0800 (PST)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
Date: Mon, 14 Nov 2011 11:42:24 +0100
Message-ID: <CADxqDgFoO63RG67McnxUJSmxZ9ZPPnE7obKkn+MZAsoJ4UMQtg@mail.gmail.com> (sfid-20111114_114250_597140_DB6484C5)
Subject: force AR5212 to sleep
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am testing some custom algorithms for powersaving using
mac80211/ath5k. I am using  Dlink DWL-AG660 PCMCIA cards for my
experiments. For these algorithms I am notifying sleep/awake events
from mac80211 down to the driver whenever I want to. For the case of
ath5k I followed that code madwifi was using to force the chipset to
sleep (full sleep mode), find the piece of code below:

The problem is, the card (and the laptop) totally freezes whenever
this is done. According to
http://madwifi-project.org/wiki/Compatibility/D-Link this card uses a
AR5212, and madwifi driver does use this piece of code to force the
chip to sleep (in that case when resetting or stopping an interface).

Undoubtedly, I am missing something I should take care of. I'd
appreciate any "clue" you could give me.


/**** CODE *****/

    struct ath5k_softc *sc = hw->priv;
    struct ath5k_hw *ah = sc->ah;
    unsigned int i;
    u32 staid, data;

    staid = ath5k_hw_reg_read(ah, AR5K_STA_ID1);

    ath5k_hw_reg_write(ah, AR5K_SLEEP_CTL_SLE_ALLOW, AR5K_SLEEP_CTL);

    staid |= AR5K_STA_ID1_PWR_SV;

    ath5k_hw_reg_write(ah, staid, AR5K_STA_ID1);

/**** CODE *****/


Thanks in advance,
Andrés
