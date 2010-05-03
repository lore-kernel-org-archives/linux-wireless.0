Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49781 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0ECUsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 May 2010 16:48:38 -0400
Received: by fxm10 with SMTP id 10so2550987fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 May 2010 13:48:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87k4rkk9tz.fsf@purkki.valot.fi>
References: <1272907549-25847-1-git-send-email-linville@tuxdriver.com>
	<87k4rkk9tz.fsf@purkki.valot.fi>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 3 May 2010 22:48:16 +0200
Message-ID: <AANLkTimf_aZyUSZInOzUPZ8KRR6oDs3Re4pSGGn541fM@mail.gmail.com>
Subject: Re: [PATCH] iwlagn: Change the TPT calculations sanity-check to
	WARN_ON
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johill@sipsolutions.net,
	reinette.chatre@intel.com, Adel Gadllah <adel.gadllah@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 3, 2010 at 10:29 PM, Kalle Valo <kvalo@adurom.com> wrote:
> "John W. Linville" <linville@tuxdriver.com> writes:
>
>> From: Adel Gadllah <adel.gadllah@gmail.com>
>>
>> Currently it is a BUG_ON() which will hang the machine once triggered.
>
> Related to this: can we have a rule that no wireless driver should
> ever use BUG_ON()? I think we could extend this even to cfg80211 and
> mac80211.
>
> BUG_ON() is valid whenever there's a risk of corrupting data, for
> example on a filesystem, but I really don't see the point of using
> them in wireless drivers. They just make things miserable, especially
> for the normal users. Printing a warning and handling the case as
> gracefully as possible is much better IMHO.
>

One exception I can think of: major misconfiguration can cause a
wireless device to DMA data into sensitive memory locations. When
evidence of this is detected, it might make sense to BUG_ON()
(especially if the bogus DMA operations can be exploited remotely to
overwrite arbitrary memory addresses). However, in that case, the
attacker may have already overwritten panic() with malicious code as
well, so even this case doesn't hold.

The other thing that comes to my mind is when there is a risk of
physically frying the card, but given that BUG_ON() doesn't cut power
to the PCI bus (at least not on x86 - dunno about other platforms),
this one falls down pretty easily too.

> --
> Kalle Valo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
