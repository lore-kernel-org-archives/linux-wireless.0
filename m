Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56517C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19B302086D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:19:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 19B302086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbeJHQaD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:30:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1079 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbeJHQaC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:30:02 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DF624E34A;
        Mon,  8 Oct 2018 09:19:18 +0000 (UTC)
Received: from localhost (ovpn-204-38.brq.redhat.com [10.40.204.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 937045B0A0;
        Mon,  8 Oct 2018 09:19:17 +0000 (UTC)
Date:   Mon, 8 Oct 2018 11:19:16 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 04/12] rtw88: trx files
Message-ID: <20181008091915.GC1961@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-5-git-send-email-yhchuang@realtek.com>
 <20181004131908.GD16819@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D172A2BC@RTITMBSVM01.realtek.com.tw>
 <878t3bfe7o.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878t3bfe7o.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Mon, 08 Oct 2018 09:19:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Oct 06, 2018 at 03:32:11PM +0300, Kalle Valo wrote:
> Tony Chuang <yhchuang@realtek.com> writes:
> 
> >> > +	pkt_info->bmc = bmc;
> >> > +	pkt_info->sec_type = sec_type;
> >> > +	pkt_info->tx_pkt_size = skb->len;
> >> > +	pkt_info->offset = chip->tx_pkt_desc_sz;
> >> > +	pkt_info->qsel = skb->priority;
> >> 
> >> Shouldn't be qsel somehow mapped from skb->priority ?
> >
> > Firmware handles it.
> 
> What if meaning of skb->priority changes in the future? I don't think
> it's safe to provide kernel internal values to firmware, you should do
> some kind of mapping in the driver.

We already have some functions that do mapping:

rtw_hw_queue_mapping(struct sk_buff *skb)

and

rtw_pci_get_tx_qsel(struct sk_buff *skb, u8 queue)

Preasumly they should be used here as well.

Thanks
Stanislaw
