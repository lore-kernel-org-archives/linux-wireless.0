Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61017 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1DOKy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 06:54:29 -0400
Received: by vws1 with SMTP id 1so1981092vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 03:54:28 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 15 Apr 2011 12:54:28 +0200
Message-ID: <BANLkTimEipE8q-ehYFrXpVqHRSHrCcZxXw@mail.gmail.com>
Subject: WPA2 Access Point (HostAPD) authentication with Samsung Galaxy Tab fails.
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: hostap@lists.shmoo.com
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am having trouble to authenticate a Samsung Galaxy Tab with an AP on
a rt3070 usb device. The specifics follow...

I am configuring an access point using HostAPD 0.7.3 (openssl 0.9.8g
with the patch from hostapd 0.7.3)
My NIC is a rt3070 usb dongle with the rt2x00 driver from
compat-wireless-2011-03-13 with the follwing patches:

http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=878a2bbc20100d8bccf84cc058373fe7de2e6501
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=4f3ab1e88d8b5ce4852d075016ca784a00383452
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=c8cb3a0af064fb5d9cbbaa16bd2f308ba3b90ceb
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=66b096e6ad64f718425d2de9a70d82ba187d7db4

Everything cross compiled to a 2.624 kernel.

My hostapd.conf file is:

interface=wlan0
driver=nl80211
ssid=myAPwpa2
channel=7
hw_mode=g
max_num_sta=1
auth_algs=1
ctrl_interface=/var/run/hostapd
ignore_broadcast_ssid=0
ieee80211n=1
ht_capab=[HT40-]
beacon_int=100
dtim_period=2
rts_threshold=2347
fragm_threshold=2346
macaddr_acl=0
eapol_key_index_workaround=0
eap_server=0
wpa=2
wpa_passphrase=asdf1234
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
wpa_group_rekey=86400
wpa_gmk_rekey=86400

I disable power savings before running hostapd.

When authenticating with a Windows XP machine, I am able to do it
without problems, here is the log:

authentication: STA=00:1f:1f:da:e7:a1 auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan0: STA 00:1f:1f:da:e7:a1 IEEE 802.11: authentication OK (open system)
wlan0: STA 00:1f:1f:da:e7:a1 MLME:
MLME-AUTHENTICATE.indication(00:1f:1f:da:e7:a1, OPEN_SYSTEM)
wlan0: STA 00:1f:1f:da:e7:a1 MLME: MLME-DELETEKEYS.request(00:1f:1f:da:e7:a1)
authentication reply: STA=00:1f:1f:da:e7:a1 auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::assoc_req
association request: STA=00:1f:1f:da:e7:a1 capab_info=0x411 listen_interval=3
IEEE 802.11 element parse ignored unknown element (id=127 elen=1)
unknown vendor specific information element ignored (vendor OUI 00:0c:43 len=7)
  new AID 1
nl80211: Set beacon (beacon_set=1)
HT: STA 00:1f:1f:da:e7:a1 HT Capabilities Info: 0x000e
update_sta_ht STA 00:1f:1f:da:e7:a1 - no greenfield, num of non-gf stations 1
hostapd_ht_operation_update current operation mode=0x0
hostapd_ht_operation_update new operation mode=0x7 changes=2
nl80211: Set beacon (beacon_set=1)
wlan0: STA 00:1f:1f:da:e7:a1 IEEE 802.11: association OK (aid 1)
mgmt::auth cb
wlan0: STA 00:1f:1f:da:e7:a1 IEEE 802.11: authenticated
mgmt::assoc_resp cb
wlan0: STA 00:1f:1f:da:e7:a1 IEEE 802.11: associated (aid 1)
wlan0: STA 00:1f:1f:da:e7:a1 MLME: MLME-ASSOCIATE.indication(00:1f:1f:da:e7:a1)
wlan0: STA 00:1f:1f:da:e7:a1 MLME: MLME-DELETEKEYS.request(00:1f:1f:da:e7:a1)
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x81724a0 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=00:1f:1f:da:e7:a1
wlan0: STA 00:1f:1f:da:e7:a1 WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x81724a0 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=00:1f:1f:da:e7:a1
wlan0: STA 00:1f:1f:da:e7:a1 WPA: start authentication
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x81724a0 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=00:1f:1f:da:e7:a1
wlan0: STA 00:1f:1f:da:e7:a1 IEEE 802.1X: unauthorizing port
Could not set station 00:1f:1f:da:e7:a1 flags for kernel driver (errno=11).
WPA: 00:1f:1f:da:e7:a1 WPA_PTK_GROUP entering state IDLE
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state AUTHENTICATION
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state AUTHENTICATION2
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state INITPSK
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state PTKSTART
wlan0: STA 00:1f:1f:da:e7:a1 WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
IEEE 802.1X: 121 bytes from 00:1f:1f:da:e7:a1
   IEEE 802.1X: version=1 type=3 length=117
