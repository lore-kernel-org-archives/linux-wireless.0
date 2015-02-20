Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33146 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbbBTSrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 13:47:08 -0500
Received: by mail-wg0-f44.google.com with SMTP id k14so14872541wgh.3
        for <linux-wireless@vger.kernel.org>; Fri, 20 Feb 2015 10:47:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALA4C6UWNY3cMe6BskMNOOK4BZV40hNpnpocTKkRNSvOqHbfOA@mail.gmail.com>
References: <1424443813-13634-1-git-send-email-ap420073@gmail.com>
	<loom.20150220T175341-637@post.gmane.org>
	<CAMArcTXL7Ydka54p6HvRvP=LvFo+w56YnMMrSuUo+PnAsy1TbQ@mail.gmail.com>
	<CALA4C6UWNY3cMe6BskMNOOK4BZV40hNpnpocTKkRNSvOqHbfOA@mail.gmail.com>
Date: Sat, 21 Feb 2015 03:47:05 +0900
Message-ID: <CAMArcTVU0KawzTCtX-QK2=z-tw=Te_jLpWErdOkQ4eg89WM5ig@mail.gmail.com> (sfid-20150220_194712_121548_6DD1F62C)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix some beacon issue
From: "ap420073 ." <ap420073@gmail.com>
To: Mike Turner <miketurner.forum@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hostapd 2.3 has no problem but i found problem that hostapd is not
starting in hostapd 1.0.

would you like to try testing hostapd 2.3?

2015-02-21 2:24 GMT+09:00 Mike Turner <miketurner.forum@gmail.com>:
> On Fri, Feb 20, 2015 at 5:16 PM, ap420073 . <ap420073@gmail.com> wrote:
>> can you tell me hostapd options and detailed situation?
>> 2015-02-21 1:58 GMT+09:00 Mike Turner : > Taehee Yoo writes: > >> >>
>> Sometimes rtl8192cu is not sending beacon frame. >> This patch fix this
>> issue. >> >> Signed-off-by: Taehee Yoo > > > > Tried this and it doesn't
>> help. Beacon transmission still isn't > consistent. Can hostapd have an
>> effect on this? > > > -- > To unsubscribe from this list: send the line
>> "unsubscribe linux-wireless" in > the body of a message to
>> majordomo@vger.kernel.org > More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>
> hostapd.conf file here
>
> interface=wlan0
> driver=nl80211
> channel=3
> hw_mode=g
> preamble=1
> dtim_period=2
> beacon_int=100
> logger_syslog=-1
> logger_syslog_level=0
> logger_stdout=-1
> logger_stdout_level=0
> dump_file=/tmp/hostapd.dump
> ctrl_interface=/var/run/hostapd
> ctrl_interface_group=0
> supported_rates=60 90 120 180 240 360 480 540
> basic_rates=60 90 120 180 240
> ssid=SSID_SETUP3
> max_num_sta=5
> macaddr_acl=0
> auth_algs=3
> ieee80211d=0
> uapsd_advertisement_enabled=1
> wep_rekey_period=0
> own_ip_addr=127.0.0.1
> wpa_group_rekey=0
> wpa_strict_rekey=0
> wpa_gmk_rekey=0
> wpa_ptk_rekey=0
> #ap_table_max_size=255
> #ap_table_expiration_time=60
> eap_server=1
> disassoc_low_ack=1
> ap_max_inactivity=4294967295
>
> #WPA settings
> #WPA algorithm used (WPA2 in this case)
> wpa=2
> #AP password
> wpa_passphrase=Ssid_WIT
> #WPA key mangement type
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=TKIP
> #encription algorithm
> rsn_pairwise=CCMP
>
> Hostapd version 1.0
>
> Atmel ARM at91sam9g25 CPU on custom designed hardware using D-link
> DWA-121 USB WiFi adaptor.
>
> Test using '/etc/init.d/hostapd stop' and '/etc/init.d/hostapd start'
> repeatedly.
> Can get multiple working cycles before a failure, and can get multiple
> failed cycles before correct transmission.
