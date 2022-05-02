Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B60A3C433F5
	for <linux-wireless@archiver.kernel.org>; Mon,  2 May 2022 09:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245578AbiEBJGD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 May 2022 05:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239442AbiEBJGC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 May 2022 05:06:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DDB1B79F
        for <linux-wireless@vger.kernel.org>; Mon,  2 May 2022 02:02:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF41EB8122F
        for <linux-wireless@vger.kernel.org>; Mon,  2 May 2022 09:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F884C385A4;
        Mon,  2 May 2022 09:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651482151;
        bh=HWKFohGUZPnaGU1qyOyE+uwIfFjaWoX396QNVW3OSvk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WxI23ExpmSMk8HRxMO92noHSadS0fF6+J1TaThl9OdfeE/xccPA5mIbHzhf+9ZiTN
         OhjQfE31Auu46F0h9w6+wQGeVVU7fe9ZvcnC8IPL6ycQOsQXaCQHliKZZLlALTmoL3
         8Ae3VgyLyWJcLstVi7lmiFq4H7HOn+DtqUXohFKOrEc7L3lyXArtMBNsa1NwFM44GC
         8CGaxjzqzLB7e/8HfzocjqDpSnZ9VDRWXxrsR8eVIWmCT7VWG/C6FezaPb/TIq2d2f
         OaYp7IHMMqyt6evFEhspe4LTP8o4h2pSHoPnCT6pv/jfUW296ZsNaddO2tx6/vW+cO
         N5TdEyUc8HDFA==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] wfx: avoid flush_workqueue(system_highpri_wq) usage
References: <20220225112405.355599-1-Jerome.Pouiller@silabs.com>
        <87a6c0cuxf.fsf@kernel.org>
        <f15574a6-aba4-72bc-73af-26fdcdf9fb63@I-love.SAKURA.ne.jp>
        <3828648.MHq7AAxBmi@pc-42>
Date:   Mon, 02 May 2022 12:02:25 +0300
In-Reply-To: <3828648.MHq7AAxBmi@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Mon,
        02 May 2022 10:38:43 +0200")
Message-ID: <87wnf4b93y.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Monday 2 May 2022 10:16:06 CEST Tetsuo Handa wrote:
>> CAUTION: This email originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.
>>=20
>>=20
>> Flushing system-wide workqueues is dangerous and will be forbidden.
>> Replace system_highpri_wq with per "struct wfx_dev" bh_wq.
>>=20
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[...]

> It's right for me.
>
> Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>

Thanks, but I'll change this to Acked-by:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when=
-to-use-acked-by-cc-and-co-developed-by

Also please edit your quotes, otherwise patchwork is hard to use.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
