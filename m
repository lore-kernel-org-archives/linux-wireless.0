Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46143 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754780Ab1IFPE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 11:04:29 -0400
Date: Tue, 6 Sep 2011 11:04:22 -0400
From: Pavel Roskin <proski@gnu.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: 3.0.0: carl9170: drivers/net/wireless/ath/carl9170/tx.c:351
 carl9170_tx_status+0x431/0x440 [carl9170]()
Message-ID: <20110906110422.326f95c5@mj> (sfid-20110906_170449_112083_169D150C)
In-Reply-To: <alpine.DEB.2.02.1109051750010.23828@p34.internal.lan>
References: <alpine.DEB.2.02.1109051750010.23828@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 5 Sep 2011 17:53:06 -0400 (EDT)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Hello,
> 
> Saw this on one of my Linux machines with a Linux (community
> supported USB stick):
> 
> [88927.073741] ------------[ cut here ]------------
> [88927.073762] WARNING: at drivers/net/wireless/ath/carl9170/tx.c:351

I'm dropping LKML from cc, no need to write there if there is a specialized
mailing list.

It looks like the bitmap code in carl9170 needs reviewing.  I spotted
one error immediately.  bitmap_zero() takes the number of bits, not the
number of long integers.

Chances are not very high that it would help in your case, but here's
the patch.  I hope to give carl9170 some good testing before submitting
that patch formally.

carl9170: fix bitmap initialization

From: Pavel Roskin <proski@gnu.org>

bitmap_zero() takes the number of bits, not the long integers used to
keep them.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/ath/carl9170/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index af351ec..2f68747 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1411,7 +1411,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 		sta_info->stats[tid].req = false;
 
 		if (tid_info) {
-			bitmap_zero(tid_info->bitmap, CARL9170_BAW_SIZE);
+			bitmap_zero(tid_info->bitmap, CARL9170_BAW_BITS);
 			tid_info->state = CARL9170_TID_STATE_IDLE;
 		}
 		rcu_read_unlock();

-- 
Regards,
Pavel Roskin
