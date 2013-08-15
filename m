Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:60767 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab3HOG6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 02:58:34 -0400
Received: by mail-lb0-f175.google.com with SMTP id 13so366300lba.6
        for <linux-wireless@vger.kernel.org>; Wed, 14 Aug 2013 23:58:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877gfnwkog.fsf@purkki.adurom.net>
References: <1376323275.11514.26.camel@jlt4.sipsolutions.net>
	<1376486987-23224-1-git-send-email-ja@anyfi.net>
	<877gfnwkog.fsf@purkki.adurom.net>
Date: Thu, 15 Aug 2013 08:58:32 +0200
Message-ID: <CAJWpbEiKmyGy6boQtdsR=5Djqbsj6Cqkb2qgKLuRSEJnq_RQ4g@mail.gmail.com> (sfid-20130815_085837_612035_97E0D32B)
Subject: Re: [PATCHv2 1/2] mac80211: perform power save processing before decryption
From: Johan Almbladh <ja@anyfi.net>
To: Kalle Valo <kvalo@adurom.com>
Cc: Johan Almbladh <ja@anyfi.net>,
	Johannes Berg <johannes@sipsolutions.net>, ordex@autistici.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right, I got it.

Johan

On Thu, Aug 15, 2013 at 8:08 AM, Kalle Valo <kvalo@adurom.com> wrote:
> Johan Almbladh <ja@anyfi.net> writes:
>
>> This patch decouples the power save processing from the frame decryption
>> by running the decrypt rx handler after sta_process. In the case where
>> the decryption failed for some reason, the stack used to not process
>> the PM and MOREDATA bits for that frame. The stack now always performs
>> power save processing regardless of the decryption result. That means that
>> encrypted data frames and NULLFUNC frames are now handled in the same way
>> regarding power save processing, making the stack more robust.
>>
>> Tested-by: Johan Almbladh <ja@anyfi.net>
>> Signed-off-by: Johan Almbladh <ja@anyfi.net>
>
> The idea of the Tested-by is that someone else than the patch author has
> also tested the patch, like a bug reporter etc. The patch author should
> always tests his/her code, so adding Tested-by for the author is moot.
>
> --
> Kalle Valo
