Received: from outbound.ms.icloud.com (ms-2003f-snip4-11.eps.apple.com [57.103.72.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0F07E0FF
	for <linux-wireless@vger.kernel.org>; Sun,  9 Aug 2026 00:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.72.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786235849; cv=none; b=NSn+0POuv364JBC4rjfnztoeBXsPe9eXXjXNMzvOflQQZxgV0VQJfCR+X0N0I0dn9ECyWnQU6P3icis42OGlvhXcWDyhWuF1CpZC3izg8fvCS5kQ/3htq3mJgJrONDam3jFCfCMfRX9i2Ae3iKDYCh8eFWX1oe6aVuOcMm+7aYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786235849; c=relaxed/simple;
	bh=k7sWXjrPNDqzpfX6zkQotgrHag5+32lcbK9SBZnIoz4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l4DJqS2REvgn0mBHwd9/PvsZSXNGAkKR+a9sni9eIK45ZLK9wnJ5zrs6P0ZpEv0WvZZua+h2LGmJduMgUPZ9SKNK9S06Eo/PiuHv+zmGhLoWLUq6HNRx996DN8GNE66/TbDH17+LAPEbUxeSQ7G5Vvh5PmC6P0UgOIWMqH9G+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com; spf=pass smtp.mailfrom=icloud.com; dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b=DcfQsded; arc=none smtp.client-ip=57.103.72.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=icloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=icloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=icloud.com header.i=@icloud.com header.b="DcfQsded"
Received: from outbound.ms.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-1 (Postfix) with ESMTPS id 0F0FB1800098;
	Sun, 09 Aug 2026 00:37:24 +0000 (UTC)
X-ICL-RepId: 019fe3f3-f8d1-7fa4-9fc3-fc8004741d54
X-ICL-Out-Info: HUtFAUMEWwJACUgATUQeDx5WFlZNRAJCTQhPB0MFWhxJDFYEXBcOVk1YJ1QMQQJcMFAbXwJCDxwTVhUTC1NWWxNVF0YJGQhdHRkKUFAES1oVVRcOAkIfUB9MFldDWhgcGVoUXBhTRVEfVFhDGUVWaUELTx1dGVscQmRYVwkKAlEcVg1XQ1QEX1BUEVdQC1kCQg9IC10OWwJDDkkHQwRbBUcUSR4MaAxTBlAWcwRUB10FXVZQAlpVEgRACFZQXgheH0wc
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1786235847; x=1788827847; bh=BWAqbF8oF5kUbmscbBjcUjetbGSqx1RaiLIjW+k4Wko=; h=From:To:Subject:Date:Message-ID:MIME-Version:x-icloud-hme; b=DcfQsdedEgiZbCQZvw+g7JmOEUxS23zMEitUxVNiHIUPs7Vojtw4hg3T+9ckbnYbm0DIyPKpBY0Wxd87zJI1KEYjBF3JeLfbUJr5hgFjQQBVPuVCH8mpNlDjNsJYKd0JQ86YGn+9JT8nI95wt2+J68z9O9avKqfov9FZ2mxOGrpeT8MDuQkzKh0RmKs8qqpfu0oPL1TCT5JiJBwNw5Vkd0PF295BFy6vuBPrErmV/S4fWuaacFBl0BmwuisE1Gh0A7o/jlFyBLAtp62T6AlYAXdaEXNibEz4xlmmjsErhnStYsvHv4JLaQes9dYKmSgNbQSoIgnLPyP64TeHFRlKJg==
Received: from caracara.lan (unknown [17.57.154.37])
	by p00-icloudmta-asmtp-us-west-3a-100-percent-1 (Postfix) with ESMTPSA id E257F18000B4;
	Sun, 09 Aug 2026 00:37:23 +0000 (UTC)
From: Alex Gavin <a_gavin@icloud.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Alex Gavin <a_gavin@icloud.com>
Subject: [PATCH] iw: support skip TX monitor flag
Date: Sat,  8 Aug 2026 17:37:14 -0700
Message-ID: <20260809003714.3077-1-a_gavin@icloud.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Info-Out: v=2.4 cv=JOM2csKb c=1 sm=1 tr=0 ts=6a77cbc5
 cx=c_apl:c_pps:t_out a=qkKslKyYc0ctBTeLUVfTFg==:117 a=Sv0fKeRqtYgA:10
 a=x7bEGLp0ZPQA:10 a=h3XwevFeXowA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=v3ZZPjhaAAAA:8 a=i-cwZO7vWIGqCjohr_QA:9
X-Proofpoint-ORIG-GUID: fcJVZm-pHb8vgVSFaAJDCxhHyoA5cHWq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA5MDAwMyBTYWx0ZWRfX2EeO7n8bzERu
 LP/EO7hM7VDgRdfU+985oqOKL7OYZLt/RWCByQtPgHmIvBQsZZZnuT1yvUHp5EwWXECgbFhBfo5
 VabO25YOCDVu7wR7GbJqQBDEk9zLScDsxX0VhrC7xmaOL/edJiKNssY85SgNcSHewzR1kUn55eC
 ZjXV/HyOyatk09AvBTPr+vWnezXZ1+34QcqJ+Sg2TaBAlHGZv9qYoY0kpsrSRQ7aqZhBEj5cRrg
 ujGJ999VYi3u05wjCimkpzLQ9iWJwblNwHh0KrPfDQnatgEZ1Aw+Q5Jbovcq9zRKBHcfIrWaVJN
 wM3pxsZAykHaZvJNYLExbNQ+zi3SbnmXl/IriahcrSvivLM5R45P9aYyyZDLwA=
X-Proofpoint-GUID: fcJVZm-pHb8vgVSFaAJDCxhHyoA5cHWq
X-Apple-Category-Label: MTQ4OTM2NTExMTokY2F0ZWdvcnkkX1BlcnNvbmFsLA==

Usage:
iw dev wlan0 set monitor skiptx

Signed-off-by: Alex Gavin <a_gavin@icloud.com>
---
 interface.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/interface.c b/interface.c
index 65a4006..c01fc61 100644
--- a/interface.c
+++ b/interface.c
@@ -17,6 +17,7 @@
 			"otherbss: show frames from other BSSes\n"\
 			"cook:     use cooked mode\n"\
 			"active:   use active mode (ACK incoming unicast packets)\n"\
+			"skiptx:   do not pass local TX packets\n"\
 			"mumimo-groupid <GROUP_ID>: use MUMIMO according to a group id\n"\
 			"mumimo-follow-mac <MAC_ADDRESS>: use MUMIMO according to a MAC address"
 
@@ -30,6 +31,7 @@ static char *mntr_flags[NL80211_MNTR_FLAG_MAX + 1] = {
 	"otherbss",
 	"cook",
 	"active",
+	"skiptx",
 };
 
 static int parse_mumimo_options(int *_argc, char ***_argv, struct nl_msg *msg)
-- 
2.54.0

