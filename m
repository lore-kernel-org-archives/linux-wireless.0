Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0221EFFA1
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 04:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787632691; cv=none; b=QjGNKnX0BZs15gmLWMikvnh1zYwZXScdNM9cy685+Y+j7hSPT0xHEmoooJRdBvULyzB6zWttWXsuV6MCqG/jrAo0L96sWwMU95Cwr03qCqwKd0FhTTfxsKv18TqGu20WNXE8/EYD386abUwsTytu3x5RqVHyddPfWVkwHQpffvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787632691; c=relaxed/simple;
	bh=eBQWcADVMleBOLmmnfKm08ioE6DmdSMtpmAkohRg96Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LFCqyeNUTAkecMKfgAHSzb17RuYVfsKAm1M1609BD1frjGdo/Wzuknho8zJKRoarPboboDN3aLFi3dFPGVgmQrFVzmLnirb0PREaklB4qqPVpWfixNf+YuK5CPQDJLZbp3oWgdsxH9l4WgARXeV44UOWxiKJ6zuYfSMnMJPW0rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=ucAVQc81; arc=none smtp.client-ip=95.215.58.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="ucAVQc81"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=eBQWcADVMleBOLmmnfKm08ioE6DmdSMtpmAkohRg96Y=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787632686; v=1; x=1788237486;
 b=ucAVQc81m6+Su6Y0H6gk8Qhd38CDjzLvQGSSZGoYPdyP62ANiGApaIol16q4uvyIALJouF/w
 Dko1/jtfKqUi7wqhSP9cFYGM7EVlb8cgHs9aJxKjuMGfizJIsjC5/RbGkkc9XbTp6rRUxPFqj0A
 22XZdZ91YOl+l2tZlkb/zwYIHVH3oS9Het6XbJe+ut7DqIOCwAJkgNNRhDIySPrHuJF8HiZ5PcE
 DMV/BjPzBIX383KVzvUFhcxCkowItIbQXEcwMbQbkfglmCjkG3jstDPPgp9NHrQOirudjBzqSWw
 MZC8Af1SMWpWFHrsxNbjFE42XrC3lO3RMTMGbXQjBuoGg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 4ec9b9ee82988abc;
	Tue, 25 Aug 2026 04:37:56 +0000
X-Mizu-Trace-ID: 4ec9b9ee82988abc
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexander Wetzel <Alexander@wetzel-home.de>,
	Felix Fietkau <nbd@nbd.name>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless] wifi: mac80211: drop the monitor filter counts on stop, not just sometimes
Date: Mon, 24 Aug 2026 21:37:54 -0700
Message-ID: <20260825043754.66918-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bringing a monitor up raises the filter counts that track what userspace
asked to see: frames that failed their checksum, control frames, other-BSS
traffic. Taking it down again should lower them.

The rise happens for every monitor. The fall sits inside the branch that
retires the virtual monitor, so it is skipped for an active monitor, and
on any driver setting NO_VIRTUAL_MONITOR. For those, every up and down
leaves another increment behind.

So once anything has asked to see frames that failed their checksum, the
hardware keeps handing them up long afterwards, to monitors that never
asked for them. The other counts accumulate the same way, including the
one that keeps TX status reporting armed once it has been used.

Changing the flags on a running monitor still balances, so the
accumulation boils down to the open and stop pair.

Reproduced on mac80211_hwsim: an active monitor brought up and down
leaves one unmatched increment behind, while a passive monitor on the
same phy balances.

The two sides matched until cooked monitor support was taken off the
heat. The decrement got baked into the new conditional along with the
virtual monitor bookkeeping and never came back out. Move it out again
so it mirrors the increment.

Fixes: 286e69677065 ("wifi: mac80211: Drop cooked monitor support")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
 net/mac80211/iface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 43460a705a6b..6fc01d85eea9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -629,9 +629,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 				local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
 				hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
 			}
-
-			ieee80211_adjust_monitor_flags(sdata, -1);
 		}
+
+		ieee80211_adjust_monitor_flags(sdata, -1);
 		break;
 	case NL80211_IFTYPE_NAN:
 		/* Check if any open NAN_DATA interfaces */
-- 
2.55.0

