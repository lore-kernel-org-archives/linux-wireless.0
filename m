Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81AFCC43217
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Apr 2022 03:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455615AbiDFDLn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Apr 2022 23:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457754AbiDEQkC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Apr 2022 12:40:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F12D9E85;
        Tue,  5 Apr 2022 09:38:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3137C617D2;
        Tue,  5 Apr 2022 16:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55BCEC385A1;
        Tue,  5 Apr 2022 16:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649176683;
        bh=tWvuX7ND9rBqkP1uSP+2Tul0OWLfm6+Xw2RC0nvxfWs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=SowZPN9R+c/QuQhJLP77gmZJo761jO44XrZTN6J+ExNY9CbTnx9VqSV4dfeLiaLXD
         6vMlasopq2teF36g8URsyYfOLwGSF+27+2AbU60100mN2eojAC/yJWaiO39LKoCWgR
         XAWuCjOE/KjEnk/+rdEYq7Iu7EhzgANGoPywjj89iJvjLZbQrlSHIi0T5HFqVp9nIn
         svGWwy3sVITBYukFBzAhNJnDfLcRpU3p0MN1a0mlEab6UGrYXHlhRQs5dGFHHl7vbW
         04O8whMAbyX8ts4ZZufErL4YQMV6z+2KDQqfGMZbc04hxOt+Y9GVL9UDMC6FezdtaD
         vTV6mvmhD0U8w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/11] brcmfmac: sdio: Fix undefined behavior due to shift overflowing the constant
References: <20220405151517.29753-1-bp@alien8.de>
        <20220405151517.29753-7-bp@alien8.de> <87y20jr1qt.fsf@kernel.org>
        <YkxpIQHKLXmGBwV1@zn.tnic>
Date:   Tue, 05 Apr 2022 19:37:59 +0300
In-Reply-To: <YkxpIQHKLXmGBwV1@zn.tnic> (Borislav Petkov's message of "Tue, 5
        Apr 2022 18:06:57 +0200")
Message-ID: <87pmlvqye0.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:

> On Tue, Apr 05, 2022 at 06:25:30PM +0300, Kalle Valo wrote:
>> Via which tree is this going? I assume not the wireless tree, so:
>
> Whoever picks it up.

It would be good to have a plan so the patch is not forgotten :)

Normally brcmfmac patches go via the wireless tree, so I could take this
patch. But you didn't CC linux-wireless so our patchwork doesn't see it.
So if you want me to take this you need to resend.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
