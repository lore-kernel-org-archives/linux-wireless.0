Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f200.google.com ([209.85.212.200]:56443 "EHLO
	mail-vw0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZGPGxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 02:53:36 -0400
Received: by vwj38 with SMTP id 38so1538930vwj.33
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 23:53:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1247628512.3669.13.camel@Joe-Laptop.home>
References: <20090715032412.GE4613@myhost>
	 <1247628512.3669.13.camel@Joe-Laptop.home>
Date: Thu, 16 Jul 2009 12:23:35 +0530
Message-ID: <8e92b4100907152353l1f9921eew340261e8e50c54eb@mail.gmail.com>
Subject: Re: [PATCH 3/3] ath9k: Add support for AR9287 based chipsets.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 8:58 AM, Joe Perches<joe@perches.com> wrote:
> On Wed, 2009-07-15 at 08:54 +0530, Vivek Natarajan wrote:
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>> diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
>> index 1f0c5fe..d1bbb02 100644
>> --- a/drivers/net/wireless/ath/ath9k/calib.c
>> +++ b/drivers/net/wireless/ath/ath9k/calib.c
>> @@ -116,7 +116,7 @@ static void ath9k_hw_do_getnf(struct ath_hw *ah,
>>                               "NF calibrated [ctl] [chain 1] is %d\n", nf);
>>               nfarray[1] = nf;
>>
>> -             if (!AR_SREV_9280(ah)) {
>> +             if (!AR_SREV_9280(ah) && !AR_SREV_9287(ah)) {
>
> This looks like it needs a helper function like IS_AR_SREV_928x(ah)

928X is not needed in this case as there is some other chipset AR9285
which has different capabilities compared to AR9280 and AR9287.

Vivek.
