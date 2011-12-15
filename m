Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:44133 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1LOJGz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 04:06:55 -0500
Received: by vcbfk14 with SMTP id fk14so1327720vcb.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 01:06:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn0Zqw0zdEUrMCnBKKLsZEBw_qqT5MO=7dHCwj8Hd6WpqQ@mail.gmail.com>
References: <CAKeTQ4aVzp3GTmzR0zv1j5fWyCUrQLUk9EHHBvZFpDYiQSC1=g@mail.gmail.com>
	<CAD2nsn0jgoUDf02UrajQyOKZiETMEbP6ikBAtBNdmcgT6m34yw@mail.gmail.com>
	<CAKeTQ4adxsEiEzL1DXUvKCF6odfZkQTFhVFJC4AFwBshU-YHFw@mail.gmail.com>
	<CAD2nsn0Zqw0zdEUrMCnBKKLsZEBw_qqT5MO=7dHCwj8Hd6WpqQ@mail.gmail.com>
Date: Thu, 15 Dec 2011 14:36:54 +0530
Message-ID: <CAD2nsn2fSehL_3ntoQDN0qzfSycx_hLP7R2Nn2V+iaubc5RX4A@mail.gmail.com> (sfid-20111215_100701_688309_B1BA1195)
Subject: Re: wierless hardware using ath9k driver on AP mode leads to kernel panic
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Ashwin Mendonca <ashwinloyal@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 1:24 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Thu, Dec 15, 2011 at 12:55 PM, Ashwin Mendonca <ashwinloyal@gmail.com> wrote:
>> I tried the bleeding edge build of compat-wireless
>> (compat-wireless-2011-12-14 build) on Linux-3.1.5. It still leads to kernel
>> panic. I manually got the AP up with these steps:
>>
>> 1. Removed ip from eth0
>> 2. Created a bridge with brctl
>> 3. Added eth0 to br0
>> 4. Ran hostapd with my con file. And it showed this error:
>>     l2_packet_receive - recvfrom: Network is down
>> 5. Tried to connect my client devices. None were getting authenticated.
>> 6. I assigned an ip to br0. Client got authenticated. System on AP mode
>> froze.
>>
>> My hostapd.conf:
>>
>> ################################################
>> interface=wlan0
>> bridge=br0
>> driver=nl80211
>> logger_syslog=-1
>> logger_syslog_level=2
>> logger_stdout=-1
>> logger_stdout_level=2
>> dump_file=/tmp/hostapd.dump
>> ctrl_interface=/var/run/hostapd
>> ctrl_interface_group=0
>> ssid=test
>> hw_mode=g
>> channel=1
>> beacon_int=100
>> dtim_period=2
>> max_num_sta=255
>> rts_threshold=2347
>> fragm_threshold=2346
>> macaddr_acl=0
>> auth_algs=1
>> ignore_broadcast_ssid=0
>> wmm_enabled=1
>> wmm_ac_bk_cwmin=4
>> wmm_ac_bk_cwmax=10
>> wmm_ac_bk_aifs=7
>> wmm_ac_bk_txop_limit=0
>> wmm_ac_bk_acm=0
>> wmm_ac_be_aifs=3
>> wmm_ac_be_cwmin=4
>> wmm_ac_be_cwmax=10
>> wmm_ac_be_txop_limit=0
>> wmm_ac_be_acm=0
>> wmm_ac_vi_aifs=2
>> wmm_ac_vi_cwmin=3
>> wmm_ac_vi_cwmax=4
>> wmm_ac_vi_txop_limit=94
>> wmm_ac_vi_acm=0
>> wmm_ac_vo_aifs=2
>> wmm_ac_vo_cwmin=2
>> wmm_ac_vo_cwmax=3
>> wmm_ac_vo_txop_limit=47
>> wmm_ac_vo_acm=0
>> eapol_key_index_workaround=0
>> eap_server=0
>> own_ip_addr=127.0.0.1
>> wpa=3
>> wpa_passphrase=ashwinalwyn
>> wpa_key_mgmt=WPA-PSK
>> wpa_pairwise=TKIP
>> rsn_pairwise=CCMP
>>
> with this config file i had a freeze!  with 3.2.rc1 compat
> wireless.let me analyze with latest build

i also got the stack trace, and it seems to be a same issue we had for
STA. we are doing aggregation related stuff while the aggregation
itself is disabled. i will soon send a fix by today.

-- 
shafi
