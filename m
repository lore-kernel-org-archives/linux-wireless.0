Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F990C10F13
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 01:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ADF220693
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 01:06:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="rbQKp0o1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfDIBGN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 21:06:13 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42831 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726352AbfDIBGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 21:06:13 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44dTcy0Zwyz9sPn;
        Tue,  9 Apr 2019 11:06:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1554771970;
        bh=lxxVKlKb71VvqRuml/havxSf1qEKip/V9oXdYFARi5A=;
        h=Date:From:To:Cc:Subject:From;
        b=rbQKp0o1zN9VqgJwb165FaFyEujOs/LnT7/OvCJ20hxMIzcw0iPECZEr/PJo9QIoU
         qQs97fIWRp9/it8yixwRzC2HPJ6HqcZJTkTVZgGjUsMAQoskE+NTVLnPCixUmaqKFM
         aJFBO9rF9Qn7cHS2rheH47R0CJKbQCMPniod+pRgNZkVyriIvouxo6uGVg2V0Dl0HF
         4IrsAFjn+gH8bdaOJ48aA74XLO3fXVQZWDcK/bXMzxFj899fTbPvGnfOOoRRtVpxkx
         ulvMRzohSpvaHFzH17QpitLQd+cwEQA2sJizOWB0+PVR9DwSOdi2gezei2MwOW6BSz
         z/ykInBB13THw==
Date:   Tue, 9 Apr 2019 11:06:07 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: linux-next: manual merge of the mac80211-next tree with the
 mac80211 tree
Message-ID: <20190409110607.29df3cf3@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nk7TK0lKM_uOHgtwjGYIvFv"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/nk7TK0lKM_uOHgtwjGYIvFv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mac80211-next tree got a conflict in:

  net/mac80211/tx.c

between commit:

  eb9b64e3a9f8 ("mac80211: fix memory accounting with A-MSDU aggregation")

from the mac80211 tree and commit:

  dcec1d9bc8a7 ("mac80211: calculate hash for fq without holding fq->lock i=
n itxq enqueue")

from the mac80211-next tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc net/mac80211/tx.c
index 2e816dd67be7,3655aae96df1..000000000000
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@@ -3221,7 -3219,7 +3219,8 @@@ static bool ieee80211_amsdu_aggregate(s
  	u8 max_subframes =3D sta->sta.max_amsdu_subframes;
  	int max_frags =3D local->hw.max_tx_fragments;
  	int max_amsdu_len =3D sta->sta.max_amsdu_len;
 +	int orig_truesize;
+ 	u32 flow_idx;
  	__be16 len;
  	void *data;
  	bool ret =3D false;

--Sig_/nk7TK0lKM_uOHgtwjGYIvFv
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyr7/8ACgkQAVBC80lX
0Gz0cQgAm7Z45grpN06oI1vDHbeyWc1Nf5XOqaDdgOzObo+f8Fbemq832Wv9g9Rv
2Um1yA8WsPO1n+avHfatwoEV8O34shDxpRxCQkSauALhsdKY4W1Wlp8FA2M7GteV
E66NVIITDIL8Men0nhNTUG9UFWpI7yeEfzJyHhX0Zm3w3AyVTJqYn/06ikKYObx6
ue8YTx74ttTG/hK1N9MMoDSGNFqx+XaG9MQPWdqhi30Q1KV10hOpHUNu56ma7ZSQ
erEM9Lk1R3DJLYKklLGJEXz+x0yXQ+pHYIVYxWY6RNkFz5g+5P8z0j3ptRY6N9ki
/CohVqDhFhZEEb2RJPDCSpc1jpCRMQ==
=g+rO
-----END PGP SIGNATURE-----

--Sig_/nk7TK0lKM_uOHgtwjGYIvFv--
