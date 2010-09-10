Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57861 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0IJL5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 07:57:30 -0400
Date: Fri, 10 Sep 2010 13:57:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] airo: remove pointless check
Message-ID: <20100910115714.GE5959@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't make sense to check "!ai->config.rates" here.
"ai->config.rates" is the address of an eight bytes array and it
can't ever be null here.  Also if it were NULL then trying to set:
	ai->config.rates[i] = basic_rate | 0x80;
would cause an oops.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 1d05445..d806497 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -3886,8 +3886,7 @@ static u16 setup_card(struct airo_info *ai, u8 *mac, int lock)
 		}
 		if ( basic_rate > 0 ) {
 			for( i = 0; i < 8; i++ ) {
-				if ( ai->config.rates[i] == basic_rate ||
-				     !ai->config.rates ) {
+				if (ai->config.rates[i] == basic_rate) {
 					ai->config.rates[i] = basic_rate | 0x80;
 					break;
 				}
