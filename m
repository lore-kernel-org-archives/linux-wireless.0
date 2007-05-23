Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51409.mail.re2.yahoo.com ([206.190.38.188]:41154 "HELO
	web51409.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757237AbXEWJzs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2007 05:55:48 -0400
Date: Wed, 23 May 2007 02:49:08 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: RE: [PATCH V6] mac80211: Add support for SIOCGIWRATE ioctl to provide rate information
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Message-ID: <569491.18256.qm@web51409.mail.re2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,
what does SIOCGIWRATE do for IBSS networks? In this case you might have a different rate for every node in your network. Looking up just "sdata->u.sta.bssid" is insufficient because the BSSID of an IBSS network is not a real MAC address (after all, there is no AP).

I would very much like an official way to enumerate the current rates for all known stations in an IBSS network. This information would be useful for AdHoc routing: Currently most approaches use packet loss to weight different links. In this case a link might look better than it actually is, because rate control already lowered the current rate to a level where no packet loss occured whereas another link with higher data rate looks bad because it drops a packet now and than.

Is there a way to get this information?
 
--  
Regards
 
       Joerg
 






       __________________________________ Yahoo! Clever - Der einfachste Weg, Fragen zu stellen und Wissenswertes mit Anderen zu teilen. www.yahoo.de/clever

