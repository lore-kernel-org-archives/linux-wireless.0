Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:51273 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbaL3NDp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 08:03:45 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	Ben Greear <greearb@candelatech.com>,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	Yanbo Li <yanbol@qti.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH 0/4] ath10k: a few incorrect return handling fix-up
Date: Tue, 30 Dec 2014 07:20:42 -0500
Message-Id: <1419942046-17985-1-git-send-email-der.herr@hofr.at> (sfid-20141230_140348_234951_6425B969)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wait_for_completion_timeout does not return negative values so the tests
for <= 0 are not needed and the case differentiation in the error handling
path unnecessary.

patch was only compile tested x86_64_defconfig + CONFIG_ATH_CARDS=m
CONFIG_ATH10K=m

patch is against linux-next 3.19.0-rc1 -next-20141226

None of the proposed cleanups are critical.
All changes should only be removing unreachable cases.
