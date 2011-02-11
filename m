Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([60.250.210.242]:46626 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306Ab1BKC0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 21:26:54 -0500
From: =?gb2312?B?wO6zr8P3?= <chaoming_li@realsil.com.cn>
To: 'Stanislaw Gruszka' <sgruszka@redhat.com>
CC: 'Johannes Berg' <johannes@sipsolutions.net>,
	'Larry Finger' <Larry.Finger@lwfinger.net>,
	'John W Linville' <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	=?gb2312?B?J7frtLrR4Cc=?= <amyfcy_feng@realsil.com.cn>,
	=?gb2312?B?J9DcueKwsic=?= <guangan_xiong@realsil.com.cn>
References: <4d4eec04.v8FQZqbn2LYPF8zs%Larry.Finger@lwfinger.net> <20110207151209.GG2319@redhat.com> <B84A4806C46340989E2A6AD2EB663300@realsil.com.cn> <20110209105405.GB5528@redhat.com> <B8DE8263FD784AC082CFDB7E9269BAEA@realsil.com.cn> <20110210074140.GA2228@redhat.com> <39A39FA0AD1A481480DE0BD469AAA79E@realsil.com.cn> <20110210095006.GB2228@redhat.com> <86D43C3FD69641C38E7144E721BCC5A6@realsil.com.cn> <20110210113715.GA31839@redhat.com>
Subject: [RFC] mac80211: cisco 1252 HT bw20, sta->ht_cap.cap bw is wrong
Date: Fri, 11 Feb 2011 10:26:13 +0800
Message-ID: <3734EB1DAE3E49A1867FDE1C680A296D@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
In-Reply-To: <20110210113715.GA31839@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Stanislaw:

	I find for cisco 1252 11N mode bandwith-20,
ieee80211_sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40
	was wrong in bss_info_changed, I have to check 20/40 MHZ based on
hw->conf.channel_type.

	All other APs will be ok, So may be it's AP IE's issue, But I think
mac80211 should also check hw->conf.channel_type
	before set ieee80211_sta->ht_cap.cap &
IEEE80211_HT_CAP_SUP_WIDTH_20_40.

Thank you!
 
lizhaoming
-- 

