Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38993 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab1HIF33 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 01:29:29 -0400
Received: by wwf5 with SMTP id 5so2275198wwf.1
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2011 22:29:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
References: <CAH-LUqry4TKAvnojAo39QfT-Wy_BN94SYJEiCCRX4hrb=RcfwQ@mail.gmail.com>
Date: Tue, 9 Aug 2011 10:59:27 +0530
Message-ID: <CAD2nsn3kmo5rau17oRA83pBJRjw9cmsTQeONV5wAu9xck9xXRA@mail.gmail.com> (sfid-20110809_072932_474388_029EF3C8)
Subject: Re: AR9285 Wireless 80211n mode get only 25Mbit with Linux 2.6.38.8
 and compat-wireless-2.6.38.2-2
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Dane Shih <daneshih1981@gmail.com>
Cc: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 9, 2011 at 8:30 AM, Dane Shih <daneshih1981@gmail.com> wrote:
> hi all
>
> i try to setup AR9285 Wireless  ap mode on fedora 12
>
> but it seem not stable when setup Master mode use hostapd
> so ...i upgrade kernel to  2.6.38.8
> it's better, no more disconnect

please try to with the latest stable compat-wirelesss
http://linuxwireless.org/en/users/Download/stable/#compat-wireless_3.0_stable_releases
also the development version of hostapd
git://w1.fi/srv/git/hostap.git

>
> but ap mode in 80211n
>
> hostapd.conf
>
> nterface=wlan0
> driver=nl80211
> ssid=test
> hw_mode=g
> wme_enabled=1
> ieee80211n=1
> ht_capab=HT40+
> channel=7
> auth_algs=3
> ignore_broadcast_ssid=0
>
> throughput only 20Mbits

also please try to add more ht_capab like shortGI, STBC etc, please
use channel 1 for HT40+

>
> install compat-wireless-2.6.38.2-2 on linux
>
> /etc/modprobe.d/ath9.conf
> options ath9k nohwcrypt=1
> modprobe -v ath9k
> insmod /lib/modules/2.6.38.8/updates/net/wireless/cfg80211.ko
> insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath.ko
> insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath9k/ath9k_hw.ko
> insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath9k/ath9k_common.ko
> insmod /lib/modules/2.6.38.8/updates/net/mac80211/mac80211.ko
> insmod /lib/modules/2.6.38.8/updates/drivers/net/wireless/ath/ath9k/ath9k.ko
> nohwcrypt=1


I don't know why we should do this, its better to use default hardware
encryption, does it cause any issues.

>
> i get maxinum speed is 25Mbit
> my pc mac acccess another AP maxinum 50Mbit
>
> setup AR9285 Wireless calint maxinum 30Mbit
> AR9285 spec is 150Mbits
>
> thanks for any advice
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
shafi
