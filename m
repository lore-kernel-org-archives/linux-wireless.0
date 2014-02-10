Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38339 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaBJGs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 01:48:58 -0500
Message-ID: <52F87608.808@candelatech.com> (sfid-20140210_074928_265299_B686B50A)
Date: Sun, 09 Feb 2014 22:47:36 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Zhao Hongjiang <zhaohongjiang@huawei.com>,
	johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org, zhousiyi@huawei.com
Subject: Re: Get multiple ip addresses by dhcp for wireless card
References: <52F84DFD.4030602@huawei.com>
In-Reply-To: <52F84DFD.4030602@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2014 07:56 PM, Zhao Hongjiang wrote:
> Hello,
>
> Is it possible for one station to get multiple ip addresses from AP/Wireless
> router by dhcp? I had tried to add one or more virtual interface for
> phy0 (wlan0, wlan1, wlan2,etc), but only wlan0 can get ip address from AP.
> the following is the steps:
>
> /bin/wpa_supplicant -ddd -iwlan0 -Dnl80211 -c/wifi/wpa_supplicant.conf -B
> /bin/wpa_cli -i wlan0 -p /wlan0
>> add_network
>> set_network 0 ssid "APabc"
>> set_network 0 psk "1111111"
>> enable_network 0
>
> iw wlan0 interface add wlan1 type station 4addr on
> ip link set wlan1 up
> dhcpcd -ABKL wlan0 #works, can get ip
> dhcpcd -ABKL wlan1 #cannot work

Virtual stations work just fine for me, though I don't use that '4addr' thing.
...maybe sniff your wlan1 and see if it is sending
out proper DHCP requests (and they are being received by the AP)?

You have to create a new supplicant config for each virtual station,
or run a unique supplicant instance for each station.

To do any useful traffic, between stations, you will have to be careful
about setting up routing rules and use special binding commands for your
traffic types.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

