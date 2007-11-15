Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:46033 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764427AbXKOGW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 01:22:27 -0500
Date: Wed, 14 Nov 2007 22:20:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Dave Jones <davej@redhat.com>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [patch 17/23] ieee80211: fix TKIP QoS bug
Message-ID: <20071115062057.GR8282@kroah.com> (sfid-20071115_062238_111566_015224E1)
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071115061806.GA8282@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Johannes Berg <johannes@sipsolutions.net>

patch e797aa1b7da6bfcb2e19a10ae5ead9aa7aea732b in mainline.

The commit 65b6a277 titled "ieee80211: Fix header->qos_ctl endian issue"
*introduced* an endianness bug. Partially revert it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ieee80211/ieee80211_crypt_tkip.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -584,7 +584,7 @@ static void michael_mic_hdr(struct sk_bu
 	if (stype & IEEE80211_STYPE_QOS_DATA) {
 		const struct ieee80211_hdr_3addrqos *qoshdr =
 			(struct ieee80211_hdr_3addrqos *)skb->data;
-		hdr[12] = qoshdr->qos_ctl & cpu_to_le16(IEEE80211_QCTL_TID);
+		hdr[12] = le16_to_cpu(qoshdr->qos_ctl) & IEEE80211_QCTL_TID;
 	} else
 		hdr[12] = 0;		/* priority */
 

-- 
