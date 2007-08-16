Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43766 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbXHPS0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 14:26:04 -0400
Subject: Re: [PATCHv3] mac80211: dynamic wep
From: Volker Braun <volker.braun@physik.hu-berlin.de>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200708152158.11677.flamingice@sourmilk.net>
References: <1187151162.3253.18.camel@thinkpad>
	 <200708142355.27708.flamingice@sourmilk.net>
	 <1187191455.6462.14.camel@carrot.hep.upenn.edu>
	 <200708152158.11677.flamingice@sourmilk.net>
Content-Type: text/plain
Date: Thu, 16 Aug 2007 14:26:01 -0400
Message-Id: <1187288761.6462.47.camel@carrot.hep.upenn.edu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-08-15 at 21:58 -0700, Michael Wu wrote:
> Hm.. I'm not really convinced that this is the main reason. Can you check and 
> see if the keyidx that wpa_supplicant configures and the keyidx used in 
> unicast frames are the same?

Its true, wpa_supplicant and the unicast frames all have keyidx==3. I
added these printk's:

=============
        if (rx->fc & IEEE80211_FCTL_PROTECTED) {                
                if (rx->skb->pkt_type == PACKET_HOST)
                        printk(KERN_DEBUG "%s: RX WEP unicast frame from "
                               MAC_FMT " with keyidx %d\n",
                               rx->dev->name, MAC_ARG(hdr->addr2),
                               ieee80211_wep_get_keyidx(rx->skb) );

                if (rx->skb->pkt_type == PACKET_HOST && 
                    rx->sta && rx->sta->key) {

                        rx->key = rx->sta->key;
                        printk(KERN_DEBUG "Using STA key\n");
=============

Then I get a debug log that contains a lot of

...
Aug 16 14:03:58 thinkpad kernel: wlan0: RX WEP unicast frame from 00:15:c6:5e:e5:70 with keyidx 3
Aug 16 14:03:58 thinkpad kernel: Using STA key
Aug 16 14:03:58 thinkpad kernel: wlan0: RX WEP unicast frame from 00:15:c6:5e:e5:70 with keyidx 3
Aug 16 14:03:58 thinkpad kernel: Using STA key
Aug 16 14:03:58 thinkpad kernel: wlan0: RX WEP unicast frame from 00:15:c6:5e:e5:70 with keyidx 3
Aug 16 14:03:58 thinkpad kernel: Using STA key
...


Here is the relevant output from wpa_supplicant -Dwext -ddd:

EAPOL: KEY_RX entering state KEY_RECEIVE
EAPOL: processKey
EAPOL: RX IEEE 802.1X ver=1 type=3 len=57 EAPOL-Key: type=1 key_length=13 key_index=0x1
EAPOL: EAPOL-Key key signature verified
EAPOL: Decrypted(RC4) key - hexdump(len=13): [REMOVED]
EAPOL: Setting dynamic WEP key: broadcast keyidx 1 len 13
wpa_driver_wext_set_key: alg=1 key_idx=1 set_tx=0 seq_len=0 key_len=13
RX EAPOL from 00:15:c6:5e:e5:70
RX EAPOL - hexdump(len=48): 01 03 00 2c 01 00 0d 00 00 46 c4 8d 8a 35 ae f9 fc 6e 64 dc 34 71 cf 55 8f 4f 40 46 4e d2 a1 83 4f b5 fa 93 15 93 7b 02 d3 96 a5 cf e6 74 dd 93
EAPOL: Received EAPOL-Key frame
EAPOL: KEY_RX entering state KEY_RECEIVE
EAPOL: processKey
EAPOL: RX IEEE 802.1X ver=1 type=3 len=44 EAPOL-Key: type=1 key_length=13 key_index=0x83
EAPOL: EAPOL-Key key signature verified
EAPOL: using part of EAP keying material data encryption key - hexdump(len=13): [REMOVED]
EAPOL: Setting dynamic WEP key: unicast keyidx 3 len 13
wpa_driver_wext_set_key: alg=1 key_idx=3 set_tx=128 seq_len=0 key_len=13
EAPOL: all required EAPOL-Key frames received
WPA: EAPOL processing complete
Cancelling authentication timeout
State: ASSOCIATED -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:15:c6:5e:e5:70 completed (auth) [id=0 id_str=]

key_index & 0x80 means unicast, and the actual index is 3 = key_index &
0x03.


