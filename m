Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793627976;
	b=aK+0sKfKZ1f7B165M62HkzY5+8oDPeW9fh6WEtYtqBLZ6DGM0PXNRqzOKiyQ4daZsVaN
	 ZoSyG47msMPJ6FggcOrQrDziKGHiU5gQf+xiNt/RhmI1dDdnR469fYexPKIbBGeiRqRqe
	 aWgZvOWU5zlOrQabauLr0Dwp2zdMxJ3mLWGWqnVzKn8BAXSymbw9s8LL/Q9gJii8VlOH+
	 S9gB7LkX0Rb0gK5LKlUjo4+Do25A/5YiYAhkNjjBwg0POWko8LHO6IMXQyjGlBBHLOIhB
	 JRmrljepnMP12D17pa+Vk2Fq3/6Tz0xU+h33/Bt1iizzvlbWd6/ra4/FwJ19HuElxWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793627976;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JDW3C0JG9F+VgV3yAEYWd1Rq691qrVYJKPbnw+u7tgM=;
	b=OPrPijG6O4CTIv2HU4/o8ogg7GxYkpe+cL8v5TgL8afxhBepl8ldn0It2oUA2Lu7g1FX
	 qxfxeWW8xAZ9y9zb/hJpgh8OLzfA26Gl0YEARjjOkMgTnDMpNNYkgLilGYDA7GP/k5U8S
	 t6W1gc3OY4L/7TRehfxi2mEJMw9/lWOWec+/M7wo4fOMNAwyBMnm4e1OQDHjx+aOXPoXC
	 YiVcNxuFh5s1dMm7Ei7/WnrDhYKS+Wiu/nfAuvqzrDlkUqZs3jjMQbWH+9PzvJqyVeeFA
	 +aTyRDjk1bRXZJ9LhdeHRWpQ950rVR6UFaKlktrYtzcMhgsdptffuLVmyTZOPVO2l0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kXFr0qft;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0CB60A3814
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 13:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA0CB60A3814
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kXFr0qft
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2167bd087so25533955e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 05:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793627974; x=1794232774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JDW3C0JG9F+VgV3yAEYWd1Rq691qrVYJKPbnw+u7tgM=;
        b=kXFr0qftq8TpaDfhB3HDXokLdzchLcJzDmVA0zhPPblEpo3JTgmFsJpojcN/BHrZ9G
         3WSwIF35i6AoJfSUkrD4ytMa754Sf8B8AwAXG+pw/q71WkBYxqL+SyCAu2gpTx38JadK
         +Gla5T9a5vJdXM7PYhInRx6R1gZK9IwsKw9XVzamXU+XL67sKpja0v4JCaf1VYVMbsJN
         YOiUvDokYHkWF1Lsm21gaeoFrw4wSeBcF5hvw2DJot6QwqBFf7xUaDuLrGCE4J/4Y4S2
         +Qm6qYH545glnEsHbBm/1v7TsObieZnz+0OfrMW7O56D5pFbNSxQzi2/n5DoFIDix8Op
         rC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793627974; x=1794232774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JDW3C0JG9F+VgV3yAEYWd1Rq691qrVYJKPbnw+u7tgM=;
        b=f0Mbn8AV8p4kIPefw53hLH+veHE6Ao1sw2LQ4BV7hZCudPET/9RPAApq3mfAWsJsrc
         bk8ykYSTjcT45xk6Hw4dbQhm6HHttqUnnL+7K1ACL6bd8QdiLOaQunp3AKUlK8TA9Enr
         ohk9yjDpwgqu5ii7btzg52QQmWDnus2i35aLQcZfblDEAnRNmQwZ8dzT4WgEILf06GJm
         MwwcO5myg/ana1ASBwSnl7Q0Lo7K8bTWBELqHtx8ZByHF5nXcApSFXq8RhIa0YZDI9Pa
         vBZgT1D8XKBsh8tE/t7WVDD5W/JkGKSOmIGOJpEws/BGPJEUEIn6TK9HBAimGohPkhH0
         6BfA==
