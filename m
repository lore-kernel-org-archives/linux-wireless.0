Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:60551 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2DPX2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 19:28:41 -0400
Message-ID: <4F8CAB25.9000302@openwrt.org> (sfid-20120417_012844_779430_12BF7F03)
Date: Tue, 17 Apr 2012 01:28:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: spams@ivanich.org.ua, linux-wireless@vger.kernel.org
Subject: Re: Regression in kernel-3.4-rcx with rtl8192ce
References: <2054318.iQACctbcH2@ivanich.org.ua> <4F8C9DDD.5080704@lwfinger.net>
In-Reply-To: <4F8C9DDD.5080704@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-04-17 12:31 AM, Larry Finger wrote:
> On 04/16/2012 04:52 PM, spams@ivanich.org.ua wrote:
>> I'm using rtl8188ce in AP mode with hostapd, after upgrade to 3.4-rcx
>> kernel(tried 3.4-rc2,rc3 and latest source from wireless-next.git) I can't
>> connect to my AP.
>> AP Log:
>> Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE 802.11:
>> authenticated
>> Apr 16 23:31:39 localhost hostapd: wlan0: STA d8:b3:cf:d1:a0:58 IEEE 802.11:
>> Station sent an invalid association request
>>
>> Tried disabling and enabling different options in hostapd.conf but with no
>> luck. With kernels-3.3.x it works just fine.
>> Thank you.
> 
> Please bisect this using the wireless-testing git source. From what I remember, 
> there are no changes in the rtlwifi/rtl8192c/rtl8192ce that should affect this 
> situation.
Try applying my patch "mac80211: fix truncated packets in cooked monitor
rx" - I had issues with AP mode in ath9k as well and fixed them with
that one.

- Felix
