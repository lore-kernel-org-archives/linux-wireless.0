Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40618 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1ISPDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 11:03:51 -0400
Message-ID: <4E7759CA.4010100@openwrt.org> (sfid-20110919_170354_393187_373262D2)
Date: Mon, 19 Sep 2011 17:03:38 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 12/12] ath9k: do not insert padding into tx buffers on
 AR9380+
References: <1316028267-34187-3-git-send-email-nbd@openwrt.org> <1316028267-34187-4-git-send-email-nbd@openwrt.org> <1316028267-34187-5-git-send-email-nbd@openwrt.org> <1316028267-34187-6-git-send-email-nbd@openwrt.org> <1316028267-34187-7-git-send-email-nbd@openwrt.org> <1316028267-34187-8-git-send-email-nbd@openwrt.org> <1316028267-34187-9-git-send-email-nbd@openwrt.org> <1316028267-34187-10-git-send-email-nbd@openwrt.org> <1316028267-34187-11-git-send-email-nbd@openwrt.org> <1316028267-34187-12-git-send-email-nbd@openwrt.org> <20110919144002.GA22040@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110919144002.GA22040@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-19 4:40 PM, Rajkumar Manoharan wrote:
> On Wed, Sep 14, 2011 at 09:24:27PM +0200, Felix Fietkau wrote:
>>  With the new EDMA descriptor format, a single descriptor can contain up
>>  to four buffer pointers. By splitting the buffer into two parts, we can
>>  let the hardware add the padding internally instead of using memmove on
>>  the skb data.
>>
>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  ---
>>   drivers/net/wireless/ath/ath9k/xmit.c |   56 +++++++++++++++++++++-----------
>>   1 files changed, 37 insertions(+), 19 deletions(-)
>>
> Felix,
>
> This patch again introduced "ath: Failed to stop TX DMA!" for AR9380+ chips.
> After reverting this, the errors are completely gone away. Please look into this ASAP.
How frequent are these errors in your tests? I ran several tests on 
embedded hardware with AR9380 and didn't notice any issues.

- Felix
