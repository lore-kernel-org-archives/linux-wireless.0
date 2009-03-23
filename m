Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48894 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbZCWOeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 10:34:18 -0400
Received: by bwz17 with SMTP id 17so1786112bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 07:34:15 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Subject: Re: [PATCH] Marvell CF8381
Date: Mon, 23 Mar 2009 15:34:23 +0100
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
References: <200903220127.21836.marek.vasut@gmail.com> <200903231313.10699.hs4233@mail.mn-solutions.de>
In-Reply-To: <200903231313.10699.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200903231534.23815.marek.vasut@gmail.com> (sfid-20090323_153421_282028_1FD4B649)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 of March 2009 13:13:10 Holger Schurig wrote:
> Hi Marek !
>
> Great.
>
>
> Some nitpicks:
>
> 1. you attached the patches, not inline
Yes, I know, I just needed some comments if they are OK
> 2. There's no signed-off
cat ../0001-Correct-return-value-of-firmware-loading-functions-h.patch | 
head -n 6
~~~~~~~
Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

cat ../0002-Add-support-for-CF8381-WiFi-card.patch | head -n 6
~~~~~~~
Signed-off-by: Marek Vasut <marek.vasut@gmail.com>

So as you see, there is.
> 3. You didn't submit one mail per patch
Yes, I know, see 1.
>
> All of this makes review harder. If you adhere a bit to
> Documentation/SubmittingPatches you'd get the fame all by
> yourself :-)
>
>
> Some more rants:
>
>
> --- a/drivers/net/wireless/libertas/if_cs.c
> +++ b/drivers/net/wireless/libertas/if_cs.c
> @@ -273,7 +273,14 @@ static int if_cs_poll_while_fw_download(struct
> if_cs_card *card, uint addr, u8 r */
>  #define IF_CS_PRODUCT_ID               0x0000001C
>  #define IF_CS_CF8385_B1_REV            0x12
> +#define        IF_CS_CF8381_B3_REV             0x04
>
> Here's a tab, not a space. Maybe you run scripts/checkpatch.pl on it as
> well?
# ./scripts/checkpatch.pl ../0001-Correct-return-value-of-firmware-loading-functions-h.patch
total: 0 errors, 0 warnings, 11 lines checked

../0001-Correct-return-value-of-firmware-loading-functions-h.patch has no 
obvious style problems and is ready for submission.
# ./scripts/checkpatch.pl ../0002-Add-support-for-CF8381-WiFi-card.patch
total: 0 errors, 0 warnings, 31 lines checked

../0002-Add-support-for-CF8381-WiFi-card.patch has no obvious style problems 
and is ready for submission.

As you can see, I did. Otherwise I wont send them.
>
>
>
>
> -       if (if_cs_read8(card, IF_CS_PRODUCT_ID) < IF_CS_CF8385_B1_REV) {
> +       if (!(p_dev->manf_id == CF8381_MANFID &&
> +               p_dev->card_id == CF8381_CARDID) &&
> +               (if_cs_read8(card, IF_CS_PRODUCT_ID) <
> IF_CS_CF8385_B1_REV)) {
>
> I think change then breaks the existing logic for 8385 cards.
> code broke then the 8385 case. Therefore a NAK for now.
This might need review ... hang on, I'll recheck
>
>
>
>
> Kindly repost both patches again, with signed-off and fixes, thanks!


