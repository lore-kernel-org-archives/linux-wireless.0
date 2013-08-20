Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:62813 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3HTM5R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 08:57:17 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so354378wes.20
        for <linux-wireless@vger.kernel.org>; Tue, 20 Aug 2013 05:57:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52133070.2050301@blackshift.org>
References: <1376681980-27831-1-git-send-email-mkl@pengutronix.de>
	<52133070.2050301@blackshift.org>
Date: Tue, 20 Aug 2013 14:57:16 +0200
Message-ID: <CAGXE3d--mH9vnFevDn7ZDae4ZOrM9wQvVm4Y1Cx6KObouayk6A@mail.gmail.com> (sfid-20130820_145721_244107_40CE01E6)
Subject: Re: [PATCH v2] ath9k_htc: Restore skb headroom when returning skb to mac80211
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Marc Kleine-Budde <mkl@blackshift.org>,
	John Linville <linville@tuxdriver.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John, Hi Marc,

On Tue, Aug 20, 2013 at 11:01 AM, Marc Kleine-Budde <mkl@blackshift.org> wrote:
> On 08/16/2013 09:39 PM, Marc Kleine-Budde wrote:
>> From: Helmut Schaa <helmut.schaa@googlemail.com>
>>
>> ath9k_htc adds padding between the 802.11 header and the payload during
>> TX by moving the header. When handing the frame back to mac80211 for TX
>> status handling the header is not moved back into its original position.
>> This can result in a too small skb headroom when entering ath9k_htc
>> again (due to a soft retransmission for example) causing an
>> skb_under_panic oops.
>>
>> Fix this by moving the 802.11 header back into its original position
>> before returning the frame to mac80211 as other drivers like rt2x00
>> or ath5k do.
>>
>> Reported-by: Marc Kleine-Budde <mkl@blackshift.org>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> Tested-by: Marc Kleine-Budde <mkl@blackshift.org>
>> Signed-off-by: Marc Kleine-Budde <mkl@blackshift.org>
>> ---
>> Hello Helmut,
>>
>> I've change the patch a bit, I've used ieee80211_get_hdrlen_from_skb() instead
>> of open coding it.
>>
>> Tested in ARMv5 with USB device
>>   "ID 0cf3:7015 Atheros Communications, Inc. TP-Link TL-WN821N v3 802.11n [Atheros AR7010+AR9287]"
>> for four weeks. Without that patch the kernel oopes after about one week.
>>
>> I think this is a candidate for stable, can you add stable to Cc?
>
> ping

Sorry, completely forgot about this patch. You're right, this is
indeed a stable candidate.

John, could you please add  "Cc: stable@vger.kernel.org" when applying
this to your tree?

Thanks,
Helmut
