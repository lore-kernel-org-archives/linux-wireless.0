Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7900CC65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27C7B21473
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 11:45:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="N6KYUYyL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZOcirjVZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27C7B21473
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbeJFSss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 14:48:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726919AbeJFSss (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 14:48:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7614460445; Sat,  6 Oct 2018 11:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538826351;
        bh=MLIUjPs1FK1B7gmrIMd07wedvvhk9q8zdhnvdVem+F0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=N6KYUYyLCFbjmyBpAJv8tZezSHepq6IfsUUQ03K+4qED2TBesCEnWcto+hUX1zuEi
         LknI+TVCFoxVTQUCMUqiO0l/iofQeRauDoBtjGq7vk3ObMkQ1F7TNWMglDlMINBjt3
         W4OLy4Up3/tjAWJ/2PawphWmD2mgTXJt+Csg06HI=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 827E36031A;
        Sat,  6 Oct 2018 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538826350;
        bh=MLIUjPs1FK1B7gmrIMd07wedvvhk9q8zdhnvdVem+F0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZOcirjVZUJjk6CRtj6vjLThIc+TJ55S7HXS6G9PadQGJGmCxEXkNIbWBqLQVXFGrs
         Dw1ZNrIkDFMcaiEb7M/dkwYZrqsga8gB1jmUqqg5kKX1rp7UtxkahTUT70SogLtkuh
         d9J3KR4n6BMS6BxP5HkrP1d1UuL3DxslNRtHOp7w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 827E36031A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
        <20180921131235.GA10556@redhat.com> <87pnx340lt.fsf@codeaurora.org>
        <F7CD281DE3E379468C6D07993EA72F84D08D7F89@RTITMBSVM01.realtek.com.tw>
Date:   Sat, 06 Oct 2018 14:45:46 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D08D7F89@RTITMBSVM01.realtek.com.tw>
        (Tony Chuang's message of "Tue, 25 Sep 2018 11:09:06 +0000")
Message-ID: <877eivguxh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> -----Original Message-----
>> From: Kalle Valo [mailto:kvalo@codeaurora.org]
>> Sent: Monday, September 24, 2018 7:05 PM
>> To: Stanislaw Gruszka
>> Cc: Tony Chuang; Larry.Finger@lwfinger.net; linux-wireless@vger.kernel.org;
>> Pkshih; Andy Huang
>> Subject: Re: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac
>> wireless network chips
>> 
>> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>> 
>> > On Fri, Sep 21, 2018 at 02:03:55PM +0800, yhchuang@realtek.com wrote:
>> >> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> >>
>> >> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
>> >> rtwlan supports 8822BE and 8822CE chips, and will be able to support
>> >> multi-vif combinations in run-time.
>> >>
>> >> For now, only PCI bus is supported, but rtwlan was originally designed
>> >> to optionally support three buses includes USB & SDIO. USB & SDIO
>> modules
>> >> will soon be supported by rtwlan, with configurable core module to fit
>> >> with different bus modules in the same time.
>> >>
>> >> For example, if we choose 8822BE and 8822CU, only PCI & USB modules
>> will
>> >> be selected, built, loaded into kernel. This is one of the major
>> >> difference from rtlwifi, which can only support specific combinations.
>> >>
>> >> Another difference from rtlwifi is that rtwlan is designed to support
>> >> the latest Realtek 802.11ac wireless network chips like 8822B and
>> >> 8822C series. Compared to the earlier chips supported by rtlwifi like
>> >> the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
>> >> have different MAC & PHY settings, such as new multi-port feature for the
>> >> MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
>> >>
>> >> Multi-Port feature is also supported under rtwlan's software architecture.
>> >> rtlwifi can only support one vif in the same time, most because of the
>> >> hardware limitations for early chips, hence the original design of it
>> >> also restricts the usage of multi-vif support, so latest chipset seems not
>> >> take advantages from its new MAC engine.
>> >>
>> >> However, rtwlan can run multiple vifs concurrently by holding them on
>> >> hardware ports provided by MAC engine, so we can easily start different
>> >> roles on a single device.
>> >>
>> >> Based on the reasons mentioned before, we implemented rtwlan. It had
>> many
>> >> authors, they are listed here alphabetically:
>> >>
>> >> Ping-Ke Shih <pkshih@realtek.com>
>> >> Tzu-En Huang <tehuang@realtek.com>
>> >> Yan-Hsuan Chuang <yhchuang@realtek.com>
>> >
>> > I didn't do detailed review, but my general impression is very very
>> > positive. New driver looks great!
>> 
>> I also did a quick 10 min look at the driver and indeed in general it
>> looks good.
>> 
>> > Just 2 generic remarks:
>> > - please add MAINTAINERS file entry
>> > - please post a patch or request to remove staging/rtlwifi driver
>> >   since this one is replace for it (8822BE PCI-ID is the same)
>> 
>> Something I noticed:
>> 
>> o Magic numbers (BIT(1) etc) in quite a few places.
>> 
>> o Personally not really fond of "#ifdef LITTLE_ENDIAN" usage, but I
>>   guess we can live with that?
>> 
>> o To me the name "rtwlan" sounds confusing when one compares it with
>>   "rtlwifi". And how would the possible next generation 11ax driver be
>>   then called? As a good example I really like the driver name mt76,
>>   could this one have something similar to make it more descriptive?
>> 
>> I also pushed this to the pending branch on wireless-drivers-next so
>> that kbuild bot can extensively test it.
>
> Yes, we will add MAINTAINER files entry after this driver.
> got accepted into the kernel, or should we include the entry in this patch?

Please update the MAINTAINERS file in this patchset, just in a separate
patch. I can them apply it at the same time as the driver (once it's
ready).

-- 
Kalle Valo
