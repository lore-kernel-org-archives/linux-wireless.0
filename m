Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([131.228.20.171]:47036 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658AbXH0QBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 12:01:09 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: mac80211 AP mode powersaving problems?
References: <1186990509.27916.38.camel@johannes.berg>
	<87lkccf30m.fsf@tikku.osso.net>
	<1187270479.5141.44.camel@johannes.berg> <87643f4kkh.fsf@nokia.com>
	<1187275344.23489.6.camel@johannes.berg>
From: Kalle Valo <Kalle.Valo@nokia.com>
Date: Mon, 27 Aug 2007 18:58:35 +0300
Message-ID: <871wdphsus.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Are there any tricks or should this be enough with b43:
>> 
>> iwconfig wlan0 mode master channel 2 essid mac80211
>> ip link set wlan0 up
>
> Umm, of course not. You need hostapd.

Heh, I guess I have used madwifi too much :) 

I didn't even think of hostapd, for some strange reason I have always
thought it as an optional feature.

I couldn't find any instructions how to use hostapd with mac80211, so
here's what I did (for the archive):

o pulled latest wireless-dev#everything

o pulled latest hostapd from git

o compiled hostapd with these extra settings in .config:

CONFIG_DRIVER_DEVICESCAPE=y
WIRELESS_DEV=/home/kvalo/linux-2.6/
CFLAGS += -I$(WIRELESS_DEV)/net/mac80211

o edited hostapd.conf (wlan1 is my b43 interface):

interface=wlan1                                                                
driver=devicescape                                                             
hw_mode=g                                                                      
channel=5                                                                      

o started hostapd:

# ./hostapd hostapd.conf

-- 
Kalle Valo
