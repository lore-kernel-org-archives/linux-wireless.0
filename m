Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3E0C00140
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Aug 2022 16:20:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238951AbiHLQT7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Aug 2022 12:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237138AbiHLQT6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Aug 2022 12:19:58 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E426FAE9DB
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2022 09:19:55 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4M485f04zhz9sRB;
        Fri, 12 Aug 2022 18:19:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=joachim-breitner.de;
        s=MBO0001; t=1660321190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  in-reply-to:in-reply-to;
        bh=J39wPuIBwt+B6kJLntLTX2lFhQoyLH2UoxgdVzpyR4E=;
        b=Qe385n8CR/2k17Oa4xn7xJBEW9redldtYjSLpGmPiOOcSqNX1zxGrPMCtm9MdIVFzny4vH
        0B8TK7hA9ywxZBHUFeLGKkLXalEg/bSyKiw3eq6x/OLTdCnPdWSKVOSOEFcCTT5l0m+thS
        9d0lwXa29urcXVPxcgBVGcARymg1HKuEC6PkqEpTAF5cpthVJy1vEP66oCdX1eINRgEjYB
        LT+xQp1GHzYgW+7SB+73IDdKGj7rb5bq+ZZuFK1/cf2Wove9wUs5C1+LCILd7MsvStuqoh
        LoCJhzkcyFP+WEOiZSGUKaUKmSsmroM3EoTjqbxAvhIthr49wdaTS7lAYzhsdg==
Message-ID: <10b81471b9f1af8b15bc5b9a06792a0a605131fc.camel@joachim-breitner.de>
Subject: Re: iwlwifi devices disappear after suspend on kernel 5.17
From:   Joachim Breitner <mail@joachim-breitner.de>
To:     toke@toke.dk
Cc:     avraham.stern@intel.com, emmanuel.grumbach@intel.com,
        gregory.greenman@intel.com, linux-wireless@vger.kernel.org
Date:   Fri, 12 Aug 2022 18:19:48 +0200
In-Reply-To: <87ilr4hv8k.fsf@toke.dk>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Emmanuel,

> suspend. I get errors like these in dmesg:
>=20
> [104393.142264] wlan0: deauthenticating from 4c:60:de:ea:b8:58 by local c=
hoice (Reason: 3=3DDEAUTH_LEAVING)
> [104393.347775] iwlmei 0000:00:16.0-13280904-7792-4fcb-a1aa-5e70cbb1e865:=
 Couldn't get ACK from CSME on HOST_GOES_DOWN message
> [104393.347876] iwlmei 0000:00:16.0-13280904-7792-4fcb-a1aa-5e70cbb1e865:=
 failed to send the SAP_ME_MSG_CHECK_SHARED_AREA message -19
>=20
> And when the host comes back up, there is no connectivity. Restarting
> iwd fixes the problem.

I am hitting the same problem, on Kernel 5.19, with the same Intel Wi-
Fi 6 AX201 device. I reported this initially to iwd, but they said it
might be a kernel problem, so I found this thread.

Has there been a solution since?

Thanks,
Joachim


--=20
Joachim Breitner
  mail@joachim-breitner.de
  http://www.joachim-breitner.de/

