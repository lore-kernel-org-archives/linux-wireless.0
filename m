Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.5
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792505522;
	b=gKqcodafxP717R7qzm2rjB7X5et6ZDAYWROmTvDg4Ppw/EPlyjLRnUhaBeamKQ9uMD6P
	 BG7RARlWw382ihG/Z/DCb9DK2POETd9I13dtmCCoMRVpMryEspwAw/1r7G3HwrbwCZykl
	 2RWizTD6JGFDV7U3tmaLAuMXNQi1CyUt6ZGqhGX8c3mxORYLA358eyhJ/CJhYWDznBDn4
	 QJJAI0RlGVwhffob+f52mLVOteW5kR4aZdnP9wb0PiwVOqvg2i3qhjbsX7KaXAfzZ+Vqe
	 E/XKUQqGLWMTyqWW3MexEIGVhavnHINwIfxbFKWJImPjE5bYiwQEUo2KBDH7+O5hV0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505522;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-CM-SenderInfo;
	bh=YC4U1c7hM7z4cHCi0xG72ityc8fJiVCk37JEO6H/WUM=;
	b=Ooi5dNQFFXom91o0hAXmRLpQwEi1U3hww5gt7u34D87OHkGkdorDI+jc8cNinf/eOsbG
	 AEDjlTmo6KFrUtyOYicQ9ZmUzovS140L354Y5OVjSgnRjx1XuvHgvus3woeY0MgASpdA/
	 NZ9qx18IvYb35j9zAY6Rfr60P3ndScnnrobzZHsF+w8AJA4zqJD/yTnRSm8eD660ThxSF
	 wuhdhdQDOy91V7GrdsOwJ/VN8BsOedlHj8pGdi657kpoVV3Il9eWSyUqwTu3meCDmkylg
	 xESPTDeGNOzOqRDq+IOFQ8kNBJO0QHowYS+W2ioKsbtPBwYojFdjPQqf9y8cfgAq+qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=nofE6bjq;
	arc=none smtp.remote-ip=117.135.210.5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58CE60A3810;
	Tue, 20 Oct 2026 14:11:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C58CE60A3810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=nofE6bjq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=YC
	4U1c7hM7z4cHCi0xG72ityc8fJiVCk37JEO6H/WUM=; b=nofE6bjqkUzYRnhi5R
	AKk+peBPajg21dp5T5lH7zPj/jmcBBEZ6QBqqAQPepM2Ls+dgmVvzqE3/kvpgg9Z
	BdRemZX849l7oOj3t6UpLqvH0ht3IcTyQAdVIExafKLJyRu4B1SO7UApRQExDFm5
	BmxRSO5SP5Ey36+r/ijuqZdYk=
Received: from flipped.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgA36wqfdtdqmBjOAw--.52376S2;
	Tue, 20 Oct 2026 22:11:43 +0800 (CST)
From: Sicong Huang <congei42@163.com>
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	emmanuel.grumbach@intel.com,
	avraham.stern@intel.com,
	pagadala.yesu.anjaneyulu@intel.com,
	ilan.peer@intel.com,
	avinash.bhatt@intel.com,
	Sicong Huang <congei42@163.com>
Subject: [PATCH] wifi: iwlwifi: mld: fix use-after-free in timestamp marker work
Date: Tue, 20 Oct 2026 22:11:41 +0800
Message-Id: <20261020141141.388618-1-congei42@163.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgA36wqfdtdqmBjOAw--.52376S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJr13ur1rKw1rGryxCF1fCrg_yoW5JFyUpF
	Z5Wry2kr4vkw4vg34fAF4xZF98Jan8J39rGF4vk398urnYvF1rJr1jgFWjga40qr4DJ34a
	9F45tFW7WFs0qFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEG-eUUUUUU=
X-CM-SenderInfo: 5frqwvrlusqiywtou0bp/xtbC1B9VSGrXdp8UtwAA3h

Writing a period to the timestamp_marker debugfs file schedules
fwrt->timestamp.wk without checking whether the firmware is running.
The work tries to send a MARKER_CMD and reschedules itself if the
command was submitted successfully and the period is nonzero.

MLD does not cancel this work when it stops the firmware or tears down
the op mode. iwl_fw_runtime_free() only cancels the firmware dump
works. The work is embedded in struct iwl_fw_runtime, which is part
of struct iwl_mld (hw->priv). So if the work is still pending, it can
run after ieee80211_free_hw() has freed that memory. It then reads
fwrt->timestamp.delay, fwrt->fw and fwrt->trans, may increment
fwrt->timestamp.seq, and may reschedule the freed work. The period is
in seconds while teardown takes milliseconds, so a pending work at
unbind or rmmod time is the normal case, not a narrow race.

MVM already avoids this by calling iwl_fw_cancel_timestamp() when it
stops the device. Do the same in MLD: cancel the work in
iwl_mld_stop_fw() before the firmware is stopped. Also cancel it in
iwl_op_mode_mld_stop() before the memory that embeds it is freed,
because the work can be scheduled even when the firmware is already
stopped.

Signed-off-by: Sicong Huang <congei42@163.com>
---
 drivers/net/wireless/intel/iwlwifi/mld/fw.c  | 2 ++
 drivers/net/wireless/intel/iwlwifi/mld/mld.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/fw.c b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
index 7b1fb84a641c..ad529f9eb5f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/fw.c
@@ -355,6 +355,8 @@ void iwl_mld_stop_fw(struct iwl_mld *mld)
 {
 	lockdep_assert_wiphy(mld->wiphy);
 
+	iwl_fw_cancel_timestamp(&mld->fwrt);
+
 	iwl_abort_notification_waits(&mld->notif_wait);
 
 	iwl_fw_dbg_stop_sync(&mld->fwrt);
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 6e991fb99ff3..6972846f40af 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -519,6 +519,8 @@ iwl_op_mode_mld_stop(struct iwl_op_mode *op_mode)
 
 	ieee80211_unregister_hw(mld->hw);
 
+	iwl_fw_cancel_timestamp(&mld->fwrt);
+
 	iwl_fw_runtime_free(&mld->fwrt);
 	iwl_mld_low_latency_free(mld);
 
-- 
2.34.1

