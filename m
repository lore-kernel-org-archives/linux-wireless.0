Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:50416 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZJZORh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:17:37 -0400
Message-ID: <4AE5B1FB.2050306@gmail.com>
Date: Mon, 26 Oct 2009 15:28:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] airo: Reorder tests, check bounds before element
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Test whether index is within bounds before reading the element

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/wireless/airo.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 7116a1a..abf896a 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -4790,9 +4790,8 @@ static int proc_stats_rid_open( struct inode *inode,
 static int get_dec_u16( char *buffer, int *start, int limit ) {
 	u16 value;
 	int valid = 0;
-	for( value = 0; buffer[*start] >= '0' &&
-		     buffer[*start] <= '9' &&
-		     *start < limit; (*start)++ ) {
+	for (value = 0; *start < limit && buffer[*start] >= '0' &&
+			buffer[*start] <= '9'; (*start)++) {
 		valid = 1;
 		value *= 10;
 		value += buffer[*start] - '0';

