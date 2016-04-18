Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbcDRPti (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 11:49:38 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 00/16] rtl8xxxu prepare for splitting into multiple files
Date: Mon, 18 Apr 2016 11:49:20 -0400
Message-Id: <1460994576-24091-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160418_174949_868745_22820F5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This is the last set of patches I have in my queue for the rtl8xxxu
driver, as of today :)

Since the driver has grown to support quite a number of different
chips, I want to split it into multiple files. This will make it
easier to maintain and also eaiser to add support for more chips
without having to constantly touch the core files.

This set renames a bunch of functions to indicate that they are
generic rather than chip specific. I will look at doing the actual
moving around in a set right after the current merge window closes.

Please keep the test reports coming!

Cheers,
Jes


Jes Sorensen (16):
  rtl8xxxu: Rename rtl8723bu_update_rate_mask() to
    rtl8xxxu_gen2_update_rate_mask()
  rtl8xxxu: Rename rtl8723bu_report_connect() to
    rtl8xxxu_gen2_report_connect()
  rtl8xxxu: Rename rtl8723au_report_connect() to
    rtl8xxxu_gen1_report_connect()
  rtl8xxxu: Rename rtl8723bu_config_channel() to
    rtl8xxxu_gen2_config_channel()
  rtl8xxxu: Rename rtl8723b_disable_rf() to rtl8xxxu_gen2_disable_rf()
  rtl8xxxu: Rename rtl8723a_disable_rf() to rtl8xxxu_gen1_disable_rf()
  rtl8xxxu: Rename rtl8723au_config_channel() to
    rtl8xxxu_gen1_config_channel()
  rtl8xxxu: Rename rtl8723au_update_rate_mask() to
    rtl8xxxu_update_rate_mask()
  rtl8xxxu: Rename rtl8723au_phy_iq_calibrate() to
    rtl8xxxu_gen1_phy_iq_calibrate()
  rtl8xxxu: Rename rtl8723au_init_phy_bb() to
    rtl8xxxu_gen1_init_phy_bb()
  rtl8xxxu: Rename rtl8723a_set_tx_power() to
    rtl8xxxu_gen1_set_tx_power()
  rtl8xxxu: Rename rtl8723a_enable_rf() to rtl8xxxu_gen1_enable_rf()
  rtl8xxxu: Rename rtl8723a_mac_init_table to
    rtl8xxxu_gen1_mac_init_table
  rtl8xxxu: Rename rtl8723b_channel_to_group()
  rtl8xxxu: Rename rtl8723bu_simularity_compare()
  rtl8xxxu: Rename rtl8723au_iqk_phy_iq_bb_reg

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 122 ++++++++++++-----------
 1 file changed, 64 insertions(+), 58 deletions(-)

-- 
2.5.5

