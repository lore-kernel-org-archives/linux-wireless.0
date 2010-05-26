Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52031 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0EZFFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 01:05:51 -0400
Received: by pwi2 with SMTP id 2so1407767pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 May 2010 22:05:50 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 25 May 2010 22:05:50 -0700
Message-ID: <AANLkTikgoF1iaw8asRrnC1M7ezy9RBqvFBREqAb_B7Fu@mail.gmail.com>
Subject: AR9220 + compat-wireless 2010-05-25 + HT40 == death
From: Jeffrey Baker <jwbaker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On my AP I installed compat-wireless 2010-05-25, where I already had
hostapd 0.6.10 and kernel 2.6.30, with an AR9220 radio card.  I was
using this config (irrelevant bits elided):

driver=nl80211
country_code=US
hw_mode=g
channel=11
beacon_int=100
dtim_period=2
max_num_sta=255
rts_threshold=2347
fragm_threshold=2346
ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40]

After connecting with an Intel 6300 mobile station, I could pass
packets for perhaps one minute before the connection would stop
working.  I never did get disassociation on the mobile station, and
there was nothing odd in the hostapd logs.  It just stopped working.
An iperf run would kill it off immediately.  On the mobile station, iw
dev wlan0 link indicated rates as high as 300mbps before it stopped
working.

Removing these two lines from my config make it work reliably:

ieee80211n=1
ht_capab=[HT40-][SHORT-GI-40]

In other words, disabling 802.11n makes it work OK.  Unfortunately
with 11n disabled I get only about 8mbps from station to station,
which is pathetic.

Would be happy to send any logs needed to debug this.  I don't see
anything in hostapd's output nor in dmesg that indicates any kind of
error.

-jwb
