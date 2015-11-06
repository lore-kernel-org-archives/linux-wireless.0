Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.danego.net ([195.246.116.61]:64621 "EHLO smtp.danego.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161377AbbKFONB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 09:13:01 -0500
From: =?iso-8859-1?Q?Robert_Deli=EBn?= <robert@delien.nl>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>
Subject: RE: [PATCH 1/1] ath6kl: Fix SDIO broken scatter hif-scatter
Date: Fri, 6 Nov 2015 14:13:00 +0000
Message-ID: <6EA3E0BCC03CC34B89B01BD57ECBC718B17B27E5@POBOX.postoffice.danego.net> (sfid-20151106_151306_272394_7E811703)
References: <6EA3E0BCC03CC34B89B01BD57ECBC718B17AFE41@POBOX.postoffice.danego.net>
In-Reply-To: <6EA3E0BCC03CC34B89B01BD57ECBC718B17AFE41@POBOX.postoffice.danego.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have found the original post of this patch:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/210624.html
So all credits go to the original author, Jason Liu.

After reading Kalle's comments, I have isolated the cause of my problem and it turns out to be the major bug in drivers/net/wireless/ath/ath6kl/hif.h, causing hif_scatter_item scat_list to corrupt scat_q_depth. At bit unfortunate that this fix wasn't taken in...

Even though I am using GCC 4.8.1, I'm probably not stressing the target hard enough to require the work-around in drivers/net/wireless/ath/ath6kl/sdio.c

