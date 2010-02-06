Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:52627 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab0BFR2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 12:28:00 -0500
Received: by bwz19 with SMTP id 19so702559bwz.28
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2010 09:27:58 -0800 (PST)
From: Holger Schurig <holgerschurig@googlemail.com>
To: David Kilroy <kilroyd@googlemail.com>
Subject: Re: [RFC 0/2] cfg80211: Retrieve missing BSS info after connect
Date: Sat, 6 Feb 2010 18:27:48 +0100
Cc: linux-wireless@vger.kernel.org, sameo@linux.intel.com,
	dcbw@redhat.com
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201002061827.48913.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It sounds like the libertas cfg80211 drivers have the same problem, so I'm
> posting them in case they're useful.

I'm not sure about that.

One thing that I'm sure of is that for the Libertas case I need to scan 
*before* the connection takes place. The Libertas firmware doesn't roam by 
itself, so I don't tell her an SSID like you'll tell the orinoco firmware.

Instead the libertas firmware needs a BSSID where it should connect to. If 
you let do wpa_supplicant do the job (even for WEP), that's no problem, 
because wpa_supplicant always scans and then connects to a specific BSSID, 
which suits Libertas very well.

As for sending back then cfg80211_connect_result() to cfg80211, I'm using 
the IEs from the firmware CMD_802_11_ASSOCIATE command, which seems to work 
quite nicely.



The only thing where Libertas would need a scan during connect if someone 
tries to connect to an AP without a previous scan using the "iw wlan0 
connect" command. Not sure what Simon did here, but my previous v4 patch 
simply failed.

-- 
http://www.holgerschurig.de
