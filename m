Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7023133A70A
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787420581; cv=none; b=sRnEgGx1E6MpXkukA4hiXzLY7V+EiPXXs0lAojPBU2HLNKBtBxkUY6bCJDyWsmxNBZG8DkpjxyKfY5nESz4VqcIr26+bfjsb0ERvQZPNITcki+/sOpba/+1LsnnPyRpqwd8gmgPHk5UsVSx95cLuvzv6yfBO2kfWp/VsFxp/g44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787420581; c=relaxed/simple;
	bh=sG6DI2m1xA4Trk2Gc+DwLk8v6SC4KKcDG1mLw96rUIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NzvCWkUp2GQ08a2AT6RsSyOQnnOabO6fJ4PxvxXQfXYB2zbkyfhu4v6/Hp54djGovRxfYCjzcPTspkRw8tSOfIPxL6k1Dn27/TcnLDQoiSMCHK1hNnYlSkzAIN3kFSdPLuloIWEk55tS+mNjptzGbnHIpS9E8+UWsEnwuEmKeXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LmsfGppF; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LmsfGppF"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c20ce3c118aso398398466b.0
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 10:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787420576; x=1788025376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DaxLAsuKRLjpxssrjb1tKyZUVSubrXKx4Z+PvXReFWg=;
        b=LmsfGppF5WP0fLPPvre8Vn5vcCAX8OYCgj2Wuyf9lmAc1peg/9C7RQ/TqKyFMtR1bF
         aS+TrWNdM3fDIpkJEtrFxzKk2TzOOvMfvzsimQQp/XyLbHyDnLWeF4n7+Z/wDL6f9Z4R
         wpzkjIqbctsZISd3Klzbry/yUMz6e3cLcF2UXGXGaIjXVM+aU11hcMvkZ8Kac4hIzTzw
         3ia3wAzh+1CTkBHhsOb+5WLQwPjnzkz+gXP4xjRSj9btcWhCfOwCYKcNKdmyBRNGuDmM
         VDgUb4MuFhZW1XTTswMnxcG0ViNSBZV53qpTxrs+75KE1bTxHIMqIAseHA7VYtYaZcBP
         q6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787420576; x=1788025376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DaxLAsuKRLjpxssrjb1tKyZUVSubrXKx4Z+PvXReFWg=;
        b=PR43c+VoskSeZkOTrcBeviwAI3k33YC6gRokcjLUmsEwTXyD7W+gw+PJpGeM0BvcNx
         tfOIUKGtmKhCGdJM0PZ0kIjV5Gn/oBCY/Ek0+FwKbuG5xd7147uMIam0b6qHRrSftd4r
         x6pjgq65zd0v/AnqyGBY6LqMSWXInzeXjYWk/cbNK+kqNTjmn4AeL/LGMENuYIB/H67h
         9ZqDrsZfdFqtlo71gX+PE4Z/LtGc3hQ6mZXsurvjExtjx6XcpOBvpb85xx7246hhQKeP
         nAcH6GHR392/63CLPBBhA9ELdZ98UNxDxasQQIaIu2fKJjiC4xAL/Jdv7qTEZPZ517OW
         m5ew==
X-Gm-Message-State: AFuF++nl0VgICYWqMitvIdjiG1UF1Vj+NozuA2rDL4mq0XSUQKzqcshi
	2NRpIpp/kmnm8NIFP1LXjFvFVemA4pIUaoMw34u2AXBHcyJ7LAUF/I6EQMPzYUQy
