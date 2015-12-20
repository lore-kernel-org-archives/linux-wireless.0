Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:33679 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbbLTNZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 08:25:49 -0500
Received: by mail-pa0-f45.google.com with SMTP id cy9so3381678pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2015 05:25:49 -0800 (PST)
From: Fengwei Yin <fengwei.yin@linaro.org>
To: julian.calaby@gmail.com, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com
Cc: fengwei.yin@linaro.org, lking@qti.qualcomm.com
Subject: [PATCH v3 0/2] wcn36xx: fix crash because rx skb allocation failure
Date: Sun, 20 Dec 2015 21:20:39 +0800
Message-Id: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org> (sfid-20151220_142553_521403_B0013885)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current wcn36xx driver didn't handle rx skb allocation failure case.
It only could be triggered when system is in extremly memory shortage
case. King Lawrence <lking@qti.qualcomm.com> hit it by git clone linux
kernel tree on DragonBoard <1>.

The fixing is not to submit the old rx skb to network upper layer and 
reuse it as rx DMA buffer again.

Changes from v2:
 * Remove the ugly macro introduced in v2 per comment from Julian Calaby.
 * Seperate the DMA int mask register writing as one patch per comment
   from Bjorn Andersson.

Changes from v1:
 * Move switch block out of while loop.
 * Remove the warning of unknown channel because we didn't deal with it.

Fengwei Yin (2):
  wcn36xx: handle rx skb allocation failure to avoid system crash
  wcn36xx: split DMA mask register writing.

 drivers/net/wireless/ath/wcn36xx/dxe.c | 43 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 21 deletions(-)

-- 
2.1.4

