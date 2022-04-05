Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A621BC433FE
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Apr 2022 03:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451920AbiDFDJt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 5 Apr 2022 23:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457544AbiDEQI7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Apr 2022 12:08:59 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2921F25CD;
        Tue,  5 Apr 2022 09:07:01 -0700 (PDT)
Received: from zn.tnic (p2e55dff8.dip0.t-ipconnect.de [46.85.223.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C6A571EC0518;
        Tue,  5 Apr 2022 18:06:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1649174815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NIHZ+oWgHNxDPqo+kf4JAqld28hQkGONJlhfcuaM2A4=;
        b=YpyH3gE3vol361+JkMCGivTB3ISpKPRQux3pAYKUECfl0l6waGULLAo/1JAE9dDOTMQLcp
        3UrC221rE5FpMTmwHAN8IkzbdYBwjYcaDJ2C6HDBDyxNcT5bt+VAEp1IEMAQ29f3s2qRXT
        SpLbJXPjUOdJaa9FzRDSsBN4mKM5QA8=
Date:   Tue, 5 Apr 2022 18:06:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 06/11] brcmfmac: sdio: Fix undefined behavior due to
 shift overflowing the constant
Message-ID: <YkxpIQHKLXmGBwV1@zn.tnic>
References: <20220405151517.29753-1-bp@alien8.de>
 <20220405151517.29753-7-bp@alien8.de>
 <87y20jr1qt.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87y20jr1qt.fsf@kernel.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 05, 2022 at 06:25:30PM +0300, Kalle Valo wrote:
> Via which tree is this going? I assume not the wireless tree, so:

Whoever picks it up.

> Acked-by: Kalle Valo <kvalo@kernel.org>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
