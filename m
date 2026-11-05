Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793902301;
	b=JW3f6QqgS9jbclwKY4FxE7F5eAomBjfy64xnN1P8ubM/WMGojpX+/pnYefh00jkSNngf
	 t+8Sl0N4avI08CsFaFdt7Ujhw8R4dTcFoduix3z5o1Sjjv1TrH0Sq/8aqrCeevJ4HGacx
	 0hJZvBp0IUD5w//0FPMDDk0ddrmAjJuGZoNFqI85LL0EB6f+V+sTJa4OgxpfcWR+WLxAQ
	 QfTuMc43Hg1WY96tUZJY7MZBdqQCsHHNSA3Yva9ZjMvLarsooC+sT2eKau3btQzo2LAU8
	 pnrFvq4P+dlgPa5TJMZMTarKyE3SL/FB3J6Sdu3r0fJvfnEmDjC1glAfc9dLdxmM0pQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793902301;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=RipROHwmuLopPRt2uXGFcJPV70ANi2jdFd5Eul6RNjE=;
	b=dX7n8vKq+SpzDlowz+Jtj8Cia+hUaUtEWbviM8D+arLQWQZw3QkFf+lMnhcastPVZgzV
	 laZ+Ex6b0zbXrR3OSawb7qMJhjA9SOq97IAmatuCpf+yRDS/Vg617gX8t4ga0hC19qXsH
	 uSWCuh+k6zVSV6DI+4Qke5YMSHOXabaFBcJehV1IIc4Izv20npo8blOnqISl2s1A1ynBI
	 29F1PV38fBsmc6b9l0zjMpjqesgXhUwzpGwBU1Plj9GGNMk7s2hGeJgT5cQbBRuGO6EGa
	 YRasgBkVoA6DC5v9/izubI5DnEE/tCxOshj8xH0EjERAJ/TTG4vE2zs8hsu6d7FYSDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UmUkrGq9;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D94606A326;
	Thu,  5 Nov 2026 18:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UmUkrGq9
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793902301;
	b=oL3mdM0j1V8JsHl38TY+vg0CCq9S8trrLNIBDd2ezeAvonwd5h9llbwAyhDcuwo2ol6g
	 2bLPwGctI9f4q28RlvieOB+Y9B/D5Ib1XoQLMSGgzrC8q+yrdE2+X0wzKH6/DNqDbsHjg
	 DkWtegQUIytsDTwt6PGwsybbrbIONIjJCVeHnlO1QiqowVuD7BLxLv5WhFWnBy363emLx
	 ySv9oFAtrgM0r1dh8Al6p04xqnyNC7j8x69DwsrVP7Qfcfaym7nT69hdvQrq++yC/B8EO
	 ySPBupZyRVqL2ejvKkyd+sIf53RQ92Y3FgMv9lNbXb8oqfXHljSV9ZKcPCMdxzOTFwA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793902301;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=RipROHwmuLopPRt2uXGFcJPV70ANi2jdFd5Eul6RNjE=;
	b=Kf0ePlaN15NPkuZiz/83288C2DxPrT0n5q1h0C23uNsKuDNJPi711eVW/s5g2LJUjakU
	 pXjfucOSM2M8p4Vuhiwk62FFgf/K0LEbaC732R4l50BHfZjpRMRyjS86rWzKloe+8J/23
	 8G2KrdNAHmOoU4cjJAQRKBvhPErt379X6WQytFll9JykHLXkkDaw9atLMvBMWEH0iMi1D
	 pUATKhhCQ+IjvdYxvOa3jLWUB9NCF3FLkxKa560ru3FO205yyNkJGZLp6mCywi0h6fGvd
	 N0C6lu3ZgJEDuV7q4LPOZJvXjqo8qmXqpWiSBqAnsS+douU2icdHDqQ1ImO2y4ChfMA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8CE511F0093A;
	Thu,  5 Nov 2026 18:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793902301;
	bh=RipROHwmuLopPRt2uXGFcJPV70ANi2jdFd5Eul6RNjE=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=UmUkrGq9YISxxrM8zjV9UUJWFD+OXO2eFFjutyjXgzXBUUkTETWtthDtag6A0OTJd
	 vmO+nktSXgbMXa0QRD2tD9WjeFyHQNswBRLRnGJ27TC0nmN2VT20Ixztn801p2E5si
	 GuYRUH9Mv1CzyyELT8w9pNcK4aYQ6RwXmdh1Ohh2UfSJBvHU55jvekAO79Em31LfEh
	 i8y7AG2+00dDA7w7yeaNpvUwpDDhChvkmDzPE5zIv/i/Sp32K5Vxs61089HnD/4Cds
	 DC/7dLiDpIJPUCEGGEIdOJ1e/Z3CI3JTQTUse4YKROZB79CS6ss6vj23JzODEYThwy
	 Ast/ZmA1/f2Nw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E37B0473B5;
	Thu,  5 Nov 2026 18:11:39 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Subject: [PATCH 0/3] wifi: ath10k/ath11k: firmware recovery deadlock and
 stale scan timeouts
