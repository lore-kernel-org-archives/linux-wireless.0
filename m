Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793623741;
	b=2kaZtai7rExWpmGvFul9fn9wiH8PrkB3u5L68OncC/FMH6JkyPKRcOT1vNuTD6KahHoP
	 uEJGHT1oPnxkQ3if73suQtFpQzyvgGgQbhv/jjfk6QJWrFHURwqSKi7QqLGe+j4jxPyle
	 7aGf1jxRi13OS8e57TNLXbiRqxqGqLp/v3F7nf2fqtiMX96JMC/xi8wxc33kWBPzrrY3k
	 9cbtQ5t7iazRuQmhmIYMLHD5GPVhyp56Q5xDzqrn/rgrU+QQUhxcMHMBhRZWjdQfhS5wh
	 ME4nqdnCxJXH1Y+AmlDqKplh53LfH9i7JeXGByplbiaZSmbut/rjavsAmEohNitUnAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793623741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6XnqB70rXSs+gjzhceVbINLoPc35zaUEJn/5DXHkxzA=;
	b=cjwD+2gHYEmicKIDdPilCCl56poMFr7qhO76hwgWh4NgwC7SK/FC60XHFpEZQ9FsSeCj
	 sXLvdN6uYLoGem2WRPrFAM324OODe5THVaN/ahSHf7cOP2nDpk7qQcuwL8GauHjQu6i+d
	 Y2srD5ZOS0VJ2zZDwx0IusEp3HTWlHQZ93p9HeOOiioD3B2bZDEDd+Kmw5TcPFNm12j12
	 O5XtmpnGdvDSZmxzibeB9Mjwa880NblnYCt7yxGvd2pcFJT+aQLgKDjBa9nKMcoMKe+Mw
	 pmV0FpCP68ztxsvWl7vz1jDfvdEEqdg90dOczZZfkAiB53eXaW9UQzpCDrWoLrz3eIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yPFET6h3;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA5B60A2621
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:49:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2CA5B60A2621
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yPFET6h3
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48df0fa43c5so1613531f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793623740; x=1794228540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6XnqB70rXSs+gjzhceVbINLoPc35zaUEJn/5DXHkxzA=;
        b=yPFET6h3ymIhzYfTSsZwQqIEDHtlUaPrM3o+jCOhKPl48hSOiJ/XlIS+P1rehHbLFW
         WI5x+rlX0Hy8b8kPIdv3MjwSWESjt5qkMuB5wv3uz/bL9T5K7it4lcUH06aN26njy55u
         YAvuS/ATk34QZBaUn24XtvGM7cfqakpfSBorVwZpuoNAwFQijIKJtMjB/1uHz0MfToir
         qits2/pTRwzSOVq0sw6Z6LFZXqL1PNqb3RQCN3H8v1f8hA1mrwzW9dqOAEn6f21h4QBe
         VNiUuC26oEx2fgJ2kTpg1UmyY0ETkda3+TMfO22n6EfzWos6bTry9AtLWKiSPgc/0h1C
         XZlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793623740; x=1794228540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6XnqB70rXSs+gjzhceVbINLoPc35zaUEJn/5DXHkxzA=;
        b=QQbFgrfmABrfUjKB+swtYUvasQCQe9TBPJYXUteMaJQv3E7Wf7OzSsNdwsbEAjS2R7
         dI/JRbWio8lxjxxh07IJDkbvcbsax0P4a3ooJsC3YWSa4fXI921HMAEfgt1V2ZUr2mQP
         M0cw+M/jnXQ3Vo6+tS5FbjPlGu4dEe07ANunqFPRwtOqMAIjR3Wlm7oOvTjRvDnlOzh2
         gE4vgKWDpiCTbWjRSKErJYxgjtnKv9j/OqHksJtK7Qbp3PPwqpgKUAcwhT1NfdgdAyq0
         M8bG0AFddaN4aIsGyIKIxOWjdLJAy/DXv68pv5Bm0YSltOz1WjmmBt2G2H/bR3j2k2Ly
         y+QQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZx3KsTJtyQybnUxCAgAhWL1qWP2gsktm6pVKM2HwBSP+eGBTQvrXivnWTX5XP/WM8cH/XKTRevasFe15Jfw==@vger.kernel.org