X-Forwarded-Encrypted: i=1; AKwUvBzTT/go7aAis0dfpsXEEMwaGMwMKIl+lE7q1mEKuCMFkhhl3jONaw8lUjx9w9kA6ZDnsZjqJVSUIqb5TyZKEA==@vger.kernel.org
X-Gm-Message-State: AFq9FYLIyQ5T6MuCFmzHB58xzzydPyZWKnWQN0ebANmCySTTNrjEzVBs
	kDvc94zrZjSbMdamXrx6JxgO063JkRHD0Ko0f0hOiDXabm3F7yRQGDM=
X-Gm-Gg: AYBFou1gQgMxIsP9ElsIVqWTGSzdHT73sPcGgmhAYx9EtlZXsVErsiUIadbSmdOzb2E
	ZsZ06fbipq+EuRtyiEHdpTFKyrgFnbvI7sZmCT66v7WF0Omv+yKTFiwfH0HfDURfD99mZ4b5eJq
	vrtwiGVpkmg6CaHw23sGcvEc1Y3+9u+DADmYc+KWo6ddeoAtSguo3yVM3j8YFIg/qLBccvHD050
	XCRV6/f74PjdImGgJ6oaZXCLhb6I/mS1YqYWk7mw1giRyfB5bxH/ssx3Ugh6OWfQmyBzWX32lJS
	hOywoPER4cTvyrM90aTf3KchV3D94iYMMBScB8Wfj7i3VvhmK2Sf9BxoZAiEnGz+jMDTV8on4FG
	YIKGqIT5lF19Nbc+AnLMok0pU43guAvxH9vvFOdvfK3oQCHtyPQY+E8Ynyyf/EfPCQG9L8ezMJo
	jPNZvc1g2b06+RCyWiLaFxZIbgk+Aa3AzS9wZq2lojmivj3SadyhD2mQi9mELZZ5Q6AIq3XKCYn
	phuZi6Qy1HpLCnkdc3YMTsGNeDWEndN/7oK29A0UtCEqgWRJiyTWs1PV3VJUacxBKmPZ0TkHcWW
	MCez98k6HEo=
X-Received: by 2002:a05:600c:3d05:b0:4a1:faa1:3813 with SMTP id 5b1f17b1804b1-4ac187a6960mr231274955e9.27.1793627974216;
        Mon, 02 Nov 2026 05:59:34 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4abf6e63e0esm352680265e9.12.2026.11.02.05.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 05:59:33 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: briannorris@chromium.org,
	francesco@dolcini.it
Cc: bzhao@marvell.com,
	akarwar@marvell.com,
	linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 2/2] wifi: mwifiex: validate command response size against buffer length
Date: Mon,  2 Nov 2026 13:59:30 +0000
Message-ID: <20261102135930.701845-3-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102135930.701845-1-tristan@talencesecurity.com>
References: <20261102135930.701845-1-tristan@talencesecurity.com>
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

mwifiex_process_cmdresp() reads the firmware-provided resp->size field
and passes it to individual command handlers that use it to determine
how much data to process, but never validates it against the actual
response buffer length. A firmware response with an inflated size
field causes subsequent handlers to read past the buffer.

Add a check early in command response processing that validates the
declared response size fits within the response skb.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 6e04d7da62179..f59b53c2e7b5f 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -821,6 +821,20 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	orig_cmdresp_no = le16_to_cpu(resp->command);
 	cmdresp_no = (orig_cmdresp_no & HostCmd_CMD_ID_MASK);
 
+	if (le16_to_cpu(resp->size) > adapter->curr_cmd->resp_skb->len) {
+		mwifiex_dbg(adapter, ERROR,
+			    "CMD_RESP: resp size %u exceeds buffer %u\n",
+			    le16_to_cpu(resp->size),
+			    adapter->curr_cmd->resp_skb->len);
+		if (adapter->curr_cmd->wait_q_enabled)
+			adapter->cmd_wait_q.status = -1;
+		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
+		spin_lock_bh(&adapter->mwifiex_cmd_lock);
+		adapter->curr_cmd = NULL;
+		spin_unlock_bh(&adapter->mwifiex_cmd_lock);
+		return -1;
+	}
+
 	if (adapter->curr_cmd->cmd_no != cmdresp_no) {
 		mwifiex_dbg(adapter, ERROR,
 			    "cmdresp error: cmd=0x%x cmd_resp=0x%x\n",
-- 
2.47.3

