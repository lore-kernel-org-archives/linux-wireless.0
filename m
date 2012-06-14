Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21778 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab2FNWEz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 18:04:55 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Message-ID: <20442.24505.509266.393452@gargle.gargle.HOWL> (sfid-20120615_000459_190355_45A29452)
Date: Fri, 15 Jun 2012 03:33:37 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>, <c_manoha@qca.qualcomm.com>,
	<thomas@net.t-labs.tu-berlin.de>
Subject: [PATCH 3.5] ath9k: fix invalid pointer access in the tx path
In-Reply-To: <1339709262-59805-1-git-send-email-nbd@openwrt.org>
References: <1339709262-59805-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> After setup_frame_info has been called, only info->control.rates is still
> valid, other control fields have been overwritten by the ath_frame_info
> data. Move the access to info->control.vif for checking short preamble
> to setup_frame_info before it gets overwritten.
> 
> This regression was introduced in commit d47a61aa
> "ath9k: Fix multi-VIF BSS handling"
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Thomas Hühn <thomas@net.t-labs.tu-berlin.de>
> Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> Cc: stable@vger.kernel.org [3.4]

Acked-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Sujith
