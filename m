Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1CA368D51
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 03:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792119785; cv=none; b=cfHi7DuhaZwavjp0KWxT+Ep27L9Ls5U0ZN/M3cg7iouzy70aJ+x4aqRLHEMwXhd8ECqelqNtme0UCffOx47Y6PSuzd2R1nPpmh1qMSfvNLFtMlwiNtJwCKiaGJiDNZtCdXLdLPu3oGZLp26b04E/9+vGRWr8tMbQ3mDsvxH47BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792119785; c=relaxed/simple;
	bh=P8KK0+CbgquxjY69QaU3QkJm+cx7/ETHIw17Ilx+Jz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8pBoGTv4d6J+FwILHB8tFq8KC3BzU+J8Wa0uC7QxMHsOXsYof91LNxwTcya4BVm4pwvJbxiXS4hqaVOIEatSQI+bd8iLCcn4zH/bH0hJIzx8nBQCybVaMuFr/x4y5xsvYcImsA3HF9uWV+CTqlKg8+3HWelJPQWmAfzhuQWDIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=wX4G9nSU; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="wX4G9nSU"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-88834d30002so3082621b3a.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 20:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792119782; x=1792724582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AxBCVm4Z5PhosKtgTJ2T5/Coyb1UstSb78XMv83Uqfg=;
        b=wX4G9nSUgl58xXMeofoUvgCcmE+XnV2qFeJdciEF1QcqNIHtD9Y6Nq21xXY7JAyE6w
         lleVBDLfc+AyDyGWXS+imPkNnNvSzs9iQdMddrVsL2rdDBFGLCW9cx2r8LY1DeFCvJnS
         i+TnkDWkZL2q1axX+cikQIKRUKOHqESxRc1v0imz6JIsRCgO288LM2Zwqg8WNorRdNqv
         NsobbC+AjQbVG/ii6zWcW2dhzWf+Fr+BT87xL5ECkLrbiHQ6B2rw5sNC0hnIDzYD5ABQ
         YU/Ds+/cGCYerRzF9x0BYZdtJYqotSclx0cBRWr+Qb5uImoKYiYmWVXfvi82F0tpIKPw
         1FMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792119782; x=1792724582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AxBCVm4Z5PhosKtgTJ2T5/Coyb1UstSb78XMv83Uqfg=;
        b=XetEeidArhwxKeo75FAFRvHT/N67FPeAwnx2xIYm2YNgZnBk+o1dlnlZDOES8ngcA9
         sM7wNgzM//iQGKbwXjBJHl8LVsJvA8DeNUt1TlzPe9rKbWTuWwpKUk+44SLw8DiMnjI0
         lQ2RJYONovfF39TugzjtpxaRf2yuphYaPctxTSs++PX/aEqrVLnBpN9OSUPhwG9KxgrU
         gfmXZ8s3GavK7j6ApsQTg6hKRS+8PmxZV3YT1ut3Xth2UHwusCzck4iEOrtTd/9x9n6b
         a/gDPuoxPG9c5HS0u529ZOBn2rW68QILABPAewUsHhrloOmjGIyU0nG52bc3H0Kwe/wp
         7ccg==
X-Gm-Message-State: AFq9FYKpQ7kJSMjTnVT5rypCCn6HN20nuZiXJenObHqG14HE6Tnjl2PO
	sGX9KuassgicQsgRePRv91MQ+7SDXaLgTwbGEpKSoujEJJ/TMAWXHtKBFxjTaTkLUuI=
