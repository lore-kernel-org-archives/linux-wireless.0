Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:34556 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755512AbYKKNKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 08:10:13 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem/bisect with rtl8187B
Date: Tue, 11 Nov 2008 11:10:26 -0200
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <41448.77528.qm@web23104.mail.ird.yahoo.com>
In-Reply-To: <41448.77528.qm@web23104.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811111110.28066.herton@mandriva.com.br> (sfid-20081111_141019_534428_42E658CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 11 November 2008 06:39:40 Hin-Tak Leung wrote:
> Hi Herton,
> 
> I bisected through recent wireless-testing, and found the commit which results in my throughput problem - it is one of yours :-(. Can you and also possibly Larry give this a try: transfering some large files (>50MB) before and after reverting this particular commit, and see what sftp says about the transfer rate? You need to let sftp keep going for a while to see what rate it settles at. (>50MB should do, so a kernel source tarball
> would be appropriate). The difference is quite obvious in my case - 
> <60kB/s, and 7x - 10x that if I revert this commit. 
> 
> The commit is all magic numbers, so if you see the problem, can you please
> have a look and check the numbers?

Lets try to identify what part is broken, I guess is this, can you try this
patch on latest wireless-testing?

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index d49f2a7..63c796e 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -913,7 +913,6 @@ static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
 {
 	if (priv->is_rtl8187b) {
 		u8 difs, eifs, slot_time;
-		u16 ack_timeout;
 
 		if (use_short_slot) {
 			slot_time = 0x9;
@@ -933,19 +932,6 @@ static void rtl8187_conf_erp(struct rtl8187_priv *priv, bool use_short_slot,
 		 * Value in units of 4 us
 		 */
 		rtl818x_iowrite8(priv, (u8 *)&priv->map->BRSR + 1, eifs);
-
-		/*
-		 * For 8187B, CARRIER_SENSE_COUNTER is in fact ack timeout
-		 * register. In units of 4 us like eifs register
-		 * ack_timeout = ack duration + plcp + difs + preamble
-		 */
-		ack_timeout = 112 + 48 + difs;
-		if (use_short_preamble)
-			ack_timeout += 72;
-		else
-			ack_timeout += 144;
-		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER,
-				 DIV_ROUND_UP(ack_timeout, 4));
 	} else {
 		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
 		if (use_short_slot) {


> 
> Thanks,
> Hin-Tak 

--
[]'s
Herton
