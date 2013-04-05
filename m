Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:58505 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab3DEKIX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 06:08:23 -0400
Message-ID: <515EA285.5010004@neratec.com> (sfid-20130405_120828_438576_174FADD0)
Date: Fri, 05 Apr 2013 12:08:05 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1364993200.8351.35.camel@jlt4.sipsolutions.net> <515D8259.1030208@neratec.com> <20130404182219.GA24704@pandem0nium>
In-Reply-To: <20130404182219.GA24704@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/04/2013 08:22 PM, Simon Wunderlich wrote:
> [...]
> 
> So the patch does not resolve the problem for you? I've checked it again with
> a little printk in ath9ks config function.
> 
> With the patch the radar_enabled flag gets disabled when changing the channel (5500 -> 5200).
> If I don't apply the patch, it stays enabled. I did the same thing (start hostapd on
> channel 5500, wait for CAC, echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/simulate_radar).
> 
> Maybe I'm missing something?
> 
Hi Simon,

here is how to reproduce (assuming you are using the patches for DFS testing on
ath9k posted yesterday).

1) enable DFS log output at ath9k
echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/debug

2) run hostapd on DFS channel, my config is as follows
interface=wlan3
driver=nl80211
ssid=testap
hw_mode=a
channel=108
wmm_enabled=1
ieee80211d=1
ieee80211h=1
country_code=DE
wpa_group_rekey=300
wpa_gmk_rekey=640
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
wpa_passphrase=testtest

The log output I see is:
Apr 5 11:44:00: [ 335.210749] IPv6: ADDRCONF(NETDEV_UP): wlan3: link is not ready
Apr 5 11:44:00: [ 335.221152] ath: phy0: DFS enabled at freq 5540
Apr 5 11:44:04: [ 339.234487] ath: phy0: DFS enabled at freq 5540
Apr 5 11:44:04: [ 339.260298] ath: phy0: DFS enabled at freq 5540
Apr 5 11:44:04: [ 339.262750] ath: phy0: DFS enabled at freq 5540
Apr 5 11:44:04: [ 339.262786] IPv6: ADDRCONF(NETDEV_CHANGE): wlan3: link becomes ready

So we passed the (shortened to 4s) CAC and AP is operating.

3) fire radar
echo 1 > /sys/kernel/debug/ieee80211/phy0/ath9k/simulate_radar

I see:
Apr 5 11:44:25: [  360.294667] ath: phy0: DFS enabled at freq 5540
Apr 5 11:44:25: [  360.297217] ath: phy0: DFS enabled at freq 5240


The 'DFS enabled ...' message is print if ath9k_config() is called with
hw->conf.radar_enabled, which should never happen for freq 5240.


I wish I had time to learn using ftrace to track it down... As said before, it is
not critical for ath9k, but might be a hint to something going wrong above.


Thanks,
Zefir

