Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001F7C10F01
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9DA02070B
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 14:44:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="tF6V3MSW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733000AbfBROoU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 09:44:20 -0500
Received: from nbd.name ([46.4.11.11]:43148 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732167AbfBROoU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 09:44:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fyNt3unuHUQwFKHEPeiM2cIir/xnPqS20voST6LEXEU=; b=tF6V3MSW8nbGHLB95HZ/Pp68PS
        6sYs92MzfNlr5N5XPn5AyXImrN/Z4PTsStEG/sAa7+cOLeG0pZTkJtxo9Ea6yvo1G8/870TeZlngt
        gdldnQ5ImYau86AVDiC9uaPnLSbFucgpDbi8PXTjPzb2HN4EHSJps/WChRJg/E0P+gIU=;
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
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
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <0e29e99a-6ed4-40fe-1f38-30f1b5530a16@nbd.name>
Date:   Mon, 18 Feb 2019 15:43:26 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190218135247.GA9602@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-18 14:52, Stanislaw Gruszka wrote:
> On Sat, Feb 16, 2019 at 08:17:07PM +0100, Stefan Wahren wrote:
>> this is a misunderstanding. The warning is about memory alignment to 32 bit addresses, not about page alignment. This is a typical ARM restriction. Maybe we need to make sure in mt76 that the DMA buffer needs to be aligned. But it's also possible that the warning isn't the root cause of our problem.
>> 
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
This approach looks completely wrong to me. MMIO based hardware does not
need 4-byte aligned buffers at all, other USB controllers do not need
this either.
As Lorenzo already pointed out, re-aligning the buffer is *very*
expensive, so we should not do this in the driver just to work around
quirks in a particular USB host driver.
And I really don't think we can assume that this code path is going to
be hit for probe requests only.

The way I see it, we have two choices.
1. Fix dwc2 to do its alignment quirk for the urb->sg != NULL case
2. Rely on urb->transfer_buffer and keep urb->sg NULL

- Felix

