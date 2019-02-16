Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8E4C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 19:17:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF90A2192D
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 19:17:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732610AbfBPTRU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 14:17:20 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:40185 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728542AbfBPTRU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 14:17:20 -0500
Received: from oxbaltgw07.schlund.de ([172.19.246.13]) by
 mrelayeu.kundenserver.de (mreue107 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1Mgw7n-1hY1dr1fGX-00hOOP; Sat, 16 Feb 2019 20:17:10 +0100
Date:   Sat, 16 Feb 2019 20:17:07 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <2009016263.528260.1550344627996@email.ionos.de>
In-Reply-To: <20190216140739.GA2236@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:v+SjiJKkDnOiFZHu1o0Royl1v4E3T5vFdbwOZIO5LznAuIKerDR
 zemJR5yNmURVB0dfZNT24Q/hha3YmF/newYwGA3pEsQLpHj/nZbReK7NJqnPcfBVu6hsPQf
 Y5Pn6S3RgMPoclJExdZ8ewsw5XWvjdJuibRi3rM9xn0v4UziZdjU/TtI260A4ES+WCjAILA
 gzl+c+1P/f45UlvU/dPJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UnOBHlLoukg=:EkAehpFwVXIeDU1yzh4ZGO
 h63MI/5l2XXfA61oI+K/cOVwuJw5ZiRnSROuqnpZF5ar8kZRdnsEkTNFsRtnWTkPsk1pPUi9U
 W7d/YW2ccHG6o4PJJHqvrklTYMcvK+gJV3ELNa2a2eazh2SIH66R7X4KyJ7R7GDFu9BZrkUMB
 0xY0PhhsQ2yj6h1RT6R5eSG1Mh4+ISjHdZCz5pv0rlyKk7vS2x77gD7n7m5VMtJy1lBdrQ5Fv
 bJwuhcT3aUtf+ddko6D4uwfHtR9DvPURzfwX8aKcWm7km2lCOctCRM8kz9T3kVS2dlW/qNTS2
 XQvNC4A24s8MkOOP9NFqEpiJGzy3Wl7cDdPf+gN4rcN44KogltiI5M0FCYKL3afhe4knaz3d5
 5pU182j0tk2DzNWG+d4nCfyAKt3kSKhfyFdAqJspBqCiv61264GCXyiD6sYQbYrvkbsK1LpQJ
 +i7NHi2cOErFF6F1fq5NbROfu4qRruzVbZZ5QHDRstSYYpKU7jQchYPTyDobM4jNEcbcRPZNt
 AROQFlh+/oylzABioLHboorGfm2P/W7kPOcIEHCU4eegPRfo7jga15YvDapw8Tq/PGONq3bOq
 B/a7cZbaoTJZykgCfS/fRoygV0uxqN1ex/oKuNevmY89q7JUtGGTKtCZsl81dbNzqXBTFyzEv
 pjA1ymwwxPgME097UKEB0XYlYYxbJEH3OCOHpJr05Un7Xg0AJ8YAlu9UIN6EnffsUjDiAjc7H
 8g5Tb7ajSRZWP0OHgIhkhlwLDNWJGOUiVd9V450bn5Ft4GEYA8NSTdALs7k=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stanislaw,

> Stanislaw Gruszka <sgruszka@redhat.com> hat am 16. Februar 2019 um 15:07 geschrieben:
> 
> 
> On Sat, Feb 16, 2019 at 12:05:18PM +0100, Stefan Wahren wrote:
> > sorry for the delay, but i do this all in my spare time.
> 
> Stefan, thanks for sacrifing your spare time for testing this!
> 
> > The results for your recent patch series are better (no firmware timeout), but still no working wifi and still a warning:
> > https://gist.github.com/lategoodbye/c4864e446821717419cbe65df07f8d8d
> > 
> > I've identified the reason for the warning in dwc2:
> > 
> > /*
> >  * We assume that DMA is always aligned in non-split
> >  * case or split out case. Warn if not.
> >  */
> > WARN_ON_ONCE(hsotg->params.host_dma && (chan->xfer_dma & 0x3));
> 
> I think I understand why that happen, we first allocate 1024 mcu 
> buffer then standard 4096 rx buffers, that couse 4096 buffers are
> not contained in single page and need split by dwc2 driver.

this is a misunderstanding. The warning is about memory alignment to 32 bit addresses, not about page alignment. This is a typical ARM restriction. Maybe we need to make sure in mt76 that the DMA buffer needs to be aligned. But it's also possible that the warning isn't the root cause of our problem.

> 
> Attached patch should fix this, plese test, thanks in advance.

Anyway i tested the following patch combinations against next with the same results as 1,2,3 (no wifi, alignment warning):
1,3
1,2,3,4

> 
> > Btw i can confirm a regression was introduced after 4.19, because in 4.19 there was no firmware timeout but even no working wifi:
> 
> You ment 'no working wifi' or 'working wifi'?

Wifi is broken in 4.19, 4.20, 5.0 and next. It only worked with Lorenzo's SG avoid patches so far. Btw the regression (firmware timeout) started in 4.20. I also tested it today.

Thanks
Stefan

> 
> Stanislaw
