Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from condef009-v.nifty.com ([210.131.4.246]:52197 "EHLO
        condef009-v.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932286AbcIFMlc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2016 08:41:32 -0400
From: Masahiro Yamada <yamada.masahiro@socionext.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath10k@lists.infradead.org
Subject: [PATCH 0/3] ath10k: a little bit clean-up of ATH10K driver
Date: Tue,  6 Sep 2016 21:39:55 +0900
Message-Id: <1473165598-28683-1-git-send-email-yamada.masahiro@socionext.com> (sfid-20160906_144140_075539_C48F454B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Clean-up code with devm_clk_get() and devm_reset_control_get().

I know devm_reset_control_get() should be replaced with
either devm_reset_control_get_exclusive() or
devm_reset_control_get_shared().

My best guess is devm_reset_control_get_shared() for this case,
but I am not 100% sure, so I am leaving it to other developers.



Masahiro Yamada (3):
  ath10k: use devm_clk_get() instead of clk_get()
  ath10k: use devm_reset_control_get() instead of reset_control_get()
  ath10k: do not check if reset is NULL

 drivers/net/wireless/ath/ath10k/ahb.c | 105 +++++++---------------------------
 1 file changed, 21 insertions(+), 84 deletions(-)

-- 
1.9.1
