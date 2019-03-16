Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 664EDC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 19:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AAF32075C
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 19:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="hJ4qYl1P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfCPTPw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 15:15:52 -0400
Received: from nbd.name ([46.4.11.11]:34500 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfCPTPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 15:15:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/pj+On/0A/avcKOrrUhfhh8gUeWo04jN9cugwhKDBgc=; b=hJ4qYl1P5/0wE/gcpbh8NbTcbt
        z3+VJDEIIkcsjL0is+eRLRhCqaeVzzOpATnsTAlL8fjUTZk75DnpaG2pBLItT2ntNqXwc8mMIz1ej
        4VZ3SUIpL8z0VoZzG8X3W8HZvpSUyRrm3qWR5+Z7Cfp0lbrwd4kQTZk376ODILgSr/nY=;
Received: from p4ff1316d.dip0.t-ipconnect.de ([79.241.49.109] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h5Emc-0007gv-1M; Sat, 16 Mar 2019 20:15:50 +0100
Subject: Re: [PATCH] mt76: move mac_work in mt76_dev
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
References: <cover.1552575244.git.lorenzo@kernel.org>
 <e0f306b6b46881150dfb07866cd06e2f69e403dd.1552575244.git.lorenzo@kernel.org>
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
Message-ID: <cf859546-465c-52d4-c576-019315499e7b@nbd.name>
Date:   Sat, 16 Mar 2019 20:15:49 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <e0f306b6b46881150dfb07866cd06e2f69e403dd.1552575244.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-14 15:57, Lorenzo Bianconi wrote:
> Move mac_work delayed work in mt76_dev data structure since
> it is used by all drivers and it will be reused adding mac work to
> mt7615
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76.h            |  2 ++
>  drivers/net/wireless/mediatek/mt76/mt7603/init.c     |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt7603/mac.c      |  8 +++++---
>  drivers/net/wireless/mediatek/mt76/mt7603/main.c     | 10 +++++-----
>  drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h   |  1 -
>  drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      |  4 ++--
>  drivers/net/wireless/mediatek/mt76/mt76x0/usb.c      |  4 ++--
>  drivers/net/wireless/mediatek/mt76/mt76x02.h         |  1 -
>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c     |  8 +++++---
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c    |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2/pci_main.c |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c |  2 +-
>  drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c |  2 +-
>  14 files changed, 27 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index edff44f32c8e..46bde2f55fce 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -455,6 +455,8 @@ struct mt76_dev {
>  	const struct mt76_queue_ops *queue_ops;
>  	int tx_dma_idx[4];
>  
> +	struct delayed_work mac_work;
> +
>  	wait_queue_head_t tx_wait;
>  	struct sk_buff_head status_list;
>  
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
> index d54dda67d036..ce1685d44888 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
> @@ -510,7 +510,7 @@ int mt7603_register_device(struct mt7603_dev *dev)
>  	bus_ops->rmw = mt7603_rmw;
>  	dev->mt76.bus = bus_ops;
>  
> -	INIT_DELAYED_WORK(&dev->mac_work, mt7603_mac_work);
> +	INIT_DELAYED_WORK(&dev->mt76.mac_work, mt7603_mac_work);
>  	tasklet_init(&dev->pre_tbtt_tasklet, mt7603_pre_tbtt_tasklet,
>  		     (unsigned long)dev);
>  
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> index 5f800467c628..d15d8316a108 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> @@ -1691,10 +1691,12 @@ mt7603_false_cca_check(struct mt7603_dev *dev)
>  
>  void mt7603_mac_work(struct work_struct *work)
>  {
> -	struct mt7603_dev *dev = container_of(work, struct mt7603_dev,
> -					      mac_work.work);
> +	struct mt7603_dev *dev;
>  	bool reset = false;
>  
> +	dev = (struct mt7603_dev *)container_of(work, struct mt76_dev,
> +						mac_work.work);
Please drop the typecast and use this instead:

container_of(work, struct mt7603_dev, mt76.mac_work.work)

- Felix

