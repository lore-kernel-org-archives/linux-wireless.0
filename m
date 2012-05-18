Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56669 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2ERPvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2012 11:51:44 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20406.28602.202364.895590@gargle.gargle.HOWL> (sfid-20120518_175147_998110_568716EA)
Date: Fri, 18 May 2012 21:20:18 +0530
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 06/10] ath9k_hw: fix BT RF performance
In-Reply-To: <1337350053-15491-6-git-send-email-rmanohar@qca.qualcomm.com>
References: <1337350053-15491-1-git-send-email-rmanohar@qca.qualcomm.com>
	<1337350053-15491-6-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
>  bool ath9k_hw_phy_disable(struct ath_hw *ah)
>  {
> +	if (AR_SREV_9462(ah))
> +		ar9003_mci_bt_gain_ctrl(ah);
> +

ath9k_hw_mci_is_enabled() from my series should probably be used here.

Sujith