Date: Thu, 05 Nov 2026 12:11:35 -0600
Message-Id: <20261105-ath-recovery-scan-timeout-v1-0-99a70d89e114@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIANjG7GoC/yXMwQqDMAyA4VeRnBewigp7lbFDbOPMYO1IqmyI7
 75Oj9/h/zcwVmGDa7WB8iomKRa4SwV+pvhglFAMTd30ztUdUp5R2aeV9YvmKWKWF6clYzdQO7Y
 hDNRPUPq38iSf4327n7ZlfLLP/yHs+w/85mFEfQAAAA==
X-Change-ID: 20261105-ath-recovery-scan-timeout-57a3b3dd7a6f
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
 Hari Chandrakanthan <quic_haric@quicinc.com>, 
 Venkateswara Naralasetty <quic_vnaralas@quicinc.com>, 
 Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>, 
 Anilkumar Kolli <quic_akolli@quicinc.com>, 
 Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, 
 Maharaja Kennadyrajan <quic_mkenna@quicinc.com>, 
 John Crispin <john@phrozen.org>, 
 Govindaraj Saminathan <quic_gsamin@quicinc.com>, ath10k@lists.infradead.org, 
 Wen Gong <quic_wgong@quicinc.com>, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793902298; l=1437;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=W7jTq1TOtayC73926OLlkLF3M0Te4FBfzpormKp/UTk=;
 b=ksbVWRffEogZW1kkwDnEVhCHO1gq8XKyz1R0bHkd+15n80OhyJCy0aoRItaYBJ2S0EpiqhjaQ
 YjXViboSS83Di+DT6lrPdt6ju+v7bC9mjkPCBs8f/nFpvjRYCtD0z0d
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com

On an Arista C-360 (IPQ8074 with two QCN9074), a QCN9074 firmware crash
was never recovered. Patch 1 removes a conf_mutex deadlock between
ath11k_mac_op_start() and the restart work, which makes every recovery
time out when CONFIG_ATH11K_SPECTRAL is set.

The same crash left a scan timeout pending for a scan that had failed to
start, and it fired on freed memory after the driver was bound again.
Patch 2 stops arming it, and patch 3 does the same in ath10k, which has
the same code.

Tested on an Arista C-360 with the series applied to the ath11k of
OpenWrt's backports-7.2: before patch 1, two simulated asserts of the
QCN9074 firmware both ended in "Hardware became unavailable during
restart"; with it, two of two recovered in about 3 s. Patches 2
and 3 are compile-tested only (W=1); no scan failed to start in these
runs.

---
Christopher Griffin (3):
      wifi: ath11k: don't hold conf_mutex while waiting for recovery
      wifi: ath11k: don't arm the scan timeout for a scan that did not start
      wifi: ath10k: don't arm the scan timeout for a scan that did not start

 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 drivers/net/wireless/ath/ath11k/mac.c | 6 ++++++
 2 files changed, 7 insertions(+)
---
base-commit: 5c8eab13e391aaabd5a1ad58f3ee4bb10ce7573e
change-id: 20261105-ath-recovery-scan-timeout-57a3b3dd7a6f

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


