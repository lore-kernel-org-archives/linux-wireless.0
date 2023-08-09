Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B33F0C001B0
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Aug 2023 12:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232242AbjHIMXa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Aug 2023 08:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231426AbjHIMX3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2023 08:23:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8D01BDA
        for <linux-wireless@vger.kernel.org>; Wed,  9 Aug 2023 05:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=nWwK8CKTUZhgeeQHgcwt/1g76fZqRGLnTnRAA45SNoQ=;
        t=1691583809; x=1692793409; b=VW3Xd7OkYfR/7U9iIhdGPUOnm/G+oq88FvKdvcshmLBbHtb
        xZwSDc257/shma1J8yRgfozDLywi6eUKPYTXrH/nmK37epAPYcQPLnFFK1fVDqe9KVKYU5d7fAjge
        SF3v/bJEMfZrZk0o/Xq3XE8F+FIR7Z1zx6kCnnrmonD51lt492X4dxIzDawejPVD2raYWJ4X9Vq53
        KamXOI7eubDvN3GqQX7LbHQj6fWoKHTFNedn/fDS7xAg0/PuHgyCjQElaMPI90VZf+NowN2W6F2hh
        hW17IXyjKojNYz+Xmvei/jFfAROVZfsFuaJ2OPSnpeBr5VTYYK5pOwDFjBNmpCRw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qTiDm-00Ecxs-37;
        Wed, 09 Aug 2023 14:23:27 +0200
Message-ID: <e78119dc1ae2e22ea84b6528492aeba1ab6bfcec.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: mwifiex: added code to support host mlme.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Lin <yu-hao.lin@nxp.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc:     Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Pete Hsieh <tsung-hsien.hsieh@nxp.com>
Date:   Wed, 09 Aug 2023 14:23:24 +0200
In-Reply-To: <PA4PR04MB9638FE710460BC44BA290470D112A@PA4PR04MB9638.eurprd04.prod.outlook.com>
References: <PA4PR04MB9638FE710460BC44BA290470D112A@PA4PR04MB9638.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Please see

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#commit_messages

> 3. The code is enabled and tested with IW416.
>    There is no guarantee for other chips.

That seems misleading - it's not even enabled for other chips, is it?

Or are you saying that there are multiple variants of sd8979, and only
one of them is supported?! In that case you need to detect it.

Also, it seems like you likely need to detect the firmware version that
has the support, not just the hardware?


> +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> @@ -331,6 +331,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_=
sd8786 =3D {
>  	.can_dump_fw =3D false,
>  	.can_auto_tdls =3D false,
>  	.can_ext_scan =3D false,
> +	.host_mlme =3D false,

probably better to not have all the =3Dfalse lines that are default
anyway?

This is the only one enabling it afaict:

>  static const struct mwifiex_sdio_device mwifiex_sdio_sd8978 =3D {
> @@ -408,6 +413,7 @@ static const struct mwifiex_sdio_device mwifiex_sdio_=
sd8978 =3D {
>  	.fw_dump_enh =3D true,
>  	.can_auto_tdls =3D false,
>  	.can_ext_scan =3D true,
> +	.host_mlme =3D true,
>  };

johannes
