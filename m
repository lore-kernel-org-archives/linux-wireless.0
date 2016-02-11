Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f193.google.com ([209.85.214.193]:33713 "EHLO
	mail-ob0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbcBKQx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Feb 2016 11:53:26 -0500
Received: by mail-ob0-f193.google.com with SMTP id o4so6163125obb.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Feb 2016 08:53:26 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 0/4] rtlwifi: Rework 5G channel arrays
Date: Thu, 11 Feb 2016 10:53:08 -0600
Message-Id: <1455209592-12882-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160211_175337_711229_BE3D1FD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several of the rtlwifi drivers have separate definitions of the 5D channel
arrays. This patch set replaces 5 separate instances with a single one in the
common header.

These patches also eliminate spurious messages "rtl8821ae:_rtl8821ae_get_chnl_group():
5G, Channel 163 in Group not found" from rtl8821ae.

This material is for kernel 4.6.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>


Larry Finger (4):
  rtlwifi: Prepare for reworking 5G channels
  rtlwifi: rtl8192de: Convert driver to use common 5G channels
  rtlwifi: rtl8192ee: Convert driver to use new 5G channel tables
  rtlwifi: rtl8821ae: Convert driver to use common 5G channel table

 drivers/net/wireless/realtek/rtlwifi/core.c        | 16 +++++++++++++
 .../net/wireless/realtek/rtlwifi/rtl8192de/phy.c   | 23 ++++--------------
 .../net/wireless/realtek/rtlwifi/rtl8192ee/hw.c    | 12 ----------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/hw.c    | 18 ---------------
 .../net/wireless/realtek/rtlwifi/rtl8821ae/phy.c   | 27 +++++-----------------
 drivers/net/wireless/realtek/rtlwifi/wifi.h        | 11 ++++-----
 6 files changed, 31 insertions(+), 76 deletions(-)

-- 
2.1.4

