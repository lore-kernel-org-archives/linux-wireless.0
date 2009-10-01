Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:45774 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbZJAKPa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 06:15:30 -0400
Received: by ewy7 with SMTP id 7so7296234ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 03:15:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2d0a357f0910010247jfda1199h5a9b873233b186ca@mail.gmail.com>
References: <2d0a357f0910010247jfda1199h5a9b873233b186ca@mail.gmail.com>
Date: Thu, 1 Oct 2009 12:15:33 +0200
Message-ID: <2d0a357f0910010315r3f3556f7j6a4c19c9ba3480a6@mail.gmail.com>
Subject: Re: Linux-2.6.32-rc1/2] wext refactor needs wpasupplicant 0.7.0+?
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the sake of completeness:
Herre the WEXT config parameters in kernel dot-config:

# grep -i wext /boot/config-$(uname -r)
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211_WEXT=y

- Sedat -

On Thu, Oct 1, 2009 at 11:47 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> a few hours ago I compiled a new kernel from upstream and put
> wireless-testing master-2009-09-30 on top of it.
>
> Last commit a1bec0ecfc76281d5e1ebd33435c67da7dd0fe71
> wext: refactor
>
> linux-2.6/master:
> 84d88d5: Merge branch 'sched-fixes-for-linus' of
> git://git./linux/kernel/git/tip/linux-2.6-tip
>
> After installation of the above described kernel, I could not connect
> to my AP using wext driver and wpasupplicant (0.6.9-3) from Debian/sid
> [1].
> With ath5k I could not establish a network connection neither via DHCP
> nor via static-IP to my AP (iwl3945 on a second machine works with
> self-debianized wpasupplicant 0.7.0+ and static-IP, same kernel).
>
> Just for clarification:
> Does wext refactor need a wpasupplicant >= 0.7.0 from hostap GIT repository [2]?
>
> Below you will find some needful informations of my configuration and system.
>
> Kind Regards,
> - Sedat -
>
> P.S.:
> I can offer a debianized wpasupplicant package for 32bit, if you like.
>
> [1] http://packages.debian.org/sid/wpasupplicant
> [2] http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=summary
>
> ---- NEEDFUL INFORMATIONS ----
>
> # lspci -nnvv | grep -i ath
> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
> 802.11abg NIC [168c:1014] (rev 01)
>        Kernel driver in use: ath5k
>
> # ps axu | grep -v grep | grep wpa
> root      1411  0.0  0.1   4916  1124 ?        Ss   10:59   0:00
> /sbin/wpa_supplicant -B -P /var/run/wpa_supplicant.wlan0.pid -i wlan0
> -D wext -C /var/run/wpa_supplicant
>
> # wpa_cli -iwlan0 status
> bssid=00:04:0e:e4:00:3d
> ssid=$mySSID
> id=0
> pairwise_cipher=CCMP
> group_cipher=CCMP
> key_mgmt=WPA2-PSK
> wpa_state=COMPLETED
> ip_address=$myIPADDR
>
> # cat /proc/version
> Linux version 2.6.32-rc1-iniza-686-kms (Debian 2.6.32~rc1-5)
> (sedat.dilek@gmail.com) (gcc version 4.4.1 (Debian 4.4.1-4) ) #1 SMP
> PREEMPT Thu Oct 1 04:57:49 CEST 2009
>
