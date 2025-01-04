Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA71E4C9D;
	Sat,  4 Jan 2025 19:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736020516; cv=none; b=arYOGzHLuN2/oXKcEADrVbpyxzPqUFt7BhVeUQEXxiBm5k08LbcwutSoou0k4l928O77KlYroDF8f19xn7ZHCCDHSXzywA5ZBYi2MFgsUJoTgKPV45mF5qpfq0RUTpax3SX6i6qC8BM0dPok3GnArIKUXL/rxsM3ihFSZbdymIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736020516; c=relaxed/simple;
	bh=oHDA32o+U5oPLCmiNhG1EMtfzMcJVxQ0tiU747li8eg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=RR4kWdwwfeDit1rHYT9/2V57imjPZ77fhNSWSJy91jv47zOugipA+ZnhqcbkaE/VZPH72hIM4lb5DwyWnyKPcwdx0PFVeGGRaDFAMLxtqCHAqAgaMFvUO5OhZz/fB9Wkudc93wUQp8j3hJka8VoX5jFmehvVHtPRFPuuSvfi1vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TjwNZ/YS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TjwNZ/YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B4EC4CED1;
	Sat,  4 Jan 2025 19:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736020516;
	bh=oHDA32o+U5oPLCmiNhG1EMtfzMcJVxQ0tiU747li8eg=;
	h=From:To:Subject:Date:From;
	b=TjwNZ/YSw/LHHbABlPLRxUXuOMCeX9+i7Hez2DqKETYkrjzkcRpWmk4xTtUciJgJP
	 IKfKyZl/2u6rTWUZnvoEjf5ey+UTg5PVMTdREfPigTPrU/VJyoYt+FHbWHNsppCEXT
	 Qd7FsyZi0rbzXRmQVpzkhJ0aRKsArB2y74CvaMdm/di8CjkAzJjClyW09VOeGUsKpo
	 sJCD72fC66OOkw6BuEI/6FTKMNK0XGJ8pzjif0sZZv3OkqnL1JxejNbgMUAsGr2ICW
	 6jE8WnvhFScUGp0c1bKEzz6DZhUDJm+tG7NrNeUqLJQ7ccUX9bd+ndqNU+hTvfsAfS
	 0CryA+4M99wVQ==
From: akemnade@kernel.org
To: kvalo@kernel.org,
	rmk+kernel@armlinux.org.uk,
	johannes.berg@intel.com,
	miriam.rachel.korenblit@intel.com,
	leitao@debian.org,
	andreas@kemnade.info,
	emmanuel.grumbach@intel.com,
	tony@atomide.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] wifi: wlcore: fix unbalanced pm_runtime calls
Date: Sat,  4 Jan 2025 20:55:07 +0100
Message-Id: <20250104195507.402673-1-akemnade@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andreas Kemnade <andreas@kemnade.info>

If firmware boot failes, runtime pm is put too often:
[12092.708099] wlcore: ERROR firmware boot failed despite 3 retries
[12092.708099] wl18xx_driver wl18xx.1.auto: Runtime PM usage count underflow!
Fix that by redirecting all error gotos before runtime_get so that runtime is
not put.

Fixes: c40aad28a3cf ("wlcore: Make sure firmware is initialized in wl1271_op_add_interface()")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
---
Changes in V2:
- add fixes
- fix one more place

 drivers/net/wireless/ti/wlcore/main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 986b07bfa0ee8..8fb58a5d911cb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2612,24 +2612,24 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags) ||
 	    test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)) {
 		ret = -EBUSY;
-		goto out;
+		goto out_unlock;
 	}
 
 
 	ret = wl12xx_init_vif_data(wl, vif);
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 
 	wlvif->wl = wl;
 	role_type = wl12xx_get_role_type(wl, wlvif);
 	if (role_type == WL12XX_INVALID_ROLE_TYPE) {
 		ret = -EINVAL;
-		goto out;
+		goto out_unlock;
 	}
 
 	ret = wlcore_allocate_hw_queue_base(wl, wlvif);
 	if (ret < 0)
-		goto out;
+		goto out_unlock;
 
 	/*
 	 * TODO: after the nvs issue will be solved, move this block
@@ -2644,7 +2644,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 		ret = wl12xx_init_fw(wl);
 		if (ret < 0)
-			goto out;
+			goto out_unlock;
 	}
 
 	/*
-- 
2.39.5

