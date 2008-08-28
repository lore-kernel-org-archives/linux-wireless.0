Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:46720 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751471AbYH1PvG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 11:51:06 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <linux-wireless@vger.kernel.org>,
	<rt2400-devel@lists.sourceforge.net>
Subject: Race problem in mac80211/mlme.c and rt2x00
Date: Thu, 28 Aug 2008 17:51:08 +0200
Message-ID: <017001c90925$e31d54c0$0b3ca8c0@gotws1589> (sfid-20080828_175109_886660_8E4D73FA)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have found a race problem in mac80211/mlme.c and rt2x00

When the wpa_supplicant trigs an AP scan, mlme saves current configuration
and start scanning.
When the scan is complete, a SIOCGIWSCAN is sent and the saved configuration
is restored.

Since the SIOCGIWSCAN signal is send before the restore, a wpa_supplicant
initiated SIWFREQ may hit the restore operation.
The result is that local->ops->config() may be called by two different
processes at the 'same' time.

In the rt2x00 driver, rt2x00mac_config() may 'optimise' (skip) the channel
set operation.
The ultimate result/error is that the first authentication will happen on
wrong (old) channel.

I have moved the SIOCGIWSCAN code section after the restore operation and it
seems to work.
There is most likely a better solution but I leave that for the experts :)


/Lars

