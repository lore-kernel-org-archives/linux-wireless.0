Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:34901 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbcIZBzq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 21:55:46 -0400
Received: by mail-vk0-f50.google.com with SMTP id 192so35060528vkl.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2016 18:55:45 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org
From: Xuebing Wang <xbing6@gmail.com>
Subject: RTL8192CU: about trivial change of removing some 8192c declaration
 from header file
Message-ID: <5244f149-9792-e814-7ee2-0a3fd178d306@gmail.com> (sfid-20160926_035551_554139_01ED1C4C)
Date: Mon, 26 Sep 2016 09:55:39 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry and Chaoming:

I am trying to do User Mode driver for RTL8192CU (device is Alfa 
AWUS036NHR which is 802.11 b/g/n), and I am reading RTL8192CU / RTL8192C 
/ RTLWIFI driver source code.

There is a very trivial error that below declarations (in 
rtl8192cu/hw.h) are already in file 
drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.h
---
int rtl92c_download_fw(struct ieee80211_hw *hw);
void rtl92c_set_fw_pwrmode_cmd(struct ieee80211_hw *hw, u8 mode);
void rtl92c_set_fw_joinbss_report_cmd(struct ieee80211_hw *hw, u8 mstatus);
void rtl92c_fill_h2c_cmd(struct ieee80211_hw *hw,
              u8 element_id, u32 cmd_len, u8 *p_cmdbuffer);
---

Does it make sense for me to submit a trivial patch to remove these 
declarations from rtl8192cu/hw.h?

Thanks.
xuebing
