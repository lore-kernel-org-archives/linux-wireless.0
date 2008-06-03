Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3377 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYFCPcl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2008 11:32:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH] libertas: fixup if_usb_reset_olpc_card warnings for OLPC
Date: Tue,  3 Jun 2008 10:58:40 -0400
Message-Id: <1212505120-23109-1-git-send-email-linville@tuxdriver.com> (sfid-20080603_173245_003201_8328A935)
In-Reply-To: <1212502456.3108.3.camel@localhost.localdomain>
References: <1212502456.3108.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 39663ff54367064e861394f14fa6f3803cf00914 ("libertas: provide
reset_card() callback on OLPC") introduced a pair of warnings:

  CC [M]  drivers/net/wireless/libertas/if_usb.o
drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb_res=
et_olpc_card=E2=80=99:
drivers/net/wireless/libertas/if_usb.c:158: warning: no return statemen=
t in function returning non-void
drivers/net/wireless/libertas/if_usb.c: In function =E2=80=98if_usb_pro=
be=E2=80=99: drivers/net/wireless/libertas/if_usb.c:248: warning: assig=
nment from incompatible pointer type

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
I'll fold this into the original patch, which has not yet been sent
upstream.

 drivers/net/wireless/libertas/if_usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wirel=
ess/libertas/if_usb.c
index 8a7eb63..2478310 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -151,7 +151,7 @@ static void if_usb_fw_timeo(unsigned long priv)
 }
=20
 #ifdef CONFIG_OLPC
-static int if_usb_reset_olpc_card(struct lbs_private *priv)
+static void if_usb_reset_olpc_card(struct lbs_private *priv)
 {
 	printk(KERN_CRIT "Resetting OLPC wireless via EC...\n");
 	olpc_ec_cmd(0x25, NULL, 0, NULL, 0);
--=20
1.5.5.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
