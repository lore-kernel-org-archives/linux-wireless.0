Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ABFCC43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39B9920645
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 08:21:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 39B9920645
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbeJBPDH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 11:03:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46027 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727285AbeJBPDH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 11:03:07 -0400
Received: by mail-wr1-f65.google.com with SMTP id q5-v6so1077388wrw.12
        for <linux-wireless@vger.kernel.org>; Tue, 02 Oct 2018 01:21:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f9tp/R4B4yDY+59cnnrCph5tn7GLEyiueuGSSKywkJM=;
        b=hLIRFccaMPIEdHid8wiv9qhj3QCLoajmyKgjDHGg4dudheJYacdG8AgBV78GIo7/ym
         6LbE6+6ghDtnNE4VD60Rb9+WzVEZThiSYvNtLfYN7rS0NwaMgn7Ke3VUwXD5tENvCX5d
         EZUAxoVIlqZLnRTS+XRnh75I5b0CJXR2Mjt21h1xWRwCPM27ggxRRC2pKTQn11InkZ6f
         xrFIChwfhXvyoaqjpIoc9hjz3WrFBij+9LrqGRAn1ZqdvSUgf388tLO4KAJjtOiyAGc1
         fuCW4AlhqtD8bJhLik9msSdi1Y4EdqJOCP34st6MZWlicFURSq2DiWaj1SwT//UTtT29
         hQhw==
X-Gm-Message-State: ABuFfojrf+GSW0bK6YojDvYP5ifBvBI1B5BxvHHeSJ/s8y07hD4fm16t
        Qim/BicexV0IX7FzkplzaQ2dG++pb5o=
X-Google-Smtp-Source: ACcGV62vmME6K91Ci9nQFTMT5l8GuYfV/CF3DRkgVXN9w4XTYpp5lUSR8oYdv8t9ubEEtZwW/yyOVg==
X-Received: by 2002:adf:df8b:: with SMTP id z11-v6mr9262783wrl.113.1538468463222;
        Tue, 02 Oct 2018 01:21:03 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id b81-v6sm7053341wmh.47.2018.10.02.01.21.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Oct 2018 01:21:02 -0700 (PDT)
Date:   Tue, 2 Oct 2018 10:20:59 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 02/10] mt76: move mt76x02_rx_get_sta and
 mt76x02_rx_get_sta_wcid in mt76x02_util.c
Message-ID: <20181002082058.GA3156@localhost.localdomain>
References: <20181001221908.16005-3-lorenzo.bianconi@redhat.com>
 <97478608-a454-7bc0-8478-e4a8e87ac7b0@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97478608-a454-7bc0-8478-e4a8e87ac7b0@nbd.name>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> >  EXPORT_SYMBOL_GPL(mt76x02_set_beacon_offsets);
> >  
> > +struct mt76x02_sta *
> > +mt76x02_rx_get_sta(struct mt76_dev *dev, u8 idx)
> > +{
> > +	struct mt76_wcid *wcid;
> > +
> > +	if (idx >= ARRAY_SIZE(dev->wcid))
> > +		return NULL;
> > +
> > +	wcid = rcu_dereference(dev->wcid[idx]);
> > +	if (!wcid)
> > +		return NULL;
> > +
> > +	return container_of(wcid, struct mt76x02_sta, wcid);
> > +}
> > +EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta);
> > +
> > +struct mt76_wcid *
> > +mt76x02_rx_get_sta_wcid(struct mt76x02_sta *sta, bool unicast)
> > +{
> > +	if (!sta)
> > +		return NULL;
> > +
> > +	if (unicast)
> > +		return &sta->wcid;
> > +	else
> > +		return &sta->vif->group_wcid;
> > +}
> > +EXPORT_SYMBOL_GPL(mt76x02_rx_get_sta_wcid);
> Both of these functions are trivial and should be inline.

ack, will do in v2.
Regards,

Lorenzo

> 
> - Felix
