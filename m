Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42426 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbZDXTpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 15:45:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: fix format warning
Date: Fri, 24 Apr 2009 15:39:17 -0400
Message-Id: <1240601958-7273-1-git-send-email-linville@tuxdriver.com> (sfid-20090424_214557_824534_7FC69232)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/libertas/if_spi.c: In function =E2=80=98if_spi_c2h=
_data=E2=80=99:
drivers/net/wireless/libertas/if_spi.c:733: warning: format =E2=80=98%u=
=E2=80=99 expects type =E2=80=98unsigned int=E2=80=99, but argument 4 h=
as type =E2=80=98long unsigned int=E2=80=99

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/libertas/if_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wirel=
ess/libertas/if_spi.c
index 97493e2..dccd01f 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -731,7 +731,7 @@ static int if_spi_c2h_data(struct if_spi_card *card=
)
 		goto out;
 	} else if (len > MRVDRV_ETH_RX_PACKET_BUFFER_SIZE) {
 		lbs_pr_err("%s: error: card has %d bytes of data, but "
-			   "our maximum skb size is %u\n",
+			   "our maximum skb size is %lu\n",
 			   __func__, len, MRVDRV_ETH_RX_PACKET_BUFFER_SIZE);
 		err =3D -EINVAL;
 		goto out;
--=20
1.6.0.6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
