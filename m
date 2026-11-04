Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793759626;
	b=v5+wZ0XG2RvDiEfnkSsQPxapBfybOBwnLGx8A885lb6ttZAqqnkthzo8vajGYxho7VLW
	 l68xrru54QFX7BncgnM4yW+VHKzAV/tr97TradI6rHUJxI3om84p4pwkcLUZPvDYmzROY
	 SXPHDHBjL7fAaiTgwAlnajoBwDKXw9015LpN4ZRx2bjARKRJr4v8jrVIzDrZE/zZwnCYs
	 G2Hi0UXoRNBG+WE8YSHJ1I94+TKe4IzJnck9u/gu8WHy51T+nqfq2x0eQO9EMoSiWAX/+
	 Px82FZp6LVZ8jhdcC6YWyRhjAbCp/oWpPqJVPXAUb20hwlfEOMq8+K4yjRXYw+6hQSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793759626;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=BKdCmLx4asAbOBNQcstL1F5GM5V0+1b4YpXSce2bg7M=;
	b=NEOE1+sXVVsPqp5v12+sN9lMTcIQOB8X3NKeYHRLL7NW/rFifz6mu0hCmH+DVK/ZAgDi
	 C4nEdny1jhS002wO0j/96McYNJt7dzfEP9iDfS7xU9GphgR79SWVUqp/JRumZS6nkBzDY
	 HkutNzzaUmojm+7rNDuu/UWfr73axX5RAH28kvBqUd6AOQPGTGI+LOPsQmPqq/kJzmrRJ
	 TiNCVerW6u119aJKzJqZk2jMWxWBxyTQhmX4zf38IwDDrHOcj6eDTjMN9CP4EejJoD8I4
	 yJlyBGttvrdTJ5h0yJiYZagKbvaEHAJN11IusbHwfPZPLNJIkf5LoolInRr0Gu/piKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=S8XK6U7a;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F64606A33C;
	Wed,  4 Nov 2026 02:33:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 95F64606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=S8XK6U7a
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5367d073f;
	Wed, 4 Nov 2026 10:33:41 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: ath10k: Fix potential CE configuration leaks on PCI probe failure
Date: Wed,  4 Nov 2026 10:33:40 +0800
Message-ID: <20261104-db9e3c75b3-wifi-ath10k-1@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1a467b27403a1kunme6817c2d1636eb
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDTUkZVkhJT0pPTRodS0pKSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=S8XK6U7ajBL35uEiPFwe7Q/3rDmAhG8PB8myWmp9dKaR4MgWGqQ3s+Ojswzcc0U6ApmXmbcBjyKIcB/Ceg09jSqOwJJq54C+1DUyKwtqrPWSflK2lOM2zh3Ey7PJcSV2Zuy+uDylom0XfAZY5UblxhELousNHgGZEEJnnfpOXUU=; s=default; c=relaxed/relaxed; d=mail.sdu.edu.cn; v=1;
	bh=BKdCmLx4asAbOBNQcstL1F5GM5V0+1b4YpXSce2bg7M=;
	h=date:mime-version:subject:message-id:from;

PCI claim, wakeup or IRQ initialization failures bypass
ath10k_pci_release_resource(), leaking the three configuration arrays
allocated by ath10k_pci_setup_resource().

Free the arrays with the CE pipes on the common unwind path. Keep
the later hardware cleanup separate so the arrays are freed once.

This issue was found by our static analysis tool under development.

Fixes: 1cfd3426ef98 ("ath10k: Fix NULL pointer dereference in AHB device probe")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
Validation: x86-64 Clang W=1 changed-object builds passed with
allmodconfig and allyesconfig. No hardware/kernel runtime test or full
linked-kernel build.
OpenAI Codex assisted with source review, patch implementation and
commit-message drafting. The submitter has reviewed the changes.

 drivers/net/wireless/ath/ath10k/pci.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 335bc7c488e4..f3c4fe13f76b 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3716,7 +3716,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	ath10k_pci_free_irq(ar);
 
 err_deinit_irq:
-	ath10k_pci_release_resource(ar);
+	ath10k_pci_rx_retry_sync(ar);
+	netif_napi_del(&ar->napi);
+	ath10k_pci_ce_deinit(ar);
 
 err_sleep:
 	ath10k_pci_sleep_sync(ar);
@@ -3724,6 +3726,9 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 
 err_free_pipes:
 	ath10k_pci_free_pipes(ar);
+	kfree(ar_pci->attr);
+	kfree(ar_pci->pipe_config);
+	kfree(ar_pci->serv_to_pipe);
 
 err_core_destroy:
 	ath10k_core_destroy(ar);

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
