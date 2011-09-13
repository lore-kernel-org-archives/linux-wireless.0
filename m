Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:4139 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab1IMRiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 13:38:23 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id p8DHcHNl025663
	for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 10:38:18 -0700
Received: from yxm8 (yxm8.prod.google.com [10.190.4.8])
	by wpaz33.hot.corp.google.com with ESMTP id p8DHamoj004291
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 10:38:16 -0700
Received: by yxm8 with SMTP id 8so823394yxm.33
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 10:38:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110913171308.GA21972@vmraj-lnx.users.atheros.com>
References: <1315927132-21716-1-git-send-email-rmanohar@qca.qualcomm.com>
	<CAMcMvsj+AHdjf-JteV=vpYYAgRXOCvsFmN=YwWibXAzQyBwdUQ@mail.gmail.com>
	<20110913171308.GA21972@vmraj-lnx.users.atheros.com>
Date: Tue, 13 Sep 2011 10:38:16 -0700
Message-ID: <CAMcMvsjgGP40g2hokU1sOdY_DdZrK3Ciy5OE5=EgepGH7ZO3VQ@mail.gmail.com> (sfid-20110913_193830_232832_72E490CD)
Subject: Re: [PATCH] ath9k_hw: Do full chip reset on 11A channels
From: Paul Stewart <pstew@google.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 10:13 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> On Tue, Sep 13, 2011 at 09:01:29AM -0700, Paul Stewart wrote:
>> On Tue, Sep 13, 2011 at 8:18 AM, Rajkumar Manoharan
>> <rmanohar@qca.qualcomm.com> wrote:
>> > AR9003 seems to have issues sometimes with fast channel change
>> > in 5GHz and this case is handled specifically for AR9002 by doing
>> > a full reset. So let's do a full reset for 5GHz channles for all
>> > chipsets.
>> >
>> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
>> > ---
>> >  drivers/net/wireless/ath/ath9k/hw.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
>> > index 308847d..622bfc9 100644
>> > --- a/drivers/net/wireless/ath/ath9k/hw.c
>> > +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> > @@ -1504,7 +1504,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
>> >            (chan->channel != ah->curchan->channel) &&
>> >            ((chan->channelFlags & CHANNEL_ALL) ==
>> >             (ah->curchan->channelFlags & CHANNEL_ALL)) &&
>> > -           (!AR_SREV_9280(ah) || AR_DEVID_7010(ah))) {
>> > +           !IS_CHAN_5GHZ(chan)) {
>>
>> I'm not sure I understand.  Are you asserting that AR9002 does not
>> need a full reset for channel change in 2GHz?   The code before your
>> change would fall through for AR_SREV_9280(ah) && !AR_DEVID_7010(ah)
>> whether in 2HGz or 5GHz, but that case gets removed with your change.
>> Is that intentional?
>>
> Yes. Fast channel change is completely supported on 2GHz band. And also
> if you look at the log history, the fast channel change was initially
> disabled in 5GHz alone for AR9280 chips. AR7010 chip is the usb version of
> AR9280. Instead of adding chip specific checks, the fastcc is disabled for
> 5GHz.

I might not be finding the right part of the history.  I do see things
like 0a475cc6a0ac8e38ac3587cff87026551800b7fe: Vasanthakumar
Thiagarajan <vasanth@atheros.com> "ath9k: Do a full reset for AR9280;
AR9280 requires a full reset during channel change and HW reset.
Currently, a fast channel change is done. This patch fixes this bug."
This patch disabled fast-channel-change for the 9280 AND 2GHz channels
(what I assume 5MHZ_SPACED to be filtering).  I still see no point in
history where 9280 was enabled for fast channel change in 2Ghz.

>
> --
> Rajkumar
>
