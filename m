Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB72C77B6E
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Apr 2023 10:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjDNKAl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Apr 2023 06:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjDNKAj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2023 06:00:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863617D94;
        Fri, 14 Apr 2023 03:00:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DA43645FF;
        Fri, 14 Apr 2023 10:00:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47E36C433D2;
        Fri, 14 Apr 2023 10:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681466437;
        bh=+unhzZIt93zWvizO+N74h9hOS28VrKOnLga/YajlgSE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=b1B6n5tYl5i7L/2mf6Z7/GE0jhkHJM/mSJkH8JHN+wh+6Yl/1PcFz6hHU9d/dvoFl
         zo6qkq8We1ZLyhSkCoDDKBUUaNpoLsBGxD0T/LdzaodXxS0aIF2Rv9aQx3UZGrhdYw
         J4HIqgPURwu2A1PHjHRQn45ctcavLdME1+OzkBQstVK/nbqmAyNmjrDzkpl3K2z4SX
         bynMF3Poul4vcaP2t3Lve+Lb4xFHq+lrk6ta9MfgyThAiPunWt85mVBOTIWkid3kQf
         NpPsPgt6DWMp9U6xNhwHHNZWvVyN/Mj99XuCbtHfQAI2tsd/YAH4I14AB4jIIcaXcq
         fL5MQI8XyzUVQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <quic_kvalo@quicinc.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()
References: <20230413214118.153781-1-toke@toke.dk>
Date:   Fri, 14 Apr 2023 13:00:34 +0300
In-Reply-To: <20230413214118.153781-1-toke@toke.dk> ("Toke
        \=\?utf-8\?Q\?H\=C3\=B8iland-J\=C3\=B8rgensen\=22's\?\= message of "Thu, 13 Apr 2023
 23:41:18 +0200")
Message-ID: <87v8hysrzx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> This partially reverts commit e161d4b60ae3a5356e07202e0bfedb5fad82c6aa.
>
> Turns out the channelmap variable is not actually read-only, it's modified
> through the MCI_GPM_CLR_CHANNEL_BIT() macro further down in the function,
> so making it read-only causes page faults when that code is hit.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D217183
> Fixes: e161d4b60ae3 ("wifi: ath9k: Make arrays prof_prio and channelmap s=
tatic const")
> Cc: stable@vger.kernel.org
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>

I guess the casting in MCI_GPM_CLR_CHANNEL_BIT() hide this and made it
impossible for the compiler to detect it? A perfect example why I hate
casting :)

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
