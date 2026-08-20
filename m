Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC1725D53B
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 09:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787219865; cv=none; b=Mh7D22g1fUHO/GF0KKthim6NrWzDQQdx9qgmQsUgldp/NZqYBUrvRJnFwouHNWhzpMFJJ7pbi3LsPlKz+0/jYkU5umMONF6jACazpK2oKJMUlCowgcKjPYfUIABKls2deOhJ1NnJ9yOV8Y/VqjISZo5DqqmfzEZ3qQpyYa7VDT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787219865; c=relaxed/simple;
	bh=q6Dq4SJ28hatE6tV0NjlehFPL8aj+8Kn4MarEg+DLro=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=o68SlDD31K1WfFSGDKL6UiCJO7o2TMDZgK4SrkaEPEppeLxe5dEKzZIB1/mz7e0H8ZJeUsJeDOpql9KIf6abwBG8jITAV0rwJHdD1XPUfdamCjPhXTHl2gHBh0PHD/quoHbrB+NBUe2IpM1/6zmGnn3QlrYm6RGTvh4rfwjkh1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=I6xtKxp/; arc=none smtp.client-ip=212.77.101.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="I6xtKxp/"
Received: (wp-smtpd smtp.wp.pl 38237 invoked from network); 20 Aug 2026 11:30:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1787218259; bh=o4iY4/RmDmGeWDWiyKsw+Vy6Q9cz1ey9JO+dwuTZ6DU=;
          h=From:To:Cc:Subject;
          b=I6xtKxp/DkzquCyavPlf2rIptBGVN4d+ulatuTVC72R9IaC8CzUHJZNVCfMNmJGqk
           zem7c0Kih6HThqRi4SHmIonHYOLu/p9rebC7KKwPBp+YHUMGKreMlyBYktkolWU5bx
           q+CSs5t+hNVCqptTSgqLnJGVZDUSr13Qu8VK27bybPYmeXgLaFHB4ulssh6VTvsUi1
           Dk73j7W2dHyCNNxi81qNlc6TIfClHAfkeDMTTxpGGZqflR19rxgTxYHS6rXDwkVPX/
           s9ziD31B0I7LaEDa7CpVWXlvPhmJkmT22l9Qdd80hJngJi1luYVkY4SpfjJe9gPhV/
           baD9BlD0UZstg==
Received: from localhost (77-236-6-58.static.play.pl [77.236.6.58])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 20 Aug 2026 11:30:59 +0200
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Cc: martin-eric.racine@iki.fi
Subject: [PATCH] wifi: iwlegacy: fix broadcast stations deallocation
Date: Thu, 20 Aug 2026 11:30:59 +0200
Message-Id: <20260820093059.18779-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 3ff769d6f53d355d192c962b98331019
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [QePQ]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

On the error path of __il4965_up(), il_dealloc_bcast_stations() clears
only IL_STA_UCODE_ACTIVE, leaving IL_STA_BCAST set. This causes the
same broadcast stations to be deallocated again by __il4965_down().

This can occur when RF_KILL is toggled during driver startup.

To fix clear the entire 'used' field, since we will not do any
other operations on the station.

Reported-and-tested-by: Martin-Éric Racine <martin-eric.racine+kernel-bugzilla@iki.fi>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221733
Fixes: c2fd34469d16 ("iwl4965: Fix a memory leak in error handling code of __il4965_up")
Cc: <stable@vger.kernel.org> # 7.1.x: 57aa1718d595 wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check
Cc: <stable@vger.kernel.org> # 6.x.x: 57aa1718d595 wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check
Cc: <stable@vger.kernel.org> # 5.x.x: 57aa1718d595 wifi: iwlegacy: replace BUG_ON() with WARN_ON() on num_stations check
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 0bb807ff8edf..e5113c6b2d5c 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -2326,7 +2326,7 @@ il_dealloc_bcast_stations(struct il_priv *il)
 		if (!(il->stations[i].used & IL_STA_BCAST))
 			continue;
 
-		il->stations[i].used &= ~IL_STA_UCODE_ACTIVE;
+		il->stations[i].used = 0;
 		il->num_stations--;
 		if (WARN_ON(il->num_stations < 0))
 			il->num_stations = 0;
-- 
2.50.1

