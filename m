Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D95EBEB64D9
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 11:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjFNLks (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 07:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244412AbjFNLkN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 07:40:13 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56E12122
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 04:39:53 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1686742791; bh=OETc3vi49ToIeJgZq6PBCKtsHovQ2f4rRMtSEbEFJno=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=h4EoMN9e7tDUOzfC4BHeThaH5kg5ncjG8wpdD585NiJO1Of+7MLo9haV2TcsvAB48
         E+gwcjWRAEEQd0xvwdl7J19VQryiv2R3NHXsNzhDH+y+udaUDtvvAMN5hB1Fy8U6tb
         JT22T1CCbart/NXAyVp9DHDtB41TO4fyw8dxdqiv1Jaqt4cTl9F8vP2l2tRQpWHCu1
         NG1HZi5Yu8ffSsbg9zekx1pib79el5++Hg7qVeSjCA8BpeXY4aJJoc3sY8Lvkn6SqJ
         Rn2T0rMOH6GiF+8Eoze5/+UR3dRDSpQp9SQGwQEqDrPusulCairtMc56qXyviw53Az
         yeQj/zl6O9DvQ==
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Dmitry Antipov <dmantipov@yandex.ru>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: convert msecs to jiffies where needed
In-Reply-To: <87pm5yd3rz.fsf@kernel.org>
References: <20230613134655.248728-1-dmantipov@yandex.ru>
 <87y1knw7ng.fsf@toke.dk> <87pm5yd3rz.fsf@kernel.org>
Date:   Wed, 14 Jun 2023 13:39:50 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a5x2l1bt.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@kernel.org> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>> Dmitry Antipov <dmantipov@yandex.ru> writes:
>>
>>> Since 'ieee80211_queue_delayed_work()' expects timeout in
>>> jiffies and not milliseconds, 'msecs_to_jiffies()' should
>>> be used in 'ath_restart_work()' and '__ath9k_flush()'.
>>>
>>> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
>>
>> I believe this warrants a:
>>
>> Fixes: d63ffc45c5d3 ("ath9k: rename tx_complete_work to hw_check_work")
>
> I can add that.

I was hoping you'd say that - thanks :)

-Toke
