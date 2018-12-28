Return-Path: <SRS0=+yu+=PF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC68C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 12:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE2F20675
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Dec 2018 12:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="OKUroDWs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732898AbeL1MRT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Dec 2018 07:17:19 -0500
Received: from nbd.name ([46.4.11.11]:51720 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727118AbeL1MRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Dec 2018 07:17:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oxNj4W/Irs2pQdI/AtKmqs/+9ykhL3cF1DiO0vHd6CM=; b=OKUroDWs9z7fi9VtI9fY9zB/wG
        GMW+Rt6p4bRWY4eBMWuO0/NUB8neT5tShFQgyEE8uHJJxh09u1FIvX5jLKz82Fp3KE+nKvUwy7dgi
        ZkLQfOXfTlSSXeSVptR1r5HN+gdDaNWX1lpptY7QrIVkhFFXhYnHrMLa0pSwaylqBOIw=;
Subject: Re: [PATCH] mt76: usb: avoid queue/status spinlocks while passing tx
 status to mac80211
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org
References: <cover.1544119660.git.lorenzo.bianconi@redhat.com>
 <609b3532b5424fae1f82cea4ea4bb9688d943bf5.1544119660.git.lorenzo.bianconi@redhat.com>
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
Message-ID: <4c6ced18-cfed-6d1b-a874-ff5033a6ec2a@nbd.name>
Date:   Fri, 28 Dec 2018 13:17:15 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:60.0)
 Gecko/20100101 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <609b3532b5424fae1f82cea4ea4bb9688d943bf5.1544119660.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-06 19:11, Lorenzo Bianconi wrote:
> As already done for pcie code in commit 79d1c94c9c78 ("mt76: avoid
> queue/status spinlocks while passing tx status to mac80211") make sure
> that no tx related spinlocks are taken during the ieee80211_tx_status call
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Applied, thanks.

- Felix
