Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7B33AB28E
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 04:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792124758; cv=none; b=pxc8DYHCSH/1e8M1axFjQ4RcvnNvuq1Y1ciCbmEoWop1/AMhBo8ceTXhHyUH8ZxSqu79s5quVzRz6c88035rxuD+NFMUTcMqpU3+m+lD1KOqtcHRQws7Jx20pmrlLAeooEURa8N1XWqfaHmPZpbub4YRLgNu+6S65Fg5eKKgG7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792124758; c=relaxed/simple;
	bh=FtqbWhIU87ZGHIYTN9co647UktQthKP6Jy61d0do1jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El4erQuXExzI5sueD0BOkp6wNeen07kScR/saPmswW4Tk+rLVZJs8ccNpgZrT6IsWjHJ3XjxYJViiJvq3XsJNA9BJxo4KEE2WiNRS1pR1LFx53W9WdY78kgSc0JLgRaDGPgtZeIaqBFo3LbVTqi+g9nWotO8LL1svoDdsQ4CxPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=xIKZM2XN; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="xIKZM2XN"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd60c5da24cso3093941a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 21:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792124757; x=1792729557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q1N+yYub3XBNkYyW+1Hf+ziW1h/AYPNRJpBiCiyPuEs=;
        b=xIKZM2XNDwlXVbTnn0TH8PcWC9Asd+7lZuhy09XATgCQLZEgw9aR1Ee7axZDyQAy2Z
         Z5rp4AafygzRcwp3K99Qu76RB6/LnxnlleCQ0sX41mrY08bIcd+98+AAud6+B/PoAZVu
         VjP+Ozsd+QtyPkcUfZHiyRXO2TejWK2uz9P7vL7sTHV+if8iYsdpTBzeKmHU4fjczLPd
         nt96H40TP1tZkHmxiEeksn+nuCWDty83lWXQvtEZ+wuY6QFxZyF23v5gIISmy25eZ4ul
         nLX5I1rPy0LbvlHyeFaFlAxx28iU1T7zte9KUSuTPSCz9iTTwmpYwJg++EfjLx9K+EEj
         SL/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792124757; x=1792729557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q1N+yYub3XBNkYyW+1Hf+ziW1h/AYPNRJpBiCiyPuEs=;
        b=KuRfX41l8GvUOcUbfd+0Ni1rWt2EAa4w79uJFXPQhLKdTXJOhuKcow/rF/1N8RI2/z
         JGJvIl49jI04zXghivGtyUGJK24qHH4m3ggblmTQS3D+UIsUJr1XUbQ9md+dN1YyMIXR
         vjSEW1XKf1fc1k98HpSGf6W0OqgDweoM93FuYXsir/cjTzgFv5P63JTsvNunIU3AnXYc
         nkvL3LpxyXyIM2Eq3FIux91QFmL8+Ifh6d+FZEb3wozomQnAZZnRSx0h0LpSql1vPCS5
         Gow+7Evpwyoztrc5be3YrGLfZTHcKBAygXIGj5S4RP9Y3exezDJe5PDxMHIkuijRl8G0
         LFSw==
X-Gm-Message-State: AFq9FYLtNdAeOTd0sVAuf1c5cMZSmi/iISKm2hIVaKLmC0HG2YTMa8PO
	di8ZgH+Ltif0/E2SbA6mj2elAM4+AqjjTuqi6aqv+C9/hK7CIPsklGse17ZVsVFpjEQ=
X-Gm-Gg: AYBFou2Hn8g3n/o4ZVlZ6P5+9ttKsQoPb5hlGpHJp4HXdwfCkxHvfOltGHVSmsRhLiz
	eOrurdkLMRineiqEE6OyS91KL3QIFCA95r+ItSsMfKyTDWxdzBDIwHEDLw6InUTaXMawORbae7Z
	bVbY0HSLJGXBRpYbgWxWk7QsEengGhjunUSHG9ruEmEiU2pww8OMBTBuZC5sdU6xxgHte80vTiW
	3bLtvp8/8+THyCSEKY19WfXGIhhtFUlyumvCv9HxPqQoSRQ/EPgODvnCNdGaMCKYj85j5MoKaIR
	DFZ2XsxINZnc1+sJLZ9Nud7vaHinKxguhIIGbo8XL8EQgSbyofYZLm6RA1CNsFzwgvao+Ydoeyn
	JTOfD9obF40WA29xBqReW9MqKGP8pvN+ibx6asjEJX/EAIn/O1DYgeuuwB4YtWHsjkvaEzfk4t2
	3r8+0lb5FVGwnXTEgJ020Shij6OZa6RlQyCn/hWhd9S3HIhN+xdNqQCcjf1aVJzCYWShfO8s7qP
	lEYUA==
