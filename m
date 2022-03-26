Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF2E6C433F5
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Mar 2022 00:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbiCZAeI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Mar 2022 20:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiCZAeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Mar 2022 20:34:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A5821C068;
        Fri, 25 Mar 2022 17:32:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43BFD617F4;
        Sat, 26 Mar 2022 00:32:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D718DC2BBE4;
        Sat, 26 Mar 2022 00:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648254748;
        bh=W5ABJmkgq2kfOth8hTGu20ms0KqbgyZnr4kOvfQYbiw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F0y8LKzONRFCzxxREDehPswEzK0Lz1D+t2A67KRv8WDBwz0ydH0lQh+4TKmgWRs1c
         A1gGihtCwmZ0Ztcix/7u6qz+GpbrYYVTVlpwIzMgKxDMWa2qFHdsPch3V/7gQ5+T4T
         WB/FIqBeqT90YUz8qdBZsUhq2vCOmgEnmtIRI6/QW4IN6VbB/UH+dRRiAWhQlLf9Lz
         TXKvf8VyOoc2ShHrjn1oEsR9P5gZq9lAu1v0NVwY58/Hbt/dVOEfJ9moxN9U+KSCr6
         d3lSHi1RrBh1Hu007pZvlcjENdxm0PgsNGdOLLFqQdDlVjGYzAmD/z1uzz81qD6luB
         db65bzOem1Ddg==
Date:   Fri, 25 Mar 2022 19:41:37 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] iwlwifi: mei: Replace zero-length array with
 flexible-array member
Message-ID: <20220326004137.GB2602091@embeddedor>
References: <20220216195030.GA904170@embeddedor>
 <202202161235.F3A134A9@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202202161235.F3A134A9@keescook>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Feb 16, 2022 at 12:35:22PM -0800, Kees Cook wrote:
> On Wed, Feb 16, 2022 at 01:50:30PM -0600, Gustavo A. R. Silva wrote:
> > There is a regular need in the kernel to provide a way to declare
> > having a dynamically sized set of trailing elements in a structure.
> > Kernel code should always use “flexible array members”[1] for these
> > cases. The older style of one-element or zero-length arrays should
> > no longer be used[2].
> > 
> > [1] https://en.wikipedia.org/wiki/Flexible_array_member
> > [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> > 
> > Link: https://github.com/KSPP/linux/issues/78
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>

Hi all,

Friendly ping: can someone take this, please?

...I can take this in my -next tree in the meantime.

Thanks
--
Gustavo
