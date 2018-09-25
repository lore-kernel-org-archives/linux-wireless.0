Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0075ECE561
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 11:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4636E20858
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 11:09:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4636E20858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=realtek.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728702AbeIYRQ0 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 13:16:26 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:56504 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbeIYRQ0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 13:16:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID w8PB97Ut006510, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id w8PB97Ut006510
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 25 Sep 2018 19:09:08 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 25 Sep
 2018 19:09:07 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: RE: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUU/Z6fShZef+yIU+HHwSs/fcbMKUA0ulw
Date:   Tue, 25 Sep 2018 11:09:06 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D08D7F89@RTITMBSVM01.realtek.com.tw>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
        <20180921131235.GA10556@redhat.com> <87pnx340lt.fsf@codeaurora.org>
In-Reply-To: <87pnx340lt.fsf@codeaurora.org>
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
> From: Kalle Valo [mailto:kvalo@codeaurora.org]
> Sent: Monday, September 24, 2018 7:05 PM
> To: Stanislaw Gruszka
> Cc: Tony Chuang; Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org;
> Pkshih; Andy Huang
> Subject: Re: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac
> wireless network chips
> 
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > On Fri, Sep 21, 2018 at 02:03:55PM +0800, yhchuang@realtek.com wrote:
> >> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >>
> >> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> >> rtwlan supports 8822BE and 8822CE chips, and will be able to support
> >> multi-vif combinations in run-time.
> >>
> >> For now, only PCI bus is supported, but rtwlan was originally designed
> >> to optionally support three buses includes USB & SDIO. USB & SDIO
> modules
> >> will soon be supported by rtwlan, with configurable core module to fit
> >> with different bus modules in the same time.
> >>
> >> For example, if we choose 8822BE and 8822CU, only PCI & USB modules
> will
> >> be selected, built, loaded into kernel. This is one of the major
> >> difference from rtlwifi, which can only support specific combinations.
> >>
> >> Another difference from rtlwifi is that rtwlan is designed to support
> >> the latest Realtek 802.11ac wireless network chips like 8822B and
> >> 8822C series. Compared to the earlier chips supported by rtlwifi like
> >> the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
> >> have different MAC & PHY settings, such as new multi-port feature for the
> >> MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
> >>
> >> Multi-Port feature is also supported under rtwlan's software architecture.
> >> rtlwifi can only support one vif in the same time, most because of the
> >> hardware limitations for early chips, hence the original design of it
> >> also restricts the usage of multi-vif support, so latest chipset seems not
> >> take advantages from its new MAC engine.
> >>
> >> However, rtwlan can run multiple vifs concurrently by holding them on
> >> hardware ports provided by MAC engine, so we can easily start different
> >> roles on a single device.
> >>
> >> Based on the reasons mentioned before, we implemented rtwlan. It had
> many
> >> authors, they are listed here alphabetically:
> >>
> >> Ping-Ke Shih <pkshih@realtek.com>
> >> Tzu-En Huang <tehuang@realtek.com>
> >> Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > I didn't do detailed review, but my general impression is very very
> > positive. New driver looks great!
> 
> I also did a quick 10 min look at the driver and indeed in general it
> looks good.
> 
> > Just 2 generic remarks:
> > - please add MAINTAINERS file entry
> > - please post a patch or request to remove staging/rtlwifi driver
> >   since this one is replace for it (8822BE PCI-ID is the same)
> 
> Something I noticed:
> 
> o Magic numbers (BIT(1) etc) in quite a few places.
> 
> o Personally not really fond of "#ifdef LITTLE_ENDIAN" usage, but I
>   guess we can live with that?
> 
> o To me the name "rtwlan" sounds confusing when one compares it with
>   "rtlwifi". And how would the possible next generation 11ax driver be
>   then called? As a good example I really like the driver name mt76,
>   could this one have something similar to make it more descriptive?
> 
> I also pushed this to the pending branch on wireless-drivers-next so
> that kbuild bot can extensively test it.
> 
> --
> Kalle Valo
> 

Yes, we will add MAINTAINER files entry after this driver.
got accepted into the kernel, or should we include the entry in this patch?
And thanks for Kvalo doing coordination with GregKH for us.
Just remove rtlwifi in driver/staging, since this driver is a replace for that.

For the magic numbers, I can work on it to reduce them,
but I am not sure I can fix all of them, will try my best to.

I do admit that "rtwlan" is confused, after we reduce the magic number,
also add MODULE_DEVICE_TABLE that suggested by Larry, we will send
a new RFC with a new name for the driver.

Besides, should we send another RFC for it or send RFC v2 and just
rename the driver?

Yan-Hsuan, Chuang
