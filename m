Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49507 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1GSJrX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 05:47:23 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: sync driver before TX
References: <1311064793.24078.0.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 19 Jul 2011 12:47:19 +0300
In-Reply-To: <1311064793.24078.0.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Tue\, 19 Jul 2011 10\:39\:53 +0200")
Message-ID: <87oc0qtxeg.fsf@purkki.adurom.net> (sfid-20110719_114726_882341_299A3C64)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> In P2P client mode, the GO (AP) to connect to might
> have periods of time where it is not available due
> to powersave. To allow the driver to sync with it
> and send frames to the GO only when it is available
> add a new callback tx_sync (and the corresponding
> finish_tx_sync). These callbacks can sleep unlike
> the actual TX.

[...]

> + * enum ieee80211_tx_sync_type - TX sync type
> + * @IEEE80211_TX_SYNC_AUTH: sync TX for authentication
> + *	(and possibly also before direct probe)

[...]

> +	int (*tx_sync)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +		       const u8 *bssid, enum ieee80211_tx_sync_type type);

With these it should be possible to get bssid before authentication
and we would get at76c50x-usb working again. Did I understand
correctly?

-- 
Kalle Valo
