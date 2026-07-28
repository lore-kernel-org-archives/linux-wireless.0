Received: from mail-ua1-f98.google.com (mail-ua1-f98.google.com [209.85.222.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804852BE035
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249985; cv=none; b=rJLfpqwZt48VPnKIJ/mh7dYOtoOoN/zlmZ0GQeCtxPb9wHWI9AZb6rfjTvtW67shXgQLVfdWgUjxar7u3YOjFNxs9B6OjfXeS1/TTun2ljfxLn5LlZCf8J03qYxmMLSiD0zVZh1lHdKMWHcA9EIEod9mmiV0fhCD0qqT6NxAkA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249985; c=relaxed/simple;
	bh=C4VLmdlEq3W3SF6LD/PGxIdNW6CGKbivGLyN16kk4zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGT83+Z6VPV90L5yHvVUcLMOQjSePf1t294KtpzjvsYsTmxV5kaqH14KPxDs6pl4TuCQ5qbIA2ECaeOrF1ZfsrenwXel1U3YYU4+qDCRAz4EDhS1l5P5ib+51ywaCywUtGcFjniSLGRFlAYaciV6vhMOhVglcO61vrjC7av4tfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=O/Ehb3FP; arc=none smtp.client-ip=209.85.222.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="O/Ehb3FP"
Received: by mail-ua1-f98.google.com with SMTP id a1e0cc1a2514c-9693bbb962eso2619993241.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249983; x=1785854783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=A6Q6qGby3ERjMgl4TFGce6QoHTS1tMFMX4cxoOsORXA=;
        b=FJl2e9cOR5xYcD9D5CXZ/xEDLgWTo+xVz8eO1lBO6CWZNBJOXXJFQs8Vu0EczG69cf
         GPMZ6nzcTuz6T6NQRe77DCQM6SnWAdrwZ9agFyrp7OTlWP+GoKIFfE/v3MuME3MlBepA
         24s+9VSr2jpo9a3Pp/pkAtZwa8Y2fWJ1vWd1xVgf60tV7dQAA3Pbxl+t0wf7AaV+BhCt
         477UbGBjAerR70gxoczT1u/aKjuiAUdwT4n6ptkWQaHBggMHIms7gIEM4Yx4P6Vi9g4h
         ZsS6L2PL2PSj9M82NEYDI61yF+G+9ulpH50bhVGFiitpDL+iaLW/aIostHqia8pzAHUl
         XghQ==
X-Gm-Message-State: AOJu0YyzpGrlnEl8ymp/QusyUjLFFHo6qOvgDggand6ufJvuSHKpKGXK
	WOlV3CN5gwHFz7fQL8zilaXNcO50RcWsurDuKSS1xdMQzQLj7znNV7HHzj5y+umJrhqZ1miNbyh
	2lVoCcihziJzkiSpfq/boB5Wjoyf6BDxuydz9AQflfJN2pjvXwoth4yStwLbmkfo9adSOT+nIrv
	cw2I2f9lbiIG6YIHQvDeLaYwgDwSXMBGK+LXBrIinpfyg9t3UvxsygKdpCg+xtANnPLdLKgFRgx
	CpyaBxK1stTjaseMTUdTtXegEDu
X-Gm-Gg: AR+sD10aA8wSmUNwbIyZx/jtYUJIS6xj6GOFFJAf8kITkdtKuBSRfDP/UwUVMd4B5kh
	aCsvrxrJnUKsWIDxS2/eyb2ZYksg/PTzH3F40lVkKyr224K/Fdurl9lVyWKRzjPNfBhMbeVwjV5
	AM4uzMmcwNVb40r/DFMwoYxIUguevmj+ry1F08upzuwajNCeD45I/Pv7rSLvLVq/tcBMcs1c+nr
	+MyPNM5n5qb2ud/o27hzVKUTuS4t9e3ooXEDx+d2ZCdbVeIID4OS9z8sSfatkR305f/c+0P8+pW
	oIT01Vu+Pa9Gl1+NQDMKZyC21zjH6Qpd9kXdB3Sy1ovFJtFECEQjx48VtOJwjLyzlwSQ824/6mW
	bw8tmXZfRrhh4zx9hd8O8SeEAv2hOdJipTJNFC5sHihWr2i2BC6ElDxCK9kvDohTgQKboMr9N95
	Yz4Jj1N9+XQEtaPAfxcn7nmuOvnpnjK6fCXft/WEE=
X-Received: by 2002:a05:6102:1487:b0:740:2717:a1b2 with SMTP id ada2fe7eead31-7549f251658mr1539567137.1.1785249983307;
        Tue, 28 Jul 2026 07:46:23 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-97774cfdb62sm470501241.1.2026.07.28.07.46.23
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:23 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-92e632390d2so660308485a.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249983; x=1785854783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A6Q6qGby3ERjMgl4TFGce6QoHTS1tMFMX4cxoOsORXA=;
        b=O/Ehb3FPcWmAH3w2qfx9jEHmsIQIL7to74mgj3AYeCHd1KA2pO8Zv1tErDZApTD/N8
         YKJZYCgpsTsZfH2TEKLNEfo4jN2Gi0ffx3sDnEMfH01PedyVxASdZdF4QhtX7LCUNvT5
         O2Qr2M0DJ1m7NhF5SakA4wwiu8qRTgcUAkdZQ=
X-Received: by 2002:a05:620a:6888:b0:92f:279:f8ec with SMTP id af79cd13be357-933029e6c31mr249285185a.74.1785249982598;
        Tue, 28 Jul 2026 07:46:22 -0700 (PDT)
X-Received: by 2002:a05:620a:6888:b0:92f:279:f8ec with SMTP id af79cd13be357-933029e6c31mr249281885a.74.1785249982094;
        Tue, 28 Jul 2026 07:46:22 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:21 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 12/12] wifi: nl80211: send frame tx status event only for non-zero cookie
Date: Tue, 28 Jul 2026 16:45:49 +0200
Message-ID: <20260728144549.2207061-13-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The cookie value assigned by cfg80211_assign_cookie() is guaranteed to be
non-zero. So the zero cookie value has special use in tx_control_port where
userspace can indicate dont_wait_for_ack, ie. not interested in status. The
wil6210 driver also uses the zero cookie when wil_cfg80211_mgmt_tx() is invoked
from debugfs api the driver provides so the event is also redundant in that
scenario.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 39398d89c5ad..708e8bb8dafd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -22034,6 +22034,10 @@ static void nl80211_frame_tx_status(struct wireless_dev *wdev,
 	struct sk_buff *msg;
 	void *hdr;
 
+	/* userspace not interested in zero-cookie status */
+	if (!status->cookie)
+		return;
+
 	if (command == NL80211_CMD_FRAME_TX_STATUS)
 		trace_cfg80211_mgmt_tx_status(wdev, status->cookie,
 					      status->ack);
-- 
2.54.0

