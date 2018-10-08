Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLACK autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09A6FC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABFB520878
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:35:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABFB520878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbeJHQqQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:46:16 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56510 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbeJHQqQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:46:16 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w989ZFpD005516, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w989ZFpD005516
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 8 Oct 2018 17:35:15 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Mon, 8 Oct 2018 17:35:14 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2 04/12] rtw88: trx files
Thread-Topic: [RFC v2 04/12] rtw88: trx files
Thread-Index: AQHUXXCabc6Uk9/+60ywbjX8pm9S+KUUjvoAgACHIyA=
Date:   Mon, 8 Oct 2018 09:35:13 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172BED1@RTITMBSVM01.realtek.com.tw>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-5-git-send-email-yhchuang@realtek.com>
 <20181004131908.GD16819@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D172A2BC@RTITMBSVM01.realtek.com.tw>
 <878t3bfe7o.fsf@kamboji.qca.qualcomm.com> <20181008091915.GC1961@redhat.com>
In-Reply-To: <20181008091915.GC1961@redhat.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> Sent: Monday, October 08, 2018 5:19 PM
> To: Kalle Valo
> Cc: Tony Chuang; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v2 04/12] rtw88: trx files
> 
> On Sat, Oct 06, 2018 at 03:32:11PM +0300, Kalle Valo wrote:
> > Tony Chuang <yhchuang@realtek.com> writes:
> >
> > >> > +	pkt_info->bmc = bmc;
> > >> > +	pkt_info->sec_type = sec_type;
> > >> > +	pkt_info->tx_pkt_size = skb->len;
> > >> > +	pkt_info->offset = chip->tx_pkt_desc_sz;
> > >> > +	pkt_info->qsel = skb->priority;
> > >>
> > >> Shouldn't be qsel somehow mapped from skb->priority ?
> > >
> > > Firmware handles it.
> >
> > What if meaning of skb->priority changes in the future? I don't think
> > it's safe to provide kernel internal values to firmware, you should do
> > some kind of mapping in the driver.
> 
> We already have some functions that do mapping:
> rtw_hw_queue_mapping(struct sk_buff *skb)
> and
> rtw_pci_get_tx_qsel(struct sk_buff *skb, u8 queue)
> Preasumly they should be used here as well.
> 
> Stanislaw
> 

Stanislaw is right, PCI will get the qsel again and overwrite it.
Maybe we should remove the extra qsel code in tx.c
BTW, skb->priority is mapped to TID 0-15 in mac80211, and that's
what we want to provide to the firmware.

Yan-Hsuan Chuang
