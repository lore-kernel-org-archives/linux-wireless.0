Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35290 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab1ISRjv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 13:39:51 -0400
Message-ID: <4E777E5D.7040207@openwrt.org> (sfid-20110919_193958_891251_9705E58F)
Date: Mon, 19 Sep 2011 19:39:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	rodrigue@qca.qualcomm.com
Subject: Re: [PATCH 12/12] ath9k: do not insert padding into tx buffers on
 AR9380+
References: <1316028267-34187-5-git-send-email-nbd@openwrt.org> <1316028267-34187-6-git-send-email-nbd@openwrt.org> <1316028267-34187-7-git-send-email-nbd@openwrt.org> <1316028267-34187-8-git-send-email-nbd@openwrt.org> <1316028267-34187-9-git-send-email-nbd@openwrt.org> <1316028267-34187-10-git-send-email-nbd@openwrt.org> <1316028267-34187-11-git-send-email-nbd@openwrt.org> <1316028267-34187-12-git-send-email-nbd@openwrt.org> <20110919144002.GA22040@vmraj-lnx.users.atheros.com> <4E7759CA.4010100@openwrt.org> <20110919164714.GA1234@vmraj-lnx.users.atheros.com>
In-Reply-To: <20110919164714.GA1234@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-09-19 6:47 PM, Rajkumar Manoharan wrote:
> On Mon, Sep 19, 2011 at 05:03:38PM +0200, Felix Fietkau wrote:
>>  On 2011-09-19 4:40 PM, Rajkumar Manoharan wrote:
>>  >On Wed, Sep 14, 2011 at 09:24:27PM +0200, Felix Fietkau wrote:
>>  >>  With the new EDMA descriptor format, a single descriptor can contain up
>>  >>  to four buffer pointers. By splitting the buffer into two parts, we can
>>  >>  let the hardware add the padding internally instead of using memmove on
>>  >>  the skb data.
>>  >>
>>  >>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>  >>  ---
>>  >>   drivers/net/wireless/ath/ath9k/xmit.c |   56 +++++++++++++++++++++-----------
>>  >>   1 files changed, 37 insertions(+), 19 deletions(-)
>>  >>
>>  >Felix,
>>  >
>>  >This patch again introduced "ath: Failed to stop TX DMA!" for AR9380+ chips.
>>  >After reverting this, the errors are completely gone away. Please look into this ASAP.
>>  How frequent are these errors in your tests? I ran several tests on
>>  embedded hardware with AR9380 and didn't notice any issues.
> With this patch after the association and in idle state, the connection seems to be very unstable.
> Please refer the following log.
OK. This patch should be reverted then until we figure out what's going on.

- Felix
