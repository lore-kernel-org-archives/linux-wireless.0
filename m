Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36587 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbYEHSp1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 14:45:27 -0400
Subject: Re: dynamic wep with mulitple keys
From: Volker Braun <vbraun@physics.upenn.edu>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com>
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com>
	 <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
	 <1210003121.11809.10.camel@carrot.hep.upenn.edu>
	 <8704f27d0805052346u24954211l6f55513c78205586@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 08 May 2008 14:31:12 -0400
Message-Id: <1210271472.30724.43.camel@carrot.hep.upenn.edu> (sfid-20080508_204426_370682_1C6ECD2F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is more data on my problem with dynamic wep.

compat-wireless-2008-05-07 + iwl4965 + swcrypto=1: Associates and
obtains dhcp lease, works fine.

So it really is about the HW accelleration. I tried your patch (without
swcrypto=1). First, output of wpa_supplicant:

EAPOL: Received EAPOL-Key frame
EAPOL: KEY_RX entering state KEY_RECEIVE
EAPOL: processKey
EAPOL: RX IEEE 802.1X ver=1 type=3 len=57 EAPOL-Key: type=1 key_length=13 key_index=0x1
EAPOL: Successfully fetched key (len=64)
EAPOL: EAPOL-Key key signature verified
EAPOL: Decrypted(RC4) key - hexdump(len=13): [REMOVED]
EAPOL: Setting dynamic WEP key: broadcast keyidx 1 len 13
wpa_driver_wext_set_key: alg=1 key_idx=1 set_tx=0 seq_len=0 key_len=13
RX EAPOL from 00:13:c4:8a:be:30
RX EAPOL - hexdump(len=48): 01 03 00 2c 01 00 0d 00 00 48 23 40 de a7 a8 0e 57 ec cc b4 2e c4 58 30 18 51 11 55 a0 9d 5f 83 77 f4 ef ca 46 09 02 4b d4 1a 01 84 47 03 41 80
EAPOL: Received EAPOL-Key frame
EAPOL: KEY_RX entering state KEY_RECEIVE
EAPOL: processKey
EAPOL: RX IEEE 802.1X ver=1 type=3 len=44 EAPOL-Key: type=1 key_length=13 key_index=0x83
EAPOL: Successfully fetched key (len=64)
EAPOL: EAPOL-Key key signature verified
EAPOL: using part of EAP keying material data encryption key - hexdump(len=13): [REMOVED]
EAPOL: Setting dynamic WEP key: unicast keyidx 3 len 13
wpa_driver_wext_set_key: alg=1 key_idx=3 set_tx=128 seq_len=0 key_len=13
EAPOL: all required EAPOL-Key frames received
WPA: EAPOL processing complete
Cancelling scan request
Cancelling authentication timeout
State: ASSOCIATED -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:13:c4:8a:be:30 completed (auth) [id=0 id_str=]

Your patch yields: 

May  8 14:03:54 localhost kernel: iwl4965: enable hwcrypto key sta=31 alg=0,keyid=1 static_key=1
May  8 14:03:54 localhost kernel: iwl4965: enable hwcrypto key sta=0 alg=0,keyid=3 static_key=0

Should static_key not be the other way round (key_idx 3 is unicast)? In
any case, after a while the broadcast key gets updated: wpa_supplicant
says

EAPOL: Received EAPOL-Key frame
EAPOL: KEY_RX entering state KEY_RECEIVE
EAPOL: processKey
EAPOL: RX IEEE 802.1X ver=1 type=3 len=57 EAPOL-Key: type=1 key_length=13 key_index=0x2
EAPOL: Successfully fetched key (len=64)
EAPOL: EAPOL-Key key signature verified
EAPOL: Decrypted(RC4) key - hexdump(len=13): [REMOVED]
EAPOL: Setting dynamic WEP key: broadcast keyidx 2 len 13
wpa_driver_wext_set_key: alg=1 key_idx=2 set_tx=0 seq_len=0 key_len=13
EAPOL: all required EAPOL-Key frames received
WPA: EAPOL processing complete

and the syslog contains

May  8 14:05:10 localhost kernel: iwl4965: enable hwcrypto key sta=31 alg=0,keyid=2 static_key=0

5 minutes later the next cycle:

EAPOL: Received EAPOL-Key frame
EAPOL: KEY_RX entering state KEY_RECEIVE
EAPOL: processKey
EAPOL: RX IEEE 802.1X ver=1 type=3 len=57 EAPOL-Key: type=1 key_length=13 key_index=0x1
EAPOL: Successfully fetched key (len=64)
EAPOL: EAPOL-Key key signature verified
EAPOL: Decrypted(RC4) key - hexdump(len=13): [REMOVED]
EAPOL: Setting dynamic WEP key: broadcast keyidx 1 len 13
wpa_driver_wext_set_key: alg=1 key_idx=1 set_tx=0 seq_len=0 key_len=13
EAPOL: all required EAPOL-Key frames received
WPA: EAPOL processing complete
Cancelling scan request

May  8 14:10:30 localhost kernel: iwl4965: disable hwcrypto key sta=31 alg=0,keyid=1 static_key=1
May  8 14:10:30 localhost kernel: iwl4965: enable hwcrypto key sta=31 alg=0,keyid=1 static_key=0

and so on... I never acquire a dhcp lease, dhclient always times out.


As an aside, I just got an atheros-based pcmcia card for testing
purposes and maybe sniff if necessary (though haven't done that yet). 
Result so far:
1) compat-wireless-2008-05-07 + ath5k: Fails to associate with AP.
2) madwifi: associates and obtains dhcp lease, works perfectly.


Volker

