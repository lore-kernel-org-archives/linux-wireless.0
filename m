Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4521 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1BIM71 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 07:59:27 -0500
cc: linux-wireless <linux-wireless@vger.kernel.org>
To: "Johannes Berg" <johannes@sipsolutions.net>
Date: Wed, 9 Feb 2011 13:59:10 +0100
Subject: implicit band switch or not
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vqmzowhl3ri7v4@arend-laptop>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

With our mac80211-based driver I was associated with 5GHz AP and ran into  
an assert. Investigating this I found that a software scan was initiated  
and our driver got a probe request from mac80211 to be transmitted.  
However, it turned out that the transmit rate was a 2GHz rate and our  
driver was still configured to 5GHz band. The ieee80211_tx_info also  
contained the band and indeed that was for 2GHz. Given the comment for the  
band attribute I am wondering whether we should a band switch implicitly  
or not:

  * @band: the band to transmit on (use for checking for races)

Any suggestions? Are we have a race condition here?

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

