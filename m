Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB2B4EA378
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 18:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784832392; cv=none; b=bJlkySiQ7OgkBc8zPEPfQXYc9nfu15fb3S/wePQdkjx9jH5dyRXRJVgOtg3gm22dTXWC07tN4HknZQf+UQ/tZ8/LbNX041dHbmioM5ep4BkFZ6Ee+kxfUGje1ud76ymzX91XSSv1LwKRuF94GMOj5pYutSE9LxOidql3hqsebak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784832392; c=relaxed/simple;
	bh=l5cYumQSVda6TM4im2zMBBHJR+B+/MjRxhrS0PQEpUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pukTYMT+Cqyvq1f6WE+c4uq4TRVr/tKHv49DnO0cIy/+4fAhbSUics0vZuuWz30JHFVFDFG0ftSQK3xZhpbd5pxOuekvuNta8Nnu3nyvldK9GQ/AgQPBrh4Q7gqzDqupUuXeRzna2bzPjbfzCpimkokeLwOF6AX//bhuX4SwGBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lyXgxQGh; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lyXgxQGh"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so819898a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784832384; x=1785437184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=POBnk8e7cjMk5Mm303buRI06BRywbPO3M0j5oTpXzt4=;
        b=lyXgxQGh9f+VamZrV+xgiT6KkvluQa2NES/CmEJfyGCuZAf3R3FD7VJp9UTpEViBTR
         Zmy7k9dMebw5e1gmYup45nFbL0n17qewT7bssTZEGGUm6nmmF+zArf54uBIBuXn9WW69
         wgeY9ZpRjEolfMK5RCKhLKb3oMljv4sb1nvBtpjia8/54xCmFvopu3AKQi9s/OWLC5ZP
         jLh1pdf95PR+xEbtKgMLwVTOXrgomcK228DFkSwriRRCxCL8RjpHJkKQ7Ac7reksyG9r
         KKd6kPw6jpZjoCcIyoL0/SxyEj6iQ+NPjIlpj8kxo3lI0L8eLRKF2QJiG9K1rliHb7zq
         b3MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832384; x=1785437184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=POBnk8e7cjMk5Mm303buRI06BRywbPO3M0j5oTpXzt4=;
        b=P8XSRgc4Ya9elvZtsCaHfXkAKw+6ptxrLjdmwzppp8718WHSUPKV165tfbej9tHpWP
         0t2g2qSPcyAzQq7kzeOuC0UcMehTBTXbXRHPjs1G9FAeMwI5PhbGkIwZFBiiiGhql+ux
         4UntnKcLkFJv3akkTnMX66AM7M8NBXmASB3/A/uq+w/A8z/M9PTI8Q+y2onXRGt5uj81
         bENuvXsc9D9YOfi0C2IhogpBgMZ9gb4zLFf8BbXkieuwub6qBeITUDLMaQTlczvA3E+W
         DnBqnxVvznZjKl7yMJxrkFnecxTV6XMPFk3LSCBIfXU9K8VWd85dQ0ZHgEw9eK9xOOUm
         9Rdw==
X-Forwarded-Encrypted: i=1; AHgh+RrMWbNF7OPTrjncAY+oAKRMUP0GyBd1MmWSSad1TX9iujeyVHCuR0t20wQv4kJVweXIbbq3SC2fLUlghc771Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLkdoTjw5HWVQdMuYleoqTgpMWgl9U5B0OXVT1XdzN/4X9ryKk
	IhcS/lSZxRVoRxpNS7eF/R3YUbMdWb0cgh1+7LqX/zNNUR2LTfShQ9jm
X-Gm-Gg: AR+sD13yCEp2IA6JGDUe2krOnsYOsLiQS+lEogN/7Kob6sUWXlxTr1kF2MpUUasLGM1
	YqfoNiqtq0/cWxwun54ReSpD/UEra5PuP6HvDW4vlAF7K1botIywo9f2UbUazoCW59ZQyfdD0Uk
	Dj8aveWaeiE3wpUfDEokeNiuJl7mrZTpXxcNC4OVYcO3E2JJyyVGR12TNT65qnfxWoGWsSNz99G
	LIIJ5l9uFu06Tvo0T/dz+hmza2gd0Lyee54vTvhysSFtulr0kU+1cidCzFLdnFIbMvbjtVwHwse
	sPgMqlV9LbJkWuAWpiMRmRjB9IWbKyCNgtKcd0vQnznnvcF9lZOhAuksYBipim7lDd+ydp7szBv
	MNvJnAtexkWlLr7Edgn/MxMc4zPsor7ON3gN+P3mB1xmqRZT5DkEPJItxAUJYH5Pj6/rSprcyok
	cq7SPWBnA=
