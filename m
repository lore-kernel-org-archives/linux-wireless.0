Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from skprod2.natinst.com ([130.164.80.23]:58739 "EHLO ni.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751502AbcJCSBM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 14:01:12 -0400
From: James Minor <james.minor@ni.com>
To: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Cc: kvalo@qca.qualcomm.com, julia.cartwright@ni.com,
        steve.derosier@lairdtech.com, James Minor <james.minor@ni.com>
Subject: [PATCH 0/3] Allow ath6kl to be restarted
Date: Mon, 3 Oct 2016 13:00:01 -0500
Message-Id: <1475517604-17710-1-git-send-email-james.minor@ni.com> (sfid-20161003_200116_240215_40CEA498)
In-Reply-To: <1475510510-16906-1-git-send-email-james.minor@ni.com>
References: <1475510510-16906-1-git-send-email-james.minor@ni.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To work around a boot issue with the AR6234, I discovered a few
instances where error cleanup code is not working as expected.
A full solution for the boot issue is being worked up, but in the
mean time these fixes make error cleanup work properly.

James Minor (3):
  ath6kl: fix busreqs so they can be reused when sg is cleaned up
  ath6kl: after cleanup properly reflect that sg is disabled
  ath6kl: configure SDIO when power is reapplied

 drivers/net/wireless/ath/ath6kl/sdio.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

-- 
1.9.1
