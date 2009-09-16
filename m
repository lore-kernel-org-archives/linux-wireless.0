Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f180.google.com ([209.85.211.180]:41970 "EHLO
	mail-yw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbZIPHm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 03:42:29 -0400
Received: by ywh10 with SMTP id 10so3256798ywh.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 00:42:33 -0700 (PDT)
From: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
To: Christopher <c.krooss@googlemail.com>
Subject: Re: [ath9k-devel] Disconnect problem (DMA failed to stop in 10 ms)
Date: Wed, 16 Sep 2009 13:05:32 +0530
References: <1253068000.2813.11.camel@localhost.localdomain>
In-Reply-To: <1253068000.2813.11.camel@localhost.localdomain>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <200909161305.33063.kunal.gangakhedkar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 Sep 2009 7:56:40 am you wrote:
> Hi Kunal,
> I read your mails on ath9k-devel, have you tried using an ath9k build
> from September recently?
>
> http://wireless.kernel.org/download/compat-wireless-2.6/compat-wireless-2.6
>.tar.bz2
>
> My Asus is using an AR9285,too, and my wifi was dropping every 1-30
> minutes on 2.6.30 and 2.6.31, but now using the ath9k build 09-15-2009,
> my signal is gone up from <50% to ~90% and the connection is rock-stable
> =)
> Maybe give it a try, hope this issue is still current for you
>
> regards
> chris

Hi Chris,

I tested today's compat-wireless - compat-wireless-2009-09-16.
Unfortunately, I still seem to have problems with the ath9k driver.

While pinging my wireless router - which is just next to where I'm sitting - I 
consistently have 2 packets dropped after every 3 packets.

The details of compat-wireless tree:

kunal@plutonium:~/work/my_work/compat-wireless-2009-09-16$ cat git-describe
wireless-testing.git
v2.6.31-38254-g2953d61

kunal@plutonium:~/work/my_work/compat-wireless-2009-09-16$ cat compat-release
master-2009-09-04-1-g10f3185

kunal@plutonium:~/work/my_work/compat-wireless-2009-09-16$ cat master-tag
master-2009-09-14

modinfo ath9k output for the compat-wireless driver (indicated by updates/ in 
the path):
kunal@plutonium:~/work/my_work/compat-wireless-2009-09-16$ modinfo ath9k
filename:       /lib/modules/2.6.31-10-
generic/updates/drivers/net/wireless/ath/ath9k/ath9k.ko
license:        Dual BSD/GPL
description:    Support for Atheros 802.11n wireless LAN cards.
author:         Atheros Communications
srcversion:     7524C955935F75022BC1C31
alias:          pci:v0000168Cd0000002Esv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Dsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Bsv*sd*bc*sc*i*
alias:          pci:v0000168Cd0000002Asv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000029sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000027sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000024sv*sd*bc*sc*i*
alias:          pci:v0000168Cd00000023sv*sd*bc*sc*i*
depends:        mac80211,led-class,ath,cfg80211
vermagic:       2.6.31-10-generic SMP mod_unload modversions
parm:           debug:uint
parm:           nohwcrypt:Disable hardware encryption (int)


ping output to my router:
kunal@plutonium:~/work/my_work/compat-wireless-2009-09-16$ ping openwrt
PING openwrt.lan (192.168.10.1) 56(84) bytes of data.
64 bytes from openwrt (192.168.10.1): icmp_seq=1 ttl=64 time=2.54 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=5 ttl=64 time=1182 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=6 ttl=64 time=177 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=9 ttl=64 time=3.32 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=10 ttl=64 time=3.62 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=11 ttl=64 time=3.58 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=14 ttl=64 time=3.97 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=15 ttl=64 time=5.26 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=16 ttl=64 time=7.54 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=19 ttl=64 time=4.57 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=20 ttl=64 time=2.49 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=21 ttl=64 time=2.73 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=24 ttl=64 time=3.40 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=26 ttl=64 time=3.40 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=29 ttl=64 time=2.02 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=30 ttl=64 time=3.08 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=31 ttl=64 time=2.32 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=34 ttl=64 time=2.94 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=35 ttl=64 time=3.54 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=36 ttl=64 time=3.97 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=39 ttl=64 time=3.55 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=40 ttl=64 time=3.07 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=41 ttl=64 time=3.37 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=44 ttl=64 time=2028 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=45 ttl=64 time=1020 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=46 ttl=64 time=10.6 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=49 ttl=64 time=3.51 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=50 ttl=64 time=3.61 ms
64 bytes from openwrt (192.168.10.1): icmp_seq=51 ttl=64 time=2.94 ms
^C
--- openwrt.lan ping statistics ---
53 packets transmitted, 29 received, 45% packet loss, time 52212ms
rtt min/avg/max/mdev = 2.022/155.337/2028.724/450.597 ms, pipe 3

As can be seen from the icmp_seq nos., most of the times, I get 2 packets 
dropped after every 3 packets.

And I'm running this entire exercise sitting right next to the router - which 
is a Linksys WRT54GL running OpenWRT Kamikaze (8.09) release.

The rest of the setup on the laptop is plain standard Kubuntu setup - no 
modifications done to any other file.

I'm including both ath9k-devel and linux-wireless mailing lists in Cc: - 
maybe, someone from there might have a clue about what's going on.

Kunal
