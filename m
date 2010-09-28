Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snt0-omc2-s25.snt0.hotmail.com ([65.55.90.100]:41412 "EHLO
	snt0-omc2-s25.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab0I1KLG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 06:11:06 -0400
Message-ID: <SNT113-W6152D56CD8692FD222366FF1660@phx.gbl>
From: Dale Turner <rx_guy@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: Re: carl9170 problem
Date: Tue, 28 Sep 2010 07:11:04 -0300
In-Reply-To: <SNT113-W459FFC08EF0C4936BEDD5CF1660@phx.gbl>
References: <SNT113-W182B461295E717BB27130BF1630@phx.gbl>,<201009260057.38286.chunkeey@googlemail.com>,<SNT113-W459FFC08EF0C4936BEDD5CF1660@phx.gbl>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>> Hello everyone.
>>>
>>> Thanks for releasing the carl9170 driver in the
>>> compat-wireless package.
>> I recommend using wireless-testing.git over
>> compat-wireless + old kernel.
>>
>>> I have been able to compile the driver, so that is great.
>>> The connection seems to be a bit inconsistent.
>>> I get the following quite often in /var/log/messages :
>>
>>> kernel: ieee80211 phy9: channel change: 2472 -> 2462 failed (2)
>> That's a noise floor calibration error. Check if your compat-wireless
>> source includes "carl9170: reinit phy after HT settings have changed".
>> Also check if there is another device active on the same (primary/
>> secondary) channel like a microwave oven, DECT phone or another wifi
>> network, or wifi network peer.
>>
>>> kernel: ieee80211 phy9: invalid plcp cck rate (0)
>> This is a known bug, the driver received a invalid stream frame
>> from the hardware. This only happens a lot when the AP ignores
>> the device's ampdu spacing.
>> (Do you have an older draft-n AP, if so what chip?)
>>
>>> kernel: ieee80211 phy9: FW: MAC RESET
>> The device failed to send pending data for more than 150ms(HT40) - 300ms,
>> either because the medium was busy, or the AP failed to response at all
>> mostly because it has crashed first.
>> (check if your AP's TSF is no where near your AP's uptime)
>>
>>> When
>>> that happens (which can be as often as every few minutes) my reported
>>> connection speed in network manager drops to 6 or 1 Mb/s. The network
>>> speed is noticeably reduced (for instance download speeds drastically
>>> reduce, online videos stutter, or music streaming from a different
>>> computer pauses, etc).
>> Network manager has a feature called "background scanning".
>> The advantage is that you'll always have a up-to-date site survey.
>> The disadvantage is that it needs to perform a periodically scan
>> (as in every few minutes) which on some occasions result in a
>> channel change failed hiccup.
>>
>>>
>>> My previous adapter TP-Link TL-WN721N (ath9k_htc driver) did not behave like this.
>> Why did you go back to the previous generation?
>> ath9k_htc (for AR9271) is in fact the replacement for AR9170.
>>
>> Regards,
>> Chr
>  
Thanks for your response.
 
 I chose the TL-WN821N because it seemed to have a 'better' feature set (faster speed, MIMO, etc) plus the carl9170 driver is supposed to capable of AP mode. (I have plans in the future of constructing a wireless router). So I thought I was improving (guess I'm wrong).
 
 I don't think there are any nearby networks on my channel. I purposely change it from default ( 6 ) to 11 (actually wide 9). 
 
 The access point is a Linksys wrt120n (probably not the best, I know).
 
 To be honest, I don't know what a TSF is or how to check it.
 
 Thanks again,
 
 Dale

 		 	   		  