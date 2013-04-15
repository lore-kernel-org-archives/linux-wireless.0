Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-1.exch022.serverdata.net ([64.78.56.53]:16521 "EHLO
	HUB022-ca-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317Ab3DOKnj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 06:43:39 -0400
Message-ID: <516BD9D7.3060804@posedge.com> (sfid-20130415_124343_618919_2D15DB9F)
Date: Mon, 15 Apr 2013 16:13:35 +0530
From: Vivekananda Holla <vivekanandah@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Patch] mac80211: add rts-cts for dynamic SMPS stations
References: <516B9F21.2080304@posedge.com> <1366017844.8361.7.camel@jlt4.sipsolutions.net>
In-Reply-To: <1366017844.8361.7.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

I ran checkpatch.pl script and found some trailing white spaces in the patch which i have now
corrected.
 
Also,i had initially placed my code in minstrel_ht_get_rate but saw that the minstrel code is being
changed.
hence, moved the code in to ieee80211_tx_h_rate_ctrl function.

there is a check in this function

        if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS) {
            WARN_ON(info->control.rates[i].idx > 76);
            continue;
        }
 
I feel it would be okay to move  the code for dyn_smps within this loop as
this would solve the check for MCS rates.

however i am not sure whether all ht rates flag settings need to be handled within minstrel_ht?

        if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS) {
            WARN_ON(info->control.rates[i].idx > 76);

+        if (dyn_smps) {
+            if ((info->control.rates[i].idx > 7) &&
+                (info->control.rates[i].idx != 32))
+                info->control.rates[i].flags |=
+                    IEEE80211_TX_RC_USE_RTS_CTS;    


            continue;
        }

awaiting your inputs

thanks and regards
Vivek

On 04/15/2013 02:54 PM, Johannes Berg wrote:
> Vivek,
>
> Please work with some of your colleagues at posedge to submit a proper
> patch. This is formatted completely wrongly in many ways.
>
>> +        if (dyn_smps) {
>> +            if ((info->control.rates[i].idx > 7) &&
>> +                (info->control.rates[i].idx != 32))
> This is also completely wrong. (hint, there are non-HT bitrates still)
>
> johannes
>

