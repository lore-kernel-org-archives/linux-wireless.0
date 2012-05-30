Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57532 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2E3F3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 May 2012 01:29:30 -0400
Message-ID: <4FC5B033.7020900@qca.qualcomm.com> (sfid-20120530_072935_001791_13C4F639)
Date: Wed, 30 May 2012 08:29:23 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kiran Reddy <c_lreddy@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath6kl: separate ht cap for each band
References: <1338315170-9940-1-git-send-email-c_lreddy@qca.qualcomm.com>
In-Reply-To: <1338315170-9940-1-git-send-email-c_lreddy@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/29/2012 09:12 PM, Kiran Reddy wrote:
> In virtual interface structure, for each band separate ht cap
> is needed. so that one can disable or enable ht capability band
> wise.
> This will fix the following issue:
> 
> 1) Disable 11n from supplicant and start a P2P GO.
> 2) In beacon frames no HT-CAP IE is seen which is expected.
> 3) Now remove the P2P GO and kill the supplicant.
> 4) Beacon stops
> 5) Now using iw  associate to an external AP in 5 GHZ
> 6) In 5 GHZ no HT IE going in assoc request but
> when  associated in 2.4 GHZ can see HT IES over the air
> in assoc request.
> 
> In the code for del_beacon in cfg80211.c,set_ht_cap is being
> called first for 2.4 GHZ and then for 5 GHZ. When  called
> for the first time for 2.4 GHZ the enable flag will be set to true
> and so when called for the second time for 5 GHZ it just returns
> after checking the flag.
> 
> Also using this one can have different HT capabilities
> per band (for example one may decide not to use 20/40 in 2.4 GHZ
> but use it in 5 GHZ). So maintaining a single context is not ok.
> it is true for even the enable/disable flag and other HT
> capabilities as well
> 
> Signed-off-by: Kiran Reddy <c_lreddy@qca.qualcomm.com>

Thanks, applied.

Kalle
