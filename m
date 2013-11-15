Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:26034 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755560Ab3KODKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 22:10:55 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Ujjal Roy <royujjal@gmail.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 3.13 5/6] mwifiex: fix memory leak issue for sdio and pcie cards
Date: Thu, 14 Nov 2013 19:10:41 -0800
Message-ID: <1384485042-7083-5-git-send-email-bzhao@marvell.com> (sfid-20131115_041059_394513_88216CDA)
In-Reply-To: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
References: <1384485042-7083-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

When driver is failed to load, card pointer doesn't get
freed. We will free it in cleanup handler which is called
in failure as well as unload path.
Also, update drvdata in init/cleanup handlers instead of
register/unregister handlers.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/pcie.c | 2 +-
 drivers/net/wireless/mwifiex/sdio.c | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 33fa943..03688aa 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -232,7 +232,6 @@ static void mwifiex_pcie_remove(struct pci_dev *pdev)
 	}
 
 	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
-	kfree(card);
 }
 
 static void mwifiex_pcie_shutdown(struct pci_dev *pdev)
@@ -2313,6 +2312,7 @@ static void mwifiex_pcie_cleanup(struct mwifiex_adapter *adapter)
 		pci_release_region(pdev, 0);
 		pci_set_drvdata(pdev, NULL);
 	}
+	kfree(card);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 9bf8898..b44a315 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -196,7 +196,6 @@ mwifiex_sdio_remove(struct sdio_func *func)
 	}
 
 	mwifiex_remove_card(card->adapter, &add_remove_card_sem);
-	kfree(card);
 }
 
 /*
@@ -1745,7 +1744,6 @@ mwifiex_unregister_dev(struct mwifiex_adapter *adapter)
 		sdio_claim_host(card->func);
 		sdio_disable_func(card->func);
 		sdio_release_host(card->func);
-		sdio_set_drvdata(card->func, NULL);
 	}
 }
 
@@ -1773,7 +1771,6 @@ static int mwifiex_register_dev(struct mwifiex_adapter *adapter)
 		return ret;
 	}
 
-	sdio_set_drvdata(func, card);
 
 	adapter->dev = &func->dev;
 
@@ -1801,6 +1798,8 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	int ret;
 	u8 sdio_ireg;
 
+	sdio_set_drvdata(card->func, card);
+
 	/*
 	 * Read the HOST_INT_STATUS_REG for ACK the first interrupt got
 	 * from the bootloader. If we don't do this we get a interrupt
@@ -1883,6 +1882,8 @@ static void mwifiex_cleanup_sdio(struct mwifiex_adapter *adapter)
 	kfree(card->mpa_rx.len_arr);
 	kfree(card->mpa_tx.buf);
 	kfree(card->mpa_rx.buf);
+	sdio_set_drvdata(card->func, NULL);
+	kfree(card);
 }
 
 /*
-- 
1.8.2.3

