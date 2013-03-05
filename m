Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:33197 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3CEMzf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 07:55:35 -0500
Date: Tue, 5 Mar 2013 16:55:33 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Felix Fietkau <nbd@openwrt.org>
cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 1/2] mac80211/minstrel_ht: increase sampling frequency
 of some slower rates
In-Reply-To: <5135E48E.8080604@openwrt.org>
Message-ID: <alpine.DEB.2.02.1303051651030.16654@icf.org.ru> (sfid-20130305_135538_960413_E0A53F11)
References: <1362311392-83648-1-git-send-email-nbd@openwrt.org> <alpine.DEB.2.02.1303051432550.23906@icf.org.ru> <5135DBB4.5090407@openwrt.org> <alpine.DEB.2.02.1303051607490.6047@icf.org.ru> <5135E48E.8080604@openwrt.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1051000339-1772395058-1362488133=:16654"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1051000339-1772395058-1362488133=:16654
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-03-05 13:26 +0100, Felix Fietkau wrote Georgiewskiy Yuriy:


FF>Please test if this patch helps:
FF>---
FF>--- a/net/mac80211/rc80211_minstrel_ht.c
FF>+++ b/net/mac80211/rc80211_minstrel_ht.c
FF>@@ -480,7 +480,7 @@ minstrel_ht_tx_status(void *priv, struct
FF> 
FF> 	if (!mi->sample_wait && !mi->sample_tries && mi->sample_count > 0) {
FF> 		mi->sample_wait = 16 + 2 * MINSTREL_TRUNC(mi->avg_ampdu_len);
FF>-		mi->sample_tries = 2;
FF>+		mi->sample_tries = 1;
FF> 		mi->sample_count--;
FF> 	}

Seems this helps, with this patch throughput is near as without this two patches applied.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1051000339-1772395058-1362488133=:16654--
