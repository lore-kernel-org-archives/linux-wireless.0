Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37085 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdJEJrU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 05:47:20 -0400
From: Colin King <colin.king@canonical.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: fdp: make struct nci_ops static
Date: Thu,  5 Oct 2017 10:47:12 +0100
Message-Id: <20171005094712.28627-1-colin.king@canonical.com> (sfid-20171005_114733_692509_57604A8E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The structure nci_ops is local to the source and does not need to
be in global scope, so make it static.

Cleans up sparse warning:
symbol 'nci_ops' was not declared. Should it be static?

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index ec50027b0d8b..d5784a47fc13 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -726,7 +726,7 @@ static struct nci_driver_ops fdp_prop_ops[] = {
 	},
 };
 
-struct nci_ops nci_ops = {
+static struct nci_ops nci_ops = {
 	.open = fdp_nci_open,
 	.close = fdp_nci_close,
 	.send = fdp_nci_send,
-- 
2.14.1
