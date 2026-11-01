Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793569878;
	b=aS67XuVmzgmcdnYAvgXA+uNil0jAxaHEYlEygkw5ccLBjY18LHpawadxVDwA+4ZUvKfJ
	 nlYxaxeLa4Pg5eyG0s+nEhkdXzov/5Rwy+MjFVZG7ymLV8CA4zwy4cXW8wJF2wncijTVZ
	 5aqoVay8oXJ/6U5WMOK4kCYeo2kISSbL8xChCf9iZg8CkOjZIuME7rT8Ap0w2LHGgx1/t
	 9ywmQ6N2e76Z5/ZbaAnhJ+u/gPl6Tnp7VksHTaz+E4xjOWZ6OpFdjI6Mq0HP2Dtx+O4ys
	 96Qv+j6S/h9QwjoRAJz1LBPoOrCdQp+QQ3Cjcl1SdSJFBYmAEOkajzWnuucUGtzfAMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793569878;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+fFwfLqRK9JmViO+Rr59prjwvHp0VxvmW/Io5rw0BcM=;
	b=Rsq+VESAdIFyQg3s/9JmdAJSDl2MOG94TPwvSjALoWf+qWsbUSQUAskgHRjZgGgNP8yS
	 reEyGfOETBLydTHo6MZNscTatf0j7N8MEcRYuS9W8QzDoOU7cT629NuibSnlCq68qtIA9
	 0OXlMoN59t4Oz/omamWps7+sR+hVftUQashE63USKFk5NnK/ZoE36ItQTmgCEMOW59ze2
	 oZQhhc3sMHS15mld+oLjOm5SM4w9Inl03oXeBrDUboT1bovamd8am0+0q5h0BwzxF7xQw
	 l6YalomNLnULnNfcvRs+jP4TUnkkgWPGNfIuPCILacP4+L/qeI47k/HDNdVq+WsZofg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=arA3dOZ8;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CCB606A32C
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 21:51:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12CCB606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=arA3dOZ8
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48b060ec084so1307865f8f.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 13:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793569876; x=1794174676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+fFwfLqRK9JmViO+Rr59prjwvHp0VxvmW/Io5rw0BcM=;
        b=arA3dOZ8Qw5VaeKLI9WB4WkUoRVxRsRcmtnwspOBQgut4M22YR8KAmSIgd2cy+jpqy
         nwAVawvJFXB/kMP/qyNmfF2akNs2OZlAS3y6ohNQyqmWgSZPkC76adbAOOLFpGVJSaMb
         cMa865WRNln0vyvb9mu1VtPQd7m6AJWlpnpCV4GqxkcxQkY+WsJI3ufPtgRsJeDGbYPq
         Z2QgXVCdAg/LYfIrWvDjiBNvcxFuIMFYyU0yaOdhJs+uNGxvwyiB1hEUfLNkJIJwn5lw
         qe/mw3qptH76Z36WdpUH9XA377yLNbK/+piYbdM74y3HfU+IeAAvI0ndDsTy8j4VDQGp
         iXQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793569876; x=1794174676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+fFwfLqRK9JmViO+Rr59prjwvHp0VxvmW/Io5rw0BcM=;
        b=P0s9Y/bn6x2Et+27lC3arSXz/f+y30nfuL4EImVgYgHcilWsZExFW/JMMrkjBIqipL
         mgp9zEw9GbrQ6llC1xS4eQYRGUE6DTO70egqsC/uUUUCXCNBLGzF8RcRCJebgQiV0WSt
         RzM/IkdWIub/7Tk4NQNypr6GOM2idVoCGTb9buNZ/xjmrf1VHoxaRf/uGQOz1OnouLEW
         DBdxTnj5SVh4X7DALlU0qJt6zDgKsiQ+ni8qqEJPSRofLVoHQwSRo9ZqpBTkxiKYEEqR
         14Fwy0EE5Gfx6otNSotYIG4NV7B9eBdXVkVpI9CcwcFy2WlzXSu5ENggsFoFcFvlcIlr
         HzPA==
