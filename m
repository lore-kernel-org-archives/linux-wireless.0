Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42517 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbaKTUK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 15:10:57 -0500
Received: by mail-pd0-f179.google.com with SMTP id w10so3734266pde.10
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2014 12:10:57 -0800 (PST)
MIME-Version: 1.0
From: Catalin Iacob <iacobcatalin@gmail.com>
Date: Thu, 20 Nov 2014 21:10:37 +0100
Message-ID: <CAHg_5go+AZTytHq7OyoV_r35sj2wW0OwgBq+sm8R+zJbOXiYcA@mail.gmail.com> (sfid-20141120_211114_440071_8AD37E8C)
Subject: rtl8192ce 3.18 regression scan doesn't find any APs
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the 3.18 merge window my wireless card cannot find any access
point (tested with both NetworkManager and sudo /usr/sbin/iw dev
wlp2s0 scan). More precisely, in 3.18-rc1 I got the oops described at
http://marc.info/?l=linux-wireless&m=141324391807122&w=2. Sometime
after rc1 Larry fixed this but when I tested again I found that scan
doesn't work (tested 3.18-rc3 and just now 3.18-rc5).

According to lspci -nn my hardware is:
02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd.
RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)

If I grep dmesg for rtl, for 3.17 which works I get:
[   31.208206] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip
Version ID: B_CHIP_88C
[   31.219973] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[   31.861478] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   31.865655] rtlwifi: wireless switch is on
[   31.872019] rtl8192ce 0000:02:00.0 wlp2s0: renamed from wlan0
[   41.428487] rtl8192ce 0000:02:00.0 wlp2s0: disabling HT as WMM/QoS
is not supported by the AP
[   41.428499] rtl8192ce 0000:02:00.0 wlp2s0: disabling VHT as WMM/QoS
is not supported by the AP

3.18 says:
[   29.213829] rtl8192ce:_rtl92ce_read_chip_version():<0-0> Chip
Version ID: B_CHIP_88C
[   29.230599] rtl8192ce: Using firmware rtlwifi/rtl8192cfw.bin
[   29.330232] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   29.332250] rtlwifi: rtlwifi: wireless switch is on
[   29.339416] rtl8192ce 0000:02:00.0 wlp2s0: renamed from wlan0
[  344.942070] rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed

I added some debug prints and the last line comes from core.c,
rtl_op_stop which calls get_hw_reg with HAL_DEF_WOWLAN. This happens
indeed when I untick Enable wireless in NetworkManager. I assume it's
not related to the more serious scan issue.

How can I help with debugging this?
