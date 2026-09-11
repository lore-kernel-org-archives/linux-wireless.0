Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF80939B497
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789111468; cv=none; b=MHOBVM8/S00vHVnzSIvYiLBdEXOGpgkwc22nV9GhaZq4xNOpq/y6DJGiBOvT7/m5qGa7i4b4S1fESnSxFnq68uEhnD1VOPtEaCH3igPJx+yxpEiVlDsmGJfAqE/uR2yPC8i7mx2uWXkH0QK1hwuHHXpuf5XPkr7HAEdWCTfb1ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789111468; c=relaxed/simple;
	bh=sXwF1on9n81MGRbpeOCmX2s0+AQudSNFliaULKBSRt8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ue48Vi99gyiHa9+lD6IiUGzKOAgp3aMqtF/1qxzGiGgqtZeHSnVRkDIC6L/61CNifvMVgHGqupLEmZc+2bn/Kf3CyGdnYSBQX8s8LnH/rl6mfy2EZ0VsokI6AEWEndIufWDQjuB+9c5XSBDo298/U1nTHsdmLpoDjgMTYOodpIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c3mChfep; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c3mChfep"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb751so515684a91.2
        for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 00:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789111460; x=1789716260; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TGZGv5Mzyd9kaR4ZVZfO50u8GGM3KaCihDXEWev0Cbo=;
        b=c3mChfepux621/CehuPL6hF80l7RotnOGtEHkqfa54RAMn+MuWzmLE2ayxgARHQUtC
         9PsDZBJcD29B4QIvd6ZDDCr9qhkQLRdgKfC7UndOtjpr/vfj+Li6mdz65LROK51hZKIJ
         zIfDNEszp9WBotU9XBrPTS0VlXXptQKoEWlhOijM7ENYh3/Uivbib6E9N7PM93C0SpNQ
         Cm4fTeAS796FOEqPfBOBcY57SjF9kyOHO2mOYLbz7JOJ9D4bTikgegcQxF4aDyYQLAFA
         /VIgfFnSvZh1tC5Q7s4dZ17/EY88vFi5wpzX7/Yrct8CjsDa9s/pgSsruH14OQ2Hez6Y
         y99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789111460; x=1789716260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TGZGv5Mzyd9kaR4ZVZfO50u8GGM3KaCihDXEWev0Cbo=;
        b=Zm4wT/+CtFevfDCV9xO27SVKAwnsdL7zlS5StNAfm/HOFtOcBZNdnFfDaGCMF80PoY
         Gfm3dtlZQac8+vPuy/4p0iNOvJeQJ6CUVXDxm4FmExwkLGfnIQyBcp+X3dWbXuhxonOO
         LnR/rNgLXUm1wn5Te7dWoXfe5T76nBTvidzrFdtTYcVF+ACQVptGc1fzOKq/+S3LgsLT
         GiBATFNQeWK1Q4TgCvvynayryMi/WKWd0jD4ttDG6I4WiSOYf3/hJAHdz+P8GDBdQnIk
         LsSauqnNAELw5EedebOSeYTBIajTpTqFc8TIr5Qp6/XlYfEK061CdCjZAuOkOrtgDaNy
         ae+A==
X-Gm-Message-State: AFuF++kOGQ97hS6No48aypjVzV1XlkUZG1LQUikObeCFR8ltTfJZ2F+3
	QU6HVLAN4BM9dJEfCOIGEBXO4OdUYqx4PQ1m7wI+JqUKecbQjRnrOqoZXSRnkggZ
X-Gm-Gg: AYBFou16j8HRh2Aspt1DSscO3RWOsQUtFsjrN3wVoNyJ+sNobJSTLBwq63gEzJDzps6
	RbUmn6DCypDKznMD4y0BrN8xAmUZ6S7S8QL64m6dj+dtkzzLLT/xhC+tAEQqAnGe1WfTOx6u2FI
	Yt3QYPH91O4wrF37lrsRgdnwxJ2VBvHyGj8qsbH8owhvsP+hMaAZnfB86P3gJlLh/HmYP2hv3wS
	XZPesvRKwRs+bAd53o232a4vbIctZ+eACLhv2kS82sDNsf8okQ90MeEmrspVdsBGuP/sNi9Be//
	skJrzPNCVVFuZ54ruYLdulnoDG4blFsY0F917dGwgYyppDic+PP/BaMIHLi/95PZiWX+SwX3y4z
	CNEBG5NaXU8WAE+P6nrrZJXXXMlsKQe2a6C33DF4ARZTfDbOyJEM0dKIHTI/T+FDgKOHG8Fe+5E
	2D2PpXZDTvYxnx9VTw2FVon9kARcdqJHOBI/DdSLwW25Ijt7T8E27uce+faxs2O9ylrefMUb52h
	CeJP5isnGA2EU5wd/4WmmNsmPIztEMm/0j/dk9fO9GTTV5iu98wL4JtvhoYJqRzeS6MbPRkadUi
	WiU=
X-Received: by 2002:a17:90b:580e:b0:396:40e6:f631 with SMTP id 98e67ed59e1d1-39d9bbe47a7mr5454805a91.3.1789111460451;
        Fri, 11 Sep 2026 00:24:20 -0700 (PDT)
Received: from codespaces-1adab9.ktkhmpmw22vebpok31ngjx2qsb.ix.internal.cloudapp.net ([23.97.62.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39da1ad5d79sm1984815a91.12.2026.09.11.00.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 00:24:19 -0700 (PDT)
From: Rivaldi Hormat <rivaldihormat@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org,
	ath10k@lists.infradead.org,
	Rivaldi Hormat <rivaldihormat@gmail.com>
Subject: [PATCH 1/2] wifi: ath10k: Add missing validation in debugfs mem_value and reg_value
Date: Fri, 11 Sep 2026 07:23:16 +0000
Message-ID: <20260911072318.5232-1-rivaldihormat@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mem_value and reg_value don't validate the address and size provided
by the user. This can lead to out-of-bounds access to hardware memory
and registers.

Fix this by adding the missing validation.

Signed-off-by: Rivaldi Hormat <rivaldihormat@gmail.com>
---
 drivers/net/wireless/ath/ath10k/debug.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index fb61e53ff..50e017021 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -729,6 +729,13 @@ static ssize_t ath10k_reg_value_write(struct file *file,
 
 	reg_addr = ar->debug.reg_addr;
 
+	/* FIX: Validate register address */
+	if (reg_addr > ar->hw_params.reg_size) {
+		ath10k_warn(ar, "Invalid register address 0x%08x\n", reg_addr);
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	ret = kstrtou32_from_user(user_buf, count, 0, &reg_val);
 	if (ret)
 		goto exit;
@@ -819,6 +826,19 @@ static ssize_t ath10k_mem_value_write(struct file *file,
 
 	mutex_lock(&ar->conf_mutex);
 
+	/* FIX: Validate address against memory size */
+	if (*ppos > ar->hw_params.mem_size) {
+		ath10k_warn(ar, "Invalid address 0x%08x for mem_value\n", (u32)*ppos);
+		return -EINVAL;
+	}
+
+	/* FIX: Validate size against remaining memory */
+	if (count > ar->hw_params.mem_size - *ppos) {
+		ath10k_warn(ar, "Invalid size %zu for mem_value at 0x%08x\n",
+			    count, (u32)*ppos);
+		return -EINVAL;
+	}
+
 	buf = vmalloc(count);
 	if (!buf) {
 		ret = -ENOMEM;
-- 
2.53.0

