Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:13848 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbXGBIuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2007 04:50:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: drivers/net/wireless/libertas/rx.c: use-after-free
Date: Mon, 2 Jul 2007 10:50:32 +0200
Cc: Dan Williams <dcbw@redhat.com>, Adrian Bunk <bunk@stusta.de>,
	linville@tuxdriver.com, linux-kernel@vger.kernel.org,
	libertas-dev@lists.infradead.org
References: <20070629195116.GG6087@stusta.de> <1183233766.9150.2.camel@xo-13-A4-25.localdomain>
In-Reply-To: <1183233766.9150.2.camel@xo-13-A4-25.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707021050.33039.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libertas: remove a coverity bug

... by removing an ill-conceived, useless line.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

Dunno how this line made it into the patch that I made in
February and was commited in May. At that time, I didn't hardly
knew anything about skb's at all and certainly didn't play with
raw ethernet types. Maybe it was a remnant of some bugus test
that I or the committer did?!?

I tested the driver after the removal of this line with ping and
ssh, but not anything else (e.g. no mesh, no tshark monitoring).

 drivers/net/wireless/libertas/rx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/rx.c b/drivers/net/wireless/libertas/rx.c
index 88d9d2d..769c86f 100644
--- a/drivers/net/wireless/libertas/rx.c
+++ b/drivers/net/wireless/libertas/rx.c
@@ -439,7 +439,6 @@ static int process_rxed_802_11_packet(wlan_private * priv, struct sk_buff *skb)
 	ret = 0;
 
 done:
-	skb->protocol = __constant_htons(0x0019);	/* ETH_P_80211_RAW */
 	lbs_deb_leave_args(LBS_DEB_RX, "ret %d", ret);
 	return ret;
 }
