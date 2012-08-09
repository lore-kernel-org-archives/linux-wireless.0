Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:57485 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab2HISGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:06:46 -0400
Received: by ghrr11 with SMTP id r11so759345ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:06:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120809173435.GQ3745@lenteja.do-not-panic.com>
References: <CAA2SeNJmaHs5fMHrG65HWbe5Y-ytz2qvuzNGKvhBKgvZ15KoVw@mail.gmail.com>
	<20120809173435.GQ3745@lenteja.do-not-panic.com>
Date: Thu, 9 Aug 2012 20:06:45 +0200
Message-ID: <CAA2SeNKbBCxPbJmXMyo4-nK2SXL-WcOFQaKDrEM-cxbVrzt7Ew@mail.gmail.com> (sfid-20120809_200650_075768_8E98D296)
Subject: Re: [PATCH v2] ath9k: decrypt_error flag issue
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, Aug 09, 2012 at 05:47:47PM +0200, Lorenzo Bianconi wrote:
>> From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>>
>> After the hw reports a decryption error, the flag decrypt_error is set to
>> true in ath9k_rx_accept.
>> Since this flag is initialized to false just outside ath_rx_tasklet while cycle,
>> all subsequent frames are marked as corrupted until ath_rx_tasklet ends.
>> Fix the issue initializing decrypt_error flag at the begging of the cycle.
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>
> Thanks! In practice what issues did you see ?
>
>   Luis

If the decrypt_error flag is set to true for correctly decrypted
packets, the ieee80211_rx_status flag is not marked with
RX_FLAG_DECRYPTED in ath9k_rx_skb_postprocess.
This behavior causes some issues. For example mac80211 attempts to
decrypt the frame in software even if the packet is already decrypted
in hw.

Regards

Lorenzo
