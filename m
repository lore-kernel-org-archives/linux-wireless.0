Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:44872 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755977Ab2GaMzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 08:55:14 -0400
Received: by qcro28 with SMTP id o28so3617689qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2012 05:55:13 -0700 (PDT)
MIME-Version: 1.0
From: Pedro Francisco <pedrogfrancisco@gmail.com>
Date: Tue, 31 Jul 2012 13:54:52 +0100
Message-ID: <CAJZjf_wv=+HKLwnH-=rvx9h=0jEGzoCrd-a8GOW-QnXfOVgc_g@mail.gmail.com> (sfid-20120731_145519_552712_8E3F6AA6)
Subject: unloading WiFi modules is usually triggering kernel crash
To: ML linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've noticed in the past few days a pattern: sometimes nm-applet
starts showing empty bars for the signal strength.

Running the script:
sudo ifconfig wlan0 down; sleep 1
sudo rmmod hp_wmi; sudo rmmod iwl3945; sudo rmmod iwlegacy; sudo rmmod
mac80211; sudo rmmod cfg80211
sleep 2; sudo rmmod rfkill; sync
sudo modprobe rfkill; sudo modprobe cfg80211; sudo modprobe mac80211;
sudo modprobe iwlegacy
sudo modprobe iwl3945; sudo modprobe hp_wmi; sleep 1; sudo ifconfig wlan0 up

usually triggers a kernel crash. This has happened twice so far. I
tried it now for the third time but it didn't crash.

Logs (running with slub_debug ):
https://dl.dropbox.com/u/1332655/WiFi-issues/notTainted-cfg80211_mlme_disassoc-WARNING.log
https://dl.dropbox.com/u/1332655/WiFi-issues/alreadyTainted-debug_print_object-WARNING.log
(debug_print_object-WARNING was caused by running the above script
rmmoding things)
https://dl.dropbox.com/u/1332655/WiFi-issues/iw_dev_scan.log
https://dl.dropbox.com/u/1332655/WiFi-issues/gshell-wifiBars_empty.png

Any ideas on what is going on? Looking at other mails around here it
seems not to be driver specific, at least the cfg80211_mlme_disassoc
part.

Thanks in Advance,
-- 
Pedro
