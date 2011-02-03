Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:40550 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200Ab1BCK7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 05:59:30 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PkwuM-0000OJ-L6
	for linux-wireless@vger.kernel.org; Thu, 03 Feb 2011 11:59:29 +0100
Received: from san_juan-143-68.umh.es ([san_juan-143-68.umh.es])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 11:59:26 +0100
Received: from baldo.ath9k by san_juan-143-68.umh.es with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 11:59:26 +0100
To: linux-wireless@vger.kernel.org
From: Baldomero Coll <baldo.ath9k@gmail.com>
Subject: Re: [RFC] mac80211: support for IEEE80211N in IBSS
Date: Thu, 3 Feb 2011 10:59:06 +0000 (UTC)
Message-ID: <loom.20110203T115745-317@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I have sacesfully installed the IBSS HT support patches [1] [2], but something
wrong happends when the network is created. Any idea why this happens?

[1]
# iw --debug dev wlan0 ibss join "uwicoreHT" 2412 HT20
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE ---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 36
    .nlmsg_type = 2 <ERROR>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 1296727732
    .nlmsg_pid = 2350
  [ERRORMSG] 20 octets
    .error = 0 "Success"
  [ORIGINAL MESSAGE] 16 octets
    .nlmsg_len = 16
    .nlmsg_type = 23 <0x17>
    .nlmsg_flags = 5 <REQUEST,ACK>
    .nlmsg_seq = 1296727732
    .nlmsg_pid = 2350
---------------------------  END NETLINK MESSAGE   ---------------------------

[2]
iw --debug dev wlan0 ibss join "uwicoreHT" 2412 HT40-
-- Debug: Received Message:
--------------------------   BEGIN NETLINK MESSAGE ---------------------------
  [HEADER] 16 octets
    .nlmsg_len = 36
    .nlmsg_type = 2 <ERROR>
    .nlmsg_flags = 0 <>
    .nlmsg_seq = 1296727811
    .nlmsg_pid = 2354
  [ERRORMSG] 20 octets
    .error = 0 "Success"
  [ORIGINAL MESSAGE] 16 octets
    .nlmsg_len = 16
    .nlmsg_type = 23 <0x17>
    .nlmsg_flags = 5 <REQUEST,ACK>
    .nlmsg_seq = 1296727811
    .nlmsg_pid = 2354
---------------------------  END NETLINK MESSAGE   ---------------------------

[3]
As a result, the iwconfig shows the following:

wlan0     IEEE 802.11abgn  ESSID:"uwicoreHT"  
          Mode:Ad-Hoc  Frequency:2.412 GHz  Cell: Not-Associated   
          Tx-Power=30 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

(After few seconds the ESSID disappear)

wlan0     IEEE 802.11abgn  Mode:Ad-Hoc  Frequency:2.412 GHz  
          Cell: Not-Associated   Tx-Power=27 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



