Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43657 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab1FNAC4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 20:02:56 -0400
Received: by yxi11 with SMTP id 11so1099421yxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 17:02:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110613132009.GA7133@redhat.com>
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
	<20110613132009.GA7133@redhat.com>
Date: Tue, 14 Jun 2011 08:02:54 +0800
Message-ID: <BANLkTi=epV40yWe0piXoaDes_F5jOV_DJQ@mail.gmail.com> (sfid-20110614_020303_693847_4DBAD1B9)
Subject: Re: APSM, AR9285 and bus hangs
From: Adrian Chadd <adrian@freebsd.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>, ath9k-devel@venema.h4ckr.net,
	Tony Houghton <h@realh.co.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk, Rajkumar Manoharan <rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think the problem on these laptops is that -disabling- the APSM bits
causes some systems to hang.

That's what the commit earlier in the year did - it disabled those
bits by default. Later code then enabled those bits only on poweron,
and disabled them on suspend. My dirty patch just has them enabled by
default again as per the previous behaviour.

I guess someone should establish whether APSM is even supported on those boards?

Adrian

On 13 June 2011 21:20, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jun 13, 2011 at 09:01:57PM +0800, Adrian Chadd wrote:
>> On 13 June 2011 19:00, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>
>> > cam a fedora user, confirms that patch fixes the locks-ups
>> > https://bugzilla.redhat.com/show_bug.cgi?id=697157#c26
>> >
>> > We are waiting for fix now :-)
>>
>> Cool.
>>
>> The problem is, the initial modification and subsequent changes to the
>> powersave function were documented to fix an APSM hang, not cause it.
>>
>> I'm happy to submit a patch to undo that particular change but I'm not
>> sure if it'll -break- things for other people. :)
>>
>> Someone with PCIe/APCI/APSM/general clue in the area of CPU + bus
>> sleep states needs to step in and help. I'm just not equipped to fix
>> the problem at the moment.
>
> I see this commit in 2.6.39, missed in 2.6.38 and 2.6.35 currently.
> Is possible this is the fix which do not break other things?
>
> commit 5b64aa72ead6f8be488d2be7af579f0d69fb7a6e
> Author: Rajkumar Manoharan <rmanoharan@atheros.com>
> Date:   Thu Jan 27 18:39:37 2011 +0530
>
>    ath9k_hw: Fix system hang when resuming from S3/S4
>
>    The bit 6 & 7 of AR_WA (0x4004) should be enabled only
>    for the chips that are supporting L0s functionality
>    while resuming back from S3/S4.
>
>    Enabling these bits for AR9280 is causing system hang
>    within a few S3/S4-resume cycles.
>
>    Cc: stable@kernel.org
>    Cc: Jack Lee <jlee@atheros.com>
>    Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
>    Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> index f8a7771..f44c84a 100644
> --- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> +++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
> @@ -426,9 +426,8 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
>                }
>
>                /* WAR for ASPM system hang */
> -               if (AR_SREV_9280(ah) || AR_SREV_9285(ah) || AR_SREV_9287(ah)) {
> +               if (AR_SREV_9285(ah) || AR_SREV_9287(ah))
>                        val |= (AR_WA_BIT6 | AR_WA_BIT7);
> -               }
>
>                if (AR_SREV_9285E_20(ah))
>                        val |= AR_WA_BIT23;
>
