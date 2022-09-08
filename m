Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77C00C38145
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Sep 2022 06:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiIHGzE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Sep 2022 02:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiIHGzA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Sep 2022 02:55:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F4B2F3BE;
        Wed,  7 Sep 2022 23:54:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27AEAB81FCC;
        Thu,  8 Sep 2022 06:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135D6C433C1;
        Thu,  8 Sep 2022 06:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662620093;
        bh=tQX5iNi/oq5CwLdFj3lYOobrVtX8RWhm1gXhhk3Oexc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=G4+K5h0mN+XqIBciUBOHEQ8hoWGdZG47cd1JlUWrCsCif+ZNhE1KODKxYfsxRdi3E
         MRZn6HapBYAg0UA5cGPdYjN2Ez49pKL3oTWgsNfTbPXh7QP7IOSew8xHPE9Lzk0EYL
         taWHXlbEjxqgoXlV8+BenbnwAm331XFx3FkrwOL5vU2D3Z3sL7uZJ/fFwDuzXJ/H+4
         jO50MmkRYCHbIRnvrtcsJdF8A0X35ZFCFdmt+rgAB4gz/z3FqHK9a4ylu3kMUyXHIm
         /O3R59N+QURiWKG+N0x/O92ZXxyYnAt8S7U0gMgl5cLVDZdpdKg+lh2ADQo47QOYlo
         hxoePjZ5XRblQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 6.0] mt76: fix 5 GHz connection regression on mt76x0/mt76x2
References: <20220907095228.82072-1-nbd@nbd.name>
Date:   Thu, 08 Sep 2022 09:54:49 +0300
In-Reply-To: <20220907095228.82072-1-nbd@nbd.name> (Felix Fietkau's message of
        "Wed, 7 Sep 2022 11:52:28 +0200")
Message-ID: <87zgfabbk6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Some users have reported being unable to connect to MT76x0 APs running mt76
> after a commit enabling the VHT extneded NSS BW feature.
> Fix this regression by ensuring that this feature only gets enabled on drivers
> that support it
>
> Cc: stable@vger.kernel.org
> Fixes: d9fcfc1424aa ("mt76: enable the VHT extended NSS BW feature")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

I assigned this to me on patchwork and I'll queue this to v6.0.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
