Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgout0106.bt.lon5.cpcloud.co.uk ([65.20.0.126]:3784 "EHLO
	rgout0106.bt.lon5.cpcloud.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754458AbcBBLSz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 06:18:55 -0500
Received: from g.local (109.147.235.221) by rgout01.bt.lon5.cpcloud.co.uk (8.6.122.06) (authenticated as gareth.mccaughan)
        id 56A9FEED0089C840 for linux-wireless@vger.kernel.org; Tue, 2 Feb 2016 11:11:59 +0000
Received: from localhost ([127.0.0.1] helo=g.local)
	by g.local with esmtp (Exim 4.85 (FreeBSD))
	(envelope-from <gareth.mccaughan@pobox.com>)
	id 1aQYsN-000Cs5-5y
	for linux-wireless@vger.kernel.org; Tue, 02 Feb 2016 11:12:03 +0000
To: linux-wireless@vger.kernel.org
From: Gareth McCaughan <gareth.mccaughan@pobox.com>
Subject: wpa_supplicant over-eagerly blacklisting AP sending
 PREV_AUTH_NOT_VALID?
Message-ID: <56B08F03.1040802@g.local> (sfid-20160202_121900_489467_200E430D)
Date: Tue, 2 Feb 2016 11:12:03 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have some reason to believe the following:

   * Some Cisco wireless APs will regularly try to force clients
     to reauthenticate by sending deauthorization frames
     with reason code 2 (PREV_AUTH_NOT_VALID).

   * When one of these arrives, wpa_supplicant will respond by
     putting the AP on a blacklist and roaming to another AP
     rather than by immediately trying to reauthenticate with
     the same AP.

This is a Bad Thing (isn't it?) because e.g. if you have two of
these APs within range but one provides a much better signal
than the other, you'll alternate between them rather than
sticking with the good one. It seems like it might be better
for wpa_supplicant to try the original AP again immediately.

(The problem that actually sent me looking at this stuff is
more severe and involves machines completely falling off
the network after several of these transitions, but I think
that's a separate issue that I don't understand yet.)

Some details follow.

                                *

Background:

I have (more precisely, my employer has) a Linux machine sitting on
a wireless network. After a while (often at intervals slightly greater
than two hours) it falls off the network and will not automatically
reconnect. This is unfortunate for us because it's not our wireless
network but another company's, and the machine is meant to
do its thing without manual intervention.

After cranking up the logging verbosity of wpa_supplicant on the
affected machine and digging through the syslog, here is at least
part of what's going on.

   * There are multiple APs in range (and in some cases the same
     physical AP has multiple BSSIDs).

   * After being connected to any of them for half an hour,
     our machine gets kicked off, apparently because the AP
     sent a deauth frame with reason code 2
     (PREV_AUTH_NOT_VALID).

   * When this happens, the client's wpa_supplicant puts
     the AP on its blacklist and roams to a different AP.

   * Sometimes, after several of these, something goes
     wrong enough in our attempts to reconnect that the
     machine gives up completely. I think this is caused by
     an entirely different problem; I mention it only for
     context.

                                *

Evidence from the logs:

Here is a (lightly censored) portion of the syslog at the time of
one of those deauthorizations. I've censored the client's
hostname, the AP's BSSID, and the client's MAC address.
This is with wpa_supplicant -dd.

Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: RTM_NEWLINK: 
ifi_index=3 ifname=wlan0 operstate=2 linkmode=1 ifi_flags=0x1003 ([UP])
Jan 28 17:54:49 CENSORED-HOSTNAME kernel: [281557.856806] wlan0: 
deauthenticated from CENSORED-BSSID (Reason: 2=PREV_AUTH_NOT_VALID)
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: Event 
message available
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: Drv 
Event 20 (NL80211_CMD_DEL_STATION) received for wlan0
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: Delete 
station CENSORED-BSSID
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: Event 
message available
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: Drv 
Event 39 (NL80211_CMD_DEAUTHENTICATE) received for wlan0
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: MLME 
event 39 (NL80211_CMD_DEAUTHENTICATE) on wlan0(CENSORED-MAC-ADDR) 
A1=CENSORED-MAC-ADDR A2=CENSORED-BSSID
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: MLME 
event frame - hexdump(len=26): c0 00 30 00 xx xx xx xx xx xx xx xx xx xx 
xx xx xx xx xx xx xx xx 30 ca 02 00
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: nl80211: 
Deauthenticate event
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: wlan0: Event 
DEAUTH (12) received
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: wlan0: 
Deauthentication notification
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: wlan0:  * reason 2
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: wlan0:  * 
address CENSORED-BSSID
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: 
Deauthentication frame IE(s) - hexdump(len=0): [NULL]
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: wlan0: 
CTRL-EVENT-DISCONNECTED bssid=CENSORED-BSSID reason=2
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: wlan0: Auto 
connect enabled: try to reconnect (wps=0 wpa_state=9)
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: wlan0: Setting 
scan request: 0.100000 sec
Jan 28 17:54:49 CENSORED-HOSTNAME wpa_supplicant[10876]: Added BSSID 
CENSORED-BSSID into blacklist

 >From the first three octets of the BSSIDs it is apparent that
all the APs involved are Cisco ones. I know that at least some
Cisco APs have a session timeout defaulting to half an hour,
after which they will force reauthentication.

I believe the second message above (wlan0: deauthenticated ...)
is generated in function ieee80211_rx_mgmt_deauth in
net/mac80211/mlme.c, and it looks to me as if this indicates
that the AP sent us a deauth frame with reason code 2
("previous authentication no longer valid").

Then, near the end of the excerpt above, the message
"Auto connect enabled ..." comes from function
wpa_supplicant_event_disassoc_finish in wpa_supplicant;
that function has the ability to cause an immediate attempt
to reauthenticate with the same AP, but doesn't do so in
this case because it will only do it for reason codes 4,6,7
and this deauthorization had reason code 2.

                                *

I am not very expert in the ways of wireless networking;
perhaps these Cisco APs are behaving improperly, though
what they're doing seems reasonable enough to me. But
it seems to me that in this situation wpa_supplicant would
do better to try again immediately with the same AP, at
least once.

(The machine in question is a Lenovo laptop with an Intel
wireless card; if the details of the hardware are important
I can find them out, but I bet they aren't. It's running
Ubuntu 14.04 LTS which uses wpa_supplicant 2.1, but it
looks to me as if the relevant code is the same in more
recent versions of wpa_supplicant. Again, more details
are available on request.)

[I am not subscribed to the linux-wireless list but will be
watching the archives.]

--
Gareth McCaughan