X-Received: by 2002:a17:90b:28ce:b0:3ac:c03a:38b0 with SMTP id 98e67ed59e1d1-3acc03aa056mr1559159a91.8.1792124756719;
        Thu, 15 Oct 2026 21:25:56 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd6549b761bsm424443a12.15.2026.10.15.21.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:25:56 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Jeff Chen <jeff.chen_1@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v3 2/3] wifi: nxpwifi: read the 11AX_CFG extension ID at the right offset
Date: Fri, 16 Oct 2026 13:25:41 +0900
Message-ID: <20261016042542.773945-3-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016042542.773945-1-yhlee@isslab.korea.ac.kr>
References: <20261016042542.773945-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_ret_11ax_cfg() reads the extension ID of a TLV one byte past
where it is:

	ext_id = *((u8 *)header + sizeof(*header) + 1);

Everything else in the driver puts the extension ID at the first payload
byte, sizeof(*header) in. The send side of this very command does:

	memcpy(he_cfg->tlv + sizeof(*header),
	       &ax_cfg->he_cap_cfg.ext_id,
	       ax_cfg->he_cap_cfg.len);

struct nxpwifi_11ax_he_cap_cfg has ext_id at offset 4, after the u16 id
and the u16 len, and so do struct nxpwifi_ie_types_he_cap and struct
hw_spec_extension. nxpwifi_ret_sta_get_hw_spec() parses the same
TLV_TYPE_EXTENSION_ID out of a firmware response by casting to struct
hw_spec_extension and reading ->ext_id, i.e. at sizeof(*header). The
caller in nxpwifi_set_11ax_status() also writes the extension ID there,
at ax_cfg.data + 4. These two lines are the only place in the driver
that adds one.

The consequences are that the HE-capability test is made on the byte
after the extension ID, which is mac_cap_info[0], so a capability TLV is
rejected and some other TLV may be accepted in its place; that the copy
into he_cap->ext_id lands one byte off, leaving ext_id holding
mac_cap_info[0] and every later field shifted; and that the copy reads
one byte past the end of the TLV payload the response declared, since it
takes tlv_len bytes starting at payload[1]. The other copy in the same
function, into priv->user_he_cap, uses the unshifted offsets and so
disagrees with the first one. priv->user_he_cap is what
nxpwifi_update_11ax_cap() and nxpwifi_fill_he_cap_tlv() read back as a
struct nxpwifi_ie_types_he_cap, with ext_id at offset 4.

Drop the two plus-ones. With the correct offset the loop condition
"left_len > sizeof(*header)" already keeps the extension ID read inside
the declared response; it is the plus-one that needed one byte more than
the loop guarantees.

Also require a payload before reading the extension ID out of it. A
zero-length extension TLV carries no extension ID, and without the test
the first byte of whatever follows it is read as one.

Fixes: 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x")
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/net/wireless/nxp/nxpwifi/11ax.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11ax.c b/drivers/net/wireless/nxp/nxpwifi/11ax.c
index d15495a85d2ba..a5278375329a4 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11ax.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11ax.c
@@ -219,13 +219,13 @@ int nxpwifi_ret_11ax_cfg(struct nxpwifi_private *priv,
 		tlv_type = le16_to_cpu(header->type);
 		tlv_len = le16_to_cpu(header->len);
 
-		if (tlv_type == TLV_TYPE_EXTENSION_ID) {
-			ext_id = *((u8 *)header + sizeof(*header) + 1);
+		if (tlv_type == TLV_TYPE_EXTENSION_ID && tlv_len >= 1) {
+			ext_id = *((u8 *)header + sizeof(*header));
 			if (ext_id == WLAN_EID_EXT_HE_CAPABILITY) {
 				he_cap->id = tlv_type;
 				he_cap->len = tlv_len;
 				memcpy((u8 *)&he_cap->ext_id,
-				       (u8 *)header + sizeof(*header) + 1,
+				       (u8 *)header + sizeof(*header),
 				       tlv_len);
 				if (he_cfg->band_config & BIT(1)) {
 					memcpy(priv->user_he_cap,
-- 
2.43.0