X-Received: by 2002:a17:90b:314e:b0:381:5a08:6291 with SMTP id 98e67ed59e1d1-38ec658fc68mr3549005a91.20.1784832383927;
        Thu, 23 Jul 2026 11:46:23 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f03af8a45sm308155a91.10.2026.07.23.11.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:46:23 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Julia.Lawall@inria.fr,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Ping-Ke Shih <pkshih@realtek.com>
Cc: cocci@inria.fr,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 10/36] wifi: remove conditional return with no effect
Date: Fri, 24 Jul 2026 03:45:12 +0900
Message-ID: <20260723184538.3888637-11-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260723184538.3888637-1-ekffu200098@gmail.com>
References: <20260723184538.3888637-1-ekffu200098@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both branches of the check return the same value, so the check has
no effect. Remove it and return the value directly.

This is the result of running the Coccinelle script from
scripts/coccinelle/misc/cond_return_no_effect.cocci.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/init.c              | 6 +-----
 drivers/net/wireless/intel/iwlwifi/mvm/link.c       | 6 +-----
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 7 +------
 drivers/net/wireless/realtek/rtw89/mac.c            | 6 +-----
 drivers/net/wireless/realtek/rtw89/mac_be.c         | 6 +-----
 5 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 782209dcb782..61fa10d88714 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1566,11 +1566,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 
 	address = MBOX_BASE_ADDRESS + LOCAL_SCRATCH_ADDRESS;
 	param = options | 0x20;
-	status = ath6kl_bmi_reg_write(ar, address, param);
-	if (status)
-		return status;
-
-	return status;
+	return ath6kl_bmi_reg_write(ar, address, param);
 }
 
 int ath6kl_init_hw_params(struct ath6kl *ar)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/link.c b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
index b5d252ece2d9..76a548f9aea2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/link.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/link.c
@@ -278,11 +278,7 @@ int iwl_mvm_disable_link(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	ret = iwl_mvm_remove_link(mvm, vif, link_conf);
-	if (ret)
-		return ret;
-
-	return ret;
+	return iwl_mvm_remove_link(mvm, vif, link_conf);
 }
 
 void iwl_mvm_init_link(struct iwl_mvm_vif_link_info *link)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 9b119a51bc30..1ba53e671207 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1462,12 +1462,7 @@ static bool _rtl8821ae_init_llt_table(struct ieee80211_hw *hw, u32 boundary)
 			return status;
 	}
 
-	status = _rtl8821ae_llt_write(hw, last_entry_of_txpktbuf,
-				      txpktbuf_bndy);
-	if (!status)
-		return status;
-
-	return status;
+	return _rtl8821ae_llt_write(hw, last_entry_of_txpktbuf, txpktbuf_bndy);
 }
 
 static bool _rtl8821ae_dynamic_rqpn(struct ieee80211_hw *hw, u32 boundary,
diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
index 8c395517bd2f..967b42f2b6fb 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.c
+++ b/drivers/net/wireless/realtek/rtw89/mac.c
@@ -1706,11 +1706,7 @@ static int sys_init_ax(struct rtw89_dev *rtwdev)
 	if (ret)
 		return ret;
 
-	ret = chip_func_en_ax(rtwdev);
-	if (ret)
-		return ret;
-
-	return ret;
+	return chip_func_en_ax(rtwdev);
 }
 
 const struct rtw89_mac_size_set rtw89_mac_size = {
diff --git a/drivers/net/wireless/realtek/rtw89/mac_be.c b/drivers/net/wireless/realtek/rtw89/mac_be.c
index f24c119b99f1..b7ba8de9cc78 100644
--- a/drivers/net/wireless/realtek/rtw89/mac_be.c
+++ b/drivers/net/wireless/realtek/rtw89/mac_be.c
@@ -924,11 +924,7 @@ static int sys_init_be(struct rtw89_dev *rtwdev)
 	if (ret)
 		return ret;
 
-	ret = chip_func_en_be(rtwdev);
-	if (ret)
-		return ret;
-
-	return ret;
+	return chip_func_en_be(rtwdev);
 }
 
 static int mac_func_en_be(struct rtw89_dev *rtwdev)
-- 
2.43.0

