Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:35400 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030281Ab2CVMwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 08:52:04 -0400
Message-ID: <4F6B204F.2000303@windriver.com> (sfid-20120322_135216_790415_199D7DFE)
Date: Thu, 22 Mar 2012 20:51:27 +0800
From: Zhong Hongbo <hongbo.zhong@windriver.com>
MIME-Version: 1.0
To: Zhong Hongbo <hongbo.zhong@windriver.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<wey-yi.w.guy@intel.com>, <linux-wireless@vger.kernel.org>,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>,
	"'Foglia, Michael'" <Michael.Foglia@windriver.com>,
	<johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
References: <4F687667.1030605@windriver.com>  <1332247526.3329.17.camel@jlt3.sipsolutions.net>  <4F687D82.2010201@windriver.com>  <4F687F4E.4030203@windriver.com> <1332248855.3329.18.camel@jlt3.sipsolutions.net> <4F6B1D8B.8060306@windriver.com>
In-Reply-To: <4F6B1D8B.8060306@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/22/2012 08:39 PM, Zhong Hongbo wrote:

>> Ok. Maybe Windows is using (more agressive) powersaving? Can you enable
>> PS debugging in ma80211?
> Hi Johannes,
>
> Today, I test Intel Centrino N-6205 Taylor Peak on Linux 2.6.39, It work perfect on Windows XP. 
> 'PS debugging in ma80211'?, Do you mean that I open the 'CONFIG_MAC80211_DEBUGFS=y' and See the log?
> The detail step as following:
>  
> 1. Test enviroment:
> Wi-Fi client OS enviroment:
>
>  Dell E6400 desktop + Windows xp, 
>  Dell E6400 desktop + Ubuntu 11.10,
>  Iphone4 + Apple MAC.
>
> Wi-Fi AP card: Intel Centrino N-6205 Taylor Peak
> Wi-Fi AP kernel driver version: Linux 2.6.39, compat-wireless-2012-03-18
>
> 2. Test command and step:
>> hostapd -B /etc/hostapd.conf
>> ifconfig br0 192.168.0.1
>> ifconfig wlan0 0.0.0.0
>> dhcpd -cf /etc/dhcpd/dhcpd.conf
>> echo "1">  /proc/sys/net/ipv4/ip_forward
>> iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o eth0 -j MASQUERADE
>> route add default gw 128.224.162.1
>
> 3. Test result:
> Test 1: mainline Linux 2.6.39, Three Wi-Fi client connect the Wi-Fi AP(Intel Centrino N-6205 Taylor Peak) at the same time. I can see film and do any thing in the internet.
> Dell E6400 desktop + Ubuntu 11.10 work perfect
> Dell E6400 desktop + Windows xp work perfect
> Iphone4S work perfect
>
> Test 2: compat-wireless-2012-03-18 package
>  Dell E6400 desktop + Windows xp can not connect to internet. 
Dell E6400 + Windows xp can get correct IP and DNS from Wi-Fi AP, But I can not go to internet.

Thanks,
hongbo

>  Dell E6400 desktop + Ubuntu 11.10 and Iphone4 + Apple MAC work normal.
>
> 4. The hostapd.conf and dhcpd.conf are in the attachment.
>
>
> Thanks,
> hongbo 
>
>> johannes
>>
>>

