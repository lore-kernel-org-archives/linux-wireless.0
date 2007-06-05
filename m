Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:58977 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762862AbXFEUv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 16:51:58 -0400
Message-ID: <4665CCE7.5090409@lwfinger.net>
Date: Tue, 05 Jun 2007 15:51:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: RFC: Regulatory info in mac80211
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Given the recent discussions of regulatory/geographic domain compliance (or lack thereof) in 
mac80211, and the fact that the software is mainlined in 2.6.22, it seems a good time to start 
planning for full implementation of regulatory information in mac80211.

Roughly a year ago, I worked on such a scheme for ieee80211, but put the project on hold when I 
learned that ieee80211 and ieee80211_softmac, which is used by my driver of interest, would be 
replaced by mac80211. The project was far from complete; however, a number of individuals responded 
to my RFC's and suggested the following (the netdev archives should contain the E-mails):

1. The regulatory information is too dynamic to be placed in the kernel.

2. The regulatory database should be in an ASCII file for easy updating. This database should be 
read by a userspace daemon that reformats the information and supplies it to mac80211 upon demand.

3. There should be some sort of checking to verify that the database has not been hacked to modify 
transmission power, etc. in an illegal manner. Obviously, no foolproof means of enforcing this does 
not exist; however, we should prevent the crudest form of modifications.

4. The database should incorporate the parameters needed for 802.11a, 802.11b/g/n, 802.11d, and 802.11h.

5. There should be a scheme for translating country codes based on the outdated table 105 in 
Corrigendum 1 for 802.11b. This is the basis for the EEPROM data in the ZD1211 hardware. Note, this 
scheme is far too limited to be the only one available. If the translation code is needed for more 
than one driver, it should be placed in mac80211.

6. In case of errors such as the user daemon not running, database corruption, an illegal region 
code from the driver, etc., mac80211 should set a default set of parameters that are legal 
everywhere, and log a suitable error message.

7. ??

To begin such an undertaking, the following steps need to be done:

1. Decide what information is required. These data include, but are not limited to, the band, the 
maximum E.I.R.P. in dBm, whether the data are for indoors/outdoors/both, an indication regarding the 
use of active vs passive scans, allowed protocols, etc. I don't know enough about 802.11h to know 
what data will be required.

2. Accumulate the necessary regulatory data for the world. I found a source for such information. 
Although its price (2500 euro) was a significant problem, the NDA that went with it was a show 
stopper. The diversity of regulations is much greater than I expected. Although, I had only 
collected data on roughly half the countries in the ISO 3166 country codes, I had found 12 distinct 
sets of rules for the 2.4 GHz band and 17 sets in the 5 GHz bands, without any 802.11h information.

3. Decide on how to store this information within mac80211.

4. Decide on the structure of the ASCII database and the means of communication between the daemon 
and the kernel.

5. Prepare the data file and code the userspace and kernel components.

6. Other....

I welcome your comments.

Larry
