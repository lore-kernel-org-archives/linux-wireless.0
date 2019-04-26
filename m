Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D0AC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01BD6206BF
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 12:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfDZMTn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 08:19:43 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:57310 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZMTm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 08:19:42 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x3QCJF0j012636, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv02.realtek.com.tw[172.21.6.19])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x3QCJF0j012636
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 26 Apr 2019 20:19:15 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCASV02.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Fri, 26 Apr
 2019 20:19:15 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH v9 14/14] staging: rtlwifi: remove staging rtlwifi driver
Thread-Topic: [PATCH v9 14/14] staging: rtlwifi: remove staging rtlwifi
 driver
Thread-Index: AQHU/Cj1ZpX6dgKnIEKrR4OPyDDHU6ZOWrXw
Date:   Fri, 26 Apr 2019 12:19:14 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17E3307@RTITMBSVM04.realtek.com.tw>
References: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
        <1555653004-1795-15-git-send-email-yhchuang@realtek.com>
 <87d0l9ufw5.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87d0l9ufw5.fsf@kamboji.qca.qualcomm.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Friday, April 26, 2019 8:10 PM
> To: Tony Chuang
> Cc: linux-wireless@vger.kernel.org; johannes@sipsolutions.net; Pkshih; Andy
> Huang; Larry.Finger@lwfinger.net; sgruszka@redhat.com;
> briannorris@chromium.org; gregkh@linuxfoundation.org
> Subject: Re: [PATCH v9 14/14] staging: rtlwifi: remove staging rtlwifi driver
> 
> <yhchuang@realtek.com> writes:
> 
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > The rtlwifi driver is conflicting with Realtek's new 802.11ac chip
> > series driver rtw88, remove it to avoid racing with the same ID.
> >
> > The rtw88 driver can be found at drivers/net/wireless/realtek/rtw88
> >
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> BTW, this patch does not apply to wireless-drivers-next anymore. To
> avoid any conflicts, would be it be safer that the driver is removed
> directly from Greg's tree? After rtw88 is applied to
> wireless-drivers-next, of course.
> 
> error: patch failed: drivers/staging/rtlwifi/Kconfig:1
> error: drivers/staging/rtlwifi/Kconfig: patch does not apply
> error: patch failed: drivers/staging/rtlwifi/efuse.c:1
> error: drivers/staging/rtlwifi/efuse.c: patch does not apply
> error: patch failed:
> drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c:1
> error: drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c: patch
> does not apply
> error: patch failed: drivers/staging/rtlwifi/pci.h:1
> error: drivers/staging/rtlwifi/pci.h: patch does not apply
> error: patch failed: drivers/staging/rtlwifi/phydm/phydm_rainfo.c:1
> error: drivers/staging/rtlwifi/phydm/phydm_rainfo.c: patch does not apply
> error: patch failed: drivers/staging/rtlwifi/phydm/rtl_phydm.c:1
> error: drivers/staging/rtlwifi/phydm/rtl_phydm.c: patch does not apply
> error: patch failed: drivers/staging/rtlwifi/rtl8822be/fw.c:1
> error: drivers/staging/rtlwifi/rtl8822be/fw.c: patch does not apply
> Patch failed at 0014 staging: rtlwifi: remove staging rtlwifi driver
> 

Hi Greg,

Can you help us to remove the staging driver rtlwifi in your tree ?
I think Kalle can issue a signal to you when he has done reviewing
the rtw88 driver and merge it into wireless-drivers-next.
Thanks

Yan-Hsuan

