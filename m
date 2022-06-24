Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A67AC433EF
	for <linux-wireless@archiver.kernel.org>; Fri, 24 Jun 2022 19:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbiFXTNF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 24 Jun 2022 15:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbiFXTMv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Jun 2022 15:12:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5257081DBA;
        Fri, 24 Jun 2022 12:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E43D1621A3;
        Fri, 24 Jun 2022 19:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62EC7C34114;
        Fri, 24 Jun 2022 19:12:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="itCPwM20"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656097966;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Opv7H7b7jpTZpdXbND2IHSq5Uo5YT03x2GlaOQr9ns=;
        b=itCPwM20JiYyV1kN1+KDhxgW9w0RihJJu6flpMpZtuZ8oJ0DFV0juVxcxWghz5ae4y59Tq
        Ek+LUY8t7g9LNLYunYWoKtKz/TxRPNMbQi+OIJnRX5c10ispOAwInSzEKzTvsqvdPGS/KJ
        WibS2bs7Fpa7NZsS7PEwJlz0XS9DXCs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1fb3e598 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 24 Jun 2022 19:12:46 +0000 (UTC)
Date:   Fri, 24 Jun 2022 21:12:42 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Gregory Erwin <gregerwin256@gmail.com>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rui Salvaterra <rsalvaterra@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH] ath9k: rng: escape sleep loop when unregistering
Message-ID: <YrYMqqqoK7HBAXgJ@zx2c4.com>
References: <YrUKUt5nvX8qf1Je@zx2c4.com>
 <20220624011449.1473399-1-Jason@zx2c4.com>
 <CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAO+Okf5k+C+SE6pMVfPf-d8MfVPVq4PO7EY8Hys_DVXtent3HA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Gregory,

On Thu, Jun 23, 2022 at 10:25:26PM -0700, Gregory Erwin wrote:
> Hi Jason,
> 
> I think you are on the right track, but even with this patch
> 'ip link set wlan0 down' blocks until the hwrng reader gives up.
> The reader can either be userspace (dd, cat, etc) or it can also
> be the rng_core module. I can replicate the hang in the two different
> situations, so I gathered two stack traces for 'ip' depending on the
> reader of hwrng:

Thanks for the traces. I'll send a v2 to you shortly.

Jason
