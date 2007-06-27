Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:25408 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbXF0Paa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 11:30:30 -0400
Received: from lin01.mn-solutions.de (pD95F8D8F.dip0.t-ipconnect.de [217.95.141.143])
	by s131.mittwaldmedien.de (Postfix) with ESMTP id 6636B5E408D
	for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2007 17:30:29 +0200 (CEST)
Received: from mnz66.mn-solutions.de.mn-solutions.de (mnz66.mn-logistik.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id C5A0A1E002B
	for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2007 17:30:23 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: ieee80211_rx_mgmt: pushing fake 'management' frames into userspace
Date: Wed, 27 Jun 2007 17:30:59 +0200
References: <A2CE5E0A70B68046A98EB5145552E27701173B8F@sinse303.ap.infineon.com> <1182952910.4769.20.camel@johannes.berg>
In-Reply-To: <1182952910.4769.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200706271730.59591.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Also, I thought you were doing a fullmac chipset? Then you
> shouldn't be worrying about mac80211 *at all*

Yes, unfortunately.

Currently, Linux has only fullmac and softmac. However, I'm 
working with a half-soft-half-full-mac hardware (libertas). What 
I mean is that the generation of the low-level packets etc are 
all done by the firmware in the card (fullmac). However, 
issueing scans (for IBSS or Managed mode), selecting a proper AP 
from the scan result, associating etc are all commands that the 
PC has to send to the firmware.

Some of this is not yet correctly working, e.g. when I kick out 
the WLAN card from the AP, then libertas just notifies this, but 
stays up ... it doesn't re-scan and re-associates. There are 
other scenarios where the current libertas code doesn't 
automatically re-scan/re-associate as well.

All of this is included in net/mac80211/ieee80211_sta.c, but 
tightly coupled to mac80211 so that it is unusable for 
non-mac80211 cards. Sigh.
