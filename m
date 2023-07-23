Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97648C001DC
	for <linux-wireless@archiver.kernel.org>; Sun, 23 Jul 2023 22:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjGWWKm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 23 Jul 2023 18:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjGWWKl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Jul 2023 18:10:41 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F120AD;
        Sun, 23 Jul 2023 15:10:39 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1690150234; bh=RBLYzId7q5rLyrmeOfA7KtxUDvqgZPZcTGOEpMnxbOo=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OeuGmuPhicNWMwN1ajbzHHH55e0IEwqhIz8RNBgekmQ7zXWc1pTXxsxPnCUP4HWku
         KbA+Yv6U0F+Mi6sZnUcn51yJsYhlVBSCRoGAXsludTAXnpgymgqRThS2Xd8GKf6E8O
         CV+9BfuguTz7W1dN79bD7cteUdfwMdQ7Uf+v/eYeHAc//ScT06KkS482CNBA9DKOrU
         g1f8MOv4pG5B3arjzVVG6ScuVQDFu7fRZmbSSZgmnxwc7GbZj/LdVNv0u3tpIlslHs
         XtHGpoKzEoWVwnVMnF+tWbx4HpII/LZ92zMMdPLy3vW10kIXDiIOsfARcNQyiMZWJv
         /W/Fo7qpD/9Ag==
To:     Dongliang Mu <dzm91@hust.edu.cn>, Kalle Valo <kvalo@kernel.org>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] wifi: ath9k: fix printk specifier
In-Reply-To: <20230723040403.296723-1-dzm91@hust.edu.cn>
References: <20230723040403.296723-1-dzm91@hust.edu.cn>
Date:   Mon, 24 Jul 2023 00:10:33 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87mszms2hy.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dongliang Mu <dzm91@hust.edu.cn> writes:

> Smatch reports:
>
> ath_pci_probe() warn: argument 4 to %lx specifier is cast from pointer
> ath_ahb_probe() warn: argument 4 to %lx specifier is cast from pointer
>
> Fix it by modifying %lx to %p in the printk format string.
>
> Note that with this change, the pointer address will be printed as a
> hashed value by default. This is appropriate because the kernel
> should not leak kernel pointers to user space in an informational
> message. If someone wants to see the real address for debugging
> purposes, this can be achieved with the no_hash_pointers kernel option.
>
> Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
