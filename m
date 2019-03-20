Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D9DCC10F05
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 12:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0CA52175B
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 12:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="e2ssjAx/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfCTMNn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 08:13:43 -0400
Received: from kadath.azazel.net ([81.187.231.250]:45520 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfCTMNm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 08:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=K+BS3UVbmz6lIBbC1bue6JFHcJxWC6jm7YXAXxS2wUM=; b=e2ssjAx/NCQpiYAehjV7nx2N6k
        xCFmQieu5XIbV9lO0clBz7ElsU1Svgl4XbYDhnOFYV5HRLlT05LGPX61kCF6N3s5XrXEYO4evBbHK
        UeDvcAkBwMYi8WDC3pRKZdeG3yRN+RS8qUXNrq4iRGxmSSBKhKQT7v7EpEWw2J4yNCNhc7HcIBWz6
        zYLwUiMl71hOy2voYrus6Ycia37SEb5QltkK52nOgvwzNuFlKannt8OILszBhTALXqAWpqMhn1+Zo
        y0+anEPuv2rNL7Jq/tV9CHmuhZxcyYncIwd+IapqQ6Q4caKIaMjZSbU3K5927tXt2+GjN4/SHqhRq
        mC7OVetg==;
Received: from kadath.azazel.net ([2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jeremy@azazel.net>)
        id 1h6a5x-0002pe-V4; Wed, 20 Mar 2019 12:13:22 +0000
Date:   Wed, 20 Mar 2019 12:13:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Julius Niedworok <julius.n@gmx.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ga58taw@mytum.de,
        linux-wireless@vger.kernel.org, david@redhat.com, nc@net.in.tum.de,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2] mac80211: debugfs option to force TX status frames
Message-ID: <20190320121320.myrxmtfccaoybyih@azazel.net>
References: <e20962001ee10a0f90f8e2f1f8baafcf3b70e9dd.camel@sipsolutions.net>
 <20190306200206.60916-1-julius.n@gmx.net>
 <87k1hazo6r.fsf@purkki.adurom.net>
 <20190307193045.a7awwn6mycloccq5@mission-control>
 <87h8c98q4l.fsf@codeaurora.org>
 <20190311145240.akms2pz2hxsalmaz@azazel.net>
 <D78A58DC-E38B-4BD8-9D11-A873FFE16602@gmx.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gobq5cnyp6n7jj7v"
Content-Disposition: inline
In-Reply-To: <D78A58DC-E38B-4BD8-9D11-A873FFE16602@gmx.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e2cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--gobq5cnyp6n7jj7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-03-19, at 16:07:32 +0100, Julius Niedworok wrote:
> On 11.03.2019 15:52, Jeremy Sowden wrote:
> > It's the value that matters, not the type.  It will only be too big
> > for the buffer if the result of casting local->force_tx_status to
> > int is less than -9 or greeater than 99.
> >
> >  scnprintf(buf, size(buf), "%lld\n",
> >            (long long)local->force_tx_status)
> >
> > would also be fine if the value were in range.  Note also that
> > scnprintf will not overrun the buffer: it will truncate the string.
>
> Thanks for the clarification :)

You're welcome. :)

> > As it happens, arguments to variadic functions are subject to the
> > "default argument promotions," so if local->force_tx_status is in
> > fact a bool (I can't find the definition), it would be promoted to
> > int and the cast is superfluous.
>
> Yes - the cast is superfluous. We still think it might be useful to
> keep it there to make the point that the value will be casted.
> However, if you prefer to omit the cast, we are happy to take it out.

If I were maintaining this code, I'd probably take it out.  However, I
did have to check the documentation to verify that the cast wasn't
required, and I know the more obscure corners of the C standard pretty
well, so it may cause less confusion to keep it.

J.

--gobq5cnyp6n7jj7v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAlySLlcACgkQ0Z7UzfnX
9sNIMQ//fDp3IMBLu8+HwPUXtM2AkLgb9rCRP5CRwci6vn8rV5oz3LS3QMcA7jFp
l3f0QBBR46ci5rYYT0j51coOagA0OYwvm1rdeodnvCpXm4uNveBoHYpjuYsSWpuf
HNlauDby25BT57hyzvccO//gpig5BAcBa7tXunbvPao69AGB2txfPBOXgkFdBzP5
wgZ+4ajlneiliNdLVxEOn7pNNV0fFcn4msz4tqi2ek7ooWwTZquvDqwcz4/hfcqd
te3xsqY1lTYk3xOzBuk0gNbCcf0+vQEW9Z72VWbJtuJsm9ydz/JNRjzRFbxMTNdF
tg4fNARhN3U4rn0/vOXtLfLcdYBgzMlvAXy/Mh/QX72ME2Uz9sLktZGgwNCXje5p
7QkVkYI3JYrK+YlAN8oYb5C+mK5hTJg6Zj6RXaR8vuRpV+r/qvU7pr+JTzBYLs5N
C/2SM1CcCFA/7P+JyIFUbM1dDRRjq2vtNQ7as2+JFNvAlnzwpMrJ7hsQz73ZxIdf
/xSe3m3RyI3bHhAPFVJFAchL/lLAkvNhHccwFaIrBsSpYfXihxK/TNX4LfXDYeTl
ZLJ/IHDMaHVAvkOdfa3zgs2Hb7aMgWsCfrq5hzbG+pF7pXJSvPM2/KoT7ZiCmh6l
1xSMO+jgWFPBMCgO7T6IB7si7QgrINZmLy20/lNY4KAVIIAi8l8=
=tpY5
-----END PGP SIGNATURE-----

--gobq5cnyp6n7jj7v--
