Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D09733A9D6
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 21:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789334084; cv=none; b=t57UX1GKWlYmhnXDqNwszbR3/wNTCGRZPGYsTHByfz+bWIioNCxz3GJ21eXejvX99Ea85LfXHaSudW80Uz5o2koB/ItmczsgNAbW6qJd7qeF9KHkwdV7FZFSfww1BsadBsR7kKHo055XmALzL4Td8dgD/r+038x6LzHndWNZcro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789334084; c=relaxed/simple;
	bh=RYuywvqdjTiryWx0HZMQXcmBWyUUadoRXwkVxaTdKoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPAYStChXKZEvUimc2ux1RIK+BoOwQjnyjdaro3+IUyYzbANwDbdT1JH4Ljt+iNf9h6/j1Pi4A4BdSnu0Ws/GZNwOxIppd3EHVUopHNq1LgokcScp8f3PPYIQgRKfH4AY5oBIExiV+BDCKFf6yl+j6jb/I1rDb79pFZNNTeNRwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r5QRQrxj; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r5QRQrxj"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39666e7c9efso306939a91.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 14:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789334082; x=1789938882; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=keGOAuFWtk7eVvvyNyqZYN9zhPLoleoThR6yxbotHPY=;
        b=r5QRQrxjQlldyKYYQjyCWVKVir8Xd/FKtbgNcRWheFkG3pyyRKpPEkVKfIrQUjXRKo
         pWgRqOaSoVl6cTEdptFOmBdhGFqv6IzxQi8HNXLFnQn44hbkY2WS++Wv5wumLOunNzIZ
         nT/Vp50zfIElETcpgyghrYO6kqTfuEdrFrn5Uz9gcvFrN4+FjySshrT5acUgAmVbWuO9
         eceH+gN2EICREwqMxD+8WS2WTAa0ml+ASJORW2dzQVidLi1EJJ+7ymr3cCdErDOxwDMl
         gSFqT8LsGokh570emrIhmDGPObZfsRR1PPbLetCHwAvxbtz+zvVyXaLEsx+ZLq3IOled
         vtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789334082; x=1789938882;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=keGOAuFWtk7eVvvyNyqZYN9zhPLoleoThR6yxbotHPY=;
        b=OdUM01RuvF/wvCaAae97fsVhXQQiA0Dpeey7SLPKUr+UsscW4pzO14nQsuQwtiYtZz
         /oqxEL4ut/GMhgfRK1+Jomsnz02m+Qq8NFUl77JFI2u8b68hR8d7ODWMYlpgydDIfQMH
         KNz/GN5ntIORKmliq7z4v4OXLyqtxWuqPdVWQoxDbsdZ6QTVfTHx1nO0VhyEE/vctCnH
         EdUP1gpL78Rwuu28d4+fNpUg72SB2lZqUEUQ9TTC/uz4j7R+JKPjjcKDVBIilSOWMBni
         gRymyeriKBtLTtyy0Lc4CD/nwrM/nINpYy1YCmQ5zfXZ7PDaQpF9XcYTSp+da5N1iN9b
         HeZw==
X-Forwarded-Encrypted: i=1; AKwUvBz0BO2Jz0+tRjZhokAw5jZlrGXv3qvqURZeQfsygitBqE9xHknlfOK9X+TWnEsC8wswxVxbhUQJE8zAjRldmw==@vger.kernel.org
X-Gm-Message-State: AFuF++mBmjQVhUPQpQiocrPLXoRYXoweeL22FY9UpLTg6iiuG78Lxush
	6HQepyVmiM7yTABUyiTIjsvvyTJ0w4AD3kbJxcyi1v8jv39vlET6/DAF
X-Gm-Gg: AYBFou0unBrGx5uTu2IdTwiHYtTnNGmYqaJUvihwAviIddIEzwqdsSjEIK+57x9IpLJ
	wHqIh+OQf8C4dvaMujgC2x0IoQuozurfGpo6ELLTBuAKdWMkyLpdMeUaI2eGOExoged20OtnVlv
	NADHk4GbrIsTWYh6c+a6R/NvpvB0r/Eqi5gS+MCbnS6O+7es8ik4GJ8L0Ue9D1PYI0YoAqxaIhg
	1IOBuW00+841QnGehXukbUP8+c2zRKQO4ZoX5tLA06clQjPFTDSJXq2bPgliY2j9rbznvncf4ci
	WfDuXEWAu4lV8nLOc5amyYNtVEOFdRma1lWYyLjdoXRqlxZAic3D3cpMh32c+E5hvFHfzo0VAIW
	T4WRz/R7nHokDVlhUq7fTSrB1RTm/lL2HpRdLdL999vm9QdIYL4MNXbSRaqr4Ia834ECkkAcjni
	0nvisdfyJJPIZz8qhVzCrR/smZr20wE7gJRFIgk69EwwUI/oFZBsrePlQMURiYAnqmT/x6+FawY
	Lz9SVzPwM/xcWtNcyi4m2m2hf7MWgbU38pJUESeiRj7gJIhRWbT7+Duaoorw9fUemfOmhQRabGi
	02TjQtqTvSYDqg9KNwpm
X-Received: by 2002:a17:90b:588d:b0:398:bac0:238d with SMTP id 98e67ed59e1d1-39d9c362f8dmr16743869a91.5.1789334082514;
        Sun, 13 Sep 2026 14:14:42 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.109])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b348cbsm21382925c88.3.2026.09.13.14.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 14:14:40 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: miriam.rachel.korenblit@intel.com,
	linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	helgaas@kernel.org,
	ilpo.jarvinen@linux.intel.com,
	emmanuel.grumbach@intel.com,
	nika@nikableh.moe,
	mpearson-lenovo@squebb.ca,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Navon John Lukose <navonjohnlukose@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless v3 1/4] wifi: iwlwifi: pcie: cancel the ME recheck work on probe failure
Date: Mon, 14 Sep 2026 02:44:25 +0530
Message-ID: <856bd0ddb7f3391aec28e6af710edb077204076c.1789333511.git.navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1789333511.git.navonjohnlukose@gmail.com>
References: <cover.1789333511.git.navonjohnlukose@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

iwl_pcie_check_me_status() schedules me_recheck_wk a second later. If
iwl_drv_start() then fails, the probe error path frees the trans without
cancelling it and the callback runs on freed memory.
iwl_pcie_gen1_2_remove() already cancels it; do the same here.

Sashiko's review of v2 1/3 pointed this out.

Cc: stable@vger.kernel.org
Fixes: 41fff83fe6cd ("wifi: iwlwifi: pcie: check for WiAMT/CSME presence")
Signed-off-by: Navon John Lukose <navonjohnlukose@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
index 28b276c..a30854d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c
@@ -4369,6 +4369,8 @@ int iwl_pci_gen1_2_probe(struct pci_dev *pdev,
 
 	if (IS_ERR(iwl_trans->drv)) {
 		ret = PTR_ERR(iwl_trans->drv);
+		/* iwl_pcie_check_me_status() may have armed this */
+		cancel_delayed_work_sync(&trans_pcie->me_recheck_wk);
 		goto out_free_trans;
 	}
 
