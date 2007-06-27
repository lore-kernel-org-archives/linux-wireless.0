Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:55973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXF0Qy3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 12:54:29 -0400
Subject: Re: ieee80211_rx_mgmt: pushing fake 'management' frames into  userspace
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200706271730.59591.hs4233@mail.mn-solutions.de>
References: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com>
	 <1182952910.4769.20.camel@johannes.berg>
	 <200706271730.59591.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 12:59:11 -0400
Message-Id: <1182963551.16744.26.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-06-27 at 17:30 +0200, Holger Schurig wrote:
> > Also, I thought you were doing a fullmac chipset? Then you
> > shouldn't be worrying about mac80211 *at all*
> 
> Yes, unfortunately.
> 
> Currently, Linux has only fullmac and softmac. However, I'm 
> working with a half-soft-half-full-mac hardware (libertas). What 
> I mean is that the generation of the low-level packets etc are 
> all done by the firmware in the card (fullmac). However, 
> issueing scans (for IBSS or Managed mode), selecting a proper AP 
> from the scan result, associating etc are all commands that the 
> PC has to send to the firmware.

Are you talking about 88w838x parts here?

> Some of this is not yet correctly working, e.g. when I kick out 
> the WLAN card from the AP, then libertas just notifies this, but 
> stays up ... it doesn't re-scan and re-associates. There are 
> other scenarios where the current libertas code doesn't 
> automatically re-scan/re-associate as well.
> 
> All of this is included in net/mac80211/ieee80211_sta.c, but 
> tightly coupled to mac80211 so that it is unusable for 
> non-mac80211 cards. Sigh.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

