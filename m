Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:35866 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753696AbcHXUSD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Aug 2016 16:18:03 -0400
Received: by mail-pf0-f175.google.com with SMTP id h186so9967844pfg.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Aug 2016 13:18:01 -0700 (PDT)
Subject: REGRESSION: wt-2016-08-22: only one interface is shown by 'iw dev'
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20160808130419.GA4493@localhost>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <495066e5-f7b5-ab19-5eec-09fe46733f57@broadcom.com> (sfid-20160824_221808_244874_E1285A73)
Date: Wed, 24 Aug 2016 22:17:53 +0200
MIME-Version: 1.0
In-Reply-To: <20160808130419.GA4493@localhost>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I rebased to tag wt-2016-08-22 today and loaded the modules. In my test
laptop I have three wireless devices. One PCIe device using brcmsmac
driver, ie. mac80211-based driver, and one PCIe and one SDIO device
using brcmfmac driver, ie. cfg80211-based driver.

So first thing I did was:

$ iw dev
phy#0
	Interface wlan4
		ifindex 5
		wdev 0x1
		addr 00:90:4c:70:43:35
		type managed
		channel 1 (2412 MHz), width: 20 MHz, center1: 2412 MHz

That got me spooked so checking dmesg:

[  558.943663] brcmfmac mmc0:0001:1 wlan4: renamed from wlan0
[  559.011220] brcmfmac 0000:02:00.0 wlan3: renamed from wlan0
[  597.618650] bcma: bus0: Found chip with id 43224, rev 0x01 and
package 0x0A
[  622.205143] brcmsmac bcma0:1 wlan1: renamed from wlan0

so ran iw again with debugging:

$ iw --version
iw version 4.3-16-g96fa73c-dirty
$ iw --debug dev
-- Debug: Sent Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 20
    .nlmsg_type = 27 <0x1b>
    .nlmsg_flags = 773 <REQUEST,ACK,ROOT,MATCH>
    .nlmsg_seq = 1472068432
    .nlmsg_pid = 3028
  [PAYLOAD] 4 octets
    05 00 00 00                                           ....
---------------------------  END NETLINK MESSAGE
---------------------------
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 120
    .nlmsg_type = 27 <0x1b>
    .nlmsg_flags = 2 <MULTI>
    .nlmsg_seq = 1472068432
    .nlmsg_pid = 3028
  [PAYLOAD] 104 octets
    07 01 00 00 08 00 03 00 05 00 00 00 0a 00 04 00 77 6c ................wl
    61 6e 34 00 00 00 08 00 01 00 00 00 00 00 08 00 05 00 an4...............
    02 00 00 00 0c 00 99 00 01 00 00 00 00 00 00 00 0a 00 ..................
    06 00 00 90 4c 70 43 35 00 00 08 00 2e 00 0d 00 00 00 ....LpC5..........
    08 00 26 00 6c 09 00 00 08 00 27 00 01 00 00 00 08 00 ..&.l.....'.......
    9f 00 01 00 00 00 08 00 a0 00 6c 09 00 00             ..........l...
---------------------------  END NETLINK MESSAGE
---------------------------
phy#0
	Interface wlan4
		ifindex 5
		wdev 0x1
		addr 00:90:4c:70:43:35
		type managed
		channel 1 (2412 MHz), width: 20 MHz, center1: 2412 MHz
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE
---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 20
    .nlmsg_type = 3 <DONE>
    .nlmsg_flags = 2 <MULTI>
    .nlmsg_seq = 1472068432
    .nlmsg_pid = 3028
  [PAYLOAD] 4 octets
    00 00 00 00                                           ....
---------------------------  END NETLINK MESSAGE
---------------------------

So nl80211 really reports just one interface. So I decided to revert
commit 2d75da13fbb9 ("nl80211: Allow GET_INTERFACE dumps to be
filtered") and I got my 3 interfaces listed again. So it seems that the
behavior changed for my iw version and I guess it needs to be fixed.

Regards,
Arend
