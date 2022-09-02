Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC5EECAAD5
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Sep 2022 15:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbiIBPNH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Sep 2022 11:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236325AbiIBPM1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2022 11:12:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C102495D;
        Fri,  2 Sep 2022 07:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=oxVqXtE/hinD1AroStGketJT7ozjTP3PmCtG0YZC1Y0=;
        t=1662129813; x=1663339413; b=rWpi10GiKcQR41CBIodi2aNvN9Azs0zx06qb0W4JVJGek0N
        iNgY1pzjPSlj309AT820Doft8bX/dcPQ3YWJtQGsTSxEZcK1ifIYJwdHk9ASvWXiaUxOg82TpsSJ9
        jOPLr0larvxg0axLz8o7MufYg+eKK+b796RjIOYws/LstoOh5ZeQ2T7RajiTHalKFcJJaLUkcLH/E
        ZDoZR0Ih9Na/CS/VL4Q/Doebu7qOok8agknz+z5QkDkLXujvtnmaSc1OIGjaqeItglAjAK0Vmo9Vn
        uJND1WEyIP/wFgNFMLG4jzuDdYsJY9qNwvlepoXXBpBm/yUOq+cCr+zr3LeSMnkw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oU7tJ-006D9j-2u;
        Fri, 02 Sep 2022 16:43:30 +0200
Message-ID: <0041cbac8840b51d16c6a5487a332a37effbb264.camel@sipsolutions.net>
Subject: Re: [PATCH v1] net/mac80211/agg-tx: check the return value of
 rcu_dereference_protected_tid_tx()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Li Zhong <floridsleeves@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Date:   Fri, 02 Sep 2022 16:43:26 +0200
In-Reply-To: <20220902075725.2214351-1-floridsleeves@gmail.com>
References: <20220902075725.2214351-1-floridsleeves@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2022-09-02 at 00:57 -0700, Li Zhong wrote:
> From: lily <floridsleeves@gmail.com>
>=20
> Check the return value of rcu_dereference_protected_tid_tx(), which
> could be NULL and result in null pointer dereference if not checked.
>=20

Except ... it can't happen?

johannes
