Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63FB6C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 07:57:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B96320878
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 07:57:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B96320878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbeJHPIN convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 11:08:13 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51747 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbeJHPIN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 11:08:13 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w987vTO5002881, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w987vTO5002881
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 8 Oct 2018 15:57:29 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Mon, 8 Oct 2018
 15:57:28 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3 08/12] rtw88: debug files
Thread-Topic: [RFC v3 08/12] rtw88: debug files
Thread-Index: AQHUW+3IUCwuva2cvE+MjaIlByUtB6UUpU1Q
Date:   Mon, 8 Oct 2018 07:57:27 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172BCF3@RTITMBSVM01.realtek.com.tw>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
 <1538565659-29530-9-git-send-email-yhchuang@realtek.com>
 <20181004142306.GD20484@redhat.com>
In-Reply-To: <20181004142306.GD20484@redhat.com>
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
> Sent: Thursday, October 04, 2018 10:23 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v3 08/12] rtw88: debug files
> 
> On Wed, Oct 03, 2018 at 07:20:55PM +0800, yhchuang@realtek.com wrote:
> > +static int rtw_debugfs_get_rsvd_page(struct seq_file *m, void *v)
> > +{
> > +	struct rtw_debugfs_priv *debugfs_priv = m->private;
> > +	struct rtw_dev *rtwdev = debugfs_priv->rtwdev;
> > +	u8 page_size = rtwdev->chip->page_size;
> > +	u32 buf_size = debugfs_priv->rsvd_page.page_num * page_size;
> > +	u32 offset = debugfs_priv->rsvd_page.page_offset * page_size;
> > +	u8 *buf = vzalloc(buf_size);
> Error check.
> 

OK

> > +void rtw_debugfs_init(struct rtw_dev *rtwdev)
> > +{
> > +	debugfs_topdir = debugfs_create_dir("rtw88", NULL);
> 
> You should use rtwdev->hw->wiphy->debugfsdir like other drivers.
> 

OK

> Thanks
> Stanislaw
> 


Yan-Hsuan CHuang
