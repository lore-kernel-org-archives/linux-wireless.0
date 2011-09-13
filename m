Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:58984 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1IMQBi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 12:01:38 -0400
Received: from hpaq1.eem.corp.google.com (hpaq1.eem.corp.google.com [172.25.149.1])
	by smtp-out.google.com with ESMTP id p8DG1WQS008705
	for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 09:01:32 -0700
Received: from ywb3 (ywb3.prod.google.com [10.192.2.3])
	by hpaq1.eem.corp.google.com with ESMTP id p8DG0okk002151
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 09:01:31 -0700
Received: by ywb3 with SMTP id 3so746038ywb.35
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 09:01:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315927132-21716-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1315927132-21716-1-git-send-email-rmanohar@qca.qualcomm.com>
Date: Tue, 13 Sep 2011 09:01:29 -0700
Message-ID: <CAMcMvsj+AHdjf-JteV=vpYYAgRXOCvsFmN=YwWibXAzQyBwdUQ@mail.gmail.com> (sfid-20110913_180145_774122_F3933571)
Subject: Re: [PATCH] ath9k_hw: Do full chip reset on 11A channels
From: Paul Stewart <pstew@google.com>
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 13, 2011 at 8:18 AM, Rajkumar Manoharan
<rmanohar@qca.qualcomm.com> wrote:
> AR9003 seems to have issues sometimes with fast channel change
> in 5GHz and this case is handled specifically for AR9002 by doing
> a full reset. So let's do a full reset for 5GHz channles for all
> chipsets.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index 308847d..622bfc9 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1504,7 +1504,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
>            (chan->channel != ah->curchan->channel) &&
>            ((chan->channelFlags & CHANNEL_ALL) ==
>             (ah->curchan->channelFlags & CHANNEL_ALL)) &&
> -           (!AR_SREV_9280(ah) || AR_DEVID_7010(ah))) {
> +           !IS_CHAN_5GHZ(chan)) {

I'm not sure I understand.  Are you asserting that AR9002 does not
need a full reset for channel change in 2GHz?   The code before your
change would fall through for AR_SREV_9280(ah) && !AR_DEVID_7010(ah)
whether in 2HGz or 5GHz, but that case gets removed with your change.
Is that intentional?

>
>                if (ath9k_hw_channel_change(ah, chan)) {
>                        ath9k_hw_loadnf(ah, ah->curchan);
> --
> 1.7.6.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
