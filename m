Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:42059 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152Ab2CVMkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2012 08:40:17 -0400
Message-ID: <4F6B1D8B.8060306@windriver.com> (sfid-20120322_134022_585592_90BB120E)
Date: Thu, 22 Mar 2012 20:39:39 +0800
From: Zhong Hongbo <hongbo.zhong@windriver.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, <wey-yi.w.guy@intel.com>
CC: <linux-wireless@vger.kernel.org>,
	"Cao, Qingtao (Harry)" <Qingtao.Cao@windriver.com>,
	"Gao, Guijin" <Guijin.Gao@windriver.com>,
	"'Cabuk, Yusuf'" <Yusuf.Cabuk@windriver.com>,
	"'Foglia, Michael'" <Michael.Foglia@windriver.com>,
	<johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Re: Dell E6400 + Windows XP can not work on intel N-6205 AP mode
 for compat-wireless-2012-03-18.tar.bz2 package
References: <4F687667.1030605@windriver.com>  <1332247526.3329.17.camel@jlt3.sipsolutions.net>  <4F687D82.2010201@windriver.com>  <4F687F4E.4030203@windriver.com> <1332248855.3329.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332248855.3329.18.camel@jlt3.sipsolutions.net>
Content-Type: multipart/mixed;
	boundary="------------070708080601030100060008"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------070708080601030100060008
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

> Ok. Maybe Windows is using (more agressive) powersaving? Can you enable
> PS debugging in ma80211?
Hi Johannes,

Today, I test Intel Centrino N-6205 Taylor Peak on Linux 2.6.39, It work perfect on Windows XP. 
'PS debugging in ma80211'?, Do you mean that I open the 'CONFIG_MAC80211_DEBUGFS=y' and See the log?
The detail step as following:
 
1. Test enviroment:
Wi-Fi client OS enviroment:

 Dell E6400 desktop + Windows xp, 
 Dell E6400 desktop + Ubuntu 11.10,
 Iphone4 + Apple MAC.

Wi-Fi AP card: Intel Centrino N-6205 Taylor Peak
Wi-Fi AP kernel driver version: Linux 2.6.39, compat-wireless-2012-03-18

2. Test command and step:
> hostapd -B /etc/hostapd.conf
> ifconfig br0 192.168.0.1
> ifconfig wlan0 0.0.0.0
> dhcpd -cf /etc/dhcpd/dhcpd.conf
> echo "1">  /proc/sys/net/ipv4/ip_forward
> iptables -t nat -A POSTROUTING -s 192.168.0.0/16 -o eth0 -j MASQUERADE
> route add default gw 128.224.162.1


3. Test result:
Test 1: mainline Linux 2.6.39, Three Wi-Fi client connect the Wi-Fi AP(Intel Centrino N-6205 Taylor Peak) at the same time. I can see film and do any thing in the internet.
Dell E6400 desktop + Ubuntu 11.10 work perfect
Dell E6400 desktop + Windows xp work perfect
Iphone4S work perfect

Test 2: compat-wireless-2012-03-18 package
 Dell E6400 desktop + Windows xp can not connect to internet. 
 Dell E6400 desktop + Ubuntu 11.10 and Iphone4 + Apple MAC work normal.

4. The hostapd.conf and dhcpd.conf are in the attachment.


Thanks,
hongbo 

>
> johannes
>
>


--------------070708080601030100060008
Content-Type: text/plain; name="hostapd.conf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="hostapd.conf"

