Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:42026 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729351AbeIXXM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 19:12:58 -0400
Received: by mail-oi0-f68.google.com with SMTP id v198-v6so17502851oif.9
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2018 10:09:51 -0700 (PDT)
Subject: Re: [RFC 00/12] rtwlan: mac80211 driver for Realtek 802.11ac wireless
 network chips
To: yhchuang@realtek.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <052723dc-c8b9-1a40-90a4-7c8ae2b29299@lwfinger.net> (sfid-20180924_190954_615123_CF8F07CA)
Date: Mon, 24 Sep 2018 12:09:49 -0500
MIME-Version: 1.0
In-Reply-To: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/21/18 1:03 AM, yhchuang@realtek.com wrote:
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

I have found two problems with the initial code:

1. There is a missing zero entry at the end of the struct pci_device_id.
2. You have no MODULE_DEVICE_TABLE macro call.

The effect is that the device is not autoloaded on boot. The fix is

diff --git a/drivers/net/wireless/realtek/rtwlan/pci.c 
b/drivers/net/wireless/realtek/rtwlan/pci.c
index 2ff5a152d77b..f8b1267520a7 100644
--- a/drivers/net/wireless/realtek/rtwlan/pci.c
+++ b/drivers/net/wireless/realtek/rtwlan/pci.c
@@ -1184,6 +1184,7 @@ static const struct pci_device_id rtw_pci_id_table[] = {
  #ifdef CONFIG_RTWLAN_8822CE
         { RTK_PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0xC822, rtw8822c_hw_spec) },
  #endif
+       {},
  };

  static struct pci_driver rtw_pci_driver = {
@@ -1210,6 +1211,8 @@ struct rtw_hci_ops rtw_pci_ops = {
         .check_avail_desc = rtw_pci_check_avail_desc,
  };

+MODULE_DEVICE_TABLE(pci, rtw_pci_id_table);
+
  module_pci_driver(rtw_pci_driver);

  MODULE_AUTHOR("Realtek Corporation");

Larry
