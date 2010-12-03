Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50672 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0LCPAH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 10:00:07 -0500
Date: Fri, 3 Dec 2010 09:59:18 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi <mshajakhan@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Properly use unlikely check macro
Message-ID: <20101203145918.GC2348@tuxdriver.com>
References: <1291044477-2317-1-git-send-email-mshajakhan@atheros.com>
 <20101202202127.GF2358@tuxdriver.com>
 <4CF87597.5080900@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4CF87597.5080900@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 03, 2010 at 10:14:07AM +0530, Mohammed Shafi wrote:
> On Friday 03 December 2010 01:51 AM, John W. Linville wrote:
> >On Mon, Nov 29, 2010 at 08:57:57PM +0530, Mohammed Shafi Shajakhan wrote:
> >>From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >>
> >>AUTOSLEEP feature is enabled only AR9003 and later chips.So unlikely
> >>macro should be used only to check whether auto-sleep feature is enabled
> >>
> >>Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
> >>---
> >>  drivers/net/wireless/ath/ath9k/recv.c |    6 +++---
> >>  1 files changed, 3 insertions(+), 3 deletions(-)
> >>
> >>diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> >>index 262c815..751ee1b 100644
> >>--- a/drivers/net/wireless/ath/ath9k/recv.c
> >>+++ b/drivers/net/wireless/ath/ath9k/recv.c
> >>@@ -1743,10 +1743,10 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
> >>  		}
> >>
> >>  		spin_lock_irqsave(&sc->sc_pm_lock, flags);
> >>-		if (unlikely(ath9k_check_auto_sleep(sc) ||
> >>-			     (sc->ps_flags&  (PS_WAIT_FOR_BEACON |
> >>+		if ((sc->ps_flags&  (PS_WAIT_FOR_BEACON |
> >>  					      PS_WAIT_FOR_CAB |
> >>-					      PS_WAIT_FOR_PSPOLL_DATA))))
> >>+					      PS_WAIT_FOR_PSPOLL_DATA)) ||
> >>+				unlikely(ath9k_hw_check_auto_sleep(sc)))
> >>  			ath_rx_ps(sc, skb);
> >>  		spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
> >What tree is this against?
> 2.6.37-rc4 ..Any problems in applying.Do I have to resend it based
> on the latest pull ?

Did you compile it?

/home/linville/git/linux-2.6
[linville-8530p.local]:> git describe
v2.6.37-rc4

/home/linville/git/linux-2.6
[linville-8530p.local]:> grep ath9k_hw_check_auto_sleep drivers/net/wireless/ath/ath9k/*

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
