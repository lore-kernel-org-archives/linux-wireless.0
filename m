Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.clemson.edu ([130.127.28.87]:43721 "EHLO CLEMSON.EDU"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753277AbXJQWa6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Oct 2007 18:30:58 -0400
Received: from wm.clemson.edu (wm.clemson.edu [130.127.28.88])
	by CLEMSON.EDU (8.13.6/8.13.1) with ESMTP id l9HMFtjA012060
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 17 Oct 2007 18:15:56 -0400 (EDT)
Message-ID: <60980.172.22.4.212.1192659355.squirrel@wm.clemson.edu> (sfid-20071017_233100_913562_5223528C)
Date: Wed, 17 Oct 2007 18:15:55 -0400 (EDT)
Subject: Re: iwl3945 doesn't work
From: bmoss@CLEMSON.EDU
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have observed that 'iwlist wlan0 scan' sometimes fails to produce a scan
and manual configuration with iwconfig sometimes fails to produce an
association. I also observed that the Fedora 8 configuration script issues
the command 'ip link set wlan0 up' before configuring the wlan0 and it
always works. I also noted in the Intel documentation that the command
'ifconfig wlan0 up' should be issued before configuing the wlan0. For
manual configuration, I now use

ifconfig wlan0 up
ip link set wlan0 up
iwconfig wlan0 mode Managed
iwconfig wlan0 key xxxxxxxxxxxxxxxxxxxxxxxxxx
iwconfig wlan0 essid mosswap
dhclient wlan0

It always works.

I believe the iwl3945 driver is broken when there are hidden AP's in the
scan list. It appears that the scan list returned to wpa_supplicant is
corrupted which is why the wpa_supplicant setting ap_scan=2 does not for
hidden AP's.

With hardware scanning enabled as a module option, it appears that iwl3945
does both a background scan and a scan by ssid when the ssid is set unlike
ipw2200 which does background scans constantly and only does scan by ssid
when it is requested.

Bill Moss
