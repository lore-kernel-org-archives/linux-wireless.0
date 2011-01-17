Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab1AQUVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jan 2011 15:21:51 -0500
Received: by wwa36 with SMTP id 36so5692566wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jan 2011 12:21:50 -0800 (PST)
Message-ID: <4D34A421.3070804@lwfinger.net>
Date: Mon, 17 Jan 2011 14:18:41 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Logs spammed by associate / authenticate / CRDA calls
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have just gotten the mac80211 code for the RTL8192CU devices for integration
into wireless-testing and then to mainline. All seems to be working, but I get a
lot of disassociation./reassociation messages followed by a call to CRDA. The
output from an 'iw event -t -f' command is the following:

1295294459.884470: wlan22 (phy #4): connected to c0:3f:0e:be:2b:45
1295294530.254474: wlan22 (phy #4): unknown event 64
1295294537.006563: wlan22 (phy #4): scan started
1295294538.642236: wlan22 (phy #4): scan finished: 2412 2417 2422 2427 2432 2437
2442 2447 2452 2457 2462 2467 2472, ""
1295294538.738591: wlan22 (phy #4): deauth 00:1f:1f:c8:8e:cb ->
c0:3f:0e:be:2b:45 reason 4: Disassociated due to inactivity [frame: c0 00 00 00
c0 3f 0e be 2b 45 00 1f 1f c8 8e cb c0 3f 0e be 2b 45 00 00 04 00]
1295294538.738858: wlan22 (phy #4): disconnected (local request)
1295294538.779587: phy #0: regulatory domain change: set to world roaming by the
wireless core upon initialization request
1295294538.861421: wlan22 (phy #4): scan started
1295294539.894265: wlan22 (phy #4): scan finished: 2412 2417 2422 2427 2432 2437
2442 2447 2452 2457 2462 2467 2472, "lwfdjf_rad"
1295294539.937094: wlan22 (phy #4): auth c0:3f:0e:be:2b:45 -> 00:1f:1f:c8:8e:cb
status: 0: Successful [frame: b0 00 3a 01 00 1f 1f c8 8e cb c0 3f 0e be 2b 45 c0
3f 0e be 2b 45 a0 52 00 00 02 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00]
1295294539.941963: wlan22: unknown event 19
1295294539.948184: wlan22 (phy #4): assoc c0:3f:0e:be:2b:45 -> 00:1f:1f:c8:8e:cb
status: 0: Successful [frame: 10 00 3a 01 00 1f 1f c8 8e cb c0 3f 0e be 2b 45 c0
3f 0e be 2b 45 b0 52 11 04 00 00 03 c0 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12
18 60 dd 09 00 10 18 02 02 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00
27 a4 00 00 42 43 5e 00 62 32 2f 00]
1295294539.948508: wlan22 (phy #4): connected to c0:3f:0e:be:2b:45
1295294637.011546: wlan22 (phy #4): scan started
1295294638.646848: wlan22 (phy #4): scan finished: 2412 2417 2422 2427 2432 2437
2442 2447 2452 2457 2462 2467 2472, ""
1295294638.726666: wlan22 (phy #4): deauth 00:1f:1f:c8:8e:cb ->
c0:3f:0e:be:2b:45 reason 4: Disassociated due to inactivity [frame: c0 00 00 00
c0 3f 0e be 2b 45 00 1f 1f c8 8e cb c0 3f 0e be 2b 45 00 00 04 00]
1295294638.726940: wlan22 (phy #4): disconnected (local request)
1295294638.764810: phy #0: regulatory domain change: set to world roaming by the
wireless core upon initialization request
1295294638.845333: wlan22 (phy #4): scan started
1295294639.862231: wlan22 (phy #4): scan finished: 2412 2417 2422 2427 2432 2437
2442 2447 2452 2457 2462 2467 2472, "lwfdjf_rad"
1295294639.899905: wlan22 (phy #4): auth c0:3f:0e:be:2b:45 -> 00:1f:1f:c8:8e:cb
status: 0: Successful [frame: b0 00 3a 01 00 1f 1f c8 8e cb c0 3f 0e be 2b 45 c0
3f 0e be 2b 45 40 98 00 00 02 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00]
1295294639.902684: wlan22: unknown event 19
1295294639.905854: wlan22 (phy #4): assoc c0:3f:0e:be:2b:45 -> 00:1f:1f:c8:8e:cb
status: 0: Successful [frame: 10 00 3a 01 00 1f 1f c8 8e cb c0 3f 0e be 2b 45 c0
3f 0e be 2b 45 50 98 11 04 00 00 03 c0 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12
18 60 dd 09 00 10 18 02 02 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00
27 a4 00 00 42 43 5e 00 62 32 2f 00]
1295294639.906219: wlan22 (phy #4): connected to c0:3f:0e:be:2b:45

The MAC address for the device is 00:1F:1F:C8:8E:CB and that of the AP is
C0:3F:0E:BE:2B:45, thus corresponding with the above output.

Is scanning this often normal? I suspect it is, but I have not looged the events
before.

Although both AP and STA support 802.11n, the connection is 802.11g (max 54
Mbps) using WPA2-PSK.

What triggers the "Disassociated due to inactivity"?

Thanks,

Larry
