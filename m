Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26940 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaAYJUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jan 2014 04:20:05 -0500
From: "Mani, Raja" <rmani@qti.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute
 confusion
Date: Sat, 25 Jan 2014 09:19:59 +0000
Message-ID: <BD8355E3EE4C424D96D29100D45098AB42C43AAD@aphydexd01a.ap.qualcomm.com> (sfid-20140125_102012_019732_22124FAE)
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	 <BD8355E3EE4C424D96D29100D45098AB42C43A80@aphydexd01a.ap.qualcomm.com>,<1390639211.4131.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1390639211.4131.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> How about this case where RSSI is disabled for SSID1 and and SSID 4
>> and only SSID2 and SSID3 needs RSSI filter.
>>
>>    SSID1, SSID2, RSSI, SSID3, RSSI, SSID4
>>
>> Wouldn't this change set RSSI of SSID3 to SSID1 and SSID4 ?
>> Did i miss to understand anything ?
>
>It's not a case that was previously supported. Previously, all you could
>do was
>
>{ SSID1 | SSID2 | SSID3 } + RSSI
>
>Now, you can do
>
>{ (SSID1, RSSI1) | (SSID2, RSSI2) | (SSID3, RSSI3) }
>
>IOW, it wouldn't change anything - note how the RSSI value before used
>to set request->rssi_thold, and not request->matchsets[i].rssi_thold.
>
>johannes

Agree your change and got your idea.

I am thinking like, Include RSSI only for SSID which require threshold limit check.
For other cases where SSID doesn't require rssi limit check, we can exclude adding RSSI attr for that SSID.

{ (SSID1) | (SSID2, RSSI2) | (SSID3) }

In that way, wpa_supplicant do not have to pass RSSI attr always for each SSID (case like, few SSID requires RSSI and few SSID doesn't require RSSI).

Anyway, I am fine with your change.

-Raja