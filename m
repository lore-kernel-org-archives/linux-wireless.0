Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:39139 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191AbZGRRs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 13:48:56 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: WARN_ON at minstrel_get_rate (include/net/mac80211.h:2111)
Date: Sat, 18 Jul 2009 19:48:54 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
References: <4A611FC0.9040507@lwfinger.net> <4A61E436.9060808@lwfinger.net> <200907181808.05142.chunkeey@web.de>
In-Reply-To: <200907181808.05142.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200907181948.54594.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 18 July 2009 18:08:04 Christian Lamparter wrote:
> On Saturday 18 July 2009 17:03:18 Larry Finger wrote:
> > Thanks for the patch. I'll let you know what happens.
> I have my doubts. Do you still have the WARN_ON dump?
> or at least which of the two functions are listed in the dump?
> - rate_control_get_rate 
> - rate_control_rate_init <- unlikely/really surprising

found a similar WARNINGs on kerneloops:
http://www.kerneloops.org/raw.php?rawid=449304&msgid= 
but the user has ath5k.

and there's more: iwlagn used to have this issue, but they fixed it.
---
commit c338ba3ca5bef2df2082d9e8d336ff7b2880c326                                                                                        
Author: Abbas, Mohamed <mohamed.abbas@intel.com>                                                                                       
Date:   Wed Jan 21 10:58:02 2009 -0800 

    iwlwifi: fix rs_get_rate WARN_ON()
                                      
    In ieee80211_sta structure there is u64 supp_rates[IEEE80211_NUM_BANDS]
    this is filled with all support rate from assoc_resp.  If we associate 
    with G-band AP only supp_rates of G-band will be set the other band    
    supp_rates will be set to 0. If the user type this command             
    this will cause mac80211 to set to new channel, mac80211               
    does not disassociate in setting new channel, so the active            
    band is now A-band. then in handling the new essid mac80211 will       
    kick in the assoc steps which involve sending disassociation frame.    
    in this mac80211 will WARN_ON sta->supp_rates[A_BAND] == 0.    
---

Larry, can you confirm that the frame which triggers the WARN is a
disassociation frame. 
