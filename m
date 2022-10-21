Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0AA0C43217
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Oct 2022 13:17:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiJUNRq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Oct 2022 09:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJUNR2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2022 09:17:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EB026D92E;
        Fri, 21 Oct 2022 06:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=AAvfJJFVhJ6XeQFgLxgGQ1veyEOuryBX77FqDnPvIaw=;
        t=1666358239; x=1667567839; b=SJ/fkpPwoyDY20N8O8pt4W5Fj7KfQ5xEmjN0H98y7b2t3wY
        Q7W7aeB4oFf57bXtK0Di+EEnG51txDj99eqJ4WLTSJmul9e4o6lkbQdBENWKfRbbH96fojiM286Wv
        Y/YoHbUDgOnQHhnQp6PEZ16x1WvdgSr7Yd5hbhKv4sRDqQVFsKypfpnp6cLGp5jK90v5CRCCJk+jt
        I2OHeK/Pla/0Sr14yAhp2NaHP2j9TBhRiZGPvwD1Hx2UBKvt9L8bMWdgyDgRfdBKLlwgK3uHxTDjY
        bV8v2mCDAAWUQVDhYcJaOurIDfMb6wrOMJsg33nMXcpJbjypJ8gzZfhzP6FYAaHg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1olrti-00Cs7j-0i;
        Fri, 21 Oct 2022 15:17:14 +0200
Message-ID: <8343dfbd02b6206ce974d5280897d948892a86f9.camel@sipsolutions.net>
Subject: Re: [PATCH -next] rfkill: remove BUG_ON() in core.c
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Fri, 21 Oct 2022 15:17:13 +0200
In-Reply-To: <20221021130104.469966-1-yangyingliang@huawei.com>
References: <20221021130104.469966-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2022-10-21 at 21:01 +0800, Yang Yingliang wrote:
> Replace BUG_ON() with pointer check to handle fault more gracefully.
>=20

That's basically (static) user errors though, so at least WARN_ON or
something?

johannes
