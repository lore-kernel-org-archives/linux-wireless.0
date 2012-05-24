Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61333 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2EXHZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 03:25:52 -0400
Message-ID: <4FBDE27A.2050900@qca.qualcomm.com> (sfid-20120524_092556_661251_B59C0413)
Date: Thu, 24 May 2012 10:25:46 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: Add support for setting tx rateset.
References: <1337673192-3469-1-git-send-email-bkamatch@qca.qualcomm.com>
In-Reply-To: <1337673192-3469-1-git-send-email-bkamatch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2012 10:53 AM, Bala Shanmugam wrote:
> Tx legacy and mcs rateset can configured using iw for
> 2.4 and 5 bands.  Add support for the same in driver.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>

Thanks, this looks very good now. I did two minor changes still:

    kvalo: add an enum for the hw flags and rename the flag accordingly,
    rename ath6kl_cfg80211_set_bitrate_mask() to a shorter version to make
    it easier to indent

The enum looks like this:

enum ath6kl_hw_flags {
	ATH6KL_HW_FLAG_64BIT_RATES	= BIT(0),
};

And I did that just to make it more obvious to group the flags in the
future.

Kalle
