Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:60413 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751285Ab2KGHyx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 02:54:53 -0500
Message-ID: <509A11F9.8050108@posedge.com> (sfid-20121107_085455_907313_19D3A586)
Date: Wed, 07 Nov 2012 13:17:05 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: Johannes Berg <johannes@sipsolutions.net>
Subject: Clarification needed on Last Tx Rate statistic update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

I am Saravana and i am currently working on adding statistics. It will 
be really helpful if someone could provide me clarification related to 
Last Tx Rate statistics.

In ieee80211_tx_status(), the Last Tx Rate (sta->last_tx_rate) update 
happens only when the rate control is done by the HW 
(IEEE80211_HW_HAS_RATE_CONTROL) .
My understanding is that irrespective of whether the rate control is 
done by the hardware or not, the driver will fill up all the rates that 
it had tried along with the retry count for each rate to 
ieee80211_tx_status() using the
  struct ieee80211_tx_info (info->status.rates).

  The 'info->status.rates[rates_idx]' would point to the rate with which 
the packet transmission has occured irrespective of the where the rate 
control is done.

Could somebody clarify why the statistics update happens only when the 
rate control is done by the hardware(flag IEEE80211_HW_HAS_RATE_CONTROL 
is set)?

Thanks,
Saravana
