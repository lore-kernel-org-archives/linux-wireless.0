Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CE4C433FE
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Oct 2022 17:28:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJGR2h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Oct 2022 13:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiJGR2f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Oct 2022 13:28:35 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B5ECA89B;
        Fri,  7 Oct 2022 10:28:31 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1665163709; bh=yWWstJ0SxaiWCJ8yChG5yXzzTd8E+OEk2k17cMD7mTk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ni9bjdb2lOBzjWg5bkIRVl0/gKyrMjH8L5J3acubVv3okw75RWwz9hnqYNlgTgXEv
         Suorg0BCQFLYRWDSKyDVR5SRmXmgt/nsxbMPgoQyVaf7ARP5NW/G+ofmX05XSNg2OC
         HDoflgzMRWYFSAeluVH3Qnxz7jBrRKS4Yi2cTOTTCSKxuSmzZYFK4XwzyZeU7RCYV/
         NE7cIpy/EmprBughiCigylajlUPVUsI0BxpWC4/7YMrO2rZXCudeFJpRRo09GV5sPM
         GcyUPj9jVE8pugnlpteHKWz3n62wC9l296uTZFBOhmXwcvzlJ1euQ9sC2CaoZfkciq
         j30VVJOaEbKZQ==
To:     Kees Cook <keescook@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] ath9k: Remove -Warray-bounds exception
In-Reply-To: <20221006192054.1742982-1-keescook@chromium.org>
References: <20221006192054.1742982-1-keescook@chromium.org>
Date:   Fri, 07 Oct 2022 19:28:29 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87r0zjczlu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> GCC-12 emits false positive -Warray-bounds warnings with
> CONFIG_UBSAN_SHIFT (-fsanitize=3Dshift). This is fixed in GCC 13[1],
> and there is top-level Makefile logic to remove -Warray-bounds for
> known-bad GCC versions staring with commit f0be87c42cbd ("gcc-12: disable
> '-Warray-bounds' universally for now").
>
> Remove the local work-around.
>
> [1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D105679
>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