X-Gm-Gg: AR+sD11V8S2IqKwxZ2PU9fkXYpBgF/Uu4swqHVGEYR+k0CgbEWETMeo/W3pqWzkOfkC
	ELhW5nWQeDBcsS7fcTq2tiC0gfwv8Eg6bWc/qksfswxghMUQTCS2ujp7sPOWdt9gLpMtDjanywi
	gtGzRpiF0oQZ15ajdon9AFbF1rfV8kRXhtoKBEPzOiKPjpJS9sIJ+PiaPhn7Ku72dpJYLj5tV4t
	W6I0Ak1YGL+cwruuVnFtftU1G9ZfODhPq7R/Ks2dEUk8q+2sBQyS75WYqjN87t3xNx8u3hl1k1u
	SEggYCc5rIpf45awOmvb7X+ZcuTQvjxqmfqleTahbezCvJIpiZmc3hlzjZE2SX1bvYUeBeQajDU
	RNhf+/ArSGxxQKN1C0NkST/DKxjMuy9bAraUKXfl5+Lz+gduiVp3axkLJfGIYDwK6B+pkBFYHPs
	vSQ4AcWCUPBld+CSQYFDtV7zpE0GIInVC2aivrKsRfM1bs/hDzoAp/w3StNZcr3yr3eOEWG3xKx
	OSFyweO/7FzFuM29Xdsg4jDCP5JKJ7RJrU/U8c=
X-Received: by 2002:a17:906:4788:b0:c08:580e:899a with SMTP id a640c23a62f3a-c246dcbfa62mr1368968266b.10.1787420575557;
        Sat, 22 Aug 2026 10:42:55 -0700 (PDT)
Received: from lenovocachyos.home (c83-251-3-7.bredband.tele2.se. [83.251.3.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249689fa97sm334367466b.57.2026.08.22.10.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 10:42:55 -0700 (PDT)
From: andres parra <andres.parrab@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: andres parra <andres.parrab@gmail.com>
Subject: [RFC PATCH 2/4] wifi: rtw89: map P2P_DEVICE to RTW89_WIFI_ROLE_P2P_DEVICE
Date: Sat, 22 Aug 2026 19:42:27 +0200
Message-ID: <20260822174229.65643-3-andres.parrab@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260822174229.65643-1-andres.parrab@gmail.com>
References: <20260822174229.65643-1-andres.parrab@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend rtw89_vif_type_mapping()'s switch with
RTW89_TYPE_MAPPING(P2P_DEVICE), same generic macro already used for
ADHOC/MONITOR/MESH_POINT. Without this, a P2P-Device vif reaching this
function (now possible after the previous commit advertised the mode)
would fall through to the default: WARN_ON(1) case.

RTW89_WIFI_ROLE_P2P_DEVICE already existed in enum rtw89_wifi_role
before this change, and every existing consumer of wifi_role
(chan.c, ps.c, phy.c, coex.c) already handles it correctly by falling
through their "not STATION"/"not P2P_CLIENT" branches, since a
P2P-Device role has no BSS/association state those checks assume for
other roles. The BT-coexistence firmware command path
(RTW89_SET_FWCMD_CXROLE_ROLE_P2P_DEV in fw.c, three call sites) already
consumes this role generically via a role-bitmap built from
rtw89_vif_type_mapping()'s output, so this one-line mapping is
sufficient to make P2P-Device role signaling to firmware work with no
further changes needed there.

Part 2 of 2 for NL80211_IFTYPE_P2P_DEVICE support. Together with the
previous commit, this is the full v1 diff per this project's Phase 2
design (see rtw89-p2p-device-project's PLAN.md/BUILD_LOG.md): a real,
startable/stoppable P2P-Device wdev with working BT-coex signaling and
remain_on_channel (already present on this chip/firmware, unaffected
by this change). No start_p2p_device/stop_p2p_device driver ops are
needed -- mac80211 core (net/mac80211/cfg.c) implements those
generically and calls the ordinary add_interface/remove_interface ops,
which require no vif->type-specific handling on this driver (confirmed
by reading rtw89_ops_add_interface() in full).

Signed-off-by: andres parra <andres.parrab@gmail.com>
---
 core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/core.c b/core.c
index 5cf29bf..c8f12ef 100644
--- a/core.c
+++ b/core.c
@@ -5702,6 +5702,7 @@ void rtw89_vif_type_mapping(struct rtw89_vif_link *rtwvif_link, bool assoc)
 	RTW89_TYPE_MAPPING(ADHOC);
 	RTW89_TYPE_MAPPING(MONITOR);
 	RTW89_TYPE_MAPPING(MESH_POINT);
+	RTW89_TYPE_MAPPING(P2P_DEVICE);
 	default:
 		WARN_ON(1);
 		break;
-- 
2.55.0

