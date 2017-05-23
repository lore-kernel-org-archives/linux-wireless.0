Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61217 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750846AbdEWP3D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 11:29:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix reported HT MCS rates with NSS > 1
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170511090930.18205-1-sven.eckelmann@openmesh.com>
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: <ath10k@lists.infradead.org>, <akolli@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Message-ID: <0a29ec25ec374a12adbc222af9a7dda1@euamsexm01a.eu.qualcomm.com> (sfid-20170523_172911_795449_3C26164A)
Date: Tue, 23 May 2017 17:28:55 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:
> The QCA4019 firmware 10.4-3.2.1-00050 reports only HT MCS rates between
> 0-9. But 802.11n MCS rates can be larger than that. For example a 2x2
> device can send with up to MCS 15.
> 
> The firmware encodes the higher MCS rates using the NSS field. The actual
> calculation is not documented by QCA but it seems like the NSS field can be
> mapped for HT rates to following MCS offsets:
> 
>  * NSS 1: 0
>  * NSS 2: 8
>  * NSS 3: 16
>  * NSS 4: 24
> 
> This offset therefore has to be added for HT rates before they are stored
> in the rate_info struct.
> 
> Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>

Patch applied to ath-next branch of ath.git, thanks.

c1dd8016ae02 ath10k: fix reported HT MCS rates with NSS > 1

-- 
https://patchwork.kernel.org/patch/9721111/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