X-Gm-Gg: AYBFou04hc70TwfP8TlYsZfq0wvS8sT7e5rHlJNRqgYDcPN3a7ANHc/VEBazsiwenSA
	N5vr+/zZalBeKalogGzkp0knuWZF7NXZgnC1QDwVBdkFREtMCToJjpM9HTjlOoS4EKjBBRdGN5x
	1ZudVYlZzjBmXvNosUMN3Q8FNye+lZEb1YUoIaCV+tN+1NU5ldj3+F0DW3kJtYshW4TwZZ35T+E
	3bHN6ZW/PaJELYCGZC0zHtUPTEqt581HS2/Id7mXggQ8ifOIL0vrb5P6lUlsEdEtaRks/ZGxXwG
	qAxBrMaYr/vyijye5R35KchV0/RuWNC+++m20MhCb71PLOW7nIJgo/iA9eLs/8727WXGGDQFAgG
	zQmk42NzMo2luyCccTIJBPQH4gHN8XjhV31k0nJ+k/P79gXlVR9TaWG3AlOFKDY3jXKekGB4gJv
	9tXPxfYDEwME49q5iqQK37Z/gxKDNk7JLD/lD+ze1cYeuBrKIN90CEyciUroaVWOS45mM11nA8g
	2WUfA==
X-Received: by 2002:a05:6a00:c1c1:20b0:89e:71df:d6d5 with SMTP id d2e1a72fcca58-89e71dfd837mr2359208b3a.10.1792119781991;
        Thu, 15 Oct 2026 20:03:01 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c8c490sm422493b3a.10.2026.10.15.20.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 20:03:01 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 1/2] wifi: nxpwifi: reject a NULL command buffer in the 11AX_CFG response handler
Date: Fri, 16 Oct 2026 12:02:49 +0900
Message-ID: <20261016030251.690780-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016030251.690780-1-yhlee@isslab.korea.ac.kr>
References: <20261016030251.690780-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_ret_11ax_cfg() writes the parsed HE capability through the
data_buf the command was issued with, and never checks that it is still
there.

It may not be. When a synchronous command is interrupted,
nxpwifi_wait_queue_complete() detaches the buffer because the caller is
about to go out of scope:

	/*
	 * The response path writes through cmd_node->data_buf. The
	 * caller can release a stack-allocated data_buf after an
	 * interrupted wait while a late response is still pending.
	 * Detach it from the current command before returning.
	 */
	spin_lock_bh(&adapter->nxpwifi_cmd_lock);
	if (adapter->curr_cmd == cmd_queued)
		adapter->curr_cmd->data_buf = NULL;

A response that arrives after that still reaches
nxpwifi_process_cmdresp(), which reads the field and hands it to the
handler as it finds it:

	void *data_buf = adapter->curr_cmd->data_buf;

	ret = adapter->curr_cmd->cmd_resp(priv, resp, cmdresp_no, data_buf);

The handler then takes the address of a member of that pointer and stores
through it, so a response carrying an HE capability TLV writes a few
bytes at a low fixed address and the kernel oopses.
nxpwifi_set_11ax_status() issues this command synchronously from the AP
start path, which is where an interrupted wait comes from.

Check the buffer first, the way the other response handlers in this
driver already do -- nxpwifi_ret_sta_802_11_snmp_mib() stores only "if
(data_buf)" and nxpwifi_ret_sta_reg_access() returns early on
"!data_buf".

This is a local denial of service: it needs a command whose wait is
interrupted and a response that arrives late, both on the local host.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index 96540914f3cf6..1665bd514596e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -205,9 +205,13 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 	struct host_cmd_11ax_cfg *he_cfg = &resp->params.ax_cfg;
 	struct nxpwifi_ie_types_header *header;
 	u16 left_len, tlv_type, tlv_len;
+	struct nxpwifi_11ax_he_cap_cfg *he_cap;
 	u8 ext_id;
-	struct nxpwifi_11ax_he_cap_cfg *he_cap = &ax_cfg->he_cap_cfg;
 
+	if (!ax_cfg)
+		return -EINVAL;
+
+	he_cap = &ax_cfg->he_cap_cfg;
 	left_len = le16_to_cpu(resp->size) - sizeof(*he_cfg) - S_DS_GEN;
 	header = (struct nxpwifi_ie_types_header *)he_cfg->tlv;
 
-- 
2.43.0

