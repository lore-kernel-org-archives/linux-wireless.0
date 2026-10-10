Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB1B37B02D;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791600144; cv=none; b=gsUXO0H6KPs5VH19b0wMRB3iiOrNuDC15qXOQZKd2srhC21ljrkWdSUMHuJSCJn+tZ2gGmRzpeetepyv3rB4NPv7HnYSBKpTyS51eAVatadhDaYnbb2lAI384AajUI+rF4YvhjUQ9feyCOngocbvmorAjUX3YaE/kz+AChbzR+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791600144; c=relaxed/simple;
	bh=S57sgVcE/7Jei4pRIK3BUSdo5UYSccERXm9nve4j2CM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=qLFEMNNLhSyuPZzi9D2UOHEbi9AzM6DJou4Yg7M8a1620TYQZF7zYsM/8YNmDNw9/oUbBqLcoo9N3YwXAJeeMS86yCZoybUjZsoIeJKLBdmyM2GkiLzy4zom6HMwyIET9siZpbst7RiJgckoyPpIaxedvpRmThJlD50KFyzbnZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iecd3/TQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iecd3/TQ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C059AC2BCF4;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791600143;
	bh=S57sgVcE/7Jei4pRIK3BUSdo5UYSccERXm9nve4j2CM=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Iecd3/TQlt/PwPuVx1nTQDyOO6tx0bq3KfQmtr1/cAAF9xbdttElJ/tKS9hYOaqBu
	 7RJzoOgNFPStnFfw0s5DjJ3qaepHAiBMZg9Pb5gcIAFNNcni1dJFD02/xpKBLccERj
	 xDWBx7mLU3PUD8uPqu6E5dLDp5ci0PFb9zwl8PflgcUu1Cd2jqm11FS1cdHntfCtMj
	 70zVHrVg2n/SBXfvEHutIXnoxhjr45wLmtKCS+e5a96HN6kvaW9ekVK9FZtXNMZ6rn
	 i0b9nnlBd7xSOEQrlUBQZ2V9hNOHPQJxmcIXAB1TO9E18v30SfxZ0o9K7tsj8Lnw2k
	 LYGCvB/S/yBTA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C20CA9EBE;
	Sat, 10 Oct 2026 02:42:23 +0000 (UTC)
From: benthecarman via B4 Relay <devnull+benthecarman1.gmail.com@kernel.org>
Subject: [PATCH 0/2] wifi: iwlwifi: fix legacy-rate injection outside 2.4
 GHz
Date: Fri, 09 Oct 2026 21:42:21 -0500
Message-Id: <20261009-next-v1-0-b370f5302d27@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDAwNL3bzUihLdlEQLCxMDE4tUMzNzJaDSgqLUtMwKsDHRsbW1ABJ2MpB
 WAAAA
X-Change-ID: 20261009-next-da884048e667
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, 
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 benthecarman <benthecarman@live.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791600143; l=1858;
 i=benthecarman1@gmail.com; s=20261009; h=from:subject:message-id;
 bh=S57sgVcE/7Jei4pRIK3BUSdo5UYSccERXm9nve4j2CM=;
 b=ZmdkOA3SQ9vUOhlhIRrMIcoHuMpaIiWEpQGlAg0RzOVPuAb6Z1mmBQDSttQxOt890+47RbEYD
 At09DbQ9hVKBXj9B1MBRpWDhyRarTOKX2dOFnDuTtLsywC/E2f5y2J6
X-Developer-Key: i=benthecarman1@gmail.com; a=ed25519;
 pk=8RDA9X90+5wKUu3kkgPYpamlxYvX93l7iXqMWrkhvOY=
X-Endpoint-Received: by B4 Relay for benthecarman1@gmail.com/20261009 with
 auth_id=1149
X-Original-From: benthecarman <benthecarman1@gmail.com>
Reply-To: benthecarman1@gmail.com

Both op modes pass mac80211's legacy rate index for an injected frame
to the driver's rate conversion unchanged. Outside 2.4 GHz that index
points into a bitrate table starting at 6 Mbps, so every injected
legacy rate is shifted down by the four CCK rates: 12 Mbps on 5 GHz
goes out as 5.5 Mbps CCK, which nothing on that band can receive.

I found this bringing up userspace AWDL (OWL) on an AX211: the peer
heard none of our data frames until the rate was remapped. Patch 1
(mvm) was tested on that hardware; patch 2 (mld) is the same fix and
build-tested only, as I have no iwlmld device.

Testing: patch 1 was tested on an Intel AX211 (iwlmvm, firmware
89.123cf747.0) with the same change applied to Ubuntu's 7.0.0-38
kernel, injecting AWDL frames at a radiotap rate of 12 Mbps on channel
44 (5220 MHz). Before, the TX response showed status 0x83 (long retry
limit) and rate_n_flags 0x8002; after, status 0x1, no retries,
rate_n_flags 0x8102, and the peer ACKed every frame. Against
iwlwifi-next both mvm/tx.c and mld/tx.c build without warnings at W=1,
but I could not boot an iwlwifi-next kernel, and patch 2 is untested
at runtime.

The bug was found, and the patches written, with help from an AI
assistant (Claude) during that debugging session; I reviewed and
tested them as described above.

Signed-off-by: benthecarman <benthecarman@live.com>
---
benthecarman (2):
      wifi: iwlwifi: mvm: Fix injected 5 GHz legacy rate
      wifi: iwlwifi: mld: Fix injected 5 GHz legacy rate

 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 11 ++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c |  8 ++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)
---
base-commit: 5d017b30f502e20bfb96ba534b1c36f060a06e98
change-id: 20261009-next-da884048e667

Best regards,
-- 
benthecarman <benthecarman1@gmail.com>


