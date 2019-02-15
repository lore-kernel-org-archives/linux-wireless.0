Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB96C10F04
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:20:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D6C420643
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 02:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBOCPS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:15:18 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55379 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405593AbfBOCPR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 21:15:17 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1F2ElrA010169, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas11.realtek.com.tw[172.21.6.12])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1F2ElrA010169
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 15 Feb 2019 10:14:47 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS11.realtek.com.tw ([fe80::7c6d:ced5:c4ff:8297%15]) with mapi id
 14.03.0399.000; Fri, 15 Feb 2019 10:14:46 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>
Subject: RE: [PATCH v5 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
Thread-Topic: [PATCH v5 00/13] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
Thread-Index: AQHUxDyEEDxOy7IFh0OKqLgYM4CgU6XgHiow
Date:   Fri, 15 Feb 2019 02:14:46 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A6C5B@RTITMBSVM04.realtek.com.tw>
References: <1550131671-2601-1-git-send-email-yhchuang@realtek.com>
In-Reply-To: <1550131671-2601-1-git-send-email-yhchuang@realtek.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
> rtw88 supports 8822BE and 8822CE chips, and will be able to support
> multi-vif combinations in run-time.
> 
> For now, only PCI bus is supported, but rtw88 was originally designed
> to optionally support three buses includes USB & SDIO. USB & SDIO modules
> will soon be supported by rtw88, with configurable core module to fit
> with different bus modules in the same time.
> 
> For example, if we choose 8822BE and 8822CU, only PCI & USB modules will
> be selected, built, loaded into kernel. This is one of the major
> difference from rtlwifi, which can only support specific combinations.
> 
> Another difference from rtlwifi is that rtw88 is designed to support
> the latest Realtek 802.11ac wireless network chips like 8822B and
> 8822C series. Compared to the earlier chips supported by rtlwifi like
> the 802.11n 8192EE chipset or 802.11ac 8821AE/8812AE chips, newer ICs
> have different MAC & PHY settings, such as new multi-port feature for the
> MAC layer design and Jaguar2/Jaguar3 PHY layer IPs.
> 
> Multi-Port feature is also supported under rtw88's software architecture.
> rtlwifi can only support one vif in the same time, most because of the
> hardware limitations for early chips, hence the original design of it
> also restricts the usage of multi-vif support, so latest chipset seems not
> take advantages from its new MAC engine.
> 
> However, rtw88 can run multiple vifs concurrently by holding them on
> hardware ports provided by MAC engine, hence can easily start different
> roles on a single device.
> 
> Based on the reasons mentioned before, we implemented rtw88. It had many
> authors, they are listed here alphabetically:
> 
> Ping-Ke Shih <pkshih@realtek.com>
> Tzu-En Huang <tehuang@realtek.com>
> Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> 
> v2
> 
>  - add comment for watch dog
> 
> 
> v3
> 
>  - change tree location to wireless-next
> 
> 
> v4
> 
>  - remove useless "T:" and "W:" lines in MAINTAINERS file, as we don't have
>    our own tree and wiki page now
>  - rename patch 13 to "add MAINTAINERS entry"
>  - use skb_pull to remove tx descriptors before reporting tx status to
>    mac80211 stack, otherwise mac80211 tx status will always fail to match
>    addr1/addr2 and will finally trigger to disconnect
>  - return back to operating channel when we leave IDLE state, as mac80211
>    stack expected. If we don't, mac80211 will assume we are already at
>    channel 1 and start to scan. And we will never be able to connect to
>    APs that are in channel 1. (which is most AP's default channel)
>  - wait for async firmware load successfully, otherwise some slower platform
>    might start to download firmware before loaded. And system crashes with a
>    null pointer accessed.
>  - fix typo for mac.h __RTW_MAc_H__ -> __RTW_MAC_H__
> 
> 
> v5
> 
>  - add rtw_debug_mask for rtw_dbg to control debug messages
>  - use dev_printk for rtw_dbg to not depend on CONFIG_DYNAMIC_DEBUG
>  - remove useless rtw_pci_parse_configuration
>  - keep struct and MODULE_* declaration close
>  - use macro instead of ugly struct layout with #ifdef __LITTLE_ENDIAN
>  - simplify efuse logical map parsing function
>  - remove unused member and whole map dump for efuse
>  - reduce some usage of magic number
>  - enable DMA sync to avoid pci bus timeout
> 

I am sorry that I missed some descriptions about v5. Listed below

 - adjust download firmware sequence to avoid DMA error flag honored
 - change download firmware prototype for further use, sometimes we may
   want to download another special purposed firmware
 - move out rtw_send_rsvd_page_h2c, remove the static


Thanks.

Yan-Hsuan
