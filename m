Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:40592 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab1HWJ7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 05:59:12 -0400
From: =?gb2312?B?wO6zr8P3?= <chaoming_li@realsil.com.cn>
To: <linville@tuxdriver.com>,
	'Larry Finger' <Larry.Finger@lwfinger.net>,
	<linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
References: <1314049818-21839-1-git-send-email-Larry.Finger@lwfinger.net> <1314049818-21839-6-git-send-email-Larry.Finger@lwfinger.net>
Subject: [RFC] mac80211: Adhoc WPA-NONE packets lost by mac80211 
Date: Tue, 23 Aug 2011 17:58:58 +0800
Message-ID: <F5749057C8FE46CD88E05545135626BB@realsil.com.cn> (sfid-20110823_115916_036908_E0E26086)
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
In-Reply-To: <1314049818-21839-6-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Dear John:

	Recently I test IBSS WPA-NONE use rtlwifi driver,  it can link
successfully, but can not ping.
	And I found that receive packet from other non-mac80211 peer have
been decryped by rtlwifi hardware like RTL8188CE, but 
	these packets will be discard by follwing code in
ieee80211_rx_h_decrypt:
	
	==============================================================
	/*
	 * RSNA-protected unicast frames should always be
	 * sent with pairwise or station-to-station keys,
	 * but for WEP we allow using a key index as well.
	 */
	if (rx->key &&
	    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP40 &&
	    rx->key->conf.cipher != WLAN_CIPHER_SUITE_WEP104 &&
	    !is_multicast_ether_addr(hdr->addr1))
		rx->key = NULL;	
	==============================================================

	because not only WEP, but IBSS WPA-NONE will also use Group for both
receiving
	and sending unicast and multicast packets.

	So I want to ask, why we can't receive WPA-NONE packets here ? Will
WPA-NONE 
	packets cause other issues ?

Thank you for your help.

Best Regards!
chaoming_li

