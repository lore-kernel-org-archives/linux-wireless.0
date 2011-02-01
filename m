Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38305 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1BAWSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 17:18:13 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 05/18] wl1251: retry power save entry
References: <4D45A5AD.4010402@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 00:18:10 +0200
In-Reply-To: <4D45A5AD.4010402@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 18\:53\:49 +0100")
Message-ID: <878vxzcsbh.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Port of the power save entry retry code from wl1251 driver version included
> in the Maemo Fremantle kernel.
> This tries to enable power save mode up to 3 times before failing.

[...]

> +		if (wl->psm_entry_retry < WL1251_PSM_ENTRY_RETRIES) {
> +			wl->psm_entry_retry++;
> +			ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
> +		} else {
> +			wl1251_error("Power save entry failed, giving up");
> +			wl->psm_entry_retry = 0;
> +		}

If firmware fails to send the nullfunc frame, something is wrong with
the connection and we should notify about this to mac80211. At least
wl12xx uses ieee80211_connection_loss(), maybe that's the best option
here?

-- 
Kalle Valo
