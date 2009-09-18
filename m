Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:19939 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbZIRNIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 09:08:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 5C21A50005
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 15:08:45 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bP1VQ-vWMvSB for <linux-wireless@vger.kernel.org>;
	Fri, 18 Sep 2009 15:08:45 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F87DB.dip0.t-ipconnect.de [217.95.135.219])
	by mx51.mymxserver.com (Postfix) with ESMTP id B663D50004
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 15:08:44 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id CBBE21E0036
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 15:08:34 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Life-time of scan-results?
Date: Fri, 18 Sep 2009 15:07:59 +0200
References: <200909181418.30958.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909181418.30958.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909181507.59420.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a log of the events with some kernel msgs.

First, a successfull association:

##HS nl80211_trigger_scan:2922
##HS ieee80211_scan_rx:150 mac 00:1b:53:11:dc:40, probe resp 0
##HS ieee80211_scan_rx:150 mac 00:1b:53:11:dc:40, probe resp 0
##HS ieee80211_scan_rx:150 mac 00:13:19:80:da:30, probe resp 0
##HS ieee80211_scan_rx:150 mac 00:1b:d4:44:35:90, probe resp 0
eth1: direct probe to AP 00:13:19:80:da:30 (try 1)
eth1 direct probe responded
eth1: authenticate with AP 00:13:19:80:da:30 (try 1)
eth1: authenticated
eth1: associate with AP 00:13:19:80:da:30 (try 1)
eth1: RX AssocResp from 00:13:19:80:da:30 (capab=0x11 status=0 aid=53)
eth1: associated

And here the user-space view:

1253275071.933750: wpa_driver_nl80211_scan:1570
1253275071.934167: NL80211_CMD_TRIGGER_SCAN
1253275072.454547: NL80211_CMD_NEW_SCAN_RESULTS
1253275072.454652: Received scan results (3 BSSes)
1253275072.454670: ##HS 0: 00:1b:53:11:dc:40 ssid='MNFUNK' freq=2412
1253275072.454689: ##HS 1: 00:1b:d4:44:35:90 ssid='MNWPA' freq=2412
1253275072.454706: ##HS 2: 00:13:19:80:da:30 ssid='MNHS' freq=2412
1253275072.454728: CTRL-EVENT-SCAN-RESULTS
1253275072.454791: Trying to authenticate with 00:13:19:80:da:30 (SSID='MNHS' freq=2412 MHz)
1253275072.704223: NL80211_CMD_AUTHENTICATE
1253275072.704244: MLME event NL80211_CMD_AUTHENTICATE
1253275072.704267: Trying to associate with 00:13:19:80:da:30 (SSID='MNHS' freq=2412 MHz)
1253275072.762116: NL80211_CMD_ASSOCIATE
1253275072.762136: MLME event NL80211_CMD_ASSOCIATE
1253275072.762175: Associated with 00:13:19:80:da:30
1253275072.767178: NL80211_CMD_CONNECT
1253275072.880891: WPA: Key negotiation completed with 00:13:19:80:da:30 [PTK=TKIP GTK=TKIP]
1253275072.880931: CTRL-EVENT-CONNECTED - Connection to 00:13:19:80:da:30 completed (auth) [id=0 id_str=]




Now I take away the AP:

eth1: deauthenticated from 00:13:19:80:da:30 (Reason: 1)
##HS nl80211_trigger_scan:2922
##HS ieee80211_scan_rx:150 mac 00:1b:53:11:dc:40, probe resp 0
##HS ieee80211_scan_rx:150 mac 00:1b:d4:44:35:90, probe resp 0
##HS ieee80211_scan_rx:150 mac 00:1b:d4:44:35:90, probe resp 0
##HS ieee80211_scan_rx:150 mac 00:1b:53:11:dc:40, probe resp 0
##HS ieee80211_scan_rx:150 mac 00:1b:d4:44:35:90, probe resp 0

Note: there was no beacon nor probe-response from
00:13:19:80:da:30.

253275108.483431: NL80211_CMD_DEAUTHENTICATE
1253275108.483451: MLME event NL80211_CMD_DEAUTHENTICATE
1253275108.483464: ##HS wpa_supplicant_event_disassoc:1040
1253275108.483490: CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
1253275108.483857: wpa_driver_nl80211_scan:1570
1253275108.484063: NL80211_CMD_DISCONNECT
1253275108.484106: NL80211_CMD_TRIGGER_SCAN
1253275108.958527: NL80211_CMD_NEW_SCAN_RESULTS
1253275108.958624: Received scan results (3 BSSes)
1253275108.958642: ##HS 0: 00:1b:53:11:dc:40 ssid='MNFUNK' freq=2412
1253275108.958661: ##HS 1: 00:1b:d4:44:35:90 ssid='MNWPA' freq=2412
1253275108.958677: ##HS 2: 00:13:19:80:da:30 ssid='MNHS' freq=2412


But here it was in the results. And because of that,
wpa_supplicant tries to use this AP in vain:

1253275108.958746: Trying to authenticate with 00:13:19:80:da:30 (SSID='MNHS' freq=2412 MHz)
1253275109.722468: NL80211_CMD_AUTHENTICATE
...

-- 
http://www.holgerschurig.de
