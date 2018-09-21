Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbeIUTB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 15:01:28 -0400
Date: Fri, 21 Sep 2018 15:12:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: yhchuang@realtek.com
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac
 wireless network chips
Message-ID: <20180921131235.GA10556@redhat.com> (sfid-20180921_151247_578658_D38AF673)
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2018 at 02:03:55PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtwlan supports 8822BE and 8822CE chips, and will be able to support
> multi-vif combinations in run-time.
> 
> For now, only PCI bus is supported, but rtwlan was originally designed
> to optionally support three buses includes USB & SDIO. USB & SDIO modules
> will soon be supported by rtwlan, with configurable core module to fit
> with different bus modules in the same time.
> 
> For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
> be selected, built, loaded into kernel. This is one of the major
> difference from rtlwifi, which can only support specific combinations.
> 
> Another difference from rtlwifi is that rtwlan is designed to support
> the latest Realtek 802.11ac wireless network chips like 8822B and
> 8822C series. Compared to the earlier chips supported by rtlwifi like
> the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
> have different MAC & PHY settings, such as new multi-port feature for the
> MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
> 
> Multi-Port feature is also supported under rtwlan's software architecture.
> rtlwifi can only support one vif in the same time, most because of the
> hardware limitations for early chips, hence the original design of it
> also restricts the usage of multi-vif support, so latest chipset seems not
> take advantages from its new MAC engine.
> 
> However, rtwlan can run multiple vifs concurrently by holding them on
> hardware ports provided by MAC engine, so we can easily start different
> roles on a single device.
> 
> Based on the reasons mentioned before, we implemented rtwlan. It had many
> authors, they are listed here alphabetically:
> 
> Ping-Ke Shih <pkshih@realtek.com>
> Tzu-En Huang <tehuang@realtek.com>
> Yan-Hsuan Chuang <yhchuang@realtek.com>

I didn't do detailed review, but my general impression is very very
positive. New driver looks great!

Just 2 generic remarks:
- please add MAINTAINERS file entry
- please post a patch or request to remove staging/rtlwifi driver
  since this one is replace for it (8822BE PCI-ID is the same)

Thanks
Stanislaw
