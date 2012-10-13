Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta-blr1.sasken.com ([203.200.200.72]:36019 "EHLO
	mta-blr1.sasken.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2JMGCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Oct 2012 02:02:31 -0400
From: Krishnan Manivannan <krishnan.manivannan@sasken.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 13 Oct 2012 11:21:59 +0530
Subject: Receive all data packets in Managed mode
Message-ID: <2316A524B7DB8C4AB39B9EDEDF597C8F015B779D1DBA@EXGMBX01.sasken.com> (sfid-20121013_080241_347669_C7D9954C)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are experimenting using CARL9170. Firmware Release:"1.9.6"

The VIF is in 'Managed mode' we want to receive data packets of other stations destined to a DS, and get it in the MAC reveive path.
For example, In monitor mode, the VIF receives all packets, by sniffing in the medium & allows all packets of other stations being sent to AP, and deliver it to the upper layers. We want to receive all packets(of other Destination address) in managed mode,

Is it possible to sniff packets in Managed mode. where in data packets sent by other stations are also received?

Although I tried couple of things in Firmware & Carl9170, I coudn't  achieve the result.
1.In ::carlfw/usb/main.c,
   void handle_usb(void)
++   set(AR9170_MAC_REG_SNIFFER, 1);   //added this line to enable sniffing in Managed mode

2. In ::carlfw/src/wlanrx.c
    void handle_wlan_rx(void)
  -- if (!(wlan_rx_filter(desc) & fw.wlan.rx_filter))   //changed this line to
  ++ if( 1 )


In carl9170 module, source code,
  In fine mac.c
  int carl9170_set_operating_mode(struct ar9170 *ar)
  -- carl9170_regwrite(AR9170_MAC_REG_SNIFFER, sniffer);
  ++ carl9170_regwrite(AR9170_MAC_REG_SNIFFER, sniffer | AR9170_MAC_SNIFFER_ENABLE_PROMISC );


In order to achieve this, what changes in firmware/ Carl9170 module needs to be done?


Thanks
Mani

SASKEN BUSINESS DISCLAIMER: This message may contain confidential, proprietary or legally privileged information. In case you are not the original intended Recipient of the message, you must not, directly or indirectly, use, disclose, distribute, print, or copy any part of this message and you are requested to delete it and inform the sender. Any views expressed in this message are those of the individual sender unless otherwise stated. Nothing contained in this message shall be construed as an offer or acceptance of any offer by Sasken Communication Technologies Limited ("Sasken") unless sent with that express intent and with due authority of Sasken. Sasken has taken enough precautions to prevent the spread of viruses. However the company accepts no liability for any damage caused by any virus transmitted by this email.
Read Disclaimer at http://www.sasken.com/extras/mail_disclaimer.html
