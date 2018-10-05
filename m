Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF652C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 09:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6881820875
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 09:19:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6881820875
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbeJEQRn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 12:17:43 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:55452 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbeJEQRn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 12:17:43 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w959JXxV015089, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w959JXxV015089
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Fri, 5 Oct 2018 17:19:33 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCASV01.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Fri, 5 Oct
 2018 17:19:32 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v2 06/12] rtw88: fw and efuse files
Thread-Topic: [RFC v2 06/12] rtw88: fw and efuse files
Thread-Index: AQHUW8/6erXZlvWH8kuyj9YKBeZDeqUQJhVQ
Date:   Fri, 5 Oct 2018 09:19:31 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172A29B@RTITMBSVM01.realtek.com.tw>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-7-git-send-email-yhchuang@realtek.com>
 <20181004104929.GA16819@redhat.com>
In-Reply-To: <20181004104929.GA16819@redhat.com>
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
> Sent: Thursday, October 04, 2018 6:50 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v2 06/12] rtw88: fw and efuse files
> 
> Hi
> 
> On Wed, Oct 03, 2018 at 04:02:22PM +0800, yhchuang@realtek.com wrote:
> > +void rtw_fw_do_iqk(struct rtw_dev *rtwdev, struct rtw_iqk_para *para)
> > +{
> > +	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
> 
> Not sure if '= {0}' work as expected for arrays, you
> want to nulify first byte or whole h2c_pkt ?

I want to nullify the whole h2c_pkt.
And I think it works as expected.

> 
> > +void rtw_add_rsvd_page(struct rtw_dev *rtwdev, enum
> rtw_rsvd_packet_type type,
> > +		       bool txdesc)
> > +{
> > +	struct rtw_rsvd_page *rsvd_pkt;
> > +
> > +	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
> > +		if (rsvd_pkt->type == type)
> > +			return;
> > +	}
> > +
> > +	rsvd_pkt = kmalloc(sizeof(*rsvd_pkt),
> > +			   in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
> 
> It's never called from interrupt. You have to check kmalloc output value.
> 

OK, it's better.

> > +	rsvd_pkt->type = type;
> > +	rsvd_pkt->add_txdesc = txdesc;
> > +	list_add_tail(&rsvd_pkt->list, &rtwdev->rsvd_page_list);
> <snip>
> > +
> > +void rtw_reset_rsvd_page(struct rtw_dev *rtwdev)
> > +{
> > +	struct rtw_rsvd_page *rsvd_pkt, *tmp;
> > +
> > +	list_for_each_entry_safe(rsvd_pkt, tmp, &rtwdev->rsvd_page_list, list) {
> > +		if (rsvd_pkt->type == RSVD_BEACON)
> > +			continue;
> > +		list_del(&rsvd_pkt->list);
> > +		kfree(rsvd_pkt);
> > +	}
> 
> It also not clear how the list is protected agains concurrent access.
> However seems like much simpler solution would be use array instead of
> the list. For example above code could be replaced by:


It should be protected bu rtwdev->mutex, but indeed it is not clear
Would have to add lockdep for it.


> 
> for (i = RSVD_BEACON + 1; i <= RSVD_QOS_NULL ; i++) {
> 	kfree(rwdev->rsvd_page_arr[i]));
> 	rsvd_page_arr[i] = NULL;
> }
> 
> And other operations like adding / removing / checking if present could
> be simplified as well.
> 
> Also RSVD_PROBE_RESP page is never created.

RSVD_PROBE_RESP will be used for AP/GO mode,
so I think I might leave it here.

And change rsvd_list to array is not a good idea if there is more than
one interfaces running. For this case will need to download more rsvd
packets, and the order can be changed. Array seems not enough to
handle that.

> 
> > +	*size = (total_page - 1) * page_size + page_margin;
> > +	buf = kzalloc(*size, GFP_KERNEL | GFP_ATOMIC);
> 
> Those GPF flags contradict to each other :-)
> and buf not checked agains NULL.

fixed

> 
> Thanks
> Stanislaw
> 

Thanks
Yan-Hsuan Chuang
