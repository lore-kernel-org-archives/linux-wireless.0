Received: from smtp-outbound7.duck.com (smtp-outbound7.duck.com [20.67.222.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C35403EBE
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2026 13:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=20.67.222.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779886935; cv=none; b=ACikEMcg+CpU0xmCzwN812nV44qAFGj0acO+Bmn6f2jI40zpEOZ4hqydMQcjewSsqju+VQUcdLTIJomXum3sT8Nvf5RQaKFW74wS3WQWPHG1oodZ8VAN8AHJJ7hoKwZYeBlNVPGEDdIT6sPBGFISrQ4EULNXY3E7ynUAiFnbHRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779886935; c=relaxed/simple;
	bh=+wGFBO5CzKAAemQ7CNeUg8aTIOLQjPsmWN8sx65LM5M=;
	h=Subject:MIME-Version:Content-Type:To:Cc:Message-ID:Date:From; b=gKnuvKbY2gBecbMsJwDKl78UmtkWsAjR0HN3fiULIRY044Z2augR3JgVNH2no3Dvaof08AE3a+ieKiu30hR2QESOOU0BU1J4UygsIchbZYPUQn65FbsPnfMz/F52tuzPB8Gh86cmBRPBAivR41aQO9Rh2a3aWgoFHHdH5cftr8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=duck.com; spf=pass smtp.mailfrom=duck.com; dkim=pass (1024-bit key) header.d=duck.com header.i=@duck.com header.b=bL4k7mu+; arc=none smtp.client-ip=20.67.222.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=duck.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=duck.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=duck.com header.i=@duck.com header.b="bL4k7mu+"
Subject: [PATCH] iw: fix broken links in README and iw.8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Bar: /
X-Rspamd-Report: R_DKIM_ALLOW(-0.2)
X-Rspamd-Score: -0.2
X-Rspamd-Action: no action
To: "johannes_at_sipsolutions.net_kawacoder@duck.com" <johannes@sipsolutions.net>
Cc: "linux-wireless_at_vger.kernel.org_kawacoder@duck.com" <linux-wireless@vger.kernel.org>
Received: by smtp-inbound1.duck.com; Wed, 27 May 2026 09:02:12 -0400
Message-ID: <D42FD315-4D8A-4383-BC0E-D92197D5CD6E.1@smtp-inbound1.duck.com>
Date: Wed, 27 May 2026 09:02:12 -0400
From: kawacoder@duck.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=duck.com; h=From:
 Date: Message-ID: Cc: To: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Subject; q=dns/txt; s=postal-KpyQVw; t=1779886933;
 bh=+wGFBO5CzKAAemQ7CNeUg8aTIOLQjPsmWN8sx65LM5M=;
 b=bL4k7mu+DFUPPqSOma5LQskw38TPKP7e73kzI7KiXqj6ekc66QShWuHL1DLvMhgYMZNVyhl/J
 BZmsj1N00hnUYMIYPohPTo5dfTNdWlUoPuzJe6c0oJMPZgiHBjJpDATm/zfyY6dTcd23kBM6x8J
 /xAIT0M4ZTS+5XKDwQF510s=

From 69851144ea8689b77379fbe2598a379564a7bb59 Mon Sep 17 00:00:00 2001
From: kawacoder <kawacoder@duck.com>
Date: Wed, 27 May 2026 12:05:22 +0200
Subject: [PATCH] iw: fix broken link in README and iw.8

Fixes a broken URL (404 error code) in the README and iw.8 that pointed to =
https://wireless.wiki.kernel.org/en/users/Documentation/iw. The new URL =
points to https://wireless.wiki.kernel.org/en/users/docume
ntation/iw

Signed-off-by: kawacoder <kawacoder@duck.com>
---
README | 2 +-
iw.8 =C2=A0=C2=A0| 2 +-
2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/README b/README
index 113bf38..41b1613 100644
--- a/README
+++ b/README
@@ -9,7 +9,7 @@ to find libnl.
=C2=A0
'iw' is currently maintained at http://git.sipsolutions.net/iw.git/,
some more documentation is available at
-https://wireless.wiki.kernel.org/en/users/Documentation/iw
+https://wireless.wiki.kernel.org/en/users/documentation/iw
=C2=A0
Please send all patches to Johannes Berg <johannes@sipsolutions.net>
and CC linux-wireless@vger.kernel.org for community review.
diff --git a/iw.8 b/iw.8
index 4ae55b8..cec26f2 100644
--- a/iw.8
+++ b/iw.8
@@ -70,6 +70,6 @@ will print the help for all matching commands.
.BR regulatory.bin (5).
.
.P
-.UR https://wireless.wiki.kernel.org/en/users/Documentation/iw
+.UR https://wireless.wiki.kernel.org/en/users/documentation/iw
Documentation at kernel wiki
.UE .
-- =C2=A0
2.54.0

