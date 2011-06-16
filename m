Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.3eti.com ([65.220.88.139]:44009 "EHLO 3eSpam.3eti.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754463Ab1FPOwy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 10:52:54 -0400
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Help on AMPDU stuck in transmit queue
Date: Thu, 16 Jun 2011 14:32:46 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D05822A57@RockMX01.rock.corp> (sfid-20110616_165258_539667_5E53E4F3)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Linux wireles experts,

Here is my problem. If anyone can throw some ideas, I would appreciate it.

I have a customized router board which has one wireless card (ath9160) and one Ethernet port. The ath9160 is (and must be) put in client mode. My customization is to translate packet strictly between Ethernet port and wireless port so that the board can be used for old PC to access wireless network.

I am running kernel 2.6.38.5. I made a mini module which always forwards data packets between wireless port and Ethernet port. 
In addition, I made two small changes as follows.
1. On wireless Tx path (in ieee80211_subif_start_xmit() defined in mac80211). The change is to replace source address (the MAC of old PC) with wireless radio MAC (ath9160).
2. On wireless Rx path (in ieee80211_deliver_skb() defined in mac80211). The change is to replace destination address (ath9160 MAC) with MAC of my old PC.

My customization works very well when 802.11n is disabled on AP which is hostapd based on nl80211 driver.
When 802.11n is enabled on AP, my customization works only for the first few minutes. (Ping packets from old PC to AP go through well). After a few minutes, wireless radio (ath9160) on my customized router board won't transmit any ping packet. I see AMPDU stuck in transmit queue based on the info from /debugfs/ieee80211/phy0/ath9k/xmit as follows

                            BE         BK        VI        VO

MPDUs Queued:              126          0         0      4261
MPDUs Completed:           126          0         0      4261
Aggregates:                  0          0         0         0
AMPDUs Queued:            4002          0         0         0
AMPDUs Completed:         3877          0         0         0
AMPDUs Retried:              0          0         0         0
AMPDUs XRetried:             1          0         0         0
FIFO Underrun:               0          0         0         0
TXOP Exceeded:               0          0         0         0
TXTIMER Expiry:              0          0         0         0
DESC CFG Error:              0          0         0         0
DATA Underrun:               0          0         0         0
DELIM Underrun:              0          0         0         0
TX-Pkts-All:              4004          0         0      4261
TX-Bytes-All:           462852          0         0    105128


I noticed that when 11n is disable, MPDUs are sent and the "MPDUs queued" == "MPDUs completed".
When 11n is enabled, AMPDUs are sent and the "AMPDUs queued"=="AMPDUs Complete" only for the first few minutes. After that, "AMPDUs Complete" stop incrementing.

I also sniffed the air, the "NULL data packet" is still sent out as usual (it's also reflected in the number "MPDUs Queued and Completed" in VO queue). But no ping packets at all.

Without my customization, the wireless client (standalone) on router board works very well with the AP with 11n enabled. This eliminates the AP or client issue.

I also tried another radio (ar9380). The symptom is exactly the same.

Any help on the following is highly appreciated.
1. Point out the issue, or 
2. Throw some idea on how to investigate, or 
3. Tell me how that AMPDU works in ath9k (mac80211).
4. Anywhere in ath9k or mac80211 that is sensitive to the address change.


Thanks

Chaoxing

