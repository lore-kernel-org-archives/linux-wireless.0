Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9BCC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D7B2216C4
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 15:10:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D7B2216C4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727426AbeI0V3V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 17:29:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38885 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727280AbeI0V3V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 17:29:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id j8-v6so3033706wrw.5
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 08:10:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JhqHKcz/gp83ZqRkugvWy21Pg2U89o9oLJrTHXQo2fY=;
        b=OtTU8SmvnoMVhjJu3da/TeFXPth5HXSWGY46bChSj+/i0IqNXdT9ItTVi+XV8nnknG
         se+0Pj5e/AHXcgV/Q8D3UtsCR1whYatsZOLZxTgF/nz/mFbBk9iE3lSoqLoBUh9owXVd
         5yrhntBy6TnZ9z7I54IDFYIrpalZ8EUrYOhLePj6EOfps30vpbNDwE4kAcAnJJ6IFnEL
         czwU1cJHyFBSm1F06mga3lZoOf9Dpwqng2rr2eeZI0R/an12umgT/mPfuaBxh7FXZhhT
         abNz2lVddQDXaZ3SSJIADWBg+cEz80dPRFhommIjpglP8MSPQQf0KHoyqndGTTHlu9B0
         Gkeg==
X-Gm-Message-State: ABuFfoiXvPrwcgbe8vfBYkqxER9v/PHpnekteqy574cmx8PTBS1cpDqd
        2LwRS0XSEG6HzrZjxHa337c+Hw==
X-Google-Smtp-Source: ACcGV63XmP6NK/8kl8RAotUCoAPd90F+uFKsXt0QvmqG9zx+sW9Co6xAMotqcNY8pef/ZLIVXS7Ylw==
X-Received: by 2002:adf:c405:: with SMTP id v5-v6mr9096908wrf.20.1538061037756;
        Thu, 27 Sep 2018 08:10:37 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id z16-v6sm1452018wrq.78.2018.09.27.08.10.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 08:10:37 -0700 (PDT)
Date:   Thu, 27 Sep 2018 17:10:35 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 17/26] mt76: add mt76x02_mac_start routine
Message-ID: <20180927151034.GA24450@localhost.localdomain>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <282971bcd54817ae02fbe065bc357ded9e068e56.1538036134.git.lorenzo.bianconi@redhat.com>
 <20180927101721.GD19941@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180927101721.GD19941@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Thu, Sep 27, 2018 at 11:01:46AM +0200, Lorenzo Bianconi wrote:
> >  enum mt76x02_cipher_type
> >  mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
> > @@ -520,3 +522,16 @@ void mt76x02_mac_setaddr(struct mt76_dev *dev, u8 *addr)
> >  		  FIELD_PREP(MT_MAC_ADDR_DW1_U2ME_MASK, 0xff));
> >  }
> >  EXPORT_SYMBOL_GPL(mt76x02_mac_setaddr);
> > +
> > +void mt76x02_mac_start(struct mt76_dev *dev)
> > +{
> > +	mt76x02_dma_enable(dev);
> > +	__mt76_wr(dev, MT_RX_FILTR_CFG, dev->rxfilter);
> > +	__mt76_wr(dev, MT_MAC_SYS_CTRL,
> > +		  MT_MAC_SYS_CTRL_ENABLE_TX |
> > +		  MT_MAC_SYS_CTRL_ENABLE_RX);
> > +	mt76x02_irq_enable(dev,
> > +			   MT_INT_RX_DONE_ALL | MT_INT_TX_DONE_ALL |
> > +			   MT_INT_TX_STAT);
> > +}
> 
> irq_enable is PCIe specific (also mt76x02_dma_enable() seems to
> be PCIe specifc). I think this should be not mixed within generic code
> and perhaps the function name prefix should be mt76x02e_ .

ack, I will move them in mt76x02_mmio.c but I would prefer to maintain name
convetion we are using so far.

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
> 
