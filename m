Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14339C43381
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 21:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD6952070B
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 21:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726639AbfCCVQ1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 16:16:27 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:47655 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfCCVQ1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 16:16:27 -0500
Received: from oxbaltgw04.schlund.de ([172.19.246.10]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MIMKq-1gmIrD1adw-00EIis; Sun, 03 Mar 2019 22:16:15 +0100
Date:   Sun, 3 Mar 2019 22:16:13 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <174589996.263316.1551647773482@email.ionos.de>
In-Reply-To: <20190220163229.GB14165@redhat.com>
References: <20190218135247.GA9602@redhat.com>
 <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
 <20190218150303.GD9602@redhat.com>
 <a035966b-99f8-1109-d96f-0c3862d26518@nbd.name>
 <20190219104208.GA22999@redhat.com>
 <58097bb1-d726-c48e-2a40-2e12098dfb15@nbd.name>
 <20190220130009.GA2377@redhat.com>
 <20190220132206.GF2626@localhost.localdomain>
 <20190220161415.GA14165@redhat.com>
 <20190220162217.GH2626@localhost.localdomain>
 <20190220163229.GB14165@redhat.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev51
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:uW5lGoJotPE4OXuxaoN/+X1GBFIqIAb0iLLd6ecVOXjANQ9sUqV
 xVnXy9KAu1J+VqYWlrzja6Wxa6KDcChIdA2lJI88SPliSgn8oo3WwkIxTClQ3CxCv/gmaxf
 eRm4ce/fjWP3XrBFc7ovT0Xnhbg/fMfljyATU25UzVEH6hW15o7fHHLGZfalu57tbU2f6Ea
 QmrKetiQvbRr972pVhPQQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Q9D1MAViOiA=:2jCwF1OxQgx+x5Tgr9WmqN
 U7lDCCOW2cMxlUC3LwetnAZzb64ysvkWMbeyddcTMQf0QxN77zpGh9nAjmK0u6Tp8/ZSwyVWp
 uiGXeov73I3K+V9M0FQL6thTlOTyalR/cQ2ps571AFtxu8uqO2QS/Z0CRsq69qoVDUXNS3wWi
 JZCPA0KRewcvmS5U3Y8ouLE2+7DOTV24E3nl60JaGYx0Lid3YiOrNM41JrawuLGcaGPb3YRWD
 Metgui1iaTUvc6Nz1DJ6GSWar+bnw6S2s3v5QEoy7daWLlsUcbfWzCubmVOIcwtVWx8WzBeia
 +UFON9PyS4onPH69Mk+N4eYacEFRhXp3SHXQIK/xz3IOk7jLsL3LlHIpMLQH4KwnPmQoVA/65
 tJtRm48LX9m58WUmUh8JHNOUZ9SQ3mOWJ5vvRZ1vcwl06qFTYw2KHcCHkz85kgvGbVBmtsXer
 zOmB4SVS9b0smbvl1psgW+nwpaWUub1Z1yBw/rv+y/aqJ/M8V3aueE0rFFD2qpfwuSXzNiz/Z
 XE/LTfz22NZ22GwqgP1EdCrZ7Yg76UVh0TRXoHAskbK7VUtLgb1fq01rLVHS1GxGxat3gTB83
 l8HkZqtpOPD5fnSZdyi/kA2Jt6WNPJTF0VsWweNAQyIOE1DbQXHPqAceG+6Sin2YT1tSJtOEE
 Qt7EM3ufzG4fX0fu2nwmvro8EJfqHIDqh1wYxipFLUMg3wKjmrnej1hor2crQUS2AknuYVFkU
 AWMZ+yn9Rfe6ifC5MwlstQ69Y90AT4seCatGF7nlknyqcJAX+p6YRm3akY8=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> Stanislaw Gruszka <sgruszka@redhat.com> hat am 20. Februar 2019 um 17:32 geschrieben:
> 
> 
> On Wed, Feb 20, 2019 at 05:22:18PM +0100, Lorenzo Bianconi wrote:
> > > On Wed, Feb 20, 2019 at 02:22:08PM +0100, Lorenzo Bianconi wrote:
> > > > > On Tue, Feb 19, 2019 at 01:19:26PM +0100, Felix Fietkau wrote:
> > > > > > >> >> The way I see it, we have two choices.
> > > > > > >> >> 1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
> > > > > > >> >> 2. Rely on urb->transfer_buffer and keep urb->sg NULL
> > > > > > >> > 
> > > > > > >> > I agree, if this is only needed for dwc2. Though I would investigate
> > > > > > >> > if this is not a bug on other platforms as well.
> > > > > > >> >From what I can see, using Lorenzo's patches seems to be the better
> > > > > > >> solution, since they avoid these corner cases in dwc2 (and maybe other
> > > > > > >> drivers as well). I will apply them and then we'll see if we need to do
> > > > > > >> any further improvements later on.
> > > > > > > 
> > > > > > > They work on rpi dwc2, but they do not address root of the problem.
> > > > > > > There is clearly something wrong how mt76usb handle SG, what is not
> > > > > > > fixed. And adding disable_usb_sg module parameter for hcd's supporting
> > > > > > > SG should be red flag.
> > > > > > I think we're simply dealing with multiple issues here, only some of
> > > > > > which are fixed by Lorenzo's patches.
> > > > > > I'm pretty sure it's still wrong for mt76 to try to align its buffers,
> > > > > > since the Linux USB API supports non-aligned transfer buffers and it
> > > > > > should be up to the controller driver to deal with that.
> > > > > 
> > > > > Agree.
> > > > > 
> > > > > > dwc2 tries to do that, but that has limitations which I already pointed
> > > > > > out and which are properly dealt with by Lorenzo's patches.
> > > > > 
> > > > > I planed to just accept current solution, but I started to work on patch
> > > > > that remove len, sglen arguments from mt76u_buf_alloc() and use
> > > > > q->buf_size and SKB_WITH_OVERHEAD(q->buf_size) directly and realized how
> > > > > related code is now tangled.
> > > > > 
> > > > > Would be ok to send this patch with proper changelog as fix for RPI
> > > > > against wireless-drivers and cc:stable (assuming it works and really
> > > > > fix things on RPI) and revert Lorenzo's patches in -next ?
> > > > 
> > > > Hi Stanislaw,
> > > > 
> > > > what is the advantage of doing so?
> > > To have small fix proper for -stable to fix the problem in 4.20 and 4.19,
> > > and have simpler code.
> > 
> > merging the series I sent we will have a pretty simple approach, just a
> > single routine that allocates the rx buffers in the control path according to
> > the operating mode.
> 

FWIW i tested current linux-next and it also works with arm64/defconfig on Raspberry Pi 3B.

Thanks

> 
> Stanislaw
