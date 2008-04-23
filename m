Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:41224 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYDWRPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 13:15:48 -0400
Received: by wa-out-1112.google.com with SMTP id m16so4756849waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2008 10:15:48 -0700 (PDT)
Message-ID: <1ba2fa240804231015r41e7d7f5ocf7d78af72fb4622@mail.gmail.com> (sfid-20080423_191626_063650_81D8B2D9)
Date: Wed, 23 Apr 2008 20:15:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Volker Braun" <vbraun@physics.upenn.edu>
Subject: Re: dynamic wep with mulitple keys
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
In-Reply-To: <1208969544.3312.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208969544.3312.5.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 23, 2008 at 7:52 PM, Volker Braun <vbraun@physics.upenn.edu> wrote:
> We have a wireless network with dynamically set wep keys on some sort of
>  cisco APs. With compat-wireless-2008-04-22 I can reliably associate
>  (dynamic wep, EAP-TTLS with phase 2 PAP auth) using
>  wpa_supplicant-0.6.3. But I do not obtain a DHCP lease, and I'm
>  suspecting that my outgoing packets are dropped by the AP.
>
>  There was a similar thread on this list about one month ago (same
>  topic), and Tomas Winkler wrote "Please validate that you are receiving
>  two keys from a supplicant.  The order should be first unicast then
>  broadcast key." For the record, the AP sets the keys in the reverse
>  order:
>
>  wpa_supplicant -Dwext -iwlan0 -c /root/wpa_supplicant.conf -ddd
>
>  [...]
>  CTRL-EVENT-EAP-SUCCESS EAP authentication completed successfully
>  EAPOL: SUPP_BE entering state RECEIVE
>  EAPOL: SUPP_BE entering state SUCCESS
>  EAPOL: SUPP_BE entering state IDLE
>  RX EAPOL from 00:15:c6:5e:e5:70
>  RX EAPOL - hexdump(len=61): 01 03 00 39 01 00 0d 00 00 48 0f 65 c8 37 56
>  a8 32 17 1a 5f 38 4d 50 5b b9 11 13 4c 61 af 30 02 e0 29 39 c8 e4 ee e4
>  00 c8 e3 75 99 cf 2f 5c 72 31 b8 c8 e1 07 83 ff d9 01 82 08 6c 08
>  EAPOL: Received EAPOL-Key frame
>  EAPOL: KEY_RX entering state KEY_RECEIVE
>  EAPOL: processKey
>  EAPOL: RX IEEE 802.1X ver=1 type=3 len=57 EAPOL-Key: type=1
>  key_length=13 key_index=0x2
>  EAPOL: Successfully fetched key (len=64)
>  EAPOL: EAPOL-Key key signature verified
>  EAPOL: Decrypted(RC4) key - hexdump(len=13): [REMOVED]
>  EAPOL: Setting dynamic WEP key: broadcast keyidx 2 len 13
>  wpa_driver_wext_set_key: alg=1 key_idx=2 set_tx=0 seq_len=0 key_len=13
>  RX EAPOL from 00:15:c6:5e:e5:70
>  RX EAPOL - hexdump(len=48): 01 03 00 2c 01 00 0d 00 00 48 0f 65 c8 37 57
>  71 cf 6b a3 b1 08 ce 88 d0 ca 0a 0c 00 84 7b c4 83 5e 20 c0 0d a2 f9 ce
>  f0 94 5f 38 ee e7 7c 68 3a
>  EAPOL: Received EAPOL-Key frame
>  EAPOL: KEY_RX entering state KEY_RECEIVE
>  EAPOL: processKey
>  EAPOL: RX IEEE 802.1X ver=1 type=3 len=44 EAPOL-Key: type=1
>  key_length=13 key_index=0x83
>  EAPOL: Successfully fetched key (len=64)
>  EAPOL: EAPOL-Key key signature verified
>  EAPOL: using part of EAP keying material data encryption key -
>  hexdump(len=13): [REMOVED]
>  EAPOL: Setting dynamic WEP key: unicast keyidx 3 len 13
>  wpa_driver_wext_set_key: alg=1 key_idx=3 set_tx=128 seq_len=0 key_len=13
>  EAPOL: all required EAPOL-Key frames received
>  WPA: EAPOL processing complete
>  Cancelling scan request
>  Cancelling authentication timeout
>  State: ASSOCIATED -> COMPLETED
>  [...]
>
>  Finally, I'm enabling some TX debugging:
>
>  echo 0x20800002 >> /sys/bus/pci/drivers/iwl4965/debug_level
>
>  This is what I get in the log:
>
>  Apr 22 19:02:56 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
>  Apr 22 19:02:56 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>  Apr 22 19:02:56 localhost dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 14
>  Apr 22 19:02:56 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x8003 retries 5
>  Apr 22 19:02:57 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(90 bytes) at rate 0x21c
>  Apr 22 19:02:57 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>  Apr 22 19:02:57 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x8003 retries 4
>  Apr 22 19:03:01 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(90 bytes) at rate 0x21c
>  Apr 22 19:03:01 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>  Apr 22 19:03:01 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 2
>  Apr 22 19:03:12 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
>  Apr 22 19:03:12 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>  Apr 22 19:03:12 localhost dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 port 67
>  Apr 22 19:03:12 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 0
>  Apr 22 19:03:17 localhost dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 port 67
>  Apr 22 19:03:17 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
>  Apr 22 19:03:17 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>  Apr 22 19:03:17 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 2
>  Apr 22 19:03:22 localhost dhclient: DHCPREQUEST on wlan0 to 255.255.255.255 port 67
>  Apr 22 19:03:22 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
>  Apr 22 19:03:22 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>  Apr 22 19:03:22 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 2
>  Apr 22 19:03:28 localhost dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 6
>  Apr 22 19:03:28 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
>  Apr 22 19:03:28 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>  Apr 22 19:03:28 localhost kernel: iwl4965: I iwl4965_rx_reply_tx Tx queue 2 Status SUCCESS (0x00002201) rate_n_flags 0x4003 retries 2
>  Apr 22 19:03:34 localhost dhclient: DHCPDISCOVER on wlan0 to 255.255.255.255 port 67 interval 9
>  Apr 22 19:03:34 localhost kernel: iwl4965: I iwl4965_mac_tx dev->xmit(362 bytes) at rate 0x21c
>  Apr 22 19:03:34 localhost kernel: iwl4965: I iwl4965_build_tx_cmd_hwcrypto Configuring packet for WEP encryption with key 3
>
>
>  I thought the DHCP broadcast ought to be encrypted with the broadcast
>  key (=keyidx 2)?? But its encrypted with the unicast key (keyidx 3). Or
>  am I really confused here? Please let me know if you have any ideas to
>  fix this!
>

Driver assumes that unicast key is assigned first as usually broadcast
key handshake encrypted with unicast key.
This probably is not always the case.
We'll try to reproduce and fix this.

Thanks
Tomas
