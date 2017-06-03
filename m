Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35864 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751077AbdFCIJ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Jun 2017 04:09:58 -0400
Received: by mail-it0-f52.google.com with SMTP id m47so25757888iti.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jun 2017 01:09:57 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Sat, 3 Jun 2017 16:09:56 +0800
Message-ID: <CABWe71yk2NfAgw21men=uxoUZ5+CcetkKDLP3vE9v_yT=+F_Bw@mail.gmail.com> (sfid-20170603_101000_956291_A29F98BE)
Subject: ath9k wds mode station break off
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wds ap:

        config wifi-device 'radio0'
                option type 'mac80211'
                option hwmode '11g'
                option path 'platform/ar933x_wmac'
                option distance '3000'
                option txpower '18'
                option country '00'
                option channel '1'
                option htmode 'HT40'

        config wifi-iface
                option device 'radio0'
                option network 'lan'
                option mode 'ap'
                option encryption 'psk2'
                option key '12345600'
               option max_inactivity '20'
                option wds '1'
                option ssid 'LK-M2-Jianxi'

wds station:

        config wifi-device 'radio0'
                option type 'mac80211'
                option channel '1'
                option hwmode '11g'
                option path 'platform/ar933x_wmac'
                option htmode 'HT20'
                option distance '3000'
                option txpower '19'
               option country '00'

        config wifi-iface
                option device 'radio0'
                option network 'lan'
                option encryption 'psk2'
                option key '12345600'
                option max_inactivity '20'
                option wds '1'
                option mode 'sta'
                option ssid 'LK-M2-Jianxi'

 When the station break off, ping can not reach ap. wifi still
connect. kernel have no error info. iwinfo signal still change.

ap with the other station still alive.

Use wpa_cli scan command, will awake station, and ping alive.
wifi command also work.

/proc/interrupts ath9k still alive.
