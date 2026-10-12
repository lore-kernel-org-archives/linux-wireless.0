Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69694A4993
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791820089; cv=none; b=Dz2wV0p/7/V1eg+xrpMDLhfFK2qinRZwXC1SYhH+o9PNzQp8sCNVhygE6SpgcUKXjOlZnw+Nw1SW+S2qqRVUFrjV8hDx6d0q+Y40rGbmeFk5hU6z/QvFg/9LOODPOz1FhHLnWfDPSTYCpN0TJIhm4LJ1CuJtlstmamcxdPstvFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791820089; c=relaxed/simple;
	bh=joa6RM6ktxOVQDu2XvVi6s+0Yg0dPrzFg1gFR3Nr0a8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e5AovjfwkeJWwYy82IOmDHO8eqIiMzhEX68YH2mxcGXvrPMcamgqb4xtprBvyXJWOmliT5FpIE7cyTAZkb+rz5C/3RNegLkxlKo8zP9+Hm+Eyvql62W+wj9DUXgYM6drT60RODLlxGDNxaI2lFcS/Xcbyr5kqP1/1U5YVprj4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L1RtzEAW; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L1RtzEAW"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3514e7cbbbaso5137892eec.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 08:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791820087; x=1792424887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9/p9hlIUpy4pciplLAexWshVdUELSi1RJnPYvzK8GQA=;
        b=L1RtzEAWzk3npGSueZLjJQHQH3Vd7WTFRXAJZsfY6UNUw7c1swjkmw3LiUW/6yIjhQ
         E38j5l4Ta0+1HN+ZJYP9et9/J0UERugkwFuFtUld6w7Kjggc9sEismudnWsZ6/RYXF6B
         6Ny2tFopPC+n3dHGErF496udH6Npan/WEJWAZVNnXfwdQ16S8QYaWPJOxXLtlUF6dF5k
         78Rj3JwgsfhOYa51pOQ1Sfk6F4t6yV9r/1EwHWi3d8Wi+AJzRu557KWVYAmulX2kW/ia
         tIhkNZzhg7tSrz6VrqZWEQLZ3WmZLbZEn1MDRjr7xvrQVhxhhQDYMnsbWrQzYgPSTPpt
         XFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791820087; x=1792424887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9/p9hlIUpy4pciplLAexWshVdUELSi1RJnPYvzK8GQA=;
        b=2aYbTMGrqGY4Ov8FzA9E93olVPDQZrQ+LEbfLlatz9BEencm7XB1EkldwzU7QsQO/X
         0A6t0nX5SIG13oQtB9Nr4UfpscZcd45OEhlLwhESsvRoxFZIC0R91P5OUFNcFkt4b3Al
         SbGJDay5WNAZi7/sAH02apEL/zxJsDiFuW1axPI1sgn7ptc+8ytajB1GHK4rTjfatFSJ
         WwwJhPMJih739L9Ddcl30O/7ft4N2z13THciIX71btTzJkqS9YCt8HYPjtjt2bHKM+/m
         MGuateGzZQzjQy40dSj2uJDExvYlMjVFCsH886JzWTGlhfUjIKZRr55BQJlJ8QXUJb5+
         0mCA==
X-Forwarded-Encrypted: i=1; AKwUvByMGkhFscWligBD5XKIcPUrGrRK+6Y9hwN9dW0cgRYCbHrwFbqCdphqd4YbBG59+yOq0TEY10Ux5JikmIlefQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYJJmXkgoTDqpsoO5mIhxvgigEBZFzLGl20tbAafNqERzcYAtpiY
	5nYeBCErEgMy9afDjCj37h5V9I+43tf9X170oasGNAi752EzHGNjRUesdpnCl+zZxeU=
