Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAF7C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D22CB20878
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D22CB20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbeJHQtz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:49:55 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56656 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbeJHQtz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:49:55 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w989cqwm006283, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w989cqwm006283
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 8 Oct 2018 17:38:52 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Mon, 8 Oct 2018 17:38:51 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC v3 09/12] rtw88: chip files
Thread-Topic: [RFC v3 09/12] rtw88: chip files
Thread-Index: AQHUW++snvDeBPPUH0i5a5B6dFOsQ6UVF57w
Date:   Mon, 8 Oct 2018 09:38:50 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D172BEEF@RTITMBSVM01.realtek.com.tw>
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
 <1538565659-29530-10-git-send-email-yhchuang@realtek.com>
 <20181004143638.GE20484@redhat.com>
In-Reply-To: <20181004143638.GE20484@redhat.com>
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
> Sent: Thursday, October 04, 2018 10:37 PM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net; Pkshih; Andy Huang;
> linux-wireless@vger.kernel.org
> Subject: Re: [RFC v3 09/12] rtw88: chip files
> 
> On Wed, Oct 03, 2018 at 07:20:56PM +0800, yhchuang@realtek.com wrote:
> > +static int rtw8822b_mac_init(struct rtw_dev *rtwdev)
> > +{
> > +	u32 value32;
> > +
> > +	rtw_write8(rtwdev, REG_SLOT, WLAN_SLOT_TIME);
> > +	rtw_write8(rtwdev, REG_PIFS, WLAN_PIFS_TIME);
> > +	rtw_write32(rtwdev, REG_SIFS, WLAN_SIFS_CFG);
> 
> Should this be changed depending on protocol/band i.e. diffrent
> for 11n : 11g and 2.4GHz : 5GHz?
> 
> Thanks
> Stanislaw
> 

Yes it should, but it will take some time to figure them out.
Need to implement it later to fit in b/g mode.

Yan-Hsuan CHuang
