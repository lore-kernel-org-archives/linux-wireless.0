Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793623740;
	b=f4tWuZar2bzt8hpnzUKCIUXHEUNBSgKfm53j+IJvgvUyj7gGwsScqGqrd/8dpNIDa36q
	 pM/3INk0OaTWbIJHeN+Zgcl50d9+FbURejzQsIRktz6TzV9HivwQmE90jOxMxjefqWLTi
	 xvirbUPtpen2HL6i8uJ+l+D8IDPPFDl3kqRRPVBVA0W6EG8WxJnmVMh7HWkn7aOMTR3X0
	 QAl82ebIazYd3s880eg1Vegil/JqaXofmyXTSso4SlYno8GRWzQPbhKi13WzqRIdSpt0k
	 zCDba194OuhUumRBgYaaD0tpPE31MjHUxTeWGtyE2qQ9givnMjK7SmkyHbY3NKF1uNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793623740;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7fMnYg29griSNHAmS2PXZq5vvQiH2csEt2FfsLS60Pk=;
	b=scLv8e3wSkBUxpWPJJAy2mcCXv7oz1/G3NGqsdBWwXQry4uCK57uYkHGJQlwOglkrRBQ
	 xo7cBgwuMREXkp7Rjcv8DXYOz4HWQRrKO5Ii4sasppZdIXEQ/AAiQugsFj3hIBQM5aSZ1
	 EjQEIiXXNRcyCe9t6WOsvfx1jkiecyoyOlRxshB+5cE5sH5bucizaW5UFlanQLfzgrQKF
	 8d196lkGW5WFonbWt84uEOHHP4IUkwPQDUO4ZiVWbPfAcpW/UPA+cu1ZHM7kkZ1Ktj8RP
	 l6woF55XJzDP9v6R00jfN74woVLCGKM3HKtDtfbRAK/E0r0qleM0GZTmjPqsBAY9i1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yJtfxzwz;
	arc=none smtp.remote-ip=209.85.221.48
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1245660A2620
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:48:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1245660A2620
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yJtfxzwz
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e46e449e8so1823653f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:48:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793623738; x=1794228538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7fMnYg29griSNHAmS2PXZq5vvQiH2csEt2FfsLS60Pk=;
        b=yJtfxzwzNIUacvigCQ0K79QD6En3ow4xtxinMtp3MyZ2olcaP6L/MDgkeUKqE80u7g
         idjkMxw6Q4RVuSuElOSjosUrBWMJrLihAp3AVT4m8E0ABHAs0dOdq4eNaaZk05RYNWk9
         enTiFAGcvD01XWhtWN8k07wUZZBDi1wwcw38xQfIuM3oZjoHua0xHlvD12ra3J4bCJeb
         S3+yCfIWAZPAMuvAVYuIBKpIwozkQgOIsNcKeQXKcJ2yP8wL8wa0aRupJv7m6tzPURub
         7TxopA1eJqCySzbWIDUpydf+idTeX4gp31xuJl7NclDuAybGdBIOSMasQvxLBPs8pqyM
         p54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793623738; x=1794228538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7fMnYg29griSNHAmS2PXZq5vvQiH2csEt2FfsLS60Pk=;
        b=wgTgFijTbHJOOmzLin3kawKWdIrrjgwBarqRkyD36usoTs13eCm1YDPgbppOZSkjAl
         j9eMEor6tgNFOvvoCuuQ62IwVYIaLaKvGJlbh+W+b7WhJucl/jtRM8ShEPtHt8XsoRRO
         83Jega4qfSD1pPvGk6WlYlleupxtP0/2dprBLbUQjpoevzVjH+pEnyatN9ndmLa1V4to
         msucdmaIcGQNVZbC5Ex0xdzcMLZX9dnhoI8j2bH4fYwD6Q8T3M367VNtJ61ZPkIsq6mW
         iN7cNmpyGXGv922a7Xk++iuhLG/QQYQ1OX3TUnhPD2rGhWCEbNWIVTCc5bXvXGcYaF7W
         ahAw==
