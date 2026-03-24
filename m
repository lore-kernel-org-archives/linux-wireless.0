Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C71E3AA4F7;
	Tue, 24 Mar 2026 06:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774332273; cv=none; b=macCauwP7JFLUTNE0S/U1RzB+WDnuHdb5LvvKqxoRA9sjwiuazHpJ5lMNlg4Vie4kwdjAjXd0VzSpsClpJs0v8jesTKrPzukGcoNQHSuxUfcv33ySHmfyHq14IplQS1fIPypvgyvdWjmo5xb/nwf3lbp+klt967BRf6H1GVyvS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774332273; c=relaxed/simple;
	bh=46mKEmqJ7If9n6oOQLlB27h455jj6EdxRIvtHJgTEo0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=hFytGNp7KuQsyj5+pXKJseNwmrDmkPRQvCAdaToZcNZ8kw0Y6EcaJEQIGxJizX7cQTwqvt+OjWvu0Q1G9XHTgXNXjc5CNR0T+HmTPg25LAfE9PBbYEzO9IWdNwmj2FwEzfKP99liSAKd5ZI8ib9NJtCEqANa6cx7F01HPUm0Yzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=V1uJJN4w; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="V1uJJN4w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=IN
	uffQ2bP82R6qrvw57oC8K0VZlNzr1HNS+Vrn9bxsA=; b=V1uJJN4wnePmsA8Q+f
	XvG+Qb2PVZiaYk8Y+m4n3uufLbr4cxHsIhElapq8P61e9hebHfay5h8msFCkuSZt
	12b+9wBcmFzIedwzphfLZ1nqxTWQm/MItVF634yRJlpcph/sJMhlzNLoI61zyXhR
	7x5K0ldrVEpn23ljE8emv90SA=
Received: from pek-lpg-core5.wrs.com (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wD3f63sKMJpJvBTBA--.36472S2;
	Tue, 24 Mar 2026 14:02:21 +0800 (CST)
From: Robert Garcia <rob_garcia@163.com>
To: stable@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Robert Garcia <rob_garcia@163.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5.15.y] wifi: iwlwifi: read txq->read_ptr under lock
Date: Tue, 24 Mar 2026 14:02:20 +0800
Message-Id: <20260324060220.1192543-1-rob_garcia@163.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3f63sKMJpJvBTBA--.36472S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJry3WrW7Aw43CF1xWr1DGFg_yoW8ZF4Up3
	sa9r4jgrs5XFsrC3y8XF4S9rnIqa1DGanIkFyF9wnIvr13Jr1S9rWF9ryUtFyUtr4SvrWY
	vF1jyFs8GF1UZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRSD77UUUUU=
X-CM-SenderInfo: 5uresw5dufxti6rwjhhfrp/xtbDAg5Qu2nCKO4DywAA3C

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit c2ace6300600c634553657785dfe5ea0ed688ac2 ]

If we read txq->read_ptr without lock, we can read the same
value twice, then obtain the lock, and reclaim from there
to two different places, but crucially reclaim the same
entry twice, resulting in the WARN_ONCE() a little later.
Fix that by reading txq->read_ptr under lock.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://msgid.link/20240319100755.bf4c62196504.I978a7ca56c6bd6f1bf42c15aa923ba03366a840b@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ Change read_ptr definition according to commit
413be839bfca9("wifi: iwlwifi: add a validity check of queue_id in iwl_txq_reclaim"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
---
 drivers/net/wireless/intel/iwlwifi/queue/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/queue/tx.c b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
index cd852b95d812..d8322a40409b 100644
--- a/drivers/net/wireless/intel/iwlwifi/queue/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/queue/tx.c
@@ -1524,7 +1524,7 @@ void iwl_txq_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 {
 	struct iwl_txq *txq = trans->txqs.txq[txq_id];
 	int tfd_num = iwl_txq_get_cmd_index(txq, ssn);
-	int read_ptr = iwl_txq_get_cmd_index(txq, txq->read_ptr);
+	int read_ptr;
 	int last_to_free;
 
 	/* This function is not meant to release cmd queue*/
@@ -1532,6 +1532,7 @@ void iwl_txq_reclaim(struct iwl_trans *trans, int txq_id, int ssn,
 		return;
 
 	spin_lock_bh(&txq->lock);
+	read_ptr = iwl_txq_get_cmd_index(txq, txq->read_ptr);
 
 	if (!test_bit(txq_id, trans->txqs.queue_used)) {
 		IWL_DEBUG_TX_QUEUES(trans, "Q %d inactive - ignoring idx %d\n",
-- 
2.34.1

