Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41827 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab1FNLor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 07:44:47 -0400
Received: by wya21 with SMTP id 21so3821707wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jun 2011 04:44:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110614100918.GA4450@redhat.com>
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
	<20110613132009.GA7133@redhat.com>
	<BANLkTi=eKBcV5OjP0qqLe6n9GsiwhYLejg@mail.gmail.com>
	<20110614100918.GA4450@redhat.com>
Date: Tue, 14 Jun 2011 17:14:45 +0530
Message-ID: <BANLkTimZFU_g5Ee4Ajh9MyFmWCvtj-Firw@mail.gmail.com> (sfid-20110614_134450_487187_2793352D)
Subject: Re: APSM, AR9285 and bus hangs
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@venema.h4ckr.net, Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk, Rajkumar Manoharan <rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 14, 2011 at 3:39 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jun 13, 2011 at 07:10:56PM +0530, Mohammed Shafi wrote:
>> > I see this commit in 2.6.39, missed in 2.6.38 and 2.6.35 currently.
>> > Is possible this is the fix which do not break other things?
>>
>> hi,
>> no, this fix only affects AR9280 and it does not affects AR9285.
>
> That could be another stupid question, but could we do not touch
> these bits on older AR9285s and disable them only on revision, that
> was added by bad commit 53bc7aa08b48e5cd745f986731cc7dc24eef2a9f
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> index f344cc2..91d99eb 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> @@ -384,7 +384,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
>                        }
>                }
>
> -               if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
> +               if (AR_SREV_9280(ah) || AR_SREV_9285E_20(ah) || AR_SREV_9287(ah)) {
>                        /*
>                         * Disable bit 6 and 7 before entering D3 to
>                         * prevent system hang.


I had verified with the internal code base whether this is being done,
unfortunately no and at least I had tested this patch in my lenovo
T400 machine it did not cause any issue. this might fix the issue for
the specific platform but I am not sure whether this will not cause
any problems in other platforms. these sort for Workarounds were done
based on testing in different platforms.
Adrian you have any thoughts?




-- 
shafi
