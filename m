Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61417 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1IQN35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 09:29:57 -0400
Date: Sat, 17 Sep 2011 19:00:32 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Paul Stewart <pstew@chromium.org>
CC: <linux-wireless@vger.kernel.org>,
	Adrian Chadd <adrian@freebsd.org>, <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: Fix samp_lock init for non-DEBUGFS
Message-ID: <20110917133031.GA22467@vmraj-lnx.users.atheros.com> (sfid-20110917_153001_541233_80377288)
References: <1314442067-11799-1-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmo=wLETTSy0i3uz3Zj5w+_o+AouzD=nJzFk9KnERK+g7Cg@mail.gmail.com>
 <20110827111641.GA17693@vmraj-lnx.users.atheros.com>
 <20110916230334.0BDD92043D@glenhelen.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110916230334.0BDD92043D@glenhelen.mtv.corp.google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 03:17:58PM -0700, Paul Stewart wrote:
> Patch "ath9k: Add debugfs support for mac/baseband samples" uses
> "&sc->debug.samp_lock" which breaks non-ATH9K_DEBUGFS builds.  Place
> the correct ifdef guard around it.
> 
> Signed-off-by: Paul Stewart <pstew@chromium.org>
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Cc: Adrian Chadd <adrian@freebsd.org>
> ---
>  drivers/net/wireless/ath/ath9k/init.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 74c9c99..b99ab96 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -553,7 +553,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
>  	spin_lock_init(&sc->wiphy_lock);
>  	spin_lock_init(&sc->sc_serial_rw);
>  	spin_lock_init(&sc->sc_pm_lock);
> +#ifdef CONFIG_ATH9K_DEBUGFS
>  	spin_lock_init(&sc->debug.samp_lock);
> +#endif
Paul,

I donno what tree you are refering to. But debug.samp_lock was placed
under proper debug switch. The code snippet as follows.

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index d7761d1..dd71a5f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -572,6 +572,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	mutex_init(&sc->mutex);
 #ifdef CONFIG_ATH9K_DEBUGFS
 	spin_lock_init(&sc->nodes_lock);
+	spin_lock_init(&sc->debug.samp_lock);
 	INIT_LIST_HEAD(&sc->nodes);
 #endif

--
Rajkumar
