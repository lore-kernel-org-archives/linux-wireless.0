Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37781 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbZGaVm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:42:58 -0400
Message-ID: <4A73655D.1020205@candelatech.com>
Date: Fri, 31 Jul 2009 14:42:53 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Patrick McHardy <kaber@trash.net>
Subject: wpa_test not used in wpa.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems to me that in this method (and others), wpa_test is not
actually assigned a useful value, but it's still tested in code
branches.


ieee80211_txrx_result
ieee80211_rx_h_michael_mic_verify(struct ieee80211_txrx_data *rx)


In this one, it seems to always force a code branch to happen:

ieee80211_txrx_result
ieee80211_tx_h_michael_mic_add(struct ieee80211_txrx_data *tx)


Any idea on how this is supposed to work?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

