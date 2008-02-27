Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:35216 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753005AbYB0UZx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 15:25:53 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: RE: Roaming issues: AP deauthentication.
Date: Wed, 27 Feb 2008 21:25:01 +0100
Message-ID: <008401c8797e$d5352810$0b3ca8c0@gotws1589> (sfid-20080227_202557_666041_F205F9B7)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
In-Reply-To: <1204134256.6309.31.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

I have split my issues into individual discussions:

> AP deauthentication.
> =====================
> When any of the ieee80211_rx_mgmt_deauth() or 
> ieee80211_rx_mgmt_disassoc() are executed, the mac layer takes two
actions.
> 1) Tells wpa_supplicant what had happened.
> 2) Start reestabliching the connaction again.
> 
> The later action will stop or significantly delay the decisions/action 
> taken by wpa_supplicant as a result of action 1. Normally the 
> supplicant will start an AP scan.
> But the mac layer is busy with reestablishing the link and will not 
> start any scan action.
>
> Does associating actually block scanning?
> 
> If it doesn't, it really should.  There's been a number of problems 
> over the years with scan requests screwing up association because the 
> card is on a different channel and misses the association/auth 
> exchanges.  To ensure that association/authentication is as robust as 
> possible, the driver should refuse scans while association is ongoing.
>
>
> My patches simply put the mac layer in IEEE80211_DISABLED state and 
> wait for the supplicant to decide.
>
> That would break supplicant-less operation which we can't do.
>
>
> Good point.


The patch might not work for all use cases, 
but might be configurable for the wpa_supplicant.


The following trace is an example before the patch 
where the STA roams from 60:00 to 84:20:
===========================================================
<4>[  513.630484] LaE: ieee80211_associated: bssid=00:0f:24:d1:60:00, diff=
419, bcnt= 9, last: rssi=-78, signa= 23, noise=  0 
<7>[  513.964713] wlan0: RX deauthentication from 00:0f:24:d1:60:00
(reason=2)
<7>[  513.964761] wlan0: deauthenticated
<7>[  514.963454] wlan0: authenticate with AP 00:0f:24:d1:60:00
<7>[  514.965015] wlan0: RX authentication from 00:0f:24:d1:60:00 (alg=0
transaction=2 status=0)
<7>[  514.965060] wlan0: authenticated
<7>[  514.965089] wlan0: associate with AP 00:0f:24:d1:60:00
<7>[  514.975332] wlan0: RX ReassocResp from 00:0f:24:d1:60:00 (capab=0x431
status=0 aid=43)
<7>[  514.975387] wlan0: associated
<7>[  514.975429] wlan0: CTS protection enabled (BSSID=00:0f:24:d1:60:00)
<7>[  515.002555] HW CONFIG: channel=1 freq=2412 phymode=2
<7>[  515.066225] HW CONFIG: channel=2 freq=2417 phymode=2
<7>[  515.130252] HW CONFIG: channel=3 freq=2422 phymode=2
<7>[  515.194672] HW CONFIG: channel=4 freq=2427 phymode=2
<7>[  515.258189] HW CONFIG: channel=5 freq=2432 phymode=2
<7>[  515.322688] HW CONFIG: channel=6 freq=2437 phymode=2
<7>[  515.386038] HW CONFIG: channel=7 freq=2442 phymode=2
<7>[  515.450156] HW CONFIG: channel=8 freq=2447 phymode=2
<7>[  515.514878] HW CONFIG: channel=9 freq=2452 phymode=2
<7>[  515.578011] HW CONFIG: channel=10 freq=2457 phymode=2
<7>[  515.642574] HW CONFIG: channel=11 freq=2462 phymode=2
<7>[  515.706186] HW CONFIG: channel=12 freq=2467 phymode=2
<7>[  515.769983] HW CONFIG: channel=13 freq=2472 phymode=2
<7>[  515.835163] HW CONFIG: channel=7 freq=2442 phymode=2
<7>[  515.846340] wlan0: set_encrypt - unknown addr 00:0e:d7:ac:84:20
<7>[  515.848784] HW CONFIG: channel=1 freq=2412 phymode=2
<7>[  515.851425] wlan0: Initial auth_alg=0
<7>[  515.851585] wlan0: authenticate with AP 00:0f:24:d1:60:00
<6>[  515.858226] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 0 -
CWmin: 4, CWmax: 10, Aifs: 2.
<6>[  515.858287] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 1 -
CWmin: 4, CWmax: 10, Aifs: 2.
<6>[  515.858328] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 2 -
CWmin: 4, CWmax: 10, Aifs: 2.
<6>[  515.858370] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 3 -
CWmin: 4, CWmax: 10, Aifs: 2.
<6>[  515.858411] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 4 -
CWmin: 4, CWmax: 10, Aifs: 2.
<6>[  515.858453] phy0 -> rt2x00mac_conf_tx: Info - Configured TX ring 7 -
CWmin: 5, CWmax: 10, Aifs: 2.
<7>[  515.859260] wlan0: Initial auth_alg=0
<7>[  515.859417] wlan0: authenticate with AP 00:0e:d7:ac:84:20
<7>[  515.865693] wlan0: RX authentication from 00:0e:d7:ac:84:20 (alg=0
transaction=2 status=0)
<7>[  515.865866] wlan0: authenticated
<7>[  515.866060] wlan0: associate with AP 00:0e:d7:ac:84:20
<7>[  515.868272] wlan0: RX ReassocResp from 00:0e:d7:ac:84:20 (capab=0x431
status=0 aid=218)
<7>[  515.868437] wlan0: associated
<7>[  515.870163] phy0: Added STA 00:0e:d7:ac:84:20
<7>[  515.870353] wlan0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023
burst=0


