Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-am1on0092.outbound.protection.outlook.com ([157.56.112.92]:17376
	"EHLO emea01-am1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753279AbbESQxI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 12:53:08 -0400
From: Vladimir DIACONESCU <vladimir.diaconescu@cti.pub.ro>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: mac80211: How to properly issue a channel switch
Date: Tue, 19 May 2015 16:18:39 +0000
Message-ID: <1432052318710.51361@cti.pub.ro> (sfid-20150519_185314_631439_426D3974)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

(using kernel version 3.14 - mptcp-0.89, to be more accurate)

I am looking for a proper/correct way to request a channel switch from the mac80211 level.

>From what I managed to gather:
- a struct cfg80211_chan_def needs to be filled in
- then passed to struct ieee80211_local, specific to our device (ath9k, in my case)
- then call ieee80211_hw_config (local, IEEE80211_CONF_CHANGE_CHANNEL), which will actually configure the device and switch the channel

However, after setting the channel parameters (via local->_oper_chandef, which is discouraged, as I have noted) I get a warning from nl80211 (nl80211_send_chandef) regarding chandef validity (the values center_freq1, control_freq and width depend one on another, as seen in cfg80211_chandef_valid, and the standard, of course).

Thank you for your time,
Vladimir