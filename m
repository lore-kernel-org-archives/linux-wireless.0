Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:28466 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759902Ab0ENUwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 16:52:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 13:52:55 -0700
Date: Fri, 14 May 2010 13:52:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Bruno Randolf <br1@einfach.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
Message-ID: <20100514205253.GC28198@tux>
References: <201005141520.30802.br1@einfach.org>
 <4BECEE3E.6090303@gmail.com>
 <201005141538.43416.br1@einfach.org>
 <4BED6F19.3040608@gmail.com>
 <20100514165325.GA28198@tux>
 <4BED8765.8040307@gmail.com>
 <AANLkTiky103uOz38yZPlLypEQ8DnkdCk1X3zPl9014Yi@mail.gmail.com>
 <67773379-350A-42D4-BEB5-DAC7D8277615@gmail.com>
 <20100514201339.GB28198@tux>
 <4638F7CF-1E00-411F-A086-BA30809E00BD@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4638F7CF-1E00-411F-A086-BA30809E00BD@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 14, 2010 at 01:21:34PM -0700, Justin P. Mattock wrote:
> Eveything is on except ath5k
> For debugging.

Bleh, try this.

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 1ca42e5..3404198 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -129,7 +129,7 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	common->rx_bufsize = roundup(IEEE80211_MAX_MPDU_LEN,
 				     min(common->cachelsz, (u16)64));
 
-	ath_print(common, ATH_DBG_CONFIG, "cachelsz %u rxbufsize %u\n",
+	printk("ATH9K: cachelsz %u rxbufsize %u\n",
 		  common->cachelsz, common->rx_bufsize);
 
 	/* Initialize rx descriptors */

Not sure why this is not printing, the common debug_mask should
already be set here prior to this. Anyway this would force the
print I want.

  Luis
