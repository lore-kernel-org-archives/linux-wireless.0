Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85D33DFC86
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 09:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169398; cv=none; b=QfvsfgQdMrEIsHoh5uabMMfrz87Yo7G2ctx9q8yKyTPmVtGv0t0kBeKFLIV4YaqGVEwkUu51X0WCkdiH6p5No2Vh7raMe2/w58c7uWr6Jpnl6T2JrlaXaap/gpDp0sf9ZJ0kFJ6kcMnc2jG2YJGAi4mgdU7FV9oPGYweayXhTdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169398; c=relaxed/simple;
	bh=Zmuvclye3NIQlE3ZRkLYBpmsbbXEKumRWjfP/QL39J0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tSoeVlR/IUDAIjY/Dt5QhU41vy7+qcJri9+pso72FaALzEvNwtrbRz0DlrBzgF44O5Qp8kBp1vgdKcciNKeYIvCw4bvF0tjJLI6d1nH1elFFTj/kSCXsORsSRtbBUL+uWjppqBA2hKIyFaFdEwD80l5Q8zD2LJ2F82nUyGzKPko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N3nV/wY3; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N3nV/wY3"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc1a4c62804so2694458a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 02:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788169396; x=1788774196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jfg7sXtsvfod3zJozifW9/U3G7TXXOEAcX0FYUgiGnU=;
        b=N3nV/wY30f8dE6mpb27uWpJAvGuLLj1jYHG8CMbc2o08EAWhSdy2fZRoXkNMsermQ8
         NEQFJXR5d1wTTAD7px2GrFZRRZxC2RXw8w/kd/P3V9NZ7knnoYUrG2lAtBQHkE9b8WP7
         MR/MbwaPJWAey90gfat0TlIrTmlVDegsclxqGJ95IJtBGePiyg/qxPnrJ6E8FSKDmwK+
         eZU54Y8Kv71J7Rr6dHsJCk3KHo8eVq1n3Vj80TQJzSSBPx5lusyNr28Edcl/yx1c+CU1
         Byt+P67xOJ3kgk50Ky5OenE3uEeuVOl2snzeBbi1cywUjn9Yyw6pOIaSx0OvkcbUeBRn
         RWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788169396; x=1788774196;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jfg7sXtsvfod3zJozifW9/U3G7TXXOEAcX0FYUgiGnU=;
        b=PnjkPGpRtJ0s9hZfgJ8zNeIKS4OEtggbfP4254uuFZ5JwH3wjCer7i+bKYu08sQ/Gf
         8p+3txV3tLfGOSSITe9CpwpuZRGbLwoZB0XteGvgDh653s+OqMfVEP66Aoh3KF6ReRgB
         mv78Og/2xgzvzPSuLkgDSRZ9GV0Ouu8lz5Oq10nBIowyb5qrWxdC8uNql1AUEPa9TXV8
         hfHk7yP9oaxlfF53vluBrZelbAIDo3ox/1nFDTs6sm4w1FiycwkPc+W9QBWLwzPH5JF6
         0qdNbwhXABmlW+VqruSJI7VlLJ+xCo3poO1pJbwflVXEtPNqett/KH2C1JBPyLsleAIr
         bHNA==
X-Gm-Message-State: AFuF++kG5D84wH/8VooHHkeGs/aeVY7Zec8qOOIOfMC/fIEeVTuoopJo
	dbuWw/Bjla/YNgLUd9l+qVGYuHDd7Jihz3w+RxQZeySBOkQAgE05pPIE8U8OlQ2n
