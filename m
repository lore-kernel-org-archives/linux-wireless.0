Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258EBC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD8B12083C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 09:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD8B12083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbeJAP4d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 11:56:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39317 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbeJAP4c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 11:56:32 -0400
Received: by mail-wr1-f65.google.com with SMTP id s14-v6so13042324wrw.6
        for <linux-wireless@vger.kernel.org>; Mon, 01 Oct 2018 02:19:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c5kHSMcUZpd5/Idn2ttfJMhPypuwTjT8FCkeEtGfMGQ=;
        b=PJq8pUtPWyknvOWTXbz/sQo/nZw/OJiSAxK5NCB/ae+TsanNgMQU8TveYYP9HagaNe
         NFFe1bpHK46PuxhlYYxaXdehchdljVbT4CCTtMgCnAJpnaZJDyzMrtx6h9rtXd/yK4ZP
         2MUaxRSOD0j23szlLILT2mqyZreDFWaNZbcFLmmijkf6lFzjh2JjJA8TAWWivKA2hTq2
         e3ejAqtxNDYziylsSqkOPnOgehdPAut1HAphMdTd4g243szir72M8HxynBcTFBpBIu0j
         ImcyDniRjacRgj2I2025HgRntWpQWX8pYtirHUDxD5+qdoN0cqCghFDMYar3+n4Csyim
         k4kg==
X-Gm-Message-State: ABuFfoj7rWzlhcqJmFaUqlfOzm0KX/rw2WNiuDagVV8FEcaNxmSkK9rr
        UaUEH9JI+s8eqwm0aOEUVnRkrg==
X-Google-Smtp-Source: ACcGV61T7275hskedc3lrYwtURXM0ZhyLbcdT8OAwMqFefJoPMPufinRzCYhqLdvqKRIEPvxrEJPww==
X-Received: by 2002:adf:cd0c:: with SMTP id w12-v6mr6633428wrm.67.1538385582816;
        Mon, 01 Oct 2018 02:19:42 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id i131-v6sm8098690wmg.26.2018.10.01.02.19.42
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Oct 2018 02:19:42 -0700 (PDT)
Date:   Mon, 1 Oct 2018 11:19:40 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76x0: init: intrduce MT_H2M_* definitions
Message-ID: <20181001091939.GB3055@localhost.localdomain>
References: <20180929173032.32747-1-lorenzo.bianconi@redhat.com>
 <20181001054355.GB22206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181001054355.GB22206@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Sat, Sep 29, 2018 at 07:30:32PM +0200, Lorenzo Bianconi wrote:
> > Add MT_H2M_BBP_AGENT, MT_H2M_MAILBOX_CSR and MT_H2M_INT_SRC and
> > remove magic numbers
> > 
> >  
> >  	/* TODO: Probably not needed */
> > -	mt76_wr(dev, 0x7028, 0);
> > -	mt76_wr(dev, 0x7010, 0);
> > -	mt76_wr(dev, 0x7024, 0);
> > -	msleep(10);
> > +	mt76_wr(dev, MT_H2M_BBP_AGENT, 0);
> > +	mt76_wr(dev, MT_H2M_MAILBOX_CSR, 0);
> > +	mt76_wr(dev, MT_H2M_INT_SRC, 0);
> 
> The same here, I think this should be just removed.

ack, will send a patch to remove them

> 
> > +	usleep_range(10000, 20000);
> 
> Why this change ?

afaik for sleeping less than 20ms it is better to use usleep_range
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/timers/timers-howto.txt

Regards,
Lorenzo

> 
> Thanks
> Stanislaw
