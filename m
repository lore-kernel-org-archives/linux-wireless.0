Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25641 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3EWF6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 01:58:04 -0400
From: "Zhou, Robie" <rzhou@qca.qualcomm.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Deng, Flavian" <flaviand@qti.qualcomm.com>
Subject: ath9k_htc p2p finding issue
Date: Thu, 23 May 2013 05:58:03 +0000
Message-ID: <A75A50687AD91044B3B81AB78993F668447D2F7F@NASANEXD02E.na.qualcomm.com> (sfid-20130523_075811_143951_FD9DD8F4)
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

We meet some problem when try P2P by using ath9k_htc compat-wireless-v3.6.8-1. 

When using the compat-wireless-v3.6.8-1, AR9271 could find other P2P devices, but other P2P devices couldn't find AR9271 (runs ath9k_htc) because driver couldn't report Probe Request to wpa_supplicant. 

And this issue could not be observed when using compat-wireless-v3.0.9-1, by compare with compat-wireless-v3.0.9-1, ATH9K RX filter is  set correctly after got "Report Probe Request" command from wpa_supplicant, but ATH9K driver couldn't get "Probe Request" frame(I add debug msg in ieee80211_rx_handlers() function).

<7>[  205.784118] [DF_DBG]    [ieee80211_mgmt_frame_register] : local->probe_req_reg = 1; 
<7>[  205.830232] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
<7>[  205.832858] [DF_DBG]    [ieee80211_configure_filter] : new_flags |= FIF_PROBE_REQ; 
<7>[  205.833101] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter
<7>[  205.878230] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter
<7>[  205.882556] [DF_DBG]    [ieee80211_configure_filter] : new_flags |= FIF_PROBE_REQ; 
<7>[  205.883606] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter

<7>[  206.010886] [DF_DBG]    [ieee80211_mgmt_frame_register] : local->probe_req_reg = 0; 
<7>[  206.036237] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x287;   ->   ath9k_hw_setrxfilter
<7>[  206.043357] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
<7>[  206.044107] [DF_DBG]    [ath9k_htc_configure_filter]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
<7>[  206.090106] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
<7>[  206.160734] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter
<7>[  206.230740] [DF_DBG]    [ath9k_htc_opmode_init]    rfilt = 0x17;   ->   ath9k_hw_setrxfilter


Did anyone ever meet this issue? Any suggestion for further debugging this issue?


Thanks
Robie



