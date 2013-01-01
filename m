Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46121 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416Ab3AASGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jan 2013 13:06:49 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so7495729pbc.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jan 2013 10:06:48 -0800 (PST)
Message-ID: <50E325B5.205@lwfinger.net> (sfid-20130101_190712_026150_01BC5E21)
Date: Tue, 01 Jan 2013 12:06:45 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Wollrath <jwollrath@web.de>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: WARNING: at net/wireless/mlme.c:517
References: <20130101154507.351dfb03@ilfaris>
In-Reply-To: <20130101154507.351dfb03@ilfaris>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/01/2013 08:45 AM, Julian Wollrath wrote:
> Hello,
>
> while trying to connect to an AP I got the following trace:
> [  436.155474] rtl8192ce 0000:01:00.0 wlan0: disabling HT/VHT due to
> WEP/TKIP use [  436.155492] rtl8192ce 0000:01:00.0 wlan0: disabling HT
> as WMM/QoS is not supported by the AP [  436.155499] rtl8192ce
> 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP

The above are informative, and are letting you know that your AP is not capable 
of supporting the highest throughput.

> [  436.155998] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
> [  436.158343] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411
> status=0 aid=4) [  436.158478] wlan0: associated [  436.158538] IPv6:
> ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready [  446.153705]
> ------------[ cut here ]------------ [  446.153765] WARNING: at
> net/wireless/mlme.c:517 cfg80211_mlme_disassoc+0x17d/0x190 [cfg80211]()

This one indicates that there was a call to disassociate when the device was not 
associated. It might have been informative to have seen the logged messages 
earlier than 436.155474 seconds.

Johannes: Why is this a WARN_ON condition? Certainly, the returned -ENOTCON does 
the right thing, even though some part of the system got confused.

Larry

