Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0641C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 06:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C784C2229F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 06:50:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388656AbfBNGuK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 01:50:10 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:54437 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729172AbfBNGuK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 01:50:10 -0500
Received: from oxbaltgw58.schlund.de ([172.19.246.145]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1N5mOb-1hA5s42wfr-017FxV; Thu, 14 Feb 2019 07:49:59 +0100
Date:   Thu, 14 Feb 2019 07:49:57 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <404607590.373282.1550126997144@email.ionos.de>
In-Reply-To: <20190212093035.GB12906@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:Isqzx2psC+Piqvp1si2802LAxvs5HJOl0rQHg13RB/MGE57va6r
 vIwCqQ0Qj/Ouwt9JzzCc2blDWYXXWYJUJA843mWokCOyQ3BfBntXHuUe3I7frGmcgHBuFAb
 i5gmxYdE7tPpEhJB5RetT5QeYjIuJFXgEXoMa6Gkl0QNy4VzFSp5ScWvWrl5rE+L649BMY2
 usoSqAUwrv/HCtwuhYY0Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ss9C29IQjyE=:BLoRdZJTWsraixaw95eeG9
 raldm/vmRWxxTTPSZqZnXuLUKcWKOTORyqrFPQpqHNFKPDT+zxQVfaWy8nTV450Z6bRex1vb9
 ynlIxlXw3jraKsZPRxZXtBMcB/3oiN8W/T4680jmPCbqb0JzZQDIWER98bOUXe3LtDx2HNhqb
 VMA52tGnMg2yf2mySziZMvBqGoq8L8gR+Fy0EK3YZClPxXtE6tDEjpZBKJ3bhVEsPoZ7UaZhg
 0BbjN7Np2XN/v4p+gPAGtJJG9LoCwjgikgV8+sRYgtiNgMV9e0O1QOqGOiTdDt3oX8ddi4B5x
 WhHSly6YsIPDjAnmL7u1Wf6J+mveNraT/F4VoYC0NDxQrIj3wVLQCgvSnIHb0hnpIMwbFaKXS
 TA3DQwkQyaTpMOvbdrYAuDlqUG9W48tRh/Ppl8rxdwKO0gAVME4f14wgnvT+aC1Cm4snwwxnV
 nQpYvQ2pRfM4TuL0rGt67FRcnCousjRXu0iOXUvZLHHJd+JhzpKprtB45O0+3+SaCVqDnMCcn
 OLaGXbUQw54qtxRDyY2ejNfEUumwbnaYgIaRyePvOEabBdoMsBvdHHcmltpmVT4tFFEbW5yH1
 DnGRjtS5KXoZfk2fx90VhlkiC55KPNWn0zaHFyrkUGB+KsV2yijuqSzF7TS8NM8QcIclN/414
 GWfVTbwaVMwqqGBPqQ4t3s+IRfI9CPejXdbR6V9V197Z3qjTvPR5N2XbiPYx7oFqUbOeXbcNx
 Qc6RoRy/zE57IQmZCrOiqrICrExYsyoRTOkWgSI61t0Mo1YMv86hR7Gyelc=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stanislaw,

> Stanislaw Gruszka <sgruszka@redhat.com> hat am 12. Februar 2019 um 10:30 geschrieben:
> 
> 
> 
> In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
> In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
> this is bug. We can fix that without changing allocation method and
> still use SG allocation. Attached patch do this, please check if it works
> on rpi. Patch is on top of your error path fixes.

your patch didn't apply cleanly to yesterdays next. After some minor manual fixup, i was able to build them and here are the results starting from boot (please ignore the invalid time in the kernel log):
https://gist.github.com/lategoodbye/33bd5bc75b9fc935faa231bc472defa8

Using multi_v7_defconfig i'm getting a warning on the first connect and always this flood of rx urb failed on disconnect. The driver seems to probe but isn't functional even after 2 tries.

Using arm64_defconfig i don't get any warning. But except of this i'm getting similiar results to multi_v7_defconfig.

So in comparison, Lorenzo's workaround behaves better.

Stefan

> 
> Stanislaw
