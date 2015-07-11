Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63223 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbbGKQPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jul 2015 12:15:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: update tx path to support QCA99X0
References: <1436287676-25767-1-git-send-email-poh@qca.qualcomm.com>
	<1436287676-25767-2-git-send-email-poh@qca.qualcomm.com>
Date: Sat, 11 Jul 2015 19:14:56 +0300
In-Reply-To: <1436287676-25767-2-git-send-email-poh@qca.qualcomm.com> (Peter
	Oh's message of "Tue, 7 Jul 2015 09:47:54 -0700")
Message-ID: <87egkewu0v.fsf@kamboji.qca.qualcomm.com> (sfid-20150711_181519_912015_563E6ED8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@qca.qualcomm.com> writes:

> Since QCA99X0 uses fragmentation descriptor differently from
> other ones on tx path, we need to handle it separately.
>
> QCA99X0 is using 48 bits for address and 16 bits for length
> out of 2 dword and each values have to be programmed by frag
> desc base addr + msdu id, so that hardware can retrieve
> corresponding frag data.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

kbuild found a new warning:

>> drivers/net/wireless/ath/ath10k/htt_tx.c:547:52: sparse: incorrect
>> type in assignment (different base types)
   drivers/net/wireless/ath/ath10k/htt_tx.c:547:52:    expected
>> restricted __le16 [usertype] len_16
   drivers/net/wireless/ath/ath10k/htt_tx.c:547:52:    got restricted
>> __le32 [usertype] <noident>

-- 
Kalle Valo