X-Gm-Message-State: APuU4Z9KXZ1Gi8AuhbamhXVGvfebuVyx228V35xntwYMivix19XU5U1c
	QWOg/m2kdMvxu9vcOJIsSDpixXAKVmnDrNfCm0RKLR3OOwR2ALTG1Pg=
X-Gm-Gg: AYBFou25vwEZG6LFnHp//AVKUiNni32wdV1iF7D252dn6ynVNMP6P5deGfADTULUb+9
	loicHnwTneFxZBNXAx8W4ypK6IDQdpWGTrN/WKVQuwioYiybBcMIstZzIF5GIEQyDYMEE4DEjt3
	W3JTMvmuM5k7NTYvpeEaCHpIg2ACO2VrmbMXsRAssop4N9cY0V+v4KhygiZuhQJUS4LRdoEmZTm
	4Olm7w7MBVsNfrMcmw3rSLnhicsyKpr8AY6/oCTXtnaQ6nGPnlmWKdzYWyw24/e57H+mNZs9OrD
	8+5DI7FgkWrY6NVLfBpGAhnnmmLExhc+2QjjuDGwHPMwwF+eTV8mjVA7WfX85mBr9yuHMiWjtE2
	u5pq9G99KLn5my14mFHC+6QThCZkCEZBAfH6SnfSesZCwVXfT6YYI0+YSExi2IU55MSUuEr3meQ
	fZ+ejZQK99rTMMhbfoQi/CPWSkw457MF9QzHO1CY6EcipbBJnnE1F8//9hlm5KO8fWVrJFFznpO
	pfycjW9lurIOnYWGkPBU4q/fxY2dKV/xpaT7Vkj4gLkE1T0AhQnZ23/scGmAJkMit92e/Hbiw==
X-Received: by 2002:a5d:5d0c:0:b0:48e:7833:2e56 with SMTP id ffacd0b85a97d-48e7833321dmr15104937f8f.23.1793623739325;
        Mon, 02 Nov 2026 04:48:59 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723bfsm18719736f8f.15.2026.11.02.04.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:48:58 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless 3/3] wifi: nxpwifi: validate command response size against buffer length
Date: Mon,  2 Nov 2026 12:48:54 +0000
Message-ID: <20261102124854.325979-4-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102124854.325979-1-tristmd@gmail.com>
References: <20261102124854.325979-1-tristmd@gmail.com>
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

From: Tristan Madani <tristan@talencesecurity.com>

nxpwifi_process_cmdresp() reads the firmware-provided resp->size field
and passes it to individual command handlers that use it to determine
how much data to process, but never validates it against the actual
response buffer length. A firmware response with an inflated size
field causes subsequent handlers to read past the buffer.

Add a check early in command response processing that validates the
declared response size fits within the response skb.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/nxp/nxpwifi/cmdevt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/cmdevt.c b/drivers/net/wireless/nxp/nxpwifi/cmdevt.c
index fc1950a125b65..50aabf1a72b2e 100644
--- a/drivers/net/wireless/nxp/nxpwifi/cmdevt.c
+++ b/drivers/net/wireless/nxp/nxpwifi/cmdevt.c
@@ -722,6 +722,20 @@ int nxpwifi_process_cmdresp(struct nxpwifi_adapter *adapter)
 	orig_cmdresp_no = le16_to_cpu(resp->command);
 	cmdresp_no = (orig_cmdresp_no & HOST_CMD_ID_MASK);
 
+	if (le16_to_cpu(resp->size) > adapter->curr_cmd->resp_skb->len) {
+		nxpwifi_dbg(adapter, ERROR,
+			    "CMD_RESP: resp size %u exceeds buffer %u\n",
+			    le16_to_cpu(resp->size),
+			    adapter->curr_cmd->resp_skb->len);
+		if (adapter->curr_cmd->wait_q_enabled)
+			adapter->cmd_wait_q.status = -EINVAL;
+		nxpwifi_recycle_cmd_node(adapter, adapter->curr_cmd);
+		spin_lock_bh(&adapter->nxpwifi_cmd_lock);
+		adapter->curr_cmd = NULL;
+		spin_unlock_bh(&adapter->nxpwifi_cmd_lock);
+		return -EINVAL;
+	}
+
 	if (adapter->curr_cmd->cmd_no != cmdresp_no) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "cmdresp error: cmd=0x%x cmd_resp=0x%x\n",
-- 
2.47.3

