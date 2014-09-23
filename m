Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39585 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbaIWVRr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 17:17:47 -0400
Received: by mail-ob0-f182.google.com with SMTP id wo20so5443150obc.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Sep 2014 14:17:46 -0700 (PDT)
Message-ID: <5421E379.4030504@lwfinger.net> (sfid-20140923_231751_901533_041897A5)
Date: Tue, 23 Sep 2014 16:17:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Berg, Johannes" <johannes.berg@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Question about channel width
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

While investigating relatively poor performance on an 802.11n link, I noticed 
the following in the logs:

wlp2s0: capabilities/regulatory prevented using AP HT/VHT configuration, downgraded

On investigation, I found that the message comes from routine 
ieee80211_determine_chantype(). I am not sure why it gets to that part of the 
code; however, chandef->width and vht_chandef.width) are not equal The first is 
reasonable with a value of 1, but vht_chandef.width has an unreasonable value of 
9708.

Is there a quick explanation of why this is happening, and why vht_chandef is 
not being properly initialized? The AP supports 300 Mbps operations, and the NIC 
should handle 150.

Larry