X-Forwarded-Encrypted: i=1; AKwUvBwxYM0ZMqVApJ/m+qmAfUCv+wlxqPXRPN3RcqI8K1M7dFuyBYtfTW7eFwAXrrxrjAbZ5KE01c+4H2RvztXcuA==@vger.kernel.org
X-Gm-Message-State: APuU4Z+WzNd7yqRCBIok9q++ewNQz+9kFmQIsgGg8lOuJLSEwToI20CY
	PUiQU86JrrTDEwOzzdtoTey+Gnsmp/6TWg2h4FzpDVQaq7b+cJ3JTog=
X-Gm-Gg: AYBFou1MpITDLeEDRUbO525sFU9taO2uB2XQDoZ4rnO7PsZbF9tYglXIMDAY8HWZUag
	wUWS6EcP+JPNK1p+THK1BVin/HTRPV+h/TQvNK09LvbQl/chJDXxMveIFdWCfDNj1XSqq945A/u
	BS7P0epI1AVMXqBg0N1Oqlc6fCwQlb7xZNxyF6Pe+3/YNBNx5Tqwg6dbhDJDqzCmAyEje3aEM3r
	xPfpwxTnY6inPVOPoBgaAeeIUkYDtMIrOslJzSVpS1ozvaZTZk1L6VO45suUMgNUR1o8jMpuAZ4
	o3qUGSkKWCmyASiHr/72dSA9ULnGuFRyiEHIRh6XE0LNxSOLio/YQ/p67ueteolPfjpBd2CLwiG
	yT3K5gjhosLMN61JY7jfCWZxQsSFpFAVOBf6eCuYoMaw2BsuxRkAfGyA/wcLLugTRfBV+XpVWvB
	XFS6BiosrmsEj3WE/+N+DXjakgfG0tf2tPMztYDPBU/vNAyNpG/ZHcwaDoYdIjEpujhzrndqUpN
	xmZjJW2O1I1dcEWaOsoUlo1TQ4j7Bl1Vm2N/aQZvqwllStutNfE85kshbIdET6kIx4QWeqMtg==
X-Received: by 2002:a5d:588e:0:b0:48e:bf0:35c with SMTP id ffacd0b85a97d-48e6e4f543cmr20614479f8f.13.1793623738447;
        Mon, 02 Nov 2026 04:48:58 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723bfsm18719736f8f.15.2026.11.02.04.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:48:57 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>,
	stable@vger.kernel.org
Subject: [PATCH wireless 2/3] wifi: nxpwifi: validate ext_scan buf_size against event buffer length
Date: Mon,  2 Nov 2026 12:48:53 +0000
Message-ID: <20261102124854.325979-3-tristmd@gmail.com>
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

nxpwifi_handle_event_ext_scan_report() uses the firmware-provided
buf_size to determine how much scan response data to parse, but never
checks it against the actual event buffer length. A firmware response
with an inflated buf_size causes reads past the event buffer.

Add a check that the declared buf_size plus the event header does not
exceed the event skb length before parsing scan results.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/nxp/nxpwifi/scan.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/nxp/nxpwifi/scan.c b/drivers/net/wireless/nxp/nxpwifi/scan.c
index f3becafb9c23c..e7d98463ad18b 100644
--- a/drivers/net/wireless/nxp/nxpwifi/scan.c
+++ b/drivers/net/wireless/nxp/nxpwifi/scan.c
@@ -2427,6 +2427,15 @@ int nxpwifi_handle_event_ext_scan_report(struct nxpwifi_private *priv,
 	u8 *scan_resp = buf + sizeof(struct nxpwifi_event_scan_result);
 	u16 scan_resp_size = le16_to_cpu(event_scan->buf_size);
 
+	if (sizeof(struct nxpwifi_event_scan_result) + scan_resp_size >
+	    adapter->event_skb->len) {
+		nxpwifi_dbg(adapter, ERROR,
+			    "EXT_SCAN: buf_size %u exceeds event length %u\n",
+			    scan_resp_size, adapter->event_skb->len);
+		ret = -EINVAL;
+		goto check_next_scan;
+	}
+
 	if (num_of_set > NXPWIFI_MAX_AP) {
 		nxpwifi_dbg(adapter, ERROR,
 			    "EXT_SCAN: Invalid number of AP returned (%d)!!\n",
-- 
2.47.3

