Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F390C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 20:10:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D04682087C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 20:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=narfation.org header.i=@narfation.org header.b="Cax4RQI5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfBYUKk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 15:10:40 -0500
Received: from narfation.org ([79.140.41.39]:48580 "EHLO v3-1039.vlinux.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726740AbfBYUKk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 15:10:40 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2019 15:10:39 EST
Received: from bentobox.localnet (unknown [IPv6:2001:16b8:556a:d9ea::788])
        by v3-1039.vlinux.de (Postfix) with ESMTPSA id 349B811004F;
        Mon, 25 Feb 2019 21:00:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=narfation.org;
        s=20121; t=1551124841;
        bh=36gWksIvBe8fYNSw6HZj3ZYsOMDFAXmT42HmaJKZRXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cax4RQI55ecQiEoHnhNfo/qIhO3aiBIxJfKM1oxbe152jbKdQSFSKxXu/Cmuurube
         PQzJoGIYJWPMJTfPHVynPjeCvJX3WO8mxxUS+39Pnm6+P+4icM2f/drxlGxxU3cMu4
         myvMG6ViqND2Nr8A5VzYkPZwj3fdNSSnMoh0ZkmQ=
From:   Sven Eckelmann <sven@narfation.org>
To:     ath10k@lists.infradead.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Zhi Chen <zhichen@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix incorrect multicast/broadcast rate setting
Date:   Mon, 25 Feb 2019 21:00:38 +0100
Message-ID: <2172036.sbaLp6LFFn@bentobox>
In-Reply-To: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org>
References: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1608350.tWY5D5mM8n"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--nextPart1608350.tWY5D5mM8n
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday, 11 December 2018 05:56:11 CET Pradeep Kumar Chitrapu wrote:
> From: Pradeep kumar Chitrapu <pradeepc@codeaurora.org>
> 
> Invalid rate code is sent to firmware when multicast rate value of 0 is
> sent to driver indicating disabled case, causing broken mesh path.
> so fix that.
> 
> Tested on QCA9984 with firmware 10.4-3.6.1-00827
> 
> Fixes: cd93b83ad92 ("ath10k: support for multicast rate control")
> Co-developed-by: Zhi Chen <zhichen@codeaurora.org>
> Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
> Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

Tested-by: Sven Eckelmann <sven@narfation.org>

Was tested on QCA988X with 10.2.4-1.0-00041

Kind regards,
	Sven

--nextPart1608350.tWY5D5mM8n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlx0SWYACgkQXYcKB8Em
e0YnWQ/+P/Haq1uzyOVtvM0YlanARqSIj8TUYC6IDGZm+XA2hHb8O5oYZgvb7vMV
uviv4QKs5HGfK252jmjdUAHbMiMBMU84YIzIyeEFZq0DB3InZequMFB9RpOfo20a
CeJTyfPwqrYeSAebTsEXi1TKvHI7AFdD7Sv7flQODMVyBDWJcNXLRDa5G557qxy9
9GuPX8kwGQ7mMTxQcDQbBZYtwrN4O22UK7AZao/Vy0q7TaTecfJ832nVTHELLVC8
FsJQthU7jxXu48BQ1MRzeMaAdlZJNcWYKYxz4WIY3XbBmq7QTJoyMcrKftGRqxPm
HCJipsb4kcNgV8geOXPG/PYWdV0bz2mzf248ofM5byEWY8UbDZCHWhLhbZJI83iG
VEghE+Dq8J6RzQqvRG3lav8gAaF+BYfFO+lZ9K3j4+97PNosstPB06Jxb+/fZBWI
sEDBHkqlY/w7iW85MpqCxYsWQYXfpokTVz9zqX5DCHnbo83K17OjSq1qzaqrcVNC
Zk2DRQJwHcnmWQtzVom0957j3dPNA3Vihp8iFxOzINbOP8OC0hCPjUTddpn9KHXr
OVd1nHXym+RcowTnpWrwgFo/47DRFoXYNMvlpsw7Y9m2kPKfosWJtSjCu66/0tcu
oIiunrUnrgnXn4gQzZYYgf6T1jjouqAUBlp9VcFLV8c+2p5LnGE=
=fqSU
-----END PGP SIGNATURE-----

--nextPart1608350.tWY5D5mM8n--



