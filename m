Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF06BC433FE
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Apr 2022 13:23:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347425AbiDCNZI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Apr 2022 09:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbiDCNZH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Apr 2022 09:25:07 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA2F2FFF0;
        Sun,  3 Apr 2022 06:23:12 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1648992189; bh=vxP9q518XE3KdAztl9//KGX9bUTP+1n779ioHEPSOHc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=kTXyJBdpSrLqD2Jq+JcFdR04mE5KkGWlUPpwy8lKKYGmk60+oYBCeWWqWSL9Gg3tZ
         hT5svZvRPSA5eJ3r0k2noh+NTBD6yvUzKify+jCbz0Mkxfyy+ciSZhAmySuYYW4kfc
         vkzqzX38Q3FPsV8VhGN858L3T/UC7bkJ5bT0isJYEOgYvMlmhzH5J5eWTGA1WwxGFR
         pIMf70rYTcfd04DZJkg49U/nSRzLKSHAyXcGHzwXB5fAsDW/KkkMRIl2fVKJIg25aG
         iB/el4mu9uBfE+SpFaVE853rsEOsKD6d/TKGoRn+99XlGhd0XHogF/GTQWfG9Z3po4
         slZsTo/feS42g==
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Peter Seiderer <ps.report@gmx.net>
Subject: Re: [PATCH v5.18] ath9k: Save rate counts before clearing tx status
 area
In-Reply-To: <874k3btm41.fsf@kernel.org>
References: <20220402122752.2347797-1-toke@toke.dk>
 <d04373063ca88490d95101e52cd1b65d123d207e.camel@sipsolutions.net>
 <87lewnfwyg.fsf@toke.dk> <874k3btm41.fsf@kernel.org>
Date:   Sun, 03 Apr 2022 15:23:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a6d2fghv.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>
>>> On Sat, 2022-04-02 at 14:27 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
>>>>=20
>>>> @@ -2591,12 +2602,6 @@ static void ath_tx_rc_status(struct ath_softc *=
sc, struct ath_buf *bf,
>>>>  				hw->max_rate_tries;
>>>>  	}
>>>>=20=20
>>>> -	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++) {
>>>
>>> might want to drop that blank line too :)
>>>
>>>> -		tx_info->status.rates[i].count =3D 0;
>>>> -		tx_info->status.rates[i].idx =3D -1;
>>>> -	}
>>>> -
>>>> -	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
>>>>  }
>>>
>>> since there's nothing else.
>>
>> Hmm, fair point; Kalle, I don't suppose I could trouble you for a fixup
>> when committing? :)
>
> Sorry, editing the diff is more difficult for me. It would be easier if
> you could submit v2.

Alright, no worries, can do. Seems we may need more changes anyway, so
will wait for the results of Peter's tests before submitting v2...

-Toke
