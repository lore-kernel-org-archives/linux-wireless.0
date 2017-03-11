Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:32831 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932789AbdCKBjd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 20:39:33 -0500
Received: by mail-pf0-f171.google.com with SMTP id w189so48009167pfb.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 17:39:33 -0800 (PST)
From: Brian Norris <briannorris@chromium.org>
To: Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 2/4] mwifiex: set adapter->dev before starting to use mwifiex_dbg()
Date: Fri, 10 Mar 2017 17:39:22 -0800
Message-Id: <20170311013924.73348-3-briannorris@chromium.org> (sfid-20170311_024039_543308_1DCE9303)
In-Reply-To: <20170311013924.73348-1-briannorris@chromium.org>
References: <20170311013924.73348-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mwifiex_dbg() log handler utilizes the struct device in
adapter->dev. Without it, it decides not to print anything.

As of commit 2e02b5814217 ("mwifiex: Allow mwifiex early access to device
structure"), we started assigning that pointer only after we finished
mwifiex_register() -- this effectively neuters any mwifiex_dbg() logging
done before this point.

Let's move the device assignment into mwifiex_register().

Fixes: 2e02b5814217 ("mwifiex: Allow mwifiex early access to device structure")
Cc: Rajat Jain <rajatja@google.com>
Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/marvell/mwifiex/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/main.c b/drivers/net/wireless/marvell/mwifiex/main.c
index 5ebca1d0cfc7..43d040e02e4d 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.c
+++ b/drivers/net/wireless/marvell/mwifiex/main.c
@@ -57,8 +57,8 @@ MODULE_PARM_DESC(mfg_mode, "manufacturing mode enable:1, disable:0");
  * In case of any errors during inittialization, this function also ensures
  * proper cleanup before exiting.
  */
-static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
-			    void **padapter)
+static int mwifiex_register(void *card, struct device *dev,
+			    struct mwifiex_if_ops *if_ops, void **padapter)
 {
 	struct mwifiex_adapter *adapter;
 	int i;
@@ -68,6 +68,7 @@ static int mwifiex_register(void *card, struct mwifiex_if_ops *if_ops,
 		return -ENOMEM;
 
 	*padapter = adapter;
+	adapter->dev = dev;
 	adapter->card = card;
 
 	/* Save interface specific operations in adapter */
@@ -1568,12 +1569,11 @@ mwifiex_add_card(void *card, struct completion *fw_done,
 {
 	struct mwifiex_adapter *adapter;
 
-	if (mwifiex_register(card, if_ops, (void **)&adapter)) {
+	if (mwifiex_register(card, dev, if_ops, (void **)&adapter)) {
 		pr_err("%s: software init failed\n", __func__);
 		goto err_init_sw;
 	}
 
-	adapter->dev = dev;
 	mwifiex_probe_of(adapter);
 
 	adapter->iface_type = iface_type;
-- 
2.12.0.246.ga2ecc84866-goog
