Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39691 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753550AbdCTPMR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:12:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.11] ath10k: fix incorrect wlan_mac_base in qca6174_regs
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1489445343-8719-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1489445343-8719-1-git-send-email-ryanhsu@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qca.qualcomm.com>
Message-ID: <61056b2da2f84bc0bc1def2646729c2c@euamsexm01a.eu.qualcomm.com> (sfid-20170320_161240_518917_6F7A6575)
Date: Mon, 20 Mar 2017 16:12:09 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qca.qualcomm.com> wrote:
> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> 
> In the 'commit ebee76f7fa46 ("ath10k: allow setting coverage class")',
> it inherits the design and the address offset from ath9k, but the address
> is not applicable to QCA6174, which leads to a random crash while doing the
> resume() operation, since the set_coverage_class.ops will be called from
> ieee80211_reconfig() when resume() (if the wow is not configured).
> 
> Fix the incorrect address offset here to avoid the random crash.
> 
> Verified on QCA6174/hw3.0 with firmware WLAN.RM.4.4-00022-QCARMSWPZ-2.
> 
> Fixes: ebee76f7fa46 ("ath10k: allow setting coverage class")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Patch applied to ath-current branch of ath.git, thanks.

6be3b6cce1e2 ath10k: fix incorrect wlan_mac_base in qca6174_regs

-- 
https://patchwork.kernel.org/patch/9622251/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
