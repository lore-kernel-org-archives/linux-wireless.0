Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:35974 "HELO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753704AbZLMQHs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 11:07:48 -0500
Date: Sun, 13 Dec 2009 17:07:45 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 5/9] drivers/net/wireless: Correct code taking the size
 of a pointer
In-Reply-To: <m2iqcbt4n5.fsf@igel.home>
Message-ID: <Pine.LNX.4.64.0912131706390.27767@ask.diku.dk>
References: <Pine.LNX.4.64.0912131241470.24267@ask.diku.dk> <m2iqcbt4n5.fsf@igel.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Julia Lawall <julia@diku.dk>

sizeof(iv16) and sizeof(iv32) are the sizes of pointers.  Change them to
the size of the copied data.

Furthermore, iveiv_entry is a local structure that has just been
initialized and is not visible outside this function.  Thus, there would
seem to be no point to copy data into it.  The order of the arguments is
thus changed to copy the data into the parameters, which are provided as
pointers, suggesting in this case that they should be used to return values.

A simplified version of the semantic patch that finds the first problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
expression f;
type T;
@@

*f(...,(T)x,...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/wireless/rt2x00/rt2800lib.c        |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index eb1e1d0..f52b82e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2140,8 +2140,8 @@ static void rt2800_get_tkip_seq(struct ieee80211_hw *hw, u8 hw_key_idx,
 	rt2800_register_multiread(rt2x00dev, offset,
 				      &iveiv_entry, sizeof(iveiv_entry));
 
-	memcpy(&iveiv_entry.iv[0], iv16, sizeof(iv16));
-	memcpy(&iveiv_entry.iv[4], iv32, sizeof(iv32));
+	memcpy(iv16, &iveiv_entry.iv[0], sizeof(*iv16));
+	memcpy(iv32, &iveiv_entry.iv[4], sizeof(*iv32));
 }
 
 static int rt2800_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
