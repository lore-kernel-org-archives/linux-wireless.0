Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36250 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbcHHQ6c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2016 12:58:32 -0400
Received: by mail-qk0-f182.google.com with SMTP id v123so195445185qkh.3
        for <linux-wireless@vger.kernel.org>; Mon, 08 Aug 2016 09:58:31 -0700 (PDT)
Received: from localhost ([147.75.206.137])
        by smtp.gmail.com with ESMTPSA id n128sm17964695qkc.36.2016.08.08.09.58.29
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Aug 2016 09:58:29 -0700 (PDT)
Date: Mon, 8 Aug 2016 12:58:29 -0400
From: Kevin O'Connor <kevin@koconnor.net>
To: linux-wireless@vger.kernel.org
Subject: mac80211: AP changed bandwidth in a way we can't support - disconnect
Message-ID: <20160808165829.GA10471@morn.lan> (sfid-20160808_185835_821957_02665A6D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am getting periodic wifi disconnects.  The logs show the following
messages when I receive the disconnect:

Sun Aug  7 16:12:59 2016 kern.info kernel: [321982.209148] wlan0: AP ... changed bandwidth, new config is 5500 MHz, width 1 (5500/0 MHz)
Sun Aug  7 16:12:59 2016 kern.info kernel: [321982.218868] wlan0: AP ... changed bandwidth in a way we can't support - disconnect

After the above messages, the connection immediately reconnects.  It
will typically stay up for a few hours and then go through the cycle
again.

The client (which I control) is a tp-link archer c7 router running
openwrt (ath10k, QCA9880-BR4A, linux v4.1.23, mac80211.ko from
compat-wireless-2016-01-10).  The AP (which I do not have admin access
to) appears to be a "Ruckus Wireless ZoneFlex 802.11ac wave 2 4x4
access point"

To try and debug this, I altered the mac80211 code to display some
additional debugging data and to not force a disconnect (see debugging
patch below).  With the altered code the client now stays connected.
I occasionally see periodic debugging messages like the following:

Sun Aug  7 17:52:54 2016 kern.info kernel: [327977.219622] wlan0: AP ... changed bandwidth, orig new config is 5500 MHz, width 3 (5530/0 MHz) 0
Sun Aug  7 17:53:02 2016 kern.info kernel: [327985.206823] wlan0: AP ... changed bandwidth, orig new config is 5500 MHz, width 3 (5530/0 MHz) 0

And then every few hours I'll get:

Sun Aug  7 18:13:04 2016 kern.info kernel: [329187.076091] wlan0: AP ... changed bandwidth, orig new config is 5500 MHz, width 1 (5500/0 MHz) 1024
Sun Aug  7 18:13:04 2016 kern.info kernel: [329187.086633] wlan0: AP ... changed bandwidth, new config is 5500 MHz, width 1 (5500/0 MHz)
Sun Aug  7 18:13:04 2016 kern.info kernel: [329187.096362] wlan0: AP ... changed bandwidth in a way we can't support 1024 132 1 - ignore
Sun Aug  7 18:13:04 2016 kern.info kernel: [329187.383324] wlan0: AP ... changed bandwidth, orig new config is 5500 MHz, width 3 (5530/0 MHz) 0

The above message sequence would have forced a disconnect in the past.
The "width 3" message always immediately follows the "width 1"
messages.

If I'm interpreting the sequence correctly, the AP and client
initially negotiate an 80mhz connection and then at some point the AP
requests a 20mhz connection that is immediately followed by an 80mhz
request.

What is the best way to proceed with this error?  I no longer have the
disconnect issue with the debugging patch (which ignores the
unsupported request instead of disconnecting), but it would be good to
get a real fix upstream.

Thanks.  I'm not subscribed to the linux-wireless mailing list, so
please CC me on replies.
-Kevin


Debugging patch:

--- mlme.c~     2016-06-30 14:51:00.999254180 -0400
+++ mlme.c      2016-08-03 18:31:08.938869667 -0400
@@ -345,6 +345,10 @@
                                             ht_cap, ht_oper, vht_oper,
                                             &chandef, true);
 
+       sdata_info(sdata,
+                  "AP %pM changed bandwidth, orig new config is %d MHz, width %d (%d/%d MHz) %d\n",
+                  ifmgd->bssid, chandef.chan->center_freq, chandef.width,
+                  chandef.center_freq1, chandef.center_freq2, flags);
        /*
         * Downgrade the new channel if we associated with restricted
         * capabilities. For example, if we associated as a 20 MHz STA
@@ -377,9 +381,9 @@
                                      IEEE80211_STA_DISABLE_160MHZ)) ||
            !cfg80211_chandef_valid(&chandef)) {
                sdata_info(sdata,
-                          "AP %pM changed bandwidth in a way we can't support - disconnect\n",
-                          ifmgd->bssid);
-               return -EINVAL;
+                          "AP %pM changed bandwidth in a way we can't support %d %d %d - ignore\n",
+                          ifmgd->bssid, flags, ifmgd->flags, cfg80211_chandef_valid(&chandef));
+               return 0;
        }
 
        switch (chandef.width) {
