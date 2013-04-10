Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-3.exch022.serverdata.net ([64.78.56.55]:60144 "EHLO
	HUB022-ca-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752731Ab3DJJfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 05:35:45 -0400
Message-ID: <5165326C.7010706@posedge.com> (sfid-20130410_113549_691617_5317A2D3)
Date: Wed, 10 Apr 2013 15:05:40 +0530
From: Vivekananda Holla <vivekanandah@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Patch] mac80211: SMPS for AP Mode
References: <516528C8.90509@posedge.com>  (sfid-20130410_105443_117821_9F07C071) <1365584151.8388.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365584151.8388.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Johannes,

do you mean the IEEE80211_TX_RC_USE_RTS_CTS flag to set RTS/CTS protection for the packet?

I did not use this based on the below understanding

my understanding for SMPS is that a station system does not need to send an RTS packet before frame transmission for SMPS however an AP system needs to send out an RTS frame.

hence, I defined a new txinfo flag which tells the lower driver (if AP) to send RTS frame if the station for which the packet is scheduled is dynamic SMPS to set the RTS frame for the same.

awaiting your feedback

thanks and regards
Vivek



On 04/10/2013 02:25 PM, Johannes Berg wrote:
> On Wed, 2013-04-10 at 14:24 +0530, Vivekananda Holla wrote:
>> Patch for SMPS mode for AP. This is to define a new ieee80211_tx_info flag to allow a lower AP driver to set RTS/CTS protection for a dynamic SMPS station
>>
>> Signed-off-by: Vivekananda Holla <vivekanandah@posedge.com>
>> ---
>>  include/net/mac80211.h             |    4 ++++
>>  net/mac80211/rc80211_minstrel_ht.c |    3 +++
>>  2 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index 64faf01..48a950c 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -458,6 +458,9 @@ struct ieee80211_bss_conf {
>>   * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
>>   *    would be fragmented by size (this is optional, only used for
>>   *    monitor injection).
>> + * @IEEE80211_TX_CTL_SMPS_SET_RTS: set the RTS/CTS protection mechanism
>> + *    for the packet at AP when SMPS mode at the station is 
>> + *    dynamic SMPS.
> Huh? No ... There are perfectly usable flags already inside each rate.
>
> johannes
>