X-Gm-Gg: AYBFou1wGHlzN+7YPe+V6Ax5Ze10+QFdYWnlszoliOR04cSIpOGclYqcQO1Xjw6ZdP9
	0clwiWfgTKT6vYAaIo8Q3UbTtNC9kWfzo4vzuwV9CaKgAVD0Ou3CTBlaD9CMiA8P4kjIKN8E/uS
	umQJwsW7UnTa1iKNlf0SdUnVNJa9q9+k3goWIAIborHgDS04fi7e54rLb9rPhyllhflk3+DcbhC
	3GJ5sNli9WZSdUpFr0Ck43E4nLF1kDXD0rWyQBioPIzjQDkQFomwwrCjSP8SmuVmmq/aGZ/xWiD
	RIze08bfZiylVZybCUhfQMis0Sc6omS4y0uW2I0gPK6oc5cEfUkRNxjyvGPbqUZ3IFaRelXvfVO
	Fj2C3h+QquOQ5aTB1PftOkzhLPz4uIecDLdshsr2vCWOOdKy1SiRj3o69zzDj2LAIXZGjOgKXz6
	8vzE8XaMObZI14+qXaFB9NKiugHwgNUA/RJqAFKsmgJplm6n29gCWW7tHnp0v7c6XmZWQ68oNAB
	9uQRlhlSwuoXBJGxKiOHMaOo/sJk6YZrQ0nVKL/N/Qj6tDnZP5Zqus1YDUsP92IbNtRMCYgl8U+
	i3fVS6aPPn47
X-Received: by 2002:a17:90b:54c5:b0:395:4de4:92c7 with SMTP id 98e67ed59e1d1-396d0e5ccc7mr40960562a91.3.1788169395828;
        Mon, 31 Aug 2026 02:43:15 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440.tw-tpe02.nxp.com (61-228-209-44.dynamic-ip.hinet.net. [61.228.209.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda7aaaasm15795716a91.6.2026.08.31.02.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:43:15 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	francesco@dolcini.it,
	Jeff Chen <jeff.chen_1@nxp.com>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH] wifi: nxpwifi: fix missing error codes in _nxpwifi_fw_dpc()
Date: Mon, 31 Aug 2026 17:43:08 +0800
Message-Id: <20260831094308.140511-1-chunfan.chen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jeff Chen <jeff.chen_1@nxp.com>

When nxpwifi_register_cfg80211(), nxpwifi_init_channel_scan_gap(),
or nxpwifi_add_virtual_intf() fail, the function jumped to an error
label but left ret == 0, causing _nxpwifi_fw_dpc() to return success
despite the failure.

Fix by propagating the return value of nxpwifi_register_cfg80211()
and nxpwifi_init_channel_scan_gap() directly into ret, and by
extracting the encoded error from the ERR_PTR wdev with PTR_ERR()
before each goto err_add_intf. The P2P client interface path had
the same IS_ERR/goto pattern and is fixed in the same way.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-wireless/anwshVbQWXXHTJpa@stanley.mountain/
Assisted-by: Claude:claude-opus-4-8

Signed-off-by: Jeff Chen <jeff.chen_1@nxp.com>
---
 drivers/net/wireless/nxp/nxpwifi/main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/main.c b/drivers/net/wireless/nxp/nxpwifi/main.c
index b4c63829024a..5df099b98719 100644
--- a/drivers/net/wireless/nxp/nxpwifi/main.c
+++ b/drivers/net/wireless/nxp/nxpwifi/main.c
@@ -603,14 +603,18 @@ static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
 	maybe_quirk_fw_disable_ds(adapter);
 
 	if (!adapter->wiphy) {
-		if (nxpwifi_register_cfg80211(adapter)) {
+		ret = nxpwifi_register_cfg80211(adapter);
+
+		if (ret) {
 			nxpwifi_dbg(adapter, ERROR,
 				    "cannot register with cfg80211\n");
 			goto err_init_fw;
 		}
 	}
 
-	if (nxpwifi_init_channel_scan_gap(adapter)) {
+	ret = nxpwifi_init_channel_scan_gap(adapter);
+
+	if (ret) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "could not init channel stats table\n");
 		goto err_init_chan_scan;
@@ -623,6 +627,7 @@ static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
 	if (IS_ERR(wdev)) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "cannot create default STA interface\n");
+		ret = PTR_ERR(wdev);
 		rtnl_unlock();
 		goto err_add_intf;
 	}
@@ -632,6 +637,7 @@ static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
 	if (IS_ERR(wdev)) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "cannot create AP interface\n");
+		ret = PTR_ERR(wdev);
 		rtnl_unlock();
 		goto err_add_intf;
 	}

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
prerequisite-patch-id: f0aef766da5c18da0e8867bf47bcff1991a4f0d5
-- 
2.34.1