After the patch it looks as follows:
where the STA roams from 60:00 to 64:f0:
===========================================================
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.008642] wlan0: RX
deauthentication from 00:0f:24:d1:60:00 (reason=2)
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.008691] wlan0:
deauthenticated
Feb 26 09:07:43 (none) user.warn kernel: [ 1146.008712] LaE:
[ieee80211_rx_mgmt_deauth] set IEEE80211_DISABLED
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.146694] HW CONFIG:
channel=1 freq=2412 phymode=2
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.220021] HW CONFIG:
channel=6 freq=2437 phymode=2
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.291429] HW CONFIG:
channel=7 freq=2442 phymode=2
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.368633] HW CONFIG:
channel=11 freq=2462 phymode=2
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.435768] HW CONFIG:
channel=13 freq=2472 phymode=2
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.508241] HW CONFIG:
channel=7 freq=2442 phymode=2
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.520670] wlan0: set_encrypt
- unknown addr 00:0e:d7:ca:64:f0
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.521289] HW CONFIG:
channel=13 freq=2472 phymode=2
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.523450] wlan0: Initial
auth_alg=0
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.528055] wlan0: authenticate
with AP 00:0f:24:d1:60:00
Feb 26 09:07:43 (none) user.info kernel: [ 1146.528888] phy0 ->
rt2x00mac_conf_tx: Info - Configured TX ring 0 - CWmin: 4, CWmax: 10, Aifs:
2.
Feb 26 09:07:43 (none) user.info kernel: [ 1146.528948] phy0 ->
rt2x00mac_conf_tx: Info - Configured TX ring 1 - CWmin: 4, CWmax: 10, Aifs:
2.
Feb 26 09:07:43 (none) user.info kernel: [ 1146.528989] phy0 ->
rt2x00mac_conf_tx: Info - Configured TX ring 2 - CWmin: 4, CWmax: 10, Aifs:
2.
Feb 26 09:07:43 (none) user.info kernel: [ 1146.529030] phy0 ->
rt2x00mac_conf_tx: Info - Configured TX ring 3 - CWmin: 4, CWmax: 10, Aifs:
2.
Feb 26 09:07:43 (none) user.info kernel: [ 1146.529072] phy0 ->
rt2x00mac_conf_tx: Info - Configured TX ring 4 - CWmin: 4, CWmax: 10, Aifs:
2.
Feb 26 09:07:43 (none) user.info kernel: [ 1146.529114] phy0 ->
rt2x00mac_conf_tx: Info - Configured TX ring 7 - CWmin: 5, CWmax: 10, Aifs:
2.
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.540333] wlan0: Initial
auth_alg=0
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.540389] wlan0: authenticate
with AP 00:0e:d7:ca:64:f0
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.542411] wlan0: RX
authentication from 00:0e:d7:ca:64:f0 (alg=0 transaction=2 status=0)
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.542464] wlan0:
authenticated
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.542493] wlan0: associate
with AP 00:0e:d7:ca:64:f0
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.550157] wlan0: RX
ReassocResp from 00:0e:d7:ca:64:f0 (capab=0x431 status=0 aid=164)
Feb 26 09:07:43 (none) user.debug kernel: [ 1146.550210] wlan0: associated


/Lars

