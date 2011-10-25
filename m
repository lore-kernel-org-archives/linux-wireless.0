Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8499 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1JYLnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 07:43:16 -0400
Message-ID: <4EA6A0CF.70806@qca.qualcomm.com> (sfid-20111025_134321_510324_6F55725D)
Date: Tue, 25 Oct 2011 14:43:11 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <nataraja@qca.qualcomm.com>,
	<athiruve@qca.qualcomm.com>
Subject: Re: [PATCH 34/34] ath6kl: Enable not more than one interface to workaround
 target assert
References: <1319537430-12459-1-git-send-email-vthiagar@qca.qualcomm.com> <1319537430-12459-35-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1319537430-12459-35-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 01:10 PM, Vasanthakumar Thiagarajan wrote:
> Configuring the firmware for three interfaces causes random
> target assert. So restrict the number of vifs to just 1
> to avoid this issue for now. Once it is fixed in firmware,
> this patch would be reverted.

Patches 32-34 are problematic. They are changing functionality of
patches earlier in the series. (I guess you created those patches
later.) Instead you should edit the original patches, not just add extra
patches on top.

For example, having this patch will break bisect as ath6kl will be
broken between the patch enabling multi interface functionality
(whatever patch that is) and this patch.

Kalle
