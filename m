Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC612C433F5
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Apr 2022 17:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244448AbiDBRrw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Apr 2022 13:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbiDBRrv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Apr 2022 13:47:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A6D107822;
        Sat,  2 Apr 2022 10:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF6360C3D;
        Sat,  2 Apr 2022 17:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255D5C340EC;
        Sat,  2 Apr 2022 17:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648921556;
        bh=EXKdnrGXgdUcHASa/vW5gEsZitzdLSnKZveTRuHY4w8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LP3LthIE9CaKA8RRUx2z6SSQ5rYMHgqdO0/HzlYX4WbXN1y3JkRaYBSAE7h0Dz4/c
         D3e+8UKlAEMdPIAPpJ9xSRc7sHQvlh0HAOFUkhvN0cAdixD74neFA4xT79eFq1uwTC
         UQA9a8jyyMz3YzGGvn5LphPv26R+38NLzasleZ0v0kXjTq5TjX4kOjpFbXd0nOCFPd
         iR3Mbht3osjaDwY75FjYVnRxGvYbBbiZaO/JB+ggCBqjZXbDU8ogp8Ngk+Bx7uapSa
         wPvHBIFdY+hfF8KTaXerN/Ro/5r5UP/4rr4YvJ36wRBSgDptyH9U+buemdZgAsTZLO
         /CS+lbo+MBF4Q==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status area
References: <20220402122752.2347797-1-toke@toke.dk>
        <d04373063ca88490d95101e52cd1b65d123d207e.camel@sipsolutions.net>
        <87lewnfwyg.fsf@toke.dk>
Date:   Sat, 02 Apr 2022 20:45:50 +0300
In-Reply-To: <87lewnfwyg.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Sat, 02 Apr 2022 15:15:19 +0200")
Message-ID: <874k3btm41.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Sat, 2022-04-02 at 14:27 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>>>=20
>>> @@ -2591,12 +2602,6 @@ static void ath_tx_rc_status(struct ath_softc *s=
c, struct ath_buf *bf,
>>>  				hw->max_rate_tries;
>>>  	}
>>>=20=20
>>> -	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++) {
>>
>> might want to drop that blank line too :)
>>
>>> -		tx_info->status.rates[i].count =3D 0;
>>> -		tx_info->status.rates[i].idx =3D -1;
>>> -	}
>>> -
>>> -	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
>>>  }
>>
>> since there's nothing else.
>
> Hmm, fair point; Kalle, I don't suppose I could trouble you for a fixup
> when committing? :)

Sorry, editing the diff is more difficult for me. It would be easier if
you could submit v2.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
