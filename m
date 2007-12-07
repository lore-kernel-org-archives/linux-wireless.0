Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:51605 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751549AbXLGAFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 19:05:19 -0500
Message-ID: <47588E37.4080400@lwfinger.net> (sfid-20071207_000525_834046_2A525D26)
Date: Thu, 06 Dec 2007 17:05:11 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix radio LED problem
References: <474dfe58.85Rcj/BwOPxQm8eE%Larry.Finger@lwfinger.net> <200711291958.45631.mb@bu3sch.de>
In-Reply-To: <200711291958.45631.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry it has taken so long to answer, but I am traveling.

Michael Buesch wrote:
> On Thursday 29 November 2007 00:48:40 Larry Finger wrote:
> 
>> @@ -2802,6 +2800,13 @@ static int b43_op_config(struct ieee8021
>>        out_unlock_mutex:
>>  	mutex_unlock(&wl->mutex);
>>  
>> +	/* if a LED is devoted to the radio and the switch is on, send
>> +	 * KEY_WLAN press/release keystrokes */
>> +	if (!err && dev->radio_hw_enable && &dev->led_radio) {
>                                             ^^^^^^^^^^^^^^^
> This condition is always true.

It looks to me that the code uses the contents of the LED section of the SPROM to initialize
dev->led_radio. Can we be certain that the initialization will always be done?
> 
>> +		input_report_key(rfk->poll_dev->input, KEY_WLAN, 1);
>> +		input_report_key(rfk->poll_dev->input, KEY_WLAN, 0);
>> +	}
>> +
> 
> Anyway, sending a key event here seems pretty bogus. The comment
> doesn't really say anything useful why this is needed.

If a key event (down/up) is not sent, the LED remains off. This location may not be the best place,
but it is needed someplace, otherwise the switch must be cycled off/on to get the LED on.


Larry


