Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:47152 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaFML0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 07:26:22 -0400
Date: Fri, 13 Jun 2014 12:54:13 +0200
From: Johannes Stezenbach <js@sig21.net>
To: linux-wireless@vger.kernel.org
Cc: ilw@linux.intel.com
Subject: iwlwifi AC 7260 fails to connect
Message-ID: <20140613105412.GA25048@sig21.net> (sfid-20140613_132654_526062_8389CC29)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

a new Thinkpad Yoga 20CD00AMGE with Intel(R) Dual Band Wireless AC 7260
fails to connect to the AP in the office, while it works
on my home AP.  WPA2 is used in both cases.  I tried with
kernel 3.14.7 and 3.15.  There is a high density of APs and
clients and lots of traffic in the office environment.

The failure is caused by:
[   32.200142] iwlwifi 0000:04:00.0: No association and the time event is over already...
and wpa_supplicant retries in an endless loop:

[   28.181020] cfg80211: Calling CRDA to update world regulatory domain
[   31.890168] wlp4s0: authenticate with f8:d1:11:39:1a:8c
[   31.892972] wlp4s0: send auth to f8:d1:11:39:1a:8c (try 1/3)
[   31.903458] wlp4s0: authenticated
[   31.927239] wlp4s0: associate with f8:d1:11:39:1a:8c (try 1/3)
[   31.963374] wlp4s0: RX AssocResp from f8:d1:11:39:1a:8c (capab=0x431 status=0 aid=5)
[   31.968857] wlp4s0: associated
[   32.200142] iwlwifi 0000:04:00.0: No association and the time event is over already...
[   32.200154] wlp4s0: Connection to AP f8:d1:11:39:1a:8c lost
[   32.270241] cfg80211: Calling CRDA to update world regulatory domain
(repeats)

For testing I used a bare Arch Linux installation and ran
wpa_supplicant manually:
  echo 'network={
	ssid="foo"
	psk="bar"
}' >w
  wpa_supplicant -Dnl80211 -iwlp4s0 -cw -d

...
wlp4s0: State: ASSOCIATED -> 4WAY_HANDSHAKE
...
wlp4s0: WPA: Key negotiation completed with f8:d1:11:39:1a:8c [PTK=CCMP GTK=CCMP]
...
wlp4s0: CTRL-EVENT-CONNECTED - Connection to f8:d1:11:39:1a:8c completed [id=0 id_str=]
...
nl80211: Drv Event 20 (NL80211_CMD_DEL_STATION) received for wlp4s0
nl80211: Delete station f8:d1:11:39:1a:8c
nl80211: Drv Event 39 (NL80211_CMD_DEAUTHENTICATE) received for wlp4s0
nl80211: Deauthenticate event
wlp4s0: Event DEAUTH (12) received
wlp4s0: Deauthentication notification
wlp4s0:  * reason 4 (locally generated)
wlp4s0:  * address f8:d1:11:39:1a:8c
Deauthentication frame IE(s) - hexdump(len=0): [NULL]
wlp4s0: CTRL-EVENT-DISCONNECTED bssid=f8:d1:11:39:1a:8c reason=4 locally_generated=1
wlp4s0: Auto connect enabled: try to reconnect (wps=0 wpa_state=9)


Not really knowing what I'm doing I simply tried to comment out
the check causing the disconnect:

drivers/net/wireless/iwlwifi/mvm/time-event.c:iwl_mvm_te_handle_notif()

                iwl_mvm_te_check_disconnect(mvm, te_data->vif,
                        "No association and the time event is over already...");

And lo and behold, it can connect.

Let me know if you need more information to produce a proper fix.


TIA,
Johannes
