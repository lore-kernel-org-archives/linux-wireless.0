Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35600 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756019AbXFAQOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 12:14:43 -0400
Message-ID: <466045F2.6010708@lwfinger.net>
Date: Fri, 01 Jun 2007 11:14:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: mac80211 initial rate: a question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In routine rate_control_simple_rate_init in net/mac80211/rc80211_simple.c, there is a comment that says

         /* TODO: what is a good starting rate for STA? About middle? Maybe not
          * the lowest or the highest rate.. Could consider using RSSI from
          * previous packets? Need to have IEEE 802.1X auth succeed immediately
          * after assoc.. */

After that the code goes on to set the rate equal to the last one in the rate table, which might be 
the highest rate. Although that rate might be OK for most of the devices using mac80211, it 
certainly is not for bcm43xx, which does not have the ability to transmit or receive at speeds much 
above 1 Mbs. In a private patch circulated only on the bcm43xx mailing list, I changed this routine 
to set an initial rate of 1 Mbs, which certainly helps bcm43xx authenticate and communicate with the 
DHCP server.

If this low rate were to be set for all drivers, how rapidly would the rate-control algorithm 
respond? Would this cause a serious performance degradation?

Larry