wlan0: STA 00:1f:1f:da:e7:a1 WPA: received EAPOL-Key frame (2/4 Pairwise)
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state PTKCALCNEGOTIATING
WPA: PTK derivation - A1=00:12:0e:b9:2d:31 A2=00:1f:1f:da:e7:a1
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state PTKCALCNEGOTIATING2
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state PTKINITNEGOTIATING
wlan0: STA 00:1f:1f:da:e7:a1 WPA: sending 3/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1 install=1 pairwise=8
kde_len=46 keyidx=1 encr=1)
Plaintext EAPOL-Key Key Data - hexdump(len=56): [REMOVED]
IEEE 802.1X: 00:1f:1f:da:e7:a1 TX status - version=2 type=3 length=95 - ack=1
IEEE 802.1X: 99 bytes from 00:1f:1f:da:e7:a1
   IEEE 802.1X: version=1 type=3 length=95
wlan0: STA 00:1f:1f:da:e7:a1 WPA: received EAPOL-Key frame (4/4 Pairwise)
WPA: 00:1f:1f:da:e7:a1 WPA_PTK entering state PTKINITDONE
wpa_driver_nl80211_set_key: ifindex=4 alg=3 addr=0x81724a0 key_idx=0
set_tx=1 seq_len=0 key_len=16
   addr=00:1f:1f:da:e7:a1
AP-STA-CONNECTED 00:1f:1f:da:e7:a1
wlan0: STA 00:1f:1f:da:e7:a1 IEEE 802.1X: authorizing port
wlan0: STA 00:1f:1f:da:e7:a1 RADIUS: starting accounting session
4DA82D8C-00000000
wlan0: STA 00:1f:1f:da:e7:a1 WPA: pairwise key handshake completed (RSN)
IEEE 802.1X: 00:1f:1f:da:e7:a1 TX status - version=2 type=3 length=151 - ack=1
STA 00:13:02:85:be:73 sent probe request for broadcast SSID
mgmt::proberesp cb

However, I am trying to authenticate with a Samsung Galaxy Tab with
Android 2.2 on it, and I get the following log:

STA bc:47:60:93:74:bd sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:13:02:85:be:73 sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:25:cf:d6:c1:b4 sent probe request for broadcast SSID
mgmt::proberesp cb
STA 00:25:cf:d6:c1:b4 sent probe request for broadcast SSID
mgmt::proberesp cb
wlan0: STA bc:47:60:93:74:bd WPA: EAPOL-Key timeout
WPA: bc:47:60:93:74:bd WPA_PTK entering state PTKSTART
wlan0: STA bc:47:60:93:74:bd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: bc:47:60:93:74:bd TX status - version=2 type=3 length=95 - ack=0
wlan0: STA bc:47:60:93:74:bd IEEE 802.1X: did not Ack EAPOL-Key frame
(broadcast index=87)
wlan0: STA bc:47:60:93:74:bd WPA: EAPOL-Key timeout
WPA: bc:47:60:93:74:bd WPA_PTK entering state PTKSTART
wlan0: STA bc:47:60:93:74:bd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: bc:47:60:93:74:bd TX status - version=2 type=3 length=95 - ack=0
wlan0: STA bc:47:60:93:74:bd IEEE 802.1X: did not Ack EAPOL-Key frame
(broadcast index=87)
wlan0: STA bc:47:60:93:74:bd WPA: EAPOL-Key timeout
WPA: bc:47:60:93:74:bd WPA_PTK entering state PTKSTART
WPA: bc:47:60:93:74:bd WPA_PTK entering state DISCONNECT
hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect:
STA bc:47:60:93:74:bd reason 2
WPA: bc:47:60:93:74:bd WPA_PTK entering state DISCONNECTED
WPA: bc:47:60:93:74:bd WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x8172760 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=bc:47:60:93:74:bd
wlan0: STA bc:47:60:93:74:bd IEEE 802.1X: unauthorizing port
wlan0: STA bc:47:60:93:74:bd IEEE 802.11: deauthenticated due to local
deauth request
hostapd_ht_operation_update current operation mode=0x7
hostapd_ht_operation_update new operation mode=0x7 changes=0
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA bc:47:60:93:74:bd sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA bc:47:60:93:74:bd sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=bc:47:60:93:74:bd auth_alg=0 auth_transaction=1
status_code=0 wep=0
  New STA
