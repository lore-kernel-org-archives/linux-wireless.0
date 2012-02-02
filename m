Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4074 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab2BBE4O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 23:56:14 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20266.5988.348365.189086@gargle.gargle.HOWL> (sfid-20120202_055619_629211_DACDFFBE)
Date: Thu, 2 Feb 2012 10:26:04 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>
Subject: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
In-Reply-To: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> +	bool stop_rx_poll;

What exactly is this variable for ?
Why can't the timer be just started/stopped/modified using the
normal timer API ?

And Ben has a point too. Different beacon intervals need to be handled,
which can be done easily by just using the timestamp of the last received
beacon and the beacon interval. Then all this fragile logic can be removed.

> +	if (!(sc->sc_flags & SC_OP_PRIM_STA_VIF))
> +		return;

This needs locking, no ?

> +	sc->rx.stop_rx_poll = false;
> +	spin_unlock_bh(&sc->rx.rxbuflock);
> +	sc->ps_flags |= PS_WAIT_FOR_BEACON;

PS_WAIT_FOR_BEACON is being used randomly everywhere, with no proper locking,
but this needs to be handled properly here, else station mode powersave would be buried
under another layer of poo.

Sujith
