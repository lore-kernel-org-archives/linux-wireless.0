Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793566692;
	b=KwDnFlpgp5sitduGVL1nL7WwgUZRgs0wy0kmSVUS0lLBr72ccyV/m0gcyFnnbstlxWZi
	 2UA4lXGxco+HKy0PRJCUhXeUHmZuZCUKpFLAfuqMZDFRDnme/Wdbb3CnbDy9/5+9WQQxQ
	 VFpSZPbSJrFvNw9IoQGOk8HkFwXFBvUIykSzBFnv2HFwRn+N/0CENZ4CGIC5BC/qsHthF
	 WkowImo3PA45cxubckfeXMuN+ENs4bReiKi5nxBXbSR+r+gHvngqF6r0J0JfPqYEVF64B
	 hkh9gOjYnHtfCC70JfdcFQd+f1p8nC6XK22D5asnJSjyUCYfZ7aLJc5xU0Si2X4p1mg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793566692;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ifNTGxpmeTaSsVFFoJbLLPWJbHDhOwV+LFaaqfbijrY=;
	b=R6iZTfYWWsSQeWqysXy//wQTuxIhLR11RZ4Dn1j1TtpCXGsHfg9tReaNmqw/zNtMzc5G
	 W3WSW6CX1Lp2jkqWIhmfZgtt09+M6uPf25XbtrGerAVbvY0ka2teXZVTWLYflzlddp2rY
	 EoIAOId8O1NFrAiOKLMGI0aNLEh7siSr/Au+pEWkPdoP1ekAdOit1+ryCYd4dFF4eALhK
	 ZMBbYjYhRc3Nr5TzPGxz+RPrEwDoaVMBUHSv9H4G5BV/IllFXBno6FXuyjtb7R7JR/yN/
	 Z2tYerCUGo/UL0UPD8f6XJC8fOqMeXF3/SbSRVJrNQ+s7uYmSn5tLV6I4+aBIJkcATA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HdLiPHuW;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAFE606A326
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:58:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1EAFE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HdLiPHuW
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48c4be28b82so2487220f8f.2
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793566690; x=1794171490; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ifNTGxpmeTaSsVFFoJbLLPWJbHDhOwV+LFaaqfbijrY=;
        b=HdLiPHuWi1Ov8HMltkd/itvsfflnPS/YznXzonVN4VNEqFOIvdu6Y4x1H79LUpYUYr
         KSel+vfaGsgLg8qKEvuULN2OekcFcQSqBPm8hBQs7xLBSKV5Y+FovTwvW6olIvat0VzK
         8S1jJWh76uR+fGSIDqLyyJnY6QmqGi9mQ0BBNgy5rTsxGfKBwyDG+IgYJGjNiYw4oi2j
         0TKux42/u8ItLzcLMC/mz4P6iMwrzTnqqrHQ0sa78712rQv94DRWcK9vEp6OFWpWXbJa
         a4VXYDD1cRBNtVPN3mBTzkHaJ3AQRNO72uBWqvUjrIbKicBivcu0uIx2yKArFb2gR904
         OrSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793566690; x=1794171490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ifNTGxpmeTaSsVFFoJbLLPWJbHDhOwV+LFaaqfbijrY=;
        b=E30+Dl2u1K/yMp9bDK+ET5zK5lDXVBPw+DOYZSdelMsH3CzOMhoqalQd40y8aDtJTo
         Y2FSzIfZmZyhUkTvJcrVHnUkGsueIZUePS1e2AbxVd+fqFvYuamlSkm+cR8+NTPYeABk
         ikUtuwyLE30NEbp5NSgx/Nur26XP0VdZrOED7aNU6Lbc3BNDamVmJVfW0Qbrzcjaz6w7
         3zEOQ/ysHnQ+fNu+5Jlm6H2MbyoRV7mBlJ42gPBPbty2DO61+/2rq+Lu98Ev1xcUlWlY
         YVZ70qM020yLOs3n2hs8bacFoEYXQF4BygQHpxquXq1/tGokaXBidaKtgOXaUaAsXAO+
         9vyw==
X-Gm-Message-State: APuU4Z/KI0NEjB9CUvDKK4uOYazjslttOc2svRvRNdAygxNyN7ALK8kr
	ZJAC/mMbBeBlYgtoFk96LctE/99eHSoA8883jqHYB5VClPBhEIdQDcI=
X-Gm-Gg: AYBFou2+q7TYIH1U1rcXAq9gjvCoo8qxyFtVZoH50MG13cBIjWGknDVJL2aHx//Xwfb
	RzUEqZ8qU9eIVa1P5XeeyxNd36shrXR2aP6ATn3NkeRS9lZmBM8NBD5UQm+UFkkNlegNulteHmo
	O0AdVHixQhMDzO/35gYppvjWrkomYR2N1nWhdko/mjOKQWaKxUCMQ1dNq9/lOKZ0h+rUuhBZTtB
	Ud9MY7nTt9WHCJgc6o6CWMYLgG5SKzxi/pm+finLlgqWWBCWpywdpgEPUIjKXRC5D6BsDIi6foN
	uzGFL/D6hXQ8Fl2d2rHcDYseCCcV7gxmaLWZQH+d3RFvCHDmSk1mducfXaLHdocaWCeh1DVqQ0B
	02pEO91rMDOtT2Z/ahd4qp39iwojfBY8T55FaFwqxhV9Feb0jkOTGKQd8yLzuVzXI5vUSZwVz93
	iV0+i5Pb6TJ5O1LkGeVVECsdjIetsQVMP17+FPg+R1QhEKglTe2Dz/uUfYTUdyTv5zeWO8ymHY2
	LfeN/OPOfTZdQcFbUi0Hh40o9s0DpDHXdEONTgNZO1dRofHdymXKbkz8fnEMBTWSswcuMWP7A==
X-Received: by 2002:a05:6000:2488:b0:487:27f9:840 with SMTP id ffacd0b85a97d-48e6e50d953mr18832639f8f.53.1793566690433;
        Sun, 01 Nov 2026 12:58:10 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9eaeesm16002280f8f.49.2026.11.01.12.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:58:08 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 1/3] wifi: mwifiex: validate TID in ADDBA response handler
Date: Sun,  1 Nov 2026 20:58:00 +0000
Message-ID: <20261101205802.2909524-2-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101205802.2909524-1-tristmd@gmail.com>
References: <20261101205802.2909524-1-tristmd@gmail.com>
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

The TID value extracted from the Block Ack parameter set is a 4-bit
field (0-15), but aggr_prio_tbl[] has only MAX_NUM_TID (8) entries.
A value >= 8 causes an out-of-bounds array access.

Add a bounds check after extracting the TID.

Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/11n.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index cef8a55427dd01..7d249508e1a38d 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -154,6 +154,12 @@ int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 	tid = (block_ack_param_set & IEEE80211_ADDBA_PARAM_TID_MASK)
 	       >> BLOCKACKPARAM_TID_POS;
 
+	if (tid >= MAX_NUM_TID) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "ADDBA RSP: invalid tid %d\n", tid);
+		return -EINVAL;
+	}
+
 	tid_down = mwifiex_wmm_downgrade_tid(priv, tid);
 	ra_list = mwifiex_wmm_get_ralist_node(priv, tid_down, add_ba_rsp->
 		peer_mac_addr);
-- 
2.47.3

