Received: from mta1.migadu.com (out-247.mta1.migadu.com [95.215.58.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882CD4F7994
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 20:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788553726; cv=none; b=HbPbjdc4UitK2b8VMVn6atWOUW/YQOAX1HFsllmMjeCc6MbsX8ogKaiQVy0nUswVI3uKgSh23kn8UOrle031JkbguZxs2MWOafAczJL6Srq4i3V8g/Ezi7xEmtllq92SAJc/zjSZleH5S8aGn4tMwK22ZlwrOMJygMYyZULhg5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788553726; c=relaxed/simple;
	bh=PWJukDUqmQjG6nax1yH5sUt5blvqZCXFje4nnl7OmoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HYD2VZc9YgGJA8+NY5spTqV1v22GpbLeTYUtzZCPqqnIezqKusSV9ZJDf0QDNCgrTCR6zerAcOrmVFeWmPRWa/oCt8eCKPCpakq76inOArhLP7PHfTTLRsmx3s3dOpgP/aE9p43H1pDRqG+3pebFQnueab1+v76q/h+D/R6QhkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=WuJT2UMq; arc=none smtp.client-ip=95.215.58.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="WuJT2UMq"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=PWJukDUqmQjG6nax1yH5sUt5blvqZCXFje4nnl7OmoM=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788553704; v=1; x=1789158504;
 b=WuJT2UMqlfu76i4+oXBjaoTthsArMEAXjKMrbmtqC4kcUYFii+vf4hzkO7NdL5bgRBGww6Ql
 IXPfGsxleHnCvXK+i9nKTD1qq+NC0HJ1Zk/yy+gRyN6SJvy+V6AZRqonI/mbGmB35emG9OI2CCK
 W6e9/9qgL9eR+zt0rj8zXr4hUTs4I+XO1NMxbQzBPvbFDfiPEiAOQ0O/MGts0ni8zIauE7G91cs
 mMr+gMDbOLby5xLRJC72SYhnKZOF3mQzbuKtmBfMf7FSad0R6oX46AcO8mu6xEMkHRgIZ4Lahq8
 Btg4FAnNtjet2DzrMEdx+tp0FVTO0Bspl4wR01jGB3HEg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 32954092dbf4826d;
	Fri, 04 Sep 2026 20:28:23 +0000
X-Mizu-Trace-ID: 32954092dbf4826d
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Alexander Wetzel <Alexander@wetzel-home.de>,
	Felix Fietkau <nbd@nbd.name>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH wireless v2] wifi: mac80211: drop the monitor filter counts on stop, not just sometimes
Date: Fri,  4 Sep 2026 13:28:17 -0700
Message-ID: <20260904202817.12564-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bringing a monitor up raises the receive filter counts for every monitor.
Taking one down lowers them only inside the branch that retires the
virtual monitor. So an active monitor leaves an increment behind on every
cycle, and the hardware keeps delivering frames nobody asked for.

Dropping cooked monitor support indented the decrement into that branch.
It sat outside before.

Counts after each up, down and delete cycle on a 7921 USB part:

  without   cycle one ends at 1, cycle two starts at 2
  with      every cycle starts and ends at 1, in any order

Move the decrement back out so it mirrors the increment.

Fixes: 286e69677065 ("wifi: mac80211: Drop cooked monitor support")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
---
The counts are fcsfail, plcpfail, control, pspoll, other_bss and the one
that keeps TX status reporting armed. Changing flags on a running monitor
still balances, so only the open and stop pair drift.

v2: changelog rewritten by hand, and the counts above are measured on
    hardware.

v1: https://lore.kernel.org/linux-wireless/20260825043754.66918-1-lucid_duck@justthetip.ca/

 net/mac80211/iface.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 43460a705a6b..9b400caf2765 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -630,8 +630,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata, bool going_do
 				hw_reconf_flags |= IEEE80211_CONF_CHANGE_MONITOR;
 			}
 
-			ieee80211_adjust_monitor_flags(sdata, -1);
 		}
+
+		ieee80211_adjust_monitor_flags(sdata, -1);
 		break;
 	case NL80211_IFTYPE_NAN:
 		/* Check if any open NAN_DATA interfaces */
-- 
2.55.0

