Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AF1C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B439214DC
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 15:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Pl8A9DhN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B439214DC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbeIZVnS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 17:43:18 -0400
Received: from nbd.name ([46.4.11.11]:48530 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727136AbeIZVnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 17:43:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0O98Y+AwPvQoeA9c3m1ShSnp5JMxIQqO8axAiMpTLbc=; b=Pl8A9DhNYfF+ATvCNIBYeQgndz
        DMdBpQZCiY9dxEaPfZ1WPUVWgI8ajZdhBNez2sQb3K2KEkBqV5El9Hv6aFHdb/dISptSmdB52qszI
        kW9iZFAUt1X1udJC3AH0MZtxXzMcO7KZaS7v21JczxpBeTIDUdqxIBNPfFk4Ipluok2E=;
Subject: Re: [PATCH] mt76: usb: make rx page_frag_cache access atomic
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
References: <cover.1537959770.git.lorenzo.bianconi@redhat.com>
 <079c65bc4ca471dac81da909fa22ee1a0797a6f7.1537959770.git.lorenzo.bianconi@redhat.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <c3d0104d-6c4a-92ca-853e-4552f8a6bfba@nbd.name>
Date:   Wed, 26 Sep 2018 17:29:48 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <079c65bc4ca471dac81da909fa22ee1a0797a6f7.1537959770.git.lorenzo.bianconi@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-26 13:07, Lorenzo Bianconi wrote:
> Add rx_page_lock spinlock in order to make rx page fragment access
> atomic. This patch fixes the following crash that occasionally
> occurs during module loading/unloading
> 
> BUG: unable to handle kernel paging request at ffff9f8322e19000
> PGD 27ba01067 P4D 27ba01067 PUD 27ddba063 PMD 263b35063 PTE 8000000262e19061
> Oops: 0003 [#1] SMP PTI
> CPU: 2 PID: 1766 Comm: systemd-udevd Not tainted 4.19.0-rc5+ #6
> Hardware name: ASUSTeK COMPUTER INC. ESC2000 G2/Z9PE-D8 WS, BIOS 0405 03/19/2012
> RIP: 0010:__memcpy+0x12/0x20
> RSP: 0018:ffffba13849b3ad8 EFLAGS: 00010246
> RAX: ffff9f8322e17004 RBX: 00000000000038f0 RCX: 000000000000031f
> RDX: 0000000000000000 RSI: ffffba13844cf058 RDI: ffff9f8322e18ffc
> RBP: 0000000000010c6c R08: 0000000000000000 R09: 0000607ec0000000
> R10: 0000000000000003 R11: 0000000000003e2e R12: ffff9f8324cd9540
> R13: 0000000000000000 R14: ffffba13849b3b30 R15: ffff9f8322e17000
> FS:  00007fadec85b880(0000) GS:ffff9f833fa80000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff9f8322e19000 CR3: 0000000263428001 CR4: 00000000000606e0
> Call Trace:
>  mt76x02u_mcu_fw_send_data+0x16c/0x270 [mt76x02_usb]
>  mt76x0u_probe+0x35a/0x598 [mt76x0u]
>  usb_probe_interface+0x113/0x310
>  really_probe+0x1c8/0x400
>  driver_probe_device+0x5c/0x130
>  __driver_attach+0xec/0x110
>  bus_for_each_dev+0x50/0x90
>  bus_add_driver+0x1c0/0x280
>  driver_register+0x5b/0xe0
>  usb_register_driver+0x7c/0x140
>  do_one_initcall+0x44/0x19b
>  do_init_module+0x5a/0x210
>  load_module+0x175c/0x1bc0
>  __do_sys_finit_module+0x97/0xc0
>  do_syscall_64+0x3f/0xf0
>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x7fadeb6f1809
> RSP: 002b:00007ffe548f9f38 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
> RAX: ffffffffffffffda RBX: 00007fadebdf0d89 RCX: 00007fadeb6f1809
> RDX: 0000000000000000 RSI: 00007fadebdf0d89 RDI: 0000000000000006
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000006 R11: 0000000000000246 R12: 0000560b9ef58ab0
> R13: 0000560b9ef29800 R14: 0000560b9ef59040 R15: 0000000000020000
> 
> Fixes: c12128ce44b0 ("mt76: use a per rx queue page fragment cache")
> Reported-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Tested-by: Stanislaw Gruszka <sgruszka@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Merged, thanks.

- Felix
