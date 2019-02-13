Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F6AFC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 15:04:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28947222C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 15:04:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391227AbfBMPEf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 10:04:35 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:45476 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfBMPEf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 10:04:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gtw5O-0002Hp-H5; Wed, 13 Feb 2019 16:04:30 +0100
Message-ID: <36adaef5c982ba10444d6f837b0d5c55ac953bdf.camel@sipsolutions.net>
Subject: Re: [PATCH 2/4] mac80211: Free mpath object when rhashtable
 insertion fails
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org, j@w1.fi,
        tgraf@suug.ch
Date:   Wed, 13 Feb 2019 16:04:29 +0100
In-Reply-To: <E1gtvgu-0006bT-4G@gondobar>
References: <20190213143853.labj6zdcsoupkris@gondor.apana.org.au>
         <E1gtvgu-0006bT-4G@gondobar>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-13 at 22:39 +0800, Herbert Xu wrote:
> +	if (ret != -EEXIST)
>  		return ERR_PTR(ret);

Surely that should still be "if (ret && ret != -EEXIST)" otherwise you
return for the success case too? or "else if"?

I'd probably say we should combine all those ifs into something like this?


if (ret == 0) {
	sdata->u.mesh.mesh_paths_generation++;
	return new_mpath;
} else if (ret == -EEXIST) {
	kfree(new_mpath);
	return mpath;
} else {
	kfree(new_mpath);
	return NULL;
}


Yes, that's a small change in behaviour as to when the generation
counter is updated, but I'm pretty sure it really only needs updating
when we inserted something, not if we found an old mpath.

johannes

