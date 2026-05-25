Received: from n169-111.mail.139.com (n169-111.mail.139.com [120.232.169.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4B8125AA;
	Mon, 25 May 2026 05:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779688141; cv=none; b=X+a5wtM32CD73KxKJhzj7zrJRbXgD4uaH/a7vFyExogDi/e+OAjncR3uBau9yq8WJOxejAWmJ4JItEmzFUurrYdErsEhGVF7D2NcEgRbPc86HiHtbOmKBr9BaKRMVUkyZ541u7SZ4zt+9Q9N/rDpQJcHK9b4YDbjE41UpmhDw/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779688141; c=relaxed/simple;
	bh=1KivS5QoCAdUrG5zSQuzPZujS6vFlKYxo7tDq+2xOFk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jwUtpu2NN3IeOasu2/zp8RUIvGiJu4sRb8Fy75Pmfyg03iPJw5eAtH5QCPDvuDzHT9GPU0/CDHAWa+sShguxV7r5vtv3HX905xXn9PcoAJZbM7de0tkK5hDS0S3/0a27xVsttO+Hp60DnzU6mZpRF9lZtp/OvKgicaRVxRGUIYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=hAQE2lrp; arc=none smtp.client-ip=120.232.169.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="hAQE2lrp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=hAQE2lrpwhHpYTxO+Uows007Z4DFXNofo3fM5qieodxlIWE5/4LKEQMmXEKrKY2vHMIO9a/pgWVoY
	 DiM8R61glgwJTSCgQj/KzWaq72sDvFHxO2OoE6fZ13G6T9jnv7uf531rQfevczT+3Lm7nYn8pJdz4j
	 t7Ywa7/5sbPm3J/Q=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-18-12021 (RichMail) with SMTP id 2ef56a13e2c45fe-00606;
	Mon, 25 May 2026 13:48:55 +0800 (CST)
X-RM-TRANSID:2ef56a13e2c45fe-00606
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	kartikey406@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	johannes@sipsolutions.net,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	johannes.berg@intel.com
Subject: [PATCH 6.1.y] wifi: mac80211: check tdls flag in ieee80211_tdls_oper
Date: Mon, 25 May 2026 13:48:54 +0800
Message-Id: <20260525054854.2457807-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit 7d73872d949c488a1d7c308031d6a9d89b5e0a8b ]

When NL80211_TDLS_ENABLE_LINK is called, the code only checks if the
station exists but not whether it is actually a TDLS station. This
allows the operation to proceed for non-TDLS stations, causing
unintended side effects like modifying channel context and HT
protection before failing.

Add a check for sta->sta.tdls early in the ENABLE_LINK case, before
any side effects occur, to ensure the operation is only allowed for
actual TDLS peers.

Reported-by: syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=56b6a844a4ea74487b7b
Tested-by: syzbot+56b6a844a4ea74487b7b@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Link: https://patch.msgid.link/20260313092417.520807-1-kartikey406@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 net/mac80211/tdls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 1f07b598a6a1..57bd4fc8d237 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1382,7 +1382,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
 
 		mutex_lock(&local->sta_mtx);
 		sta = sta_info_get(sdata, peer);
-		if (!sta) {
+		if (!sta || !sta->sta.tdls) {
 			mutex_unlock(&local->sta_mtx);
 			ret = -ENOLINK;
 			break;
-- 
2.34.1


