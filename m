Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBB7456DED
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 10:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518371; cv=none; b=TZR8gF+ZzINwN+oH26HO6hYShs0+dBwIo/hYzsR2vOhRWgUBPZ3xTE0Jjb3Kv0le6dh+mjZmnTKkYiYcAUZFc8A/AiucASN/q5kIVgCX1wm1uCztfRoZ6OWZyC3P9EXohtw1tU/2ZasuT+6gQD5MKSOXsBoWiAk+jQP8v57Hk68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518371; c=relaxed/simple;
	bh=dcd0yNsXThKJ8akKS0YFbvZ/tJFAVThfl2ekZN2Ck9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GmzHrHmhHB414Tqa3Lp3o68YzkL1m7VuDM81k2MT6e3NdSVMjgiNYdAFUz0glDqLeo92wlLPS2WTQVJODbrpOalWuBatDusCm/NE74gt7jQNNG3UoDqJDWutwr0ajLKUxt5gWwpTfCSkwqvJtaHSVtftgTYffDYPKznE8OJw0dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpUv6P5E; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpUv6P5E"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc1cb472b76so876303a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 03:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788518367; x=1789123167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0tGH1FkVa5eeQ8HJYtgT/UXLsLiGmQHDZyMBBbzdqF0=;
        b=DpUv6P5E8yRlCzTdqyU4yBlJzdhZwsr+iJmN1tW9CF8ss8guiOrmtDg+EQMvNhTksV
         5T4qkqy8RVM6eo2w0a2eGMmzNblvqryU08zyFphytyFo8vuj8tQ0BbAotptyigB29YYz
         AXvjcIMy0k6N+LqVAGlPdh7IheAHivPmXAPOYLh+MwJw6QauA4FuhWLhLg1ja5xzB4h2
         umVZa8c0MM4OUoL05yqkfSlTfGXbFVxljIbMVf7BVNilctfP7fLXTQvZ0yaeQMLLilFR
         JAFToWynMW4KgLdYXaLlBpBPmHMqEvFkJRRt1P53ajmIgLu+PjKC0fZ/XW3Rh4tAx+Ky
         q9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788518367; x=1789123167;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0tGH1FkVa5eeQ8HJYtgT/UXLsLiGmQHDZyMBBbzdqF0=;
        b=i5qS8Bw1ASkiu4ho6p2eI0aUI/mXiwmQ6X6TaEpw1o4vhzdlJgD+W/DezVcciVmNhi
         /04CoDBIU9HEW+sqswUGkxeXKsgeByk2gn/BGVjayHRBk5pojAZJutq34M1tq+JL0Ng2
         bwe6BT3aonOZsf8kaoezLjJuZCJJuWfU0miriDdB2BnvWTLHeT++2TqmAkT5q5k0JW0k
         gOGiVq10+eljG2TVyT5d50uH7kLUjktvUWiD3sqGUcxts8UIsRjsiZWYsdJqQsqhZ6uS
         4l952IDCtKijku7XpawZJ77kPPw7ZhnJeJtZdB2Sm825QIZ4+VS/hPRDpw7E5aDq1izN
         2wqg==
X-Forwarded-Encrypted: i=1; AKwUvBzHrwLpNee6spDc0X1flL4VLMDyHq/BRCQrjIdJjoWHx+M/mdpQQW2XyijVmMFXxu6phLHwvN7xTom+bIS7Fw==@vger.kernel.org
X-Gm-Message-State: AFuF++nWfSSdrhlHRhBUN2VExnnyvp452ye2PhmpKBcG/unqosgfkY6n
	vKbPBR4evHqJC7KsCFrx+1nS6yvujgAUbDsmoRTSO9bjr0crYR9chaVz
X-Gm-Gg: AYBFou128Mx1NmgB89YFoIiOuSTEATUCFatu4EhpbUM0Y/oNW+w4oaIqvne6gEz5gVZ
	w4Ea/j9MiAhXMrvTmqhF1ojbHH6JqDmCIS4qpdWwEJh297bLfdq1CK0C9oYdU5E6tx+wVq+bBAO
	4AcuICWQBjHboAu49x3ew4au48KHlM3AJ6sd9dGKCX2Z09s20P+iU/2FYJ9yVTjV2zlhbh0dpD9
	SsM6awrERAQmRY0rqPPZFzXiWtGEZttDgwaET6QcxX+YGnXW5vc9NuQJC70xg47Lq1pkpSQGUrL
	hLMY2/4aMgKgcy3/Hjmby55rTlQ8BQQd1jFECallN9z6lLKloHtW1Fy7TRF9ttQ1UTKkjOPesaj
	AngEEsYzI+1f1Nm6uxaPOoFeaWiW0JQ0tEavZF7XzN8kkHWm0feZAFgRcC4fNQMNxMQhqrVvn0W
	bf1WeZBKlCrztZs9oMctt0ianTREii/xcZaIyCRNibbY46Pp5IHlxE+Eo6id4fq0BxzbnY3BJF2
	KsBZKPxLoNg46Y=
X-Received: by 2002:a17:90a:d646:b0:398:9bd5:490d with SMTP id 98e67ed59e1d1-39b26214798mr8239534a91.20.1788518367202;
        Fri, 04 Sep 2026 03:39:27 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339885d29esm6463814eec.2.2026.09.04.03.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 03:39:26 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] wifi: mwifiex: fix typos in comments
Date: Fri,  4 Sep 2026 16:09:21 +0530
Message-ID: <20260904103922.10193-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.c | 2 +-
 drivers/net/wireless/marvell/mwifiex/usb.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index a760de191fce..aa33eae1a256 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -1402,7 +1402,7 @@ static int mwifiex_pcie_send_data_complete(struct mwifiex_adapter *adapter)
 /* This function sends data buffer to device. First 4 bytes of payload
  * are filled with payload length and payload type. Then this payload
  * is mapped to PCI device memory. Tx ring pointers are advanced accordingly.
- * Download ready interrupt to FW is deffered if Tx ring is not full and
+ * Download ready interrupt to FW is deferred if Tx ring is not full and
  * additional payload can be accomodated.
  * Caller must ensure tx_param parameter to this function is not NULL.
  */
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index f4b94a1054f6..e328b2a497cc 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -1049,7 +1049,7 @@ static int mwifiex_usb_aggr_tx_data(struct mwifiex_adapter *adapter, u8 ep,
 		} else {
 			if (port->tx_aggr.timer_cnxt.hold_tmo_msecs <
 			    MWIFIEX_USB_TX_AGGR_TMO_MAX) {
-				/* Dyanmic fit timeout */
+				/* Dynamic fit timeout */
 				timeout =
 				++port->tx_aggr.timer_cnxt.hold_tmo_msecs;
 				mod_timer(&port->tx_aggr.timer_cnxt.hold_timer,
-- 
2.48.1

