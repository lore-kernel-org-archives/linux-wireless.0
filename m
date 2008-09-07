Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59042 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753194AbYIGMJH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 08:09:07 -0400
Date: Sun, 7 Sep 2008 09:09:01 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] Ath9k: Add RF kill support.
Message-ID: <20080907120901.GB15895@khazad-dum.debian.net> (sfid-20080907_140915_038548_824AC6DE)
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 06 Sep 2008, Vasanthakumar Thiagarajan wrote:
> +/* Init s/w rfkill */
> +static void ath_init_sw_rfkill(struct ath_softc *sc)
> +{
> +	sc->rf_kill.rfkill = rfkill_allocate(wiphy_dev(sc->hw->wiphy),
> +					     RFKILL_TYPE_WLAN);
> +	if (!sc->rf_kill.rfkill) {
> +		DPRINTF(sc, ATH_DBG_FATAL, "Failed to allocate rfkill\n");
> +		return;
> +	}
> +
> +	snprintf(sc->rf_kill.rfkill_name, sizeof(sc->rf_kill.rfkill_name),
> +		"ath9k-%s:rfkill", wiphy_name(sc->hw->wiphy));
> +	sc->rf_kill.rfkill->name = sc->rf_kill.rfkill_name;
> +	sc->rf_kill.rfkill->data = sc;
> +	sc->rf_kill.rfkill->toggle_radio = ath_sw_toggle_radio;
> +	sc->rf_kill.rfkill->state = RFKILL_STATE_UNBLOCKED;
> +	sc->rf_kill.rfkill->user_claim_unsupported = 1;
> +
> +	sc->sc_flags |= SC_OP_RFKILL_ALLOCATED;
> +}

IMO, if a driver has added rfkill support, and it is enabled, that driver
must refuse to load if it cannot register with the rfkill subsystem (that
only happens due to bugs or OOM conditions, anyway).

Once you support rfkill in a piece of hardware and that support starts being
used, the configurations using your driver might start to depend on rfkill
being operational to be safe to operate in may user cases.

So, please consider shutting down the radio and aborting the driver load if
you cannot properly register rfkill support in ath9k.

Also, remember that you may get issued an immediate call to toggle_radio
trying to disable (since you default to enabled at power up -- can't you do
the inverse when rfkill support is compiled in? it is much safer) the radio
before rfkill_register() returns.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
