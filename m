Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B98CC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 07:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E9921019
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 07:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="FS72EXG9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbfCXHZy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 03:25:54 -0400
Received: from nbd.name ([46.4.11.11]:59440 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727963AbfCXHZx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 03:25:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=InzgAKpDIPTUxArWDj2I2CvJ7N8qJWI8vpqHwjaY2aw=; b=FS72EXG97aUOAwfa+YNTku2UZV
        oUGXFi2mIT5Up2d3bVkyL5VdtUV5dptjkC92TMHPoffQDqcOwLwsd2ju1i56B8JzyB7MeM0ugAXNS
        k5Wwgij0EuNSMyG4MMdCWgyqgIFaarYxt73gbQgjBGc9X+lByKyfdKDQ4pkCASt8nOhk=;
Received: from p4ff13c7c.dip0.t-ipconnect.de ([79.241.60.124] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h7xVw-00049T-5S; Sun, 24 Mar 2019 08:25:52 +0100
Subject: Re: [PATCH 00/12] mt76usb: some cleanups and optimizations
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
References: <20190321152537.19105-1-sgruszka@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <26d8dba0-0384-4e4a-6744-66fc03a66a1c@nbd.name>
Date:   Sun, 24 Mar 2019 08:25:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-21 16:25, Stanislaw Gruszka wrote:
> Significant change is remove mt76u_buf and use urb directly
> and allocate urb and sg as linear data for better cache usage.
> Other that that, set consist only of some minor cleanups.
> 
> RFC -> v1:
> - introduce mt76u_tx_setup_buffers
> - calculate data_len differently
> - fix *usb->sg bug on intermediate patches
> - use (struct scatterlist *)(e->urb + 1) trick
> 
> Rebased on latest tree and 
> [PATCH v2 00/12] mt76x02: AP support for USB with PS
> https://lore.kernel.org/linux-wireless/1552991867-5087-1-git-send-email-sgruszka@redhat.com/
>   
> Not rebased on
> [PATCH 1/6] mt76: use mac80211 txq scheduling
> https://lore.kernel.org/linux-wireless/20190316204242.73560-1-nbd@nbd.name/
> It easer to rebase '[PATCH 5/6] mt76: move tx tasklet to struct mt76_dev'
> from that set of top of my 2 pending sets. 
Applied, thanks.

- Felix
