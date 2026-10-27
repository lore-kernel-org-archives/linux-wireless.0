Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793087750;
	b=TvlkcjEzKPJCJ2umzFv79IDNwgk0M+aySR+EWTBMAWniy0rqCK02kwluv6pS5R0h7oh0
	 IlspFpxsjbdH8fSOWWwSsYuNaLGS5EGUYW478O0Z3BxUcjY7AweiEgtBzNRtQK3U4N9kW
	 e7dp7QAdjua8spzCHRi7gXDQ6RdqVXLHn0zse9G48baGCDt83ieSsSPTX3Cl1moWCyrUL
	 eN+f5MGf3+lz0Ks01jb9NyEYEwG99hbfw4lyzzFQhXSsKrBankqS9BTh0hxrc8DKbBQtY
	 /yAXaKcnY0Jh0mrNqOX1SEqjHHeGhYiWHC92ZZ8svLTZMIQTjwFzXnRbX3m91osIk+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793087750;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OnjgAO2S1SeHeUnZwhglBquHq1CKNVlZfv2BuRKP7G4=;
	b=45XSwJOgXxym7SgBiJGROJroKgx2IKnBt+6Y3dAcdkxP60eJg1VFeNlVUjAU43i/iZ7+
	 /yoos/32PTKtXpfD+DlHTdx42CBQZfKW0dLNHH/aBLa1xKl5NlAmQvm6h463uorPZKD5p
	 9BaSKMfNckJ3zPxKVE13b1pD9TlqrpT++FOdNHGXsn8zL7W5dGTJhEz4XkfaH9WCS3OJ5
	 IzH6P7ebTLej+BnYz0bDBX/OsFr+gDWaA9wnXjYSL9wOUZ65OlcEmjA80AznYG2AFsFP5
	 mizgpuCWzFVUb9p59AhvQyMMC69h+Dk0Dlpsbclnbe3ZU+SvZBL7qcflXo7Jn4MXHiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=fIati4go;
	arc=none smtp.remote-ip=209.85.208.42
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58A4606A31E
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 07:55:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E58A4606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=fIati4go
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b45f9ec1ceso2152237a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 00:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1793087748; x=1793692548; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OnjgAO2S1SeHeUnZwhglBquHq1CKNVlZfv2BuRKP7G4=;
        b=fIati4go/bYB9eSeVe1UvlGHHtQAjaFS/HqN+tmOfODSCAV7d0b7tG5X6jJIHTdZ93
         UphzDs/PYSsCPAGcv6VhD4noEFF5nPuMH46QFY65/MZsIK/T7K0kSTy1ptfppEJJoQgX
         skjIwx5Hz7gxEiA2FU5xB/t4MdLU5Pd/VLk3/1bp7MM330Djf8w3vo4hxwi8tSpypMFD
         AuJdsVMsh4uMy8Rp2bPWmJmKpDVuBAeqKhdD+Voe53WI5e2SGEzIb4p/PG2+ug15s2Wo
         GPT+JBV+y9oqzbAovSxbEJ71WNU84cYrYqtQ9lFUrBhhQB1XCRz2su/ddPHJ3Fh6KoMB
         9Fjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793087748; x=1793692548;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OnjgAO2S1SeHeUnZwhglBquHq1CKNVlZfv2BuRKP7G4=;
        b=qCnqY58+B6Ffnv58UXE9OKf4qt+EbMyKWFCxWeveMRF2GR7y1Pn7bhlIW9wRk+pyNu
         o/1IzQBSh+bcjxhubbOr3uy831eNNX/m9s0ZYt3h4JguAjFOlmxfKSQJWou41IvfDeuH
         AK/2aNnW6fJJ8HXECAfR5hb//rsXgBlG/ekyWHuuhIfg9gXLqC/3LpKgz5T/3iVZ4bUM
         fxzMRxLGj5oUkuLrI18SqI8bsoCGUiXU6xn7UYTm++pPPid+aCA5s+atDDIcZr+WaTxo
         pafTQlnQDfRuCi5eRHl/6dgF91dQ4fUu4fuI8McVQteoOt6beiwF3PSD3+/dwORLg6fZ
         7Sng==
X-Forwarded-Encrypted: i=1; AKwUvByFFTEEeRqrH4j//Cv1JL/gC6qlCSR5Xww5XCjD3UN0yuAPqA2eITAvbJt3f0rvkfx3jDtfy1dJswNDl0TzIw==@vger.kernel.org
X-Gm-Message-State: AFq9FYLaFJj28yncGLU3jP0V+7nJKcVCijgom2eiGJBmBcKBAlXQcgt4
	WOBHGXz6/y9/qaQQ0KNB/aQ8U32wTeXUweznb9p+S/49RgvaRYejPI/RyGXBm2aYyvLtYyySXb4
	+y8ei6I0T
