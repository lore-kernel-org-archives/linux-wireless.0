Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11981 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934520AbZKYEkU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 23:40:20 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 24 Nov 2009 20:40:26 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19212.46545.203653.902330@gargle.gargle.HOWL>
Date: Wed, 25 Nov 2009 10:12:57 +0530
To: Vivek Natarajan <vnatarajan@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Ensure a fair beacon distribution in IBSS mode.
In-Reply-To: <1259063627-20033-1-git-send-email-vnatarajan@atheros.com>
References: <1259063627-20033-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> @@ -2914,6 +2914,10 @@ static int ath9k_conf_tx(struct ieee80211_hw *hw, u16 queue,
>         if (ret)
>                 ath_print(common, ATH_DBG_FATAL, "TXQ Update failed\n");
> 
> +       if (sc->sc_ah->opmode == NL80211_IFTYPE_ADHOC)
> +               if (qnum == sc->tx.hwq_map[ATH9K_WME_AC_BE])
> +                       ath_beaconq_config(sc);
> +

If queue parameter updation has failed earlier, this code chunk would be
redundant. Handling the special case for IBSS should probably be done only if
the earlier ath_txq_update() is successful.

Sujith
