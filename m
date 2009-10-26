Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:56264 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZJZNnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:43:14 -0400
From: Holger Schurig <h.schurig@mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Subject: RECAP: indication of channel noise
Date: Mon, 26 Oct 2009 14:42:44 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910261442.44774.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On IRC, Johannes, Felix and I talked about how to indicate the 
noise level towards user-space.

Noise is not really a property of the link, althought derived 
values like SNR are. It can be nice to debug stuff.


However, what hardware value hardware says is a noise level 
variues. For ath5k, it's internal, thermal noise. For ath9k, 
it's external medium noise. Some hardware can determine noise 
only while in a connection, others can do it at any time.

However, noise is only one property of a channel, a wider 
approach would be to define a "site survey API". This could 
include hw cycle counters, e.g. to find out the channel 
utilization.

The idea is to have one API call "do site survey", where you tell 
the driver to scan on specified/all channels to determine those 
values.

And then there's an API call to retrieve this information. For 
hardware where you cannot really scan (e.g. Libertas, Orinoco), 
you can simply call the "retrieve site survey" call without the 
prior scanning and you just get what the hardware knows anyway. 

This makes the retrieve systeam call "cheap" in order to only get 
the noise level, but the API rich in case the hardware has much 
more versatile capabilities.



We did not yet come up with a clear API definition for this. My 
idea for an initial "retrieve site survey" response is:

NL80211_CMD_NEW_SURVEY_RESULTS
  NL80211_ATTR_GENERATION
  NL80211_ATTR_IFINDEX
  NL80211_BSS_FREQUENCY
  NL80211_BSS_NOISE_MBM

Of course this will extend over time, but that is easy due to 
nl80211.

-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
