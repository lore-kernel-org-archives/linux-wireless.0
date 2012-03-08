Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64562 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CHCo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 21:44:58 -0500
Received: by dajr28 with SMTP id r28so25127daj.19
        for <linux-wireless@vger.kernel.org>; Wed, 07 Mar 2012 18:44:57 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 8 Mar 2012 10:44:57 +0800
Message-ID: <CAFCUKTSFuOzywY3F8TLUx67P776T_jhjhUEMb3MQ679yeyTnJw@mail.gmail.com> (sfid-20120308_034501_399781_1FADFBDA)
Subject: [PROBLEM] linux-3.2.7:mwifiex:when associating with ap ,there are
 some strange warning output and after associated, executing "iwconfig" hangs up.
From: harvey yang <harvey.huawei.yang@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all
I compiled linux-3.2.7 with mwifiex as a module. When associating with
ap, the process is slow with some strange output . Afte that
"iwconfig" hangs up with no return .The fowllowing is my operation and
console ouput.

[root@FriendlyARM /home]# wpa_supplicant -B -Dwext -imlan0 -c ./wpa_supplicant_W
PAPSKCCMP.conf
mwifiex_sdio mmc1:0001:1: assoc: requested bss not found in scan results
ioctl[SIOCSIWESSID]: Bad address
[root@FriendlyARM /home]# mwifiex_sdio mmc1:0001:1: assoc: requested bss not fos
cfg80211: Calling CRDA to update world regulatory domain

[root@FriendlyARM /home]# iwconfig
mwifiex_sdio mmc1:0001:1: mwifiex_cmd_timeout_func: Timeout cmd id (995.180008)0
mwifiex_sdio mmc1:0001:1: num_data_h2c_failure = 0
mwifiex_sdio mmc1:0001:1: num_cmd_h2c_failure = 0
mwifiex_sdio mmc1:0001:1: num_cmd_timeout = 1
mwifiex_sdio mmc1:0001:1: num_tx_timeout = 0
mwifiex_sdio mmc1:0001:1: last_cmd_index = 1
mwifiex_sdio mmc1:0001:1: last_cmd_resp_index = 0
mwifiex_sdio mmc1:0001:1: last_event_index = 4
mwifiex_sdio mmc1:0001:1: data_sent=0 cmd_sent=0
mwifiex_sdio mmc1:0001:1: ps_mode=1 ps_state=0

This is my wpa_supplicant_WPAPSKCCMP.conf.
ctrl_interface=/var/run/wpa_supplicant

network={
    ssid="sherry"
    key_mgmt=WPA-PSK
    proto=WPA2
    pairwise=CCMP
    group=CCMP
    psk="010203040506"
}

What is the problem? any help will be appreciated.

Best Regards

harvey
