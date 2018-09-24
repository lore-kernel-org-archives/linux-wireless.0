Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbeIXRGz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 13:06:55 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
        <20180921131235.GA10556@redhat.com>
Date: Mon, 24 Sep 2018 14:05:18 +0300
In-Reply-To: <20180921131235.GA10556@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 21 Sep 2018 15:12:36 +0200")
Message-ID: <87pnx340lt.fsf@codeaurora.org> (sfid-20180924_130526_895579_A692EB3F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Fri, Sep 21, 2018 at 02:03:55PM +0800, yhchuang@realtek.com wrote:
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> 
>> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
>> rtwlan supports 8822BE and 8822CE chips, and will be able to support
>> multi-vif combinations in run-time.
>> 
>> For now, only PCI bus is supported, but rtwlan was originally designed
>> to optionally support three buses includes USB & SDIO. USB & SDIO modules
>> will soon be supported by rtwlan, with configurable core module to fit
>> with different bus modules in the same time.
>> 
>> For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
>> be selected, built, loaded into kernel. This is one of the major
>> difference from rtlwifi, which can only support specific combinations.
>> 
>> Another difference from rtlwifi is that rtwlan is designed to support
>> the latest Realtek 802.11ac wireless network chips like 8822B and
>> 8822C series. Compared to the earlier chips supported by rtlwifi like
>> the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
>> have different MAC & PHY settings, such as new multi-port feature for the
>> MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
>> 
>> Multi-Port feature is also supported under rtwlan's software architecture.
>> rtlwifi can only support one vif in the same time, most because of the
>> hardware limitations for early chips, hence the original design of it
>> also restricts the usage of multi-vif support, so latest chipset seems not
>> take advantages from its new MAC engine.
>> 
>> However, rtwlan can run multiple vifs concurrently by holding them on
>> hardware ports provided by MAC engine, so we can easily start different
>> roles on a single device.
>> 
>> Based on the reasons mentioned before, we implemented rtwlan. It had many
>> authors, they are listed here alphabetically:
>> 
>> Ping-Ke Shih <pkshih@realtek.com>
>> Tzu-En Huang <tehuang@realtek.com>
>> Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> I didn't do detailed review, but my general impression is very very
> positive. New driver looks great!

I also did a quick 10 min look at the driver and indeed in general it
looks good.

> Just 2 generic remarks:
> - please add MAINTAINERS file entry
> - please post a patch or request to remove staging/rtlwifi driver
>   since this one is replace for it (8822BE PCI-ID is the same)

Something I noticed:

o Magic numbers (BIT(1) etc) in quite a few places.

o Personally not really fond of "#ifdef LITTLE_ENDIAN" usage, but I
  guess we can live with that?

o To me the name "rtwlan" sounds confusing when one compares it with
  "rtlwifi". And how would the possible next generation 11ax driver be
  then called? As a good example I really like the driver name mt76,
  could this one have something similar to make it more descriptive?

I also pushed this to the pending branch on wireless-drivers-next so
that kbuild bot can extensively test it.

-- 
Kalle Valo
