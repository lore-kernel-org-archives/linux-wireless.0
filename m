Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.3eti.com ([65.220.88.139]:42633 "EHLO 3eSpam.3eti.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750948Ab1BNUdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 15:33:54 -0500
Received: from webmail.3eti.com (rockmx01.rock.corp [192.168.200.4]) by 3eSpam.3eti.com with ESMTP id LfrqG6QFG06A8sHf (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 15:33:52 -0500 (EST)
From: Chaoxing Lin <CLin@3eti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wpa_supplicant wrong behavior
Date: Mon, 14 Feb 2011 20:33:51 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D0571E695@RockMX01.rock.corp>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Linux wireless experts,

When testing hostapd MAC address filtering, I see a problem on wpa_supplicant. I am hoping that maintainer can put a quick fix for this.

Thanks

Symptom:

wpa_supplicant does not check other available APs when its association to first AP is denied by MAC address filtering.
Also exact same problems happens to wpa_supplicant when client reaches "max_num_sta" in hostapd.conf.

Procedures to recreate the problem.

1. AP-1 and AP-2 are configured with exactly same SSID, security, etc. The only difference is the AP-1 has MAC address filtering configured to deny access from client-1.
2. Power on AP-1, configure client-1 to have same SSID, security, etc so that it would be able to connect to AP-1 if there were no MAC filtering against it.
3. Verify that client-1 can't NOT associate to to AP-1. The console message is "SME: Authentication failed (status code 1)"
4. Now, power on AP-2. The intuitive behavior for wpa_supplicant is to associate to AP-2 at some point (certain period of timeout is acceptable).
5. See the problem that client-1 never switch to AP-2. 

Facts: 
1. AP-2 is configured well. If I stop AP-1 and restart wpa_supplicant at Client-1, Client-1 associates to AP-2 successfully. Or if I specify "bssid=AP-2-mac", Client-1 can associate to AP-2. So AP-2 configuration is out of the question.
2. It's not related signal strength, either. The fact is that after AP-2 is powered on, Client-1 won't associate even when AP-1 is powered off.  This eliminates the possibility that WPA_supplicant picks stronger signal to connect.
3. Windows driver of Intel Ultimate 6300N can switch to AP-2 easily without any user intervention.

Version info
1. hostapd 0.8.snapshot
2. wpa_supplicant 0.8.snapshot, tried on both ar9280 and Intel 6300 ultimate N
3. kernel 2.6.38-rc4

