Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:58982 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755342AbaAVO6m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 09:58:42 -0500
Message-ID: <52DFDAE2.8020004@erley.org> (sfid-20140122_155845_765391_0F62BD62)
Date: Wed, 22 Jan 2014 08:51:14 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: zhuyj <zyjzyj2000@gmail.com>, linux-wireless@vger.kernel.org
CC: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
Subject: Re: 802.11a is supported in AP mode or not?
References: <52DF947E.40800@gmail.com>
In-Reply-To: <52DF947E.40800@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/22/2014 03:50 AM, zhuyj wrote:
> Hi, maintainers
>
> I made tests on ubuntu 13.10. I followed these steps.
>  From the following logs, we can see 802.11a is not supported in channel
> list.
> I want to know whether 802.11a supports this or not? Or 802.11a is not
> used in this?
> Chip is 6205. lspci -vvv is as below.
>
> Thanks a lot.
> Zhu Yanjun
>
> 1. installed ubuntu 13.10 client
>
> 2. git clone
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git linux-git
>
> 3. apt-get install kernel-package
>
> 4. make-kpkg --initrd --append-to-version=-test-iwlwifi kernel_image
> kernel-headers
>
> 5. dpkg -i linux-headers-
>    dpkg -i linux-images-
>
> 6.reboot ubuntu 13.10
>
> 7.    $ vi /etc/hostapd.conf
>      interface=wlan0
>      driver=nl80211
>      logger_syslog=-1
>      logger_syslog_level=2
>      logger_stdout=-1
>      logger_stdout_level=2
>      dump_file=/tmp/hostapd.dump
>      ctrl_interface=/var/run/hostapd
>      ctrl_interface_group=0
>      ssid=test
>      country_code=US
>      hw_mode=a
>      channel=2

Channel 2 is in the 2.4ghz band (B/G) not 5ghz (A)

>      beacon_int=100
>      dtim_period=2
>      max_num_sta=255
>      rts_threshold=2347
>      fragm_threshold=2346
>      macaddr_acl=0
>      auth_algs=3
>      ignore_broadcast_ssid=0
>      wmm_enabled=1
>      wmm_ac_bk_cwmin=4
>      wmm_ac_bk_cwmax=10
>      wmm_ac_bk_aifs=7
>      wmm_ac_bk_txop_limit=0
>      wmm_ac_bk_acm=0
>      wmm_ac_be_aifs=3
>      wmm_ac_be_cwmin=4
>      wmm_ac_be_cwmax=10
>      wmm_ac_be_txop_limit=0
>      wmm_ac_be_acm=0
>      wmm_ac_vi_aifs=2
>      wmm_ac_vi_cwmin=3
>      wmm_ac_vi_cwmax=4
>      wmm_ac_vi_txop_limit=94
>      wmm_ac_vi_acm=0
>      wmm_ac_vo_aifs=2
>      wmm_ac_vo_cwmin=2
>      wmm_ac_vo_cwmax=3
>      wmm_ac_vo_txop_limit=47
>      wmm_ac_vo_acm=0
>      eap_server=0
>      wpa=2
>      wpa_passphrase=12345678
>      wpa_key_mgmt=WPA-PSK
>      wpa_pairwise=TKIP CCMP
>      wpa_group_rekey=600
>      wpa_gmk_rekey=86400
>


