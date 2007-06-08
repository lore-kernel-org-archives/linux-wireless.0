Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:63802 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752864AbXFHECO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 00:02:14 -0400
Message-ID: <4668D4C4.1050808@lwfinger.net>
Date: Thu, 07 Jun 2007 23:02:12 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] mac80211: Implementation of SIOCSIWRATE
References: <4668a64b.VmU9f2GpA2itSuFx%Larry.Finger@lwfinger.net> <200706071819.45603.flamingice@sourmilk.net>
In-Reply-To: <200706071819.45603.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Thursday 07 June 2007 17:43, Larry Finger wrote:

>> +			sta->supp_rates = supp;
> This is definitely wrong. What rates we support has nothing to do with what 
> rates the AP supports.

If sta->supp_rates is not changed, how do you lock in a single rate as would be expected from an 
'iwconfig ethX rate 11M'? Won't the following code in the rate_control_rate_dec routine of 
rc80211_simple just decrease the rate if it wants to?

         while (i > 0) {
                 i--;
                 if (sta->supp_rates & BIT(i) &&
                     mode->rates[i].flags & IEEE80211_RATE_SUPPORTED) {
                         sta->txrate = i;
                         break;
                 }
         }


Larry