IyMjIyMgaG9zdGFwZCBjb25maWd1cmF0aW9uIGZpbGUgIyMjIyMjIyMjIyMjIyMjIyMjIyMj
IyMjIyMjIyMjIyMjIyMjIyMjIyMjIyMjIwppbnRlcmZhY2U9d2xhbjEKZHJpdmVyPW5sODAy
MTEKYnJpZGdlPWJyMApsb2dnZXJfc3lzbG9nPS0xCmxvZ2dlcl9zeXNsb2dfbGV2ZWw9Mgps
b2dnZXJfc3Rkb3V0PS0xCmxvZ2dlcl9zdGRvdXRfbGV2ZWw9MgpkdW1wX2ZpbGU9L3RtcC9o
b3N0YXBkLmR1bXAKY3RybF9pbnRlcmZhY2U9L3Zhci9ydW4vaG9zdGFwZApjdHJsX2ludGVy
ZmFjZV9ncm91cD0wCnNzaWQ9SU5URUxNV0MyMDExCmNvdW50cnlfY29kZT1VUwpod19tb2Rl
PWcKY2hhbm5lbD0xMQpiZWFjb25faW50PTEwMApkdGltX3BlcmlvZD0yCm1heF9udW1fc3Rh
PTI1NQpydHNfdGhyZXNob2xkPTIzNDcKZnJhZ21fdGhyZXNob2xkPTIzNDYKbWFjYWRkcl9h
Y2w9MAphdXRoX2FsZ3M9MwppZ25vcmVfYnJvYWRjYXN0X3NzaWQ9MAp3bW1fZW5hYmxlZD0x
CndtbV9hY19ia19jd21pbj00CndtbV9hY19ia19jd21heD0xMAp3bW1fYWNfYmtfYWlmcz03
CndtbV9hY19ia190eG9wX2xpbWl0PTAKd21tX2FjX2JrX2FjbT0wCndtbV9hY19iZV9haWZz
PTMKd21tX2FjX2JlX2N3bWluPTQKd21tX2FjX2JlX2N3bWF4PTEwCndtbV9hY19iZV90eG9w
X2xpbWl0PTAKd21tX2FjX2JlX2FjbT0wCndtbV9hY192aV9haWZzPTIKd21tX2FjX3ZpX2N3
bWluPTMKd21tX2FjX3ZpX2N3bWF4PTQKd21tX2FjX3ZpX3R4b3BfbGltaXQ9OTQKd21tX2Fj
X3ZpX2FjbT0wCndtbV9hY192b19haWZzPTIKd21tX2FjX3ZvX2N3bWluPTIKd21tX2FjX3Zv
X2N3bWF4PTMKd21tX2FjX3ZvX3R4b3BfbGltaXQ9NDcKd21tX2FjX3ZvX2FjbT0wCmVhcF9z
ZXJ2ZXI9MAp3cGE9Mgp3cGFfcGFzc3BocmFzZT1pbnRlbGZyaQp3cGFfa2V5X21nbXQ9V1BB
LVBTSwp3cGFfcGFpcndpc2U9VEtJUCBDQ01QCndwYV9ncm91cF9yZWtleT02MDAKd3BhX2dt
a19yZWtleT04NjQwMAo=
--------------070708080601030100060008
Content-Type: text/plain; name="dhcpd.conf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dhcpd.conf"

IwojIERIQ1AgU2VydmVyIENvbmZpZ3VyYXRpb24gZmlsZS4KIyAgIHNlZSAvdXNyL3NoYXJl
L2RvYy9kaGNwKi9kaGNwZC5jb25mLnNhbXBsZQojICAgc2VlICdtYW4gNSBkaGNwZC5jb25m
JwojIGdsb2JhbCBvcHRpb25zCmRkbnMtdXBkYXRlLXN0eWxlIG5vbmU7ICAgIyBEeW5hbWlj
IEROUyB1cGRhdGVzIGFyZSB0dXJuZWQgb2ZmCm1heC1sZWFzZS10aW1lIDE3MjgwMDsgICAj
IG1heGltdW0gbGVhc2UgdGltZSAtIDIgZGF5cwpkZWZhdWx0LWxlYXNlLXRpbWUgODY0MDA7
ICAgIyBzZWNvbmRzIHRpbGwgbGVhc2UgZXhwaXJlIC0gMSBkYXkKCnN1Ym5ldCAxOTIuMTY4
LjAuMCBuZXRtYXNrIDI1NS4yNTUuMjU1LjAgewpvcHRpb24gcm91dGVycyAxOTIuMTY4LjAu
MTsgICAjIGRlZmF1bHQgZ2F0ZXdheQpvcHRpb24gZG9tYWluLW5hbWUtc2VydmVycyAxMjgu
MjI0LjE2MC4xMTsgICAjIElQIGFkZHJlc3Mgb2YgdGhlIEROUyBzZXJ2ZXIKb3B0aW9uIHN1
Ym5ldC1tYXNrIDI1NS4yNTUuMjU1LjA7ICAgIyBuZXRtYXNrIGFzc2lnbmVkIHRvIGNsaWVu
dHMKcmFuZ2UgMTkyLjE2OC4wLjUwIDE5Mi4xNjguMC4xNDk7ICAgIyBwb29sIG9mIHRoZSBh
ZGRyZXNzZXMgdG8gbGVhc2UKfQojCgo=
--------------070708080601030100060008--
