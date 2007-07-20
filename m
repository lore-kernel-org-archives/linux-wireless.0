Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3956 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762992AbXGTUf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 16:35:56 -0400
Date: Fri, 20 Jul 2007 14:47:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net
Subject: [PATCH] rt2x00: fix build break from (struct interface *)->id typo
Message-ID: <20070720184742.GI7428@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  drivers/net/wireless/mac80211/rt2x00/rt2x00mac.o drivers/net/=
wireless/mac80211/rt2x00/rt2x00mac.c: In function =E2=80=98rt2x00_tx_rt=
s_cts=E2=80=99:
drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c:60: error: =E2=80=98st=
ruct interface=E2=80=99 has no member named =E2=80=98if_id=E2=80=99
drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c:64: error: =E2=80=98st=
ruct interface=E2=80=99 has no member named =E2=80=98if_id=E2=80=99
make[3]: *** [drivers/net/wireless/mac80211/rt2x00/rt2x00mac.o] Error 1

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
=46YI...already committed to wireless-dev tree.

 drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c b/drivers=
/net/wireless/mac80211/rt2x00/rt2x00mac.c
index cc84198..447c55c 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt2x00mac.c
@@ -57,11 +57,11 @@ static int rt2x00_tx_rts_cts(struct rt2x00_dev *rt2=
x00dev,
 	skb_put(skb, size);
=20
 	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		ieee80211_ctstoself_get(rt2x00dev->hw, rt2x00dev->interface.if_id,
+		ieee80211_ctstoself_get(rt2x00dev->hw, rt2x00dev->interface.id,
 			frag_skb->data, frag_skb->len, control,
 			(struct ieee80211_cts*)(skb->data));
 	else
-		ieee80211_rts_get(rt2x00dev->hw, rt2x00dev->interface.if_id,
+		ieee80211_rts_get(rt2x00dev->hw, rt2x00dev->interface.id,
 			frag_skb->data, frag_skb->len, control,
 			(struct ieee80211_rts*)(skb->data));
=20
--=20
1.5.2.2
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