wlan0: STA bc:47:60:93:74:bd IEEE 802.11: authentication OK (open system)
wlan0: STA bc:47:60:93:74:bd MLME:
MLME-AUTHENTICATE.indication(bc:47:60:93:74:bd, OPEN_SYSTEM)
wlan0: STA bc:47:60:93:74:bd MLME: MLME-DELETEKEYS.request(bc:47:60:93:74:bd)
authentication reply: STA=bc:47:60:93:74:bd auth_alg=0
auth_transaction=2 resp=0 (IE len=0)
mgmt::assoc_req
association request: STA=bc:47:60:93:74:bd capab_info=0x431 listen_interval=10
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
  new AID 2
HT: STA bc:47:60:93:74:bd HT Capabilities Info: 0x182c
update_sta_ht STA bc:47:60:93:74:bd - no greenfield, num of non-gf stations 2
update_sta_ht STA bc:47:60:93:74:bd - 20 MHz HT, num of 20MHz HT STAs 1
hostapd_ht_operation_update current operation mode=0x7
hostapd_ht_operation_update new operation mode=0x7 changes=0
wlan0: STA bc:47:60:93:74:bd IEEE 802.11: association OK (aid 2)
mgmt::auth cb
wlan0: STA bc:47:60:93:74:bd IEEE 802.11: authenticated
Data/PS-poll frame from not associated STA bc:47:60:93:74:bd
mgmt::assoc_resp cb
wlan0: STA bc:47:60:93:74:bd IEEE 802.11: associated (aid 2)
wlan0: STA bc:47:60:93:74:bd MLME: MLME-ASSOCIATE.indication(bc:47:60:93:74:bd)
wlan0: STA bc:47:60:93:74:bd MLME: MLME-DELETEKEYS.request(bc:47:60:93:74:bd)
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x8172760 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=bc:47:60:93:74:bd
wlan0: STA bc:47:60:93:74:bd WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x8172760 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=bc:47:60:93:74:bd
wlan0: STA bc:47:60:93:74:bd WPA: start authentication
WPA: bc:47:60:93:74:bd WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x8172760 key_idx=0
set_tx=1 seq_len=0 key_len=0
   addr=bc:47:60:93:74:bd
wlan0: STA bc:47:60:93:74:bd IEEE 802.1X: unauthorizing port
WPA: bc:47:60:93:74:bd WPA_PTK_GROUP entering state IDLE
WPA: bc:47:60:93:74:bd WPA_PTK entering state AUTHENTICATION
WPA: bc:47:60:93:74:bd WPA_PTK entering state AUTHENTICATION2
WPA: bc:47:60:93:74:bd WPA_PTK entering state INITPSK
WPA: bc:47:60:93:74:bd WPA_PTK entering state PTKSTART
wlan0: STA bc:47:60:93:74:bd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
unknown mgmt cb frame subtype 10
IEEE 802.1X: bc:47:60:93:74:bd TX status - version=2 type=3 length=95 - ack=1
wlan0: STA bc:47:60:93:74:bd WPA: EAPOL-Key timeout
WPA: bc:47:60:93:74:bd WPA_PTK entering state PTKSTART
wlan0: STA bc:47:60:93:74:bd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8
kde_len=0 keyidx=0 encr=0)
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA bc:47:60:93:74:bd sent probe request for broadcast SSID
IEEE 802.1X: bc:47:60:93:74:bd TX status - version=2 type=3 length=95 - ack=1


So it seems the Tab is not performing the handshake correctly, (even
though it is able to connect to other access points).
I read of a similar problem in:

http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/002886.html
but i don't have a rt61 device...so it does not apply to me, and the
suggested patch is already in the driver I use...

Does anyone have any thoughts of what could be the problem?

Best Regards,

-- 
Juan Carlos Garza