X-Gm-Message-State: AFq9FYJHoxWPlrV2IyNkrffBR6ldCpGzN6JwMSosTqtBB2dBSCdCFUMe
	6Fd2G0URj/FFx1s1kw14UIZpWzfFgEot4gfKwqpuqz799JcFKGJPyeE=
X-Gm-Gg: AYBFou3ijRPx+WMPi1vok9AEIKm8fddVgWSj+8U1h4w3TxL0In9XnLirCmf2Fvl+zlE
	M44P/+NRaPjzrbag/9SJePVKWCsW2n/kepfko9LBWYxk24KhPfqdOxCRjaJRw9emCwsIwrwnyff
	yd4Z58Kn1t21CmdPEY6PJnamVJ3sWrm3Jk+le8vfhngIBVNiPVEAE4n2XPN638G+j3YU0zcmPgn
	pDkYaage8bVmKxeduDvaf8vk6IZngbTqXtxM3nDHs/vw/fGBjOF1kCUUpX64JH/iPhE414hoaQa
	hIjpw10RJBgKl2L5r8mnHk9GpbqOMrCV+tdG+5sSpowXrg7j0UitT3rAv8nie8ObKDuNThMjJo5
	x82n7M0OZ1jvE+neWlEiitIUgwun1MEKThVMCsCDZhyp/cSGQDj6srcoRi/KFXJl0w8U/fLo4/T
	ZTkWtj0rbVuHequ6qvwl5v++3ozECoPsk8gac0NYRyf/OFx5Oy7VkmrM2osNT0WSu54WPiwc8OJ
	l5rD1nwQobLfqeq0/60GN2+xjdI+AbG0go6BR0hGvl8614CyQeeA0G1KxZcRfFfYuzcp7x8SAUg
	hneyX///KdksxPhvLbs=
X-Received: by 2002:a05:600c:6095:b0:49e:7c8c:361d with SMTP id 5b1f17b1804b1-4ac182dc30fmr173291325e9.22.1793569876416;
        Sun, 01 Nov 2026 13:51:16 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ac09ad5ff8sm157249425e9.4.2026.11.01.13.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 13:51:15 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 2/2] wifi: mwifiex: validate sta_count in AP sta_list response
Date: Sun,  1 Nov 2026 21:51:12 +0000
Message-ID: <20261101215112.3199197-3-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101215112.3199197-1-tristmd@gmail.com>
References: <20261101215112.3199197-1-tristmd@gmail.com>
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

mwifiex_ret_uap_sta_list() iterates over sta_info entries using the
firmware-provided sta_count without verifying the response buffer is
large enough to hold that many entries.

Add a size check that validates the response contains enough data for
the declared number of station entries before iterating.

Fixes: 8baca1a34d4c ("mwifiex: dump station support in uap mode")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 85512f526c5f2a..4d8493f9a6697e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -973,11 +973,19 @@ static int mwifiex_ret_uap_sta_list(struct mwifiex_private *priv,
 {
 	struct host_cmd_ds_sta_list *sta_list =
 		&resp->params.sta_list;
-	struct mwifiex_ie_types_sta_info *sta_info = (void *)&sta_list->tlv;
-	int i;
+	struct mwifiex_ie_types_sta_info *sta_info;
+	u16 sta_count = le16_to_cpu(sta_list->sta_count);
+	u16 resp_size = le16_to_cpu(resp->size);
 	struct mwifiex_sta_node *sta_node;
+	int i;
+
+	if (resp_size < sizeof(*resp) - sizeof(resp->params) +
+	    sizeof(*sta_list) + sta_count * sizeof(*sta_info))
+		return -EINVAL;
+
+	sta_info = (void *)&sta_list->tlv;
 
-	for (i = 0; i < (le16_to_cpu(sta_list->sta_count)); i++) {
+	for (i = 0; i < sta_count; i++) {
 		sta_node = mwifiex_get_sta_entry(priv, sta_info->mac);
 		if (unlikely(!sta_node))
 			continue;
-- 
2.47.3

