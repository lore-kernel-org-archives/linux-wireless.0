Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43211 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1FMNk5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 09:40:57 -0400
Received: by wya21 with SMTP id 21so3185024wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jun 2011 06:40:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110613132009.GA7133@redhat.com>
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
	<20110613132009.GA7133@redhat.com>
Date: Mon, 13 Jun 2011 19:10:56 +0530
Message-ID: <BANLkTi=eKBcV5OjP0qqLe6n9GsiwhYLejg@mail.gmail.com> (sfid-20110613_154103_144958_BBBBE3DA)
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

On Mon, Jun 13, 2011 at 6:50 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
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

hi,
no, this fix only affects AR9280 and it does not affects AR9285.

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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
