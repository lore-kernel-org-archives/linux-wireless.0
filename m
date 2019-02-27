Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E756C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 04:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E28E820C01
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 04:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTW45Lsf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729621AbfB0EKO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 23:10:14 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:34113 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729128AbfB0EKN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 23:10:13 -0500
Received: by mail-qt1-f196.google.com with SMTP id w4so17795331qtc.1;
        Tue, 26 Feb 2019 20:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:openpgp:message-id:date:user-agent:mime-version;
        bh=edVEwIEcvFT3+srUheO+k6GsPreKwGYcgyl2hbxIx5U=;
        b=fTW45LsfV2KbgkqZa9P9PlNZx5UoR6P6g+sPtAuH11DmhCJLLLxwFH1e9Qn6cRVo5D
         fiMIrdEKeLN4Kv8n7w3xz/wnLPvhX/VvnICJ4/vppTgRrrU+PrVloF0nLzsbY+QYfhKJ
         Zee9ynyXUS46rRoaBMqowthk6PlUqItaNHxp1TM6uJBSRD+ExLTE9Tw5eYNZcZmEWtON
         hXlRknO8KhP1zxRD0q4DCjF7L/Ad5QP37Hx6jhe2ka0Ub7MY9jnwt1lnBHWEuFWIL6V0
         OaLNWz6zrp/83BAWPYTXphLtu/yiBHuqCKKb7EtiWleMtDu6Ge7VcHShcPnnxuzkvYNo
         8mjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:openpgp:message-id:date
         :user-agent:mime-version;
        bh=edVEwIEcvFT3+srUheO+k6GsPreKwGYcgyl2hbxIx5U=;
        b=hqnX9QVROJrD28DXKIuLBZf/mPRf0dgqBCp+8dBrjiZmKt4GVxsVB2RkiNjF9xLeRq
         mG/nnvTTRA7V+vU9Tng8gXUHql1V7rkV49O+GK7llGd3aeITmZxojw28ODbiAzG2OXEf
         OzjyXJkOe9pKDcfmfVPLrYNJ+2kGtOM43J1TZVhiog42BcifPGfI4BR5NCsW1E2Hr7hG
         IhyBjW49yH6BJUyDBv3Iq6IkSqx9M5qDpl+v5ueBClrBxijf8CnCvZ9WofU8ZSlpq9LS
         +C9WFDfxNRkLzu4vbYGEXpZvsxK+zWJUtsDK3CrzY6FbycaKwixnEQs0DyXxB3VGeGOo
         KegQ==
X-Gm-Message-State: AHQUAuaWBSy5/Z3ym/dWrKZ20yHgmubA9ODj2b/usSv1TJrTiYDJqiof
        IgVGGykv3UmZVg4WdajuiojtxuI6
X-Google-Smtp-Source: APXvYqwd3zSVvwwc24DvJlNYo2egWmbL2z4VymWRoi9u7DhiDsrAzxC+qzwmvIhDy/twYyWvUtRlSQ==
X-Received: by 2002:ac8:3341:: with SMTP id u1mr79451qta.58.1551240612322;
        Tue, 26 Feb 2019 20:10:12 -0800 (PST)
Received: from [192.168.1.6] (pool-108-28-156-19.washdc.fios.verizon.net. [108.28.156.19])
        by smtp.googlemail.com with ESMTPSA id w1sm8838193qtc.75.2019.02.26.20.10.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Feb 2019 20:10:11 -0800 (PST)
To:     pkshih@realtek.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
From:   "David R. Bergstein" <david.r.bergstein@gmail.com>
Subject: Realtek r8822be kernel module does not negotiate 802.11ac connection
Openpgp: preference=signencrypt
Message-ID: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
Date:   Tue, 26 Feb 2019 23:09:47 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jM5SJGnqCJY8qLuy5orxzXv3VXPjwhGQf"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jM5SJGnqCJY8qLuy5orxzXv3VXPjwhGQf
Content-Type: multipart/mixed; boundary="zYyrZYSjHZYVTJ14bN0A12lOuZm02PxWp";
 protected-headers="v1"
From: "David R. Bergstein" <david.r.bergstein@gmail.com>
To: pkshih@realtek.com, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <51d62a31-7cde-e815-bdee-4ef5433007aa@gmail.com>
Subject: Realtek r8822be kernel module does not negotiate 802.11ac connection

--zYyrZYSjHZYVTJ14bN0A12lOuZm02PxWp
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US

This message is in regard to a bug I have open on bugs.launchpad.net,
1813372, linked below.=C2=A0 This issue, originally identified in an Ubun=
tu
kernel, has been duplicated in the most current mainline kernel,
5.0-rc8, and is in regard to problems attaining a wireless connection at
802.11ac speeds.

https://bugs.launchpad.net/bugs/1813372

At your earliest convenience, please see the bug report above, and
advise if a fix will be available for the r8822be kernel module.

Sincerely,

David R. Bergstein



--zYyrZYSjHZYVTJ14bN0A12lOuZm02PxWp--

--jM5SJGnqCJY8qLuy5orxzXv3VXPjwhGQf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAEBCAAdFiEEmajOzgQlh7dLtUxJC6xF9iYnYB8FAlx2DZcACgkQC6xF9iYn
YB8Y6Av/TIo84uNK1g8vgmmNjl6dOAQAxyHFdGKIRijHIaLoIDlZnK88X7g01Gdf
Vn0uEsldfSRH/u1Owwl6oWcIj7REhCeUzvEF8buTqd49zx8ImRbGALmjWHrkXByv
ARhqLFLxRyQ4auwkZuS+ZtKL6OEYAL3mtBIhfkjU/lqe46tiBT2530YN4L089iOk
ALWmOz4IUAX7I3IvHe4U+cacST1Yyjw+CirccpFM3DrGFt8mixBO5bR6nhxVxxyA
0lFCyobVkCyB68tRZXNqtUIa+pS76ofZpt/LyA/b8w4sf9qRYPXsWJ86LoEig4of
dfJgPkhxr/psYp84tALfm/dWYUMhNqkGkUbooGYGUKr+mVFJq+SRD4160e9tg3Jq
7U7eJtBFVNUResUG72KdX3aVdFIwRXWcWh8oQc961MHGuXgs3fiScI0o+pCjSRhp
lUGtYQSCUOHhZ19Glzw6LnoCTe/FxAJMGGmMYy8rGbZAtI7IT2pIhCISncuATEvW
7DSkPzP8
=2sTq
-----END PGP SIGNATURE-----

--jM5SJGnqCJY8qLuy5orxzXv3VXPjwhGQf--
