Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:36263 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752194AbcKPAL2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 19:11:28 -0500
Received: by mail-it0-f51.google.com with SMTP id l8so35898877iti.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 16:11:28 -0800 (PST)
MIME-Version: 1.0
From: Matthew Stanger <matthew_stanger@trimble.com>
Date: Tue, 15 Nov 2016 17:11:27 -0700
Message-ID: <CANr77M17c7CtA_bzzVzPDHwsFU4+qmJtsci6jBLozNp9gcEyEA@mail.gmail.com> (sfid-20161116_011132_538208_35780A91)
Subject: crda not triggering kernel udev event
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm trying to troubleshoot not being able to set the Regulator Domain
on a custom Yocto 3.14 kernel with a Marvell 88W8887/at91_mci driver
on ARM. Running 'udevadm monitor --environment kernel'  there are no
kernel udev events being triggered. I've checked the following common
items, crda is installed in '/usr/sbin' (version 3.18), wireless-regdb
is installed at '/usr/lib/crda/regulatory.bin',
'/etc/modeprobe.d/cfg80211.conf' has 'options cfg80211
ieee80211_regdom=US' & I have udev rules pointing to '/usr/sbin/crda'
in both '/etc/udev/rules.d/' & '/lib/udev/rules.d/'. I have
'COUNTRY=US' set and when I run crda I get 'Failed to set regulatory
domain: -7' and with no kernel udev events in the background and no
cfg80211 messages in dmesg. Oddly if I use wpa_supplicant to connect
to an AP and then stop the wpa_sup service then cfg80211 shows up and
kenel udev messages fire and I'm able to set the reg domain via 'iw
reg set'.  Any idea's on what may be going on here or what I could
check would be most appreciated.

Thanks,
Matt
