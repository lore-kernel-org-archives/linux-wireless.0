Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8DEC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 11:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E8C6206B7
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 11:53:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hFvL4Nz0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfDCLx0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 07:53:26 -0400
Received: from nbd.name ([46.4.11.11]:60372 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfDCLx0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 07:53:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9FEN2xPqBRw3CQyEkcrty0bQkjE/Y04ISjFbO4jNLOw=; b=hFvL4Nz0gfaS0Or06TqqENKlbD
        PWxJ44Z7f3ArkkNDfLQz8oCpZzas3Gljd7fyayFbdxWrCFgF3EzME+kgjkxFK6aOP5OrcsHSq7Mvu
        +qrNVhgxzx+HgjIPVIXyk/3EtjcFYC6LVenogkQxye95aXG/+6rvZxTvXJrFgPm40/KY=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hBeSL-0006KU-3c; Wed, 03 Apr 2019 13:53:25 +0200
Subject: Re: [PATCH v2 01/12] mt76x02: introduce mt76x02_beacon.c
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
 <1552991867-5087-2-git-send-email-sgruszka@redhat.com>
 <8253140b-5ea6-3498-6bfe-144bb86f5962@nbd.name>
 <20190403114845.GA13093@redhat.com>
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
Message-ID: <c3c29ea0-131e-b507-c55e-cf5581d4638a@nbd.name>
Date:   Wed, 3 Apr 2019 13:53:24 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190403114845.GA13093@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-03 13:48, Stanislaw Gruszka wrote:
> On Wed, Apr 03, 2019 at 11:08:53AM +0200, Felix Fietkau wrote:
>> On 2019-03-19 11:37, Stanislaw Gruszka wrote:
>> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
>> > index ec94d612f53c..75dceeeed059 100644
>> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
>> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
>> > @@ -152,6 +152,21 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
>> >  	spin_unlock_bh(&q->lock);
>> >  }
>> >  
>> > +void mt76x02e_init_beacon_config(struct mt76x02_dev *dev)
>> > +{
>> > +	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
>> > +		     (unsigned long)dev);
>> > +
>> > +	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
>> > +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT, 8 << 4);
>> > +	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
>> > +		       MT_DFS_GP_INTERVAL);
>> > +	mt76_wr(dev, MT_INT_TIMER_EN, 0);
>> > +
>> > +	mt76x02_init_beacon_config(dev);
>> > +}
>> > +EXPORT_SYMBOL_GPL(mt76x02e_init_beacon_config);
>> > +
>> >  static int
>> >  mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_sw_queue *q,
>> >  		      int idx, int n_desc)
>> > @@ -230,8 +245,6 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
>> >  		return -ENOMEM;
>> >  
>> >  	tasklet_init(&dev->tx_tasklet, mt76x02_tx_tasklet, (unsigned long) dev);
>> > -	tasklet_init(&dev->pre_tbtt_tasklet, mt76x02_pre_tbtt_tasklet,
>> > -		     (unsigned long)dev);
>> Moving the tasklet init to mt76x02e_init_beacon_config can crash the
>> kernel, because it leads to the tasklet being re-initialized on every
>> reset. I will update that commit and move it back.
> 
> Ehh. Some further patches will not apply and will require to be modified.
> Perhaps could be easer move mt76x02e_init_beacon_config() to
> mt76x2_init_hardware() (or other proper function that is used only
> once once during initialization). Or just apply fix on top of the set 
> as separate patch. Anyway I'm leaving that up to you. Thanks.
It was easy enough to fix up using git rebase. I've pushed the result to
my tree already.

- Felix
