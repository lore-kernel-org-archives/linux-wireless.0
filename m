Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F9922173D;
	Sat,  7 Feb 2026 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770476988; cv=none; b=s0XvmAK9z8BvZSXVB+/66QI4IoclE5/Fs0E9halaLtqmAtMwhrB/M9e7Js5JjwqVCkgERc69Nx+85M06ne9wDSmm8Vv75CvqHcYMVJDNSsBIEHrL/NNUIekJRTSvMDKBDy7tO0j/4ewingjHWlu0bFz4NRYP4FHxMnaU1k7EYo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770476988; c=relaxed/simple;
	bh=ntqS6Hi6sUAKH/ZDIGLTcn02et3wjX120iViBGFRQn8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p15Mfj1yKumPVYnFtIj3jkOkgJULcbxk/0uZGwTadoT7DYJ44hWRyWFWUaY78YbinxxM13U+rUynC+FjYQALut6k2pj3tMznPpXm80oh73CWtx0jyoSxYbjmyyb3OYEn90rAIkrC+9v2Q57nImk14x6NTWw1cA/TznNA8a90Pek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=m8Wpg+Ug; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="m8Wpg+Ug"
Received: from VelichayshiyPC.Dlink (unknown [178.69.122.189])
	by mail.ispras.ru (Postfix) with ESMTPSA id 125C5413A4B2;
	Sat,  7 Feb 2026 15:03:52 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 125C5413A4B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1770476632;
	bh=/qEIU5I5Xgf3An75d/v1ahrbLEp4l5LAVk9J8fIPUXY=;
	h=From:To:Cc:Subject:Date:From;
	b=m8Wpg+Ug0djcmDbuhBIUud5vaD0gHii9/imVMNAJXbLk557Sjyx7xPm04D6WePsXh
	 0RXjafddEYW0m5wCKM2SZvcRBT0WwnwBFZ2KlJfv7ENVG2zyIrIwKRNWCywH90zF0V
	 F8MxUV6FtwQoD6JKINg9ZUniWEICxbmoPMu57yVk=
From: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
To: a.velichayshiy@ispras.ru,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org
Subject: [PATCH] wifi: iwlwifi: mvm: fix potential out-of-bounds read in iwl_mvm_nd_match_info_handler()
Date: Sat,  7 Feb 2026 18:03:22 +0300
Message-ID: <20260207150335.1013646-1-a.velichayshiy@ispras.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memcpy function assumes the dynamic array notif->matches is at least
as large as the number of bytes to copy. Otherwise, results->matches may
contain unwanted data. To guarantee safety, extend the validation in one
of the checks to ensure sufficient packet length.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
---
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index 07f1a84c274e..c3ad414ac85e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -2834,7 +2834,7 @@ static void iwl_mvm_nd_match_info_handler(struct iwl_mvm *mvm,
 	if (IS_ERR_OR_NULL(vif))
 		return;
 
-	if (len < sizeof(struct iwl_scan_offload_match_info)) {
+	if (len < sizeof(struct iwl_scan_offload_match_info) + matches_len) {
 		IWL_ERR(mvm, "Invalid scan match info notification\n");
 		return;
 	}
-- 
2.43.0