X-Gm-Gg: AYBFou0g+GL4F1SZi4PvtGfyE6t9nyUJ4kZJJKtpuA1Ia1jCZ4Tovpg1lR6EHQ7tyM/
	CE6L5ofazyDtCZ5FakJ/cOC84PdFIVWYljRZBEuSA/uaZZO29l4dRVMad9big0kdX1dEWeUevcp
	V92xxa1gFeEvRlyabvAJvzZFBCiOlNGShf3SWWqhCKIpPsD23m1w1qYUwlvdCZnwlsJbj3V02mn
	tA1rnsVSFy/NiChdmpkpd4H3gs/M+GV91I6P2fK7kUpba7hjyMjtoxwfg69FsZHsVXe7lBqpdc2
	upspiZGSPNgKfdDFfQDhinB8a4ydOxnwZkjMXgR+PCzGzDi/mLlKWQVmlAIlz0qXRyFD8XQQGO/
	uXCM80HlI1Al366ibWRuieazkX/dt8ldZQ7OGh4yzXvEXyYaUvvaIxitozLpDGQWM/cxvY+y0O/
	96NWIqcJjaQVcEAbmItsj24Lq6cHKO2Asy59lpnqnEeuDOHGEsKnLGyQeHLHhV0kT/S4cZATzhk
	Ms12Y19WMCCl+/gOnSESObvwi9IehiWnSAnplP22YPGxrUcjKX5W3HK5frZ2f1BvMePprIHhF0a
	9F6k9Bzy+eJGVVhJehqZeuRDUrFOMlK/9vWfkatSwIAQSh/Rsy4GeM8iGwuBZwjTTPKjrcOfoxw
	aEc+4uqZ30hZJVQIAD5CNMslUR+FS03geBKCjRg1VrsuGRR1+9w6OMANKd70iZBdCZpnoo9YdOH
	KX0uy8zA7KoB2rBeJkj3z7x9J/vNPT5e7mc7KkatTHyT/JWM1jlwZx9NJt1koIhVhtbUReUlorX
	QuPa+KIgmi1/cFa50WeOV9r6kCAeA==
X-Received: by 2002:a05:6402:1502:b0:6b4:2b70:4a7d with SMTP id 4fb4d7f45d1cf-6b443110fbemr6982638a12.40.1793087748266;
        Tue, 27 Oct 2026 00:55:48 -0700 (PDT)
Received: from Desktop (pd9513dae.dip0.t-ipconnect.de. [217.81.61.174])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b445971a9esm4669251a12.19.2026.10.27.00.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 00:55:47 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Semih Baskan <strst.gs@gmail.com>
Subject: [PATCH ath-next 2/3] wifi: ath11k: ignore regulatory info of phys outside the hw mode
Date: Tue, 27 Oct 2026 08:55:43 +0100
Message-ID: <20261027075544.19144-3-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261027075544.19144-1-julius@bairaktaris.de>
References: <20261027075544.19144-1-julius@bairaktaris.de>
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

From: Semih Baskan <strst.gs@gmail.com>

The firmware sends a regulatory event for every phy it reports, also
for phys the selected hw mode does not use. On the Zyxel NBG7815
(IPQ8074) the firmware advertises DBS with phy_id_map 0x3 and DBS_SBS
with phy_id_map 0x7, and its events always carry num_phy 3. With DBS
selected num_radios is 2, so the event for phy 2 takes the fallback
path in ath11k_reg_handle_chan_list() and hits its WARN_ON(1) each time
the firmware starts:

  WARNING: CPU: 0 PID: 0 at drivers/net/wireless/ath/ath11k/reg.c:828 ath11k_reg_handle_chan_list+0x230/0x2e0 [ath11k]
  ath11k c000000.wifi: failed to process regulatory info -22

There is no radio to apply the rules of an unused phy to, so drop the
event, as the single_pdev_only case already does. A phy ID at or above
the num_phy of the event still goes to the fallback.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Signed-off-by: Semih Baskan <strst.gs@gmail.com>
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/reg.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/reg.c b/drivers/net/wireless/ath/ath11k/reg.c
index 1030e119fd903..37be563d8de68 100644
--- a/drivers/net/wireless/ath/ath11k/reg.c
+++ b/drivers/net/wireless/ath/ath11k/reg.c
@@ -910,15 +910,27 @@ int ath11k_reg_handle_chan_list(struct ath11k_base *ab,
 	if (pdev_idx >= ab->num_radios) {
 		/* Process the event for phy0 only if single_pdev_only
 		 * is true. If pdev_idx is valid but not 0, discard the
-		 * event. Otherwise, it goes to fallback. In either case
+		 * event. The firmware also sends the rules of phys that
+		 * the selected hw mode does not use, discard those too.
+		 * Otherwise, it goes to fallback. In either case
 		 * ath11k_reg_reset_info() needs to be called to avoid
 		 * memory leak issue.
 		 */
+		u8 num_phy = reg_info->num_phy;
+
 		ath11k_reg_reset_info(reg_info);
 
 		if (ab->hw_params.single_pdev_only &&
 		    pdev_idx < ab->hw_params.num_rxdma_per_pdev)
 			return 0;
+
+		if (pdev_idx < num_phy) {
+			ath11k_dbg(ab, ATH11K_DBG_REG,
+				   "ignoring regulatory info of unused phy %d\n",
+				   pdev_idx);
+			return 0;
+		}
+
 		goto fallback;
 	}
 
-- 
2.53.0

