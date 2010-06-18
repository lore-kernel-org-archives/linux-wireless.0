Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4133 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760Ab0FRDWp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 23:22:45 -0400
Date: Thu, 17 Jun 2010 23:16:35 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Steve Brown <sbrown@cortland.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: OOPS in ath5k when setting coverage class
Message-ID: <20100618031635.GB18709@hash.localnet>
References: <4C1926E7.1070503@cortland.com> <AANLkTil-qhJ7fO3RNm4xwG1fA6uKeTkrD352ICU-z8Ab@mail.gmail.com> <4C1A6E4F.6000708@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C1A6E4F.6000708@cortland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 17, 2010 at 12:49:51PM -0600, Steve Brown wrote:
> I went a little further and tested the following patch.
>
> If it makes sense to you, I'll submit it.

So I looked over the code and found a few more trouble spots.
What about something like this instead?  It shouldn't hurt to
use a default channel but could avoid another round or two of
whack-a-mole...

From: Bob Copeland <me@bobcopeland.com>
Date: Thu, 17 Jun 2010 23:05:55 -0400
Subject: [PATCH] ath5k: initialize ah->ah_current_channel

ath5k assumes ah_current_channel is always a valid pointer in
several places, but a newly created interface may not have a
channel.  To avoid null pointer dereferences, set it up to point
to the first available channel until later reconfigured.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/attach.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index ef2dc1d..b32e28c 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -126,6 +126,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
 	ah->ah_noise_floor = -95;	/* until first NF calibration is run */
 	sc->ani_state.ani_mode = ATH5K_ANI_MODE_AUTO;
+	ah->ah_current_channel = &sc->channels[0];
 
 	/*
 	 * Find the mac version
-- 
1.6.3.3


-- 
Bob Copeland %% www.bobcopeland.com

