Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2464 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab2BPIQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 03:16:22 -0500
Message-ID: <4F3CBB4F.7070408@qca.qualcomm.com> (sfid-20120216_091650_471653_9BFEA662)
Date: Thu, 16 Feb 2012 13:46:15 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<Mohammed@venema.h4ckr.net>, <ath9k-devel@lists.ath9k.org>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC] ath9k: remove rx_bufptr
References: <1329375781-4902-1-git-send-email-mohammed@qca.qualcomm.com> <4F3CB274.1080800@openwrt.org>
In-Reply-To: <4F3CB274.1080800@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Thursday 16 February 2012 01:08 PM, Felix Fietkau wrote:
> On 2012-02-16 8:03 AM, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> it does not seems to used for anything
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> ---
>> drivers/net/wireless/ath/ath9k/ath9k.h | 1 -
>> drivers/net/wireless/ath/ath9k/recv.c | 4 ----
>> 2 files changed, 0 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h
>> b/drivers/net/wireless/ath/ath9k/ath9k.h
>> index 171ccf7..603f686 100644
>> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
>> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
>> @@ -311,7 +311,6 @@ struct ath_rx {
>> spinlock_t rxbuflock;
>> struct list_head rxbuf;
>> struct ath_descdma rxdma;
>> - struct ath_buf *rx_bufptr;
>> struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
>>
>> struct sk_buff *frag;
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c
>> b/drivers/net/wireless/ath/ath9k/recv.c
>> index 7e1a91a..c9612d9 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -224,9 +224,6 @@ static void ath_rx_edma_cleanup(struct ath_softc *sc)
>> }
>>
>> INIT_LIST_HEAD(&sc->rx.rxbuf);
>> -
>> - kfree(sc->rx.rx_bufptr);
>> - sc->rx.rx_bufptr = NULL;
>> }
>>
> Take a look at this part. It's used for avoiding a memleak, so please
> keep it ;)

sure i will leave it as it is, thanks for the review :)

-- 
thanks,
shafi
