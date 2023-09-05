Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C587CA0FFA
	for <linux-wireless@archiver.kernel.org>; Tue,  5 Sep 2023 17:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjIER4b (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Sep 2023 13:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjIERzc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Sep 2023 13:55:32 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356BD21CC4;
        Tue,  5 Sep 2023 10:46:07 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1693935186; bh=MewHvL6/b8M2rkjWGv8R4G7kmd+1WU9RWjPtEtTxQAQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pv0nv93ocQbrN+TXuIFTq0UQSzuoV6HBNgyVqoJvUjEzDwHqRO/m0PpxTFFfbKI3/
         esdAA2k0QaNrX4YoDOFle+GdxfAKUq9vHgbcQt/ggXI2/wak6bRF1slndZPCycahQy
         ThH6ib4DcX6jjF8XR1H3LAq6nJCOdlG+Ca4TKmk5LoymuRnmPkT/dPk83uY2yESIZU
         dulL2c27/sm3UJC7eKpO/O5AScjE6kV8YKbpmbU7maq2sjvGblw9Oy9gaLUdnK19mn
         BhVN6tmgnTiSuy2EKRok4j3V9DDF49M34RKz/qCrZnKcW+YwA4nMCx9uz+ZuKVy65+
         6oVWPm0VdNt9Q==
To:     Dongliang Mu <dzm91@hust.edu.cn>, Kalle Valo <kvalo@kernel.org>
Cc:     hust-os-kernel-patches@googlegroups.com,
        Dongliang Mu <dzm91@hust.edu.cn>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ath9k: clean up function ath9k_hif_usb_resume
In-Reply-To: <20230905013556.2595854-1-dzm91@hust.edu.cn>
References: <20230905013556.2595854-1-dzm91@hust.edu.cn>
Date:   Tue, 05 Sep 2023 19:33:06 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87ledkplt9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dongliang Mu <dzm91@hust.edu.cn> writes:

> In ath9k_hif_usb_resume, the error handling code calls
> ath9k_hif_usb_dealloc_urbs twice in different paths.
>
> To unify the error handling code, we move the else branch before
> the if branch and drop one level of indentation of the if branch.
>
> In addition, move the ret variable at the end of variable declarations
> to be reverse x-mas tree order.
>
> Note that this patch does not incur any functionability change.
>
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
