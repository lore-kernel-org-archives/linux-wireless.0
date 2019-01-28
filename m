Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31BAFC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 03:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 010522147A
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 03:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfA1Dg7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Jan 2019 22:36:59 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40502 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfA1Dg7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Jan 2019 22:36:59 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x0S3aiAO006302, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x0S3aiAO006302
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Mon, 28 Jan 2019 11:36:44 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV02.realtek.com.tw (172.21.6.19) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 28 Jan 2019 11:36:43 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0435.000; Mon, 28 Jan
 2019 11:36:43 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: RE: [PATCH v2 13/13] rtw88: add support for Realtek 802.11ac wireless chips
Thread-Topic: [PATCH v2 13/13] rtw88: add support for Realtek 802.11ac
 wireless chips
Thread-Index: AQHUfZ/4qY2qdj3v9Ei5zOQiwxCyi6W7sykAgAjGMLA=
Date:   Mon, 28 Jan 2019 03:36:41 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D1793553@RTITMBSVM04.realtek.com.tw>
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
 <1542367879-28880-14-git-send-email-yhchuang@realtek.com>
 <20190122213423.GA52826@google.com>
In-Reply-To: <20190122213423.GA52826@google.com>
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
> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Wednesday, January 23, 2019 5:35 AM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; Larry.Finger@lwfinger.net;
> linux-wireless@vger.kernel.org; Pkshih; Andy Huang
> Subject: Re: [PATCH v2 13/13] rtw88: add support for Realtek 802.11ac wireless
> chips
> 
> Hi Yan-Hsuan,
> 
> On Fri, Nov 16, 2018 at 07:31:19PM +0800, yhchuang@realtek.com wrote:
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > ---
> >  MAINTAINERS | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 9ad052a..138515b 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -12546,6 +12546,14 @@ T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.g
> >  S:	Maintained
> >  F:	drivers/net/wireless/realtek/rtlwifi/
> >
> > +REALTEK WIRELESS DRIVER (rtw88)
> > +M:	Yan-Hsuan Chuang <yhchuang@realtek.com>
> > +L:	linux-wireless@vger.kernel.org
> > +W:	http://wireless.kernel.org/
> > +T:	git
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> 
> That tree hasn't been updated in years. I expect that's not relevant, so
> perhaps you should remove it? I think these days, unless you have a
> large amount of patches that deserves its own tree / pull-request,
> you're probably just going to be covered by the wireless-drivers /
> wireless-drivers-next trees:
> 
> NETWORKING DRIVERS (WIRELESS)
> M:      Kalle Valo <kvalo@codeaurora.org>
> L:      linux-wireless@vger.kernel.org
> Q:      http://patchwork.kernel.org/project/linux-wireless/list/
> T:      git
> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git
> T:      git
> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> 
> Regards,
> Brian
> 


OK, I can change to wireless-drivers tree and send PATCHv3.
Thanks.

Yan-Hsuan
