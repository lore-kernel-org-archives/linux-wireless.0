Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:40059 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbXDNSXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2007 14:23:00 -0400
Message-ID: <46211C65.1040406@lwfinger.net>
Date: Sat, 14 Apr 2007 13:24:37 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] Mac80211: Add new names for statistics variables
References: <462119b6.sR44k/X6U4ToSXkJ%Larry.Finger@lwfinger.net> <200704142015.18660.mb@bu3sch.de>
In-Reply-To: <200704142015.18660.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Saturday 14 April 2007 20:13, Larry Finger wrote:
>> Index: wireless-dev/net/mac80211/ieee80211.c
>> ===================================================================
>> --- wireless-dev.orig/net/mac80211/ieee80211.c
>> +++ wireless-dev/net/mac80211/ieee80211.c
>> @@ -4211,7 +4211,7 @@ void ieee80211_rx_irqsafe(struct ieee802
>>  {
>>  	struct ieee80211_local *local = hw_to_local(hw);
>>  
>> -	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
>> +//	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
> 
> Whoops?

Yes, the BUILD_BUG_ON killed the compilation with both old and new names in the structs. Patch 4/4 
restores the statement.

Larry
