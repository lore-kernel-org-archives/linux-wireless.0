Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:36359 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761034AbZAWGQn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:43 -0500
Date: Thu, 22 Jan 2009 22:14:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
	Paul Hickey <paul@christianpatriot.us>,
	Kyle McMartin <kyle@mcmartin.ca>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
	Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
	Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [patch 24/40] ath9k: quiet harmless ForceXPAon messages
Message-ID: <20090123061415.GX2922@kroah.com> (sfid-20090123_071654_655508_CABD7054)
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090123001908.GA7397@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

This is a port of one line of upstream patch
f1dc56003b23d2d5bb5a756de6b1633a76c9e697

The "ForceXPAon" messages on ath9k were not meant to be printed
regularly, lets quiet them as this can happen quite frequently
(scans) and will fill the logs with tons of these messages.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -729,7 +729,7 @@ ath9k_hw_eeprom_set_board_values(struct 
 					  AR_AN_TOP2_LOCALBIAS,
 					  AR_AN_TOP2_LOCALBIAS_S,
 					  pModal->local_bias);
-		DPRINTF(ah->ah_sc, ATH_DBG_ANY, "ForceXPAon: %d\n",
+		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM, "ForceXPAon: %d\n",
 			pModal->force_xpaon);
 		REG_RMW_FIELD(ah, AR_PHY_XPA_CFG, AR_PHY_FORCE_XPA_CFG,
 			      pModal->force_xpaon);

