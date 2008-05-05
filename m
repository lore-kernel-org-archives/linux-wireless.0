Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:49489 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbYEEP6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 11:58:44 -0400
Subject: Re: dynamic wep with mulitple keys
From: Volker Braun <vbraun@physics.upenn.edu>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
References: <1208969544.3312.5.camel@localhost.localdomain>
	 <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com>
	 <8704f27d0805050735s647ac4aaq469630bde6bc341e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 05 May 2008 11:58:41 -0400
Message-Id: <1210003121.11809.10.camel@carrot.hep.upenn.edu> (sfid-20080505_175803_658283_BD61D409)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is my wpa_supplicant.conf:

ctrl_interface=/var/run/wpa_supplicant
ctrl_interface_group=0
eapol_version=2
ap_scan=1
network={
  priority=1
  ssid="airsas"
  key_mgmt=IEEE8021X
  eap=TTLS
  phase2="auth=PAP"
  identity="XXXXX"
  password="XXXXX"
  ca_cert="/etc/pki/tls/cert.pem"
}

Leaving out all global options (only the network={} block) produces the
same result (authenticates but no dhcp lease).

I just tried compat-wireless-2008-05-05, which does contain
03dcb07e74a62eec2badb9f6a091790c484f4a6c. No difference: 

wpa_supplicant output: 

[...]
EAPOL: Received EAPOL-Key frame
EAPOL: KEY_RX entering state KEY_RECEIVE
EAPOL: processKey
EAPOL: RX IEEE 802.1X ver=1 type=3 len=57 EAPOL-Key: type=1 key_length=13 key_index=0x1
EAPOL: Successfully fetched key (len=64)
EAPOL: EAPOL-Key key signature verified
EAPOL: Decrypted(RC4) key - hexdump(len=13): [REMOVED]
EAPOL: Setting dynamic WEP key: broadcast keyidx 1 len 13
wpa_driver_wext_set_key: alg=1 key_idx=1 set_tx=0 seq_len=0 key_len=13
RX EAPOL from 00:15:c6:5e:e5:70
RX EAPOL - hexdump(len=48): 01 03 00 2c 01 00 0d 00 00 48 1f 2b 36 3d 64 ed ce c4 13 56 c5 d9 74 22 67 3d 69 09 78 de 22 83 d6 b4 21 2a ab 31 32 d3 f1 a2 12 a5 66 6b a3 82
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
[...]


but dhclient still times out:

May  5 11:44:59 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 1
May  5 11:45:14 localhost kernel: iwl4965: I iwl4965_mac_tx enter
May  5 11:45:14 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
May  5 11:45:14 localhost kernel: iwl4965: I iwl4965_tx_skb station Id 0
May  5 11:45:14 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
May  5 11:45:14 localhost kernel: iwl4965: I iwl4965_mac_tx leave
May  5 11:45:14 localhost dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 19
May  5 11:45:14 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 1
May  5 11:45:26 localhost kernel: iwl4965: I iwl4965_mac_tx enter
May  5 11:45:26 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(49 bytes) at rate 0x0a
May  5 11:45:26 localhost kernel: iwl4965: I iwl4965_tx_skb station Id 31
May  5 11:45:26 localhost kernel: iwl4965: I iwl4965_mac_tx leave
May  5 11:45:26 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 0 Status SUCCESS (0x00000201) rate_n_flags 0x820a retries 0
May  5 11:45:33 localhost dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 10
May  5 11:45:33 localhost kernel: iwl4965: I iwl4965_mac_tx enter
May  5 11:45:33 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
May  5 11:45:33 localhost kernel: iwl4965: I iwl4965_tx_skb station Id 0
May  5 11:45:33 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
May  5 11:45:33 localhost kernel: iwl4965: I iwl4965_mac_tx leave
May  5 11:45:33 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 0
May  5 11:45:43 localhost dhclient: No DHCPOFFERS received.


On Mon, 2008-05-05 at 17:35 +0300, Emmanuel Grumbach wrote:
> can you please send your wpa_supplicant config file ?
> Did you try with a newer driver ?
> 03dcb07e74a62eec2badb9f6a091790c484f4a6c may help, you can get it by
> downloading the latest wireless-testing tree

