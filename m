Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FE6C4338F
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Aug 2021 20:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11A9461004
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Aug 2021 20:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234036AbhHIUG5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 9 Aug 2021 16:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhHIUG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Aug 2021 16:06:57 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3D0C0613D3
        for <linux-wireless@vger.kernel.org>; Mon,  9 Aug 2021 13:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=90lz2zud1WgSXseIMdNWHlW1oOyzXVZMgq01KiaMJiw=;
        t=1628539596; x=1629749196; b=i2ridrsfFiF26yfWMrq8lYb+iEquBdnYAPdZXsoM6++AM5z
        Ljogqeh6Nk3dq/JSXgfcEDzOXS6I8Cz7t5tNf6VSdVtTMtjAxdHtIpb+pOAy/LCIs32wLPkwCLSeD
        951y3UaumVFdD+obhlF7/PDi95A9CcXq8IfBnZENoR7RMw3XRUYhyLskiJyvzKWlwa5UI2pS61KAB
        KzFn2LeEeoe2cBaLB9xA6XbsvOztBi0lY25Cu7cXXb6f1TLswNfr7P9vwl9QRd7dxqNqJKKUvXbVM
        8NHxoxbH7O7fY68oV/evQlK+mmNPqnmQryxwc4WI3S/aX2xIgg2FahpE0E1nEQrQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mDBV4-008GGg-2e; Mon, 09 Aug 2021 22:06:33 +0200
Message-ID: <1f441ba830535161b62086c1fee0d027b36bffc6.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wireless-regdb: recent FCC report and order allows
 5850-5895 immediately
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Seth Forshee <seth.forshee@canonical.com>,
        bkil <b.K.il.h.u+tigbuh@gmail.com>
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Date:   Mon, 09 Aug 2021 22:06:31 +0200
In-Reply-To: <YOdVFE51Wbxr80Qf@ubuntu-x1>
References: <CAPuHQ=GbacSTgyimkJtx1FXp319Df=LdrPQZ6ZDnPQ_JVXueKw@mail.gmail.com>
         <10ffaa74a0779b7c7047de70cb1db7dfb0000022.1625068999.git.b.K.il.h.u+tigbuh@gmail.com>
         <YOdVFE51Wbxr80Qf@ubuntu-x1>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Uh, sorry for the delay.
> 
> The first is that it seems I forgot to test build this patch before I
> pushed it. The PTMP-ONLY flag isn't allowed by db2fw.py. This was done
> by Johannes for reasons which aren't explained, so maybe he can shed
> some light on it. The flag doesn't appear to be used by the kernel or
> hostapd, so maybe it was deprecated long ago. Anyway, I've pushed a
> change to remove this flag.

I don't remember, but quite likely we decided it was just not something
we could implement properly or so, and never supported it? Sorry.

Clearly the kernel does nothing at all with NL80211_RRF_PTMP_ONLY.

> The second problem is more serious. I thought that we could allow 160
> MHz bandwidth across two AUTO-BW ranges too small for this bandwidth,
> but it turns out that the kernel rejects any rules with a bandwidth
> greater than the frequency range of the rule. I'm not sure what we can
> do about this. Even if the kernel were changed to support allowing
> greater bandwidths across combined ranges, we're going to have a
> backwards compatibility problem with older kernels.

OTOH, doesn't AUTO-BW basically ignore the max bandwidth for a given
range anyway, seeing the code in reg_get_max_bandwidth_from_range()? So
just keeping it at 80 with AUTO-BW would still result in 160 being
usable? I think?

johannes

