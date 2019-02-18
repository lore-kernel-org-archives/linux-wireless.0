Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B053C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:48:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 174EC2070B
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:48:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732983AbfBROsH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:48:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34526 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731038AbfBROsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 09:48:05 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 578838E6EE;
        Mon, 18 Feb 2019 14:48:04 +0000 (UTC)
Received: from localhost (unknown [10.40.205.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 91DB55D719;
        Mon, 18 Feb 2019 14:47:57 +0000 (UTC)
Date:   Mon, 18 Feb 2019 15:47:56 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Stefan Wahren <stefan.wahren@i2se.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190218144755.GB9602@redhat.com>
References: <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
 <20190218142527.GA9283@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190218142527.GA9283@localhost.localdomain>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 18 Feb 2019 14:48:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 18, 2019 at 03:25:28PM +0100, Lorenzo Bianconi wrote:
> > commit 0d9813319b40399a0d8fd761d2fcfedee5701487
> > Author: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > Date:   Fri Sep 7 23:13:12 2018 +0200
> 
> [...]
> 
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > index 062614ad0d51..08425b1d2c30 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> > @@ -550,21 +550,33 @@ void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
> >  }
> >  EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
> >  
> > -int mt76x02_insert_hdr_pad(struct sk_buff *skb)
> > +void mt76x02_align_skb(struct sk_buff *skb)
> >  {
> > -	int len = ieee80211_get_hdrlen_from_skb(skb);
> > +	int align = ((unsigned long) skb->data) & 3;
> > +	int hdrlen, skblen;
> >  
> > -	if (len % 4 == 0)
> > -		return 0;
> > +	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
> > +	WARN_ON_ONCE(align == 0 && (hdrlen & 3));
> > +
> > +	if (align == 0)
> > +		return;
> 
> Hi Stanislaw,
> 
> is it possible that skb->data is 4 byte aligned but hdrlen is not? (e.g 4addr
> data frames, not qos)?

It might be possible, so for now I add this 

WARN_ON_ONCE(align == 0 && (hdrlen & 3));

and plan to do some investigation on frame aliment.

> are you sure this is true *only* for probe requests?
> this could hit performances and it is used even in pci code

I'm not 100% sure, but I haven't seen any other frames with
that. All other unaligned frames I've seen in my tests had
unaligned header and adding header pad aligned them.
But obviously I've haven't tested all possible scenarios.

Stanislaw
