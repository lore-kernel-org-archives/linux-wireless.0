Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58927 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab1EJEkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 00:40:40 -0400
Subject: [PATCH 2/2] ath6kl: provide hardware version to userspace
To: gregkh@suse.de
From: Kalle Valo <kvalo@adurom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Date: Tue, 10 May 2011 07:40:34 +0300
Message-ID: <20110510044034.29589.95929.stgit@localhost6.localdomain6> (sfid-20110510_064045_860605_87234314)
In-Reply-To: <20110510044023.29589.38450.stgit@localhost6.localdomain6>
References: <20110510044023.29589.38450.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@atheros.com>

Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
---
 drivers/staging/ath6kl/os/linux/ar6000_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
index 513f205..48dd9e3 100644
--- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
+++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
@@ -1732,6 +1732,7 @@ ar6000_avail_ev(void *context, void *hif_handle)
 
         ar->arVersion.target_ver = targ_info.target_ver;
         ar->arTargetType = targ_info.target_type;
+	wdev->wiphy->hw_version = targ_info.target_ver;
     }
 
     r = ar6000_configure_target(ar);

