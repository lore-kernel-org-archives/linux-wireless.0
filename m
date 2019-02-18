Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0641C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 22:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76EB42176F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 22:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731633AbfBRWTz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 17:19:55 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:43597 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731463AbfBRWTz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 17:19:55 -0500
Received: from oxbaltgw06.schlund.de ([172.19.246.12]) by
 mrelayeu.kundenserver.de (mreue009 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MvbOA-1hECtN1lKw-00sf8F; Mon, 18 Feb 2019 23:19:43 +0100
Date:   Mon, 18 Feb 2019 23:19:40 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <1181760295.588129.1550528380134@email.ionos.de>
In-Reply-To: <20190218135247.GA9602@redhat.com>
References: <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
 <1411983628.668277.1550315118443@email.ionos.de>
 <20190216140739.GA2236@redhat.com>
 <2009016263.528260.1550344627996@email.ionos.de>
 <20190218135247.GA9602@redhat.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:e7IvcRQDfSv1S+wZlBOtxTjfF+vp8NDjtHyZOo39hCqJXl9Renu
 LFXiOo2OHhNph2mPVCQv6EGSn1Zcd1hUT7Tq6SmXussK/X6YzX/19ngQ1n1r3skMglycKPI
 EjH8hoUuzRS1RZW1rtMr4Lo7SzvnZm3v8cRf+RwSKdGppn/l2leu6QwNfSRAfs+Mrejwv5o
 UrKEqMEdAwZMZZtf7372Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:cqckKGWtcnQ=:/CKEYypEhilJ4yaRuRlbtE
 w+D/k6jhyhJJ3SR4q8S+QxtybZYGwGPU7t2Gj/PyIPK5wdkRJGt1p2Qr8YFd+d8rOz50RS147
 JpXQ2y8Ouu1luxkxQmZtuG8vVn5eWnG1fNROyJvTHCJLDcgQB6pmqR/tfz5T7JZ3lzAsMK1eJ
 Li4QQTqA3Tg2lzqeha92iXDiH8CQudds4wFnAnhh+tYvEixiUnRNTiiLCygfsoYWNUfouX2Re
 VNuhukSimLXmNV9Ehu/nIgr8lFD/vdeDnyyXj/BHElJM9FymHWgLWeZ5Fxg9LFh9cUtBiZq8I
 QDl5RTqOqAUyq9J8AqtF59mvc2F6nUnRd8HKOOa/EPecucDlGl67PL59+PLjwcHZ/v+pjqWt6
 Z5VShYOS5nUsY96lLOtIX/oIyuFCdIYQFzl4Hrq8fAmap++4yDh6xdZRc8/cUdrZ8gXhWlwne
 lJyoQu+0GZm0u2jNUZ0wef+t9K1SVud+e1cZHrX7utfLPFvafZPFOO1SVLRWIVC4XLw5DoXV0
 435dablyW+1GYLYpOOVtJFFyM3Cp86nNgqzVaauj0wHHS3GvDU7D0VfUDfLxdk1tgz3txWnc6
 lSNEv8+mQNmrblgcFdUIs07JFVsufHjEaf2KwmsLQap+5Nkl6tatU90V3itDsF054CHZjZqJx
 oap0a+WmA2TYBTNpeAMe5rLD+cc+/ysbPAEXqszyq03uln2f/KsxUbeoM5E+oDzY/mRTFVOAX
 fBdjC7QU2UvGAcA+rcCdgxbxdC/GANfvbcLHsn3l0cA1Abs8ffEiZw6oZlA=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Stanislaw Gruszka <sgruszka@redhat.com> hat am 18. Februar 2019 um 14:52 geschrieben:
> 
> 
> On Sat, Feb 16, 2019 at 08:17:07PM +0100, Stefan Wahren wrote:
> > this is a misunderstanding. The warning is about memory alignment to 32 bit addresses, not about page alignment. This is a typical ARM restriction. Maybe we need to make sure in mt76 that the DMA buffer needs to be aligned. But it's also possible that the warning isn't the root cause of our problem.
> > 
> 
> I see, it needs 4 bytes alignment . There is already dwc2 code checks
> that and allocate new buffer if the alignment is not right:
> dwc2_alloc_dma_aligned_buffer(), but it does nothing if urb->sg
> is not NULL. I thought mt76usb already provide aligned buffers, but
> looks it does not for one TX special case, which are PROBE REQUEST
> frames. Other frames are aligned by inserting L2 header pad. One
> solution for this would be just submit urb with  NULL sg (same as
> Lorenzo's patches do, but still allocating buffers via buf->sg),
> but I think, you have right, we should provide 4 bytes aligned buffers
> by default as other DMA hardware may require that. I'm attaching yet
> another patch to test, which fix up alignment for PROBE REQUEST frames.
> 
> > > Attached patch should fix this, plese test, thanks in advance.

i saw Felix decided to use Lorenzo's approach.

The patches 1,3,5 applied on today's next fixed only the warning and wifi is still broken (authentication timeout).

Here are the logs for multi_v7_defconfig:
https://gist.github.com/lategoodbye/0a7c5cea7dbf25d0de7944c05d229d79

> > 
> > Anyway i tested the following patch combinations against next with the same results as 1,2,3 (no wifi, alignment warning):
> > 1,3
> > 1,2,3,4
> 
> I noticed on my setup that patch 4 can cause troubles, but still
> device is workable here on my PC machines.
> 
> > > > Btw i can confirm a regression was introduced after 4.19, because in 4.19 there was no firmware timeout but even no working wifi:
> > > 
> > > You ment 'no working wifi' or 'working wifi'?
> > 
> > Wifi is broken in 4.19, 4.20, 5.0 and next. It only worked with Lorenzo's SG avoid patches so far. Btw the regression (firmware timeout) started in 4.20. I also tested it today.
> 
> That somewhat strange because 4.19 mt76x0u does not use SG.
> On 4.19 there is phy calibration bug fixed in 4.19.5:

Sorry for being inprecise. I was talking about the branches not the exact tags. I tested 4.19.23 without luck.

Many thanks anyway
Stefan
