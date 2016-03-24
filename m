Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65086 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755257AbcCXPxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2016 11:53:05 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rmanohar@codeaurora.org" <rmanohar@codeaurora.org>
Subject: Re: [PATCH 1/9] ath10k: speedup htt rx descriptor processing for tx
 completion
Date: Thu, 24 Mar 2016 15:52:53 +0000
Message-ID: <1458834773112.89396@qti.qualcomm.com> (sfid-20160324_165333_867065_E2C1D1F9)
References: <1458647539-17213-1-git-send-email-rmanohar@qti.qualcomm.com>
	<1458647539-17213-2-git-send-email-rmanohar@qti.qualcomm.com>,<8760wcdnws.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8760wcdnws.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[...]
>
>> @@ -1712,7 +1710,20 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
>>       for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
>>               msdu_id = resp->data_tx_completion.msdus[i];
>>               tx_done.msdu_id = __le16_to_cpu(msdu_id);
>> -             ath10k_txrx_tx_unref(htt, &tx_done);
>> +
>> +             /* kfifo_put: In practice firmware shouldn't fire off per-CE
>> +              * interrupt and main interrupt (MSI/-X range case) for the same
>> +              * HTC service so it should be safe to use kfifo_put w/o lock.
>> +              *
>> +              * From kfifo_put() documentation:
>> +              *  Note that with only one concurrent reader and one concurrent
>> +              *  writer, you don't need extra locking to use these macro.
>> +              */
>> +             if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
>> +                     ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
>> +                                 tx_done.msdu_id, tx_done.status);
>> +                     ath10k_txrx_tx_unref(htt, &tx_done);
>> +             }
>
> I see two new warnings on the kfifo_put() call:
>
> drivers/net/wireless/ath/ath10k/htt_rx.c:1722:22: warning: cast to non-scalar
> drivers/net/wireless/ath/ath10k/htt_rx.c:1722:22: warning: cast from non-scalar
> 
> But I suspect they are false warnings due to my old compiler:
> 
> gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
> 
> Opinions?
> 
Hmm... I am not sure why older compiler is not complaining this. Unfortunately
both x86 and cross compiler are not throwing any warnings though :(

gcc version 5.3.0 (GCC)
Target: x86_64-unknown-linux-gnu

gcc version 4.8.3 (OpenWrt/Linaro GCC 4.8-2014.04 r47724)
Target: arm-openwrt-linux-uclibcgnueabi

Any suggestions welcome.

-Rajkumar

