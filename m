Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4300C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 18:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AB232243E
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 18:48:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8AB232243E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bues.ch
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728351AbeKOEwl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 23:52:41 -0500
Received: from bues.ch ([80.190.117.144]:38908 "EHLO bues.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbeKOEwk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 23:52:40 -0500
Received: by bues.ch with esmtpsa (Exim 4.89)
        (envelope-from <m@bues.ch>)
        id 1gN0Cj-0002hI-VO; Wed, 14 Nov 2018 19:47:58 +0100
Date:   Wed, 14 Nov 2018 19:46:28 +0100
From:   Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To:     Priit Laes <plaes@plaes.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] b43: Use cordic algorithm from kernel library
Message-ID: <20181114194628.0f485637@wiggum>
In-Reply-To: <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
References: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
 <d93962cdc5a32fe99e6e5a25172920d28583aa6a.1542219596.git-series.plaes@plaes.org>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/v/Gtp+3WZf2T0zsNVwRZBC/"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/v/Gtp+3WZf2T0zsNVwRZBC/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Nov 2018 20:27:52 +0200
Priit Laes <plaes@plaes.org> wrote:

> Kernel library has a common cordic algorithm which is identical
> to internally implementatd one, so use it and drop the duplicate
> implementation.


In v2 of the series it has been said that:

Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
> I recall doing a comparison between the algorithms and thought I put=20
> that in the original commit message. However, it is not there. It is not=
=20
> exactly the same as in b43 so there are difference for certain angles,=20
> most results are the same however. This implementation is slightly more=20
> accurate on the full scale.


That's not my definition of "identical".

Please do not apply this patch without doing a thorough regression test
on actual b43 LP hardware.


--=20
Michael

--Sig_/v/Gtp+3WZf2T0zsNVwRZBC/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEihRzkKVZOnT2ipsS9TK+HZCNiw4FAlvsbYQACgkQ9TK+HZCN
iw4ikA/9F3YX8qJLGOLZS+Mj84G+Pgbka+VHeXYzsA+7fl5qbRjf9LFz0/t3gpmS
3VjpleNONAEBrEmt6jTCEOL6/c3MiBHlCZjG75zuybjjoHPkkpDv+0MMzNZP1SmS
UfXDlXL8pvIp4rwDJvS7UEglfa9hjjUMUwLPwM/vJJ+I+dZWkgG/WB36J5r5o0uf
rqWw944Ta21vm/tb5bhaH63WZx4/yO68K3vWUFASgysIIschAbiYI1hr6ewEx5yo
7s+dahHO0pEWkf+C0bQ95a5+GSCC6mrphkonyQhYt1QYdsUQeS48Aog1HlEA2DWr
H8kjt6pxgyNHrxHxni6zK/DTP72k4UUfVo5PPgNQrPazMAefimFWqwBGUp9zw9rw
otpPxq2VsBD9tYVEwHuYrXanNI7gAqcirL8Dri931sm4dtKuHdKmid3JLzXBVgqF
4qvGsbH8fcW63OPTHPYzrfSZj+gYquf+F86KK91PPopXvb0byUGgA5kNz/Uev2G/
OmS0lPuPgwi2CgdfYKfRxLsA5dYhNNty030faoClat1jDII5gNecmt/54jj7XDbT
o/OLLEw4YaiFPAfOwMh+l78iE6awbGlKmQdKczL4QuUs4SByXZAdAkfZTF/utIFe
9OEaWjH0pP9jit1b0/7hp44fptvanh8zspM82+n/U/wlHLuWEq0=
=VqWV
-----END PGP SIGNATURE-----

--Sig_/v/Gtp+3WZf2T0zsNVwRZBC/--
