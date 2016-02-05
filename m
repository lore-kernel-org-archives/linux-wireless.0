Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35140 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbcBETZl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 14:25:41 -0500
Received: by mail-wm0-f53.google.com with SMTP id r129so40518272wmr.0
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2016 11:25:40 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Eric Hillary <eric.hillary-1@nasa.gov>
Cc: linux-wireless@vger.kernel.org
Subject: [RESEND] Re: carl9170 client RTS/CTS option being overridden by WAP's WMM option
Date: Fri, 05 Feb 2016 20:25:37 +0100
Message-ID: <2823949.eMyd5ddxzU@debian64> (sfid-20160205_202544_593617_F29B80BA)
In-Reply-To: <loom.20160205T170355-618@post.gmane.org>
References: <loom.20160205T170355-618@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, February 05, 2016 04:07:22 PM Eric Hillary wrote:
> Has anyone experienced that RTS/CTS handshaking stops occurring at the
> client if the the access point enables WMM?
yes, the 802.11-draftn device has problems (rx and tx become stuck) with
802.11n and proper WMM (and with RTS/CTS). Sadly, I don't know of any
workaround that works for all the configurations I tested, other than 
going for a ath9k_htc device. 
 
> Using the carl9170 driver with RTS/CTS handshaking enabled on a USB 
> Ubiquiti SR71-USB (Atheros AR9170 based wireless adapter).  RTS/CTS will 
> stop working when WMM is enabled on the WAP.  
You can overwrite carl9170's behavior (per device). You need to have 
DEBUGFS enabled for the driver (CONFIG_CARL9170_DEBUGFS). There is a
control setting in: /sys/kernel/debug/ieee80211/phyX/carl9170/erp

1 - Automatic (default)
2 - Set by mac80211
3 - Force off
4 - Force CTS
5 - Force RTS

You can try echo 2 > erp. And check the setting with cat erp
> The network is running in 802.11n C-band (5GHz) channels in 
> Infrastructure mode with an Atheros AR9370 based Access Point.  We are 
> using RTS/CTS handshaking to reduce “Hidden Node” effects.  Other 
> clients in the network require WMM to be enabled.  For reasons cited in 
> http://www.smallnetbuilder.com/wireless/wireless-features/30938-dont-
> mess-with-wmm, WMM should be enabled to support 802.11e, 
> required for 802.11n to use HT (High Throughput) link rates.
> 
> With the WMM turned OFF at the AP and RTS value = 256 at the Ubiquiti 
> client, the RTS/CTS handshake functions normally.  With WMM turned ON at 
> the AP and RTS value = 256 still on at the client no RTS/CTS handshake 
> occurs.  The carl9170 client stops sending the RTS, and the carl1970 
> client ignoring the CTS messages transmitted by the AP, causing 
> collisions because of my “Hidden Node” condition.
> 
> Had to get scope plots of the RF network traffic between the AP and 
> client to observe this happening.
scope plots from a real analyzer? I would love to have a look at those :).

Regards,
Christian
