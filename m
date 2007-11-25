Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33381 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755542AbXKYUHP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 15:07:15 -0500
Date: Sun, 25 Nov 2007 21:06:03 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Matthieu PATOU <mat@matws.net>
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: BCM4312 status
Message-ID: <20071125210603.2e368028@morte> (sfid-20071125_200720_363930_54408EE7)
In-Reply-To: <4749BE06.8050601@matws.net>
References: <47469E42.6050909@matws.net>
	<474984B1.90302@matws.net>
	<47499A1A.1060307@lwfinger.net>
	<4749BE06.8050601@matws.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Weird, it looks like your PHY revision isn't even 9. Please try this (it
should apply on top of Larry's patches) and report debug information,
thanks.

---

Index: wireless-2.6/drivers/net/wireless/b43/wa.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/wa.c
+++ wireless-2.6/drivers/net/wireless/b43/wa.c
@@ -642,6 +642,7 @@ void b43_wa_all(struct b43_wldev *dev)
 		case 6:
 		case 7:
 		case 8:
+		case 9:
 			b43_wa_tr_ltov(dev);
 			b43_wa_crs_ed(dev);
 			b43_wa_rssi_lt(dev);
@@ -654,6 +655,19 @@ void b43_wa_all(struct b43_wldev *dev)
 			b43_wa_txpuoff_rxpuon(dev);
 			break;
 		default:
+			b43err(dev->wl, "Unknown PHY revision %i, "
+					"applying rev9 workarounds\n",
+					phy->rev);
+			b43_wa_tr_ltov(dev);
+			b43_wa_crs_ed(dev);
+			b43_wa_rssi_lt(dev);
+			b43_wa_nft(dev);
+			b43_wa_nst(dev);
+			b43_wa_msst(dev);
+			b43_wa_wrssi_offset(dev);
+			b43_wa_altagc(dev);
+			b43_wa_analog(dev);
+			b43_wa_txpuoff_rxpuon(dev);
 			B43_WARN_ON(1);
 		}
 		b43_wa_boards_g(dev);



-- 
Ciao
Stefano
