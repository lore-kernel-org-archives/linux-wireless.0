Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49088 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753515AbXDOTpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2007 15:45:20 -0400
Message-ID: <46228134.2020300@lwfinger.net>
Date: Sun, 15 Apr 2007 14:47:00 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx-mac80211: Make wireless statistics yield reasonable  values
References: <4621a896.akSEX43I3VgRXr70%Larry.Finger@lwfinger.net> <200704150050.48891.flamingice@sourmilk.net>
In-Reply-To: <200704150050.48891.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Sunday 15 April 2007 00:22, Larry Finger wrote:
>> -	hw->max_rssi = -110;
>> -	hw->max_signal = BCM43xx_RX_MAX_SSI;
>> +	hw->max_signal = 100; /* This looks wrong, but is what mac80211 wants */
>> +	hw->max_rssi = BCM43xx_RX_MAX_SSI;
> The number being passed into ssi is dBm, so why is the max being set to 60? It 
> should be set to the minimum dBm that the device can report, like -110 as it 
> was set before. Since SSI is actually being passed into signal, MAX_SSI 
> should go to max_signal.

You are correct that -110 would be better than -196, which is what 60 translates to given the s8 
arithmetic. Due to the internal workings of mac80211, the quantity in max_signal ends up as the 
denominator in the qual report of x/y. I would sooner give the users a percentage that parts per 60.

Larry
