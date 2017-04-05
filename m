Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22152 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdDEHgd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:36:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix station nss computation
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1490342248-6213-1-git-send-email-c_vnaral@qti.qualcomm.com>
References: <1490342248-6213-1-git-send-email-c_vnaral@qti.qualcomm.com>
To: <c_vnaral@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>,
        Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <1078a1d3e46744f4bf0ff96e047c54c5@euamsexm01a.eu.qualcomm.com> (sfid-20170405_093637_005669_ACD71BF0)
Date: Wed, 5 Apr 2017 09:36:26 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_vnaral@qti.qualcomm.com wrote:
> From: Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>
> 
> If station advertises diffferent NSS capabilities in Rx_mcs set
> of HT and VHT IEs in assoc req, the current NSS computation
> logic configures the NSS support only based on Rx_mcs set of
> HT capabilities in the driver. This is configuring the station
> NSS capabilities incorreclty in the target.
> 
> For example, if station advertise Rx_mcs set as 2 spatial streams
> in HT capabilities and 1 spatial streams in VHT capabilities in
> assoc request, as per current logic we are calculating nss from
> HT capabilities and the driver sets peer_num_spatial_streams as
> 2 for the station which is configured in VHT 1*1.
> 
> This patchs fix this issue by calculating the nss from VHT cap if
> station supports vht.
> 
> Signed-off-by: Venkateswara Rao Naralasetty <c_vnaral@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

fefcd11535ab ath10k: fix station nss computation

-- 
https://patchwork.kernel.org/patch/9642345/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