X-Gm-Gg: AYBFou2NOU+7FfGkcr+lcg41yRjJ9ej+oOdfiuatvlATpP86G4YM9BRqRo3KvLPoESL
	Lw6u/QnB7tzQqIEAedoi57GpzL0pU8wPGgwbTGnps6a8CbeeqfsoqXfhqJWyegLGslAYHF2zRQ4
	sGp3LhNGTxNBeXyeiqg6bUQjNXZu1gcuw4yVSaZuwi5KQPT3583hPpc2YKJQ14kYNqsk96U0uf6
	A0oqnIIi4yB0OAdXK/j32q53Lz8xd9CT47fXrgdyYRnXA1e/8gFUzui/XiH0HYy6CAvZOcsNtyV
	SuiVi0J7qT3tuIGzQgmRCtImoX6xIBOdQ28pnw8lB068sfSeZSSYVZpMr6hx9MNI6/ox0QcJ4kW
	caCmP5cRvwXs0maSsJF+gq1C5BC33lTXExjAa7S78GVBhHkBk6hduukSkcHdCrz3VyD7DN/GxHO
	R5kWOQlrkJ4TGlwEPFMCgwX0B/HGqTuh5zGVbifJnY9vPEOKGYP/CJI5CSnisOVUlRLgUyOO4Zm
	AWqQbYRLJ+/+upYc5vTILPg1H40ua8gsdFl98JRdBjPAEUTH8PX2n1kYFZo005Xr+SqT6Fw/A==
X-Received: by 2002:a05:7301:619c:20b0:35a:ca1e:511b with SMTP id 5a478bee46e88-35aca1e547emr3700116eec.36.1791820086698;
        Mon, 12 Oct 2026 08:48:06 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:301c:f8cd:c1bb:8d21:6c07:8107])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-35b690af3easm6256328eec.1.2026.10.12.08.48.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 08:48:06 -0700 (PDT)
From: Aryan Sinha <sinha.aryan03@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aryan Sinha <sinha.aryan03@gmail.com>
Subject: [PATCH wireless-next] wifi: nxpwifi: Use str_on_off() helper
Date: Mon, 12 Oct 2026 21:17:54 +0530
Message-ID: <20261012154759.42423-1-sinha.aryan03@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both carrier prints open code the on/off ternary. Use the helper from
string_choices.h instead. No change in output.

Signed-off-by: Aryan Sinha <sinha.aryan03@gmail.com>
---
 drivers/net/wireless/nxp/nxpwifi/debugfs.c | 5 +++--
 drivers/net/wireless/nxp/nxpwifi/main.c    | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/debugfs.c b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
index ccaf0eae3..fc2f188fc 100644
--- a/drivers/net/wireless/nxp/nxpwifi/debugfs.c
+++ b/drivers/net/wireless/nxp/nxpwifi/debugfs.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/debugfs.h>
+#include <linux/string_choices.h>
 
 #include "main.h"
 #include "cmdevt.h"
@@ -98,8 +99,8 @@ nxpwifi_info_read(struct file *file, char __user *ubuf,
 	p += sprintf(p, "num_rx_pkts_dropped = %lu\n", priv->stats.rx_dropped);
 	p += sprintf(p, "num_tx_pkts_err = %lu\n", priv->stats.tx_errors);
 	p += sprintf(p, "num_rx_pkts_err = %lu\n", priv->stats.rx_errors);
-	p += sprintf(p, "carrier %s\n", ((netif_carrier_ok(priv->netdev))
-					 ? "on" : "off"));
+	p += sprintf(p, "carrier %s\n",
+		     str_on_off(netif_carrier_ok(priv->netdev)));
 	p += sprintf(p, "tx queue");
 	for (i = 0; i < netdev->num_tx_queues; i++) {
 		txq = netdev_get_tx_queue(netdev, i);
diff --git a/drivers/net/wireless/nxp/nxpwifi/main.c b/drivers/net/wireless/nxp/nxpwifi/main.c
index 9e1334810..4d77b9ecf 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.c
+++ b/drivers/net/wireless/nxp/nxpwifi/main.c
@@ -5,6 +5,7 @@
  * Copyright 2011-2024 NXP
  */
 
+#include <linux/string_choices.h>
 #include <linux/suspend.h>
 
 #include "main.h"
@@ -1088,8 +1089,8 @@ void nxpwifi_drv_info_dump(struct nxpwifi_adapter *adapter)
 			     atomic_read(&priv->wmm_tx_pending[3]));
 		p += sprintf(p, "media_state=\"%s\"\n", !priv->media_connected ?
 			     "Disconnected" : "Connected");
-		p += sprintf(p, "carrier %s\n", (netif_carrier_ok(priv->netdev)
-			     ? "on" : "off"));
+		p += sprintf(p, "carrier %s\n",
+			     str_on_off(netif_carrier_ok(priv->netdev)));
 		for (idx = 0; idx < priv->netdev->num_tx_queues; idx++) {
 			txq = netdev_get_tx_queue(priv->netdev, idx);
 			p += sprintf(p, "tx queue %d:%s  ", idx,
-- 
2.46.0

