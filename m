Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51015 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab1EFAoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 20:44:23 -0400
Message-ID: <4DC34465.6090108@openwrt.org> (sfid-20110506_024429_821215_51C1618F)
Date: Fri, 06 May 2011 02:44:21 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bisected:  ath9k: fix powersave frame filtering/buffering in
 AP mode broke STA association.
References: <4DC30C42.6070402@candelatech.com> <4DC3109F.6080601@openwrt.org> <4DC3135C.4040601@candelatech.com> <4DC31A0B.4040409@candelatech.com> <4DC31C91.1030303@openwrt.org> <4DC33DE2.1070508@candelatech.com>
In-Reply-To: <4DC33DE2.1070508@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-06 2:16 AM, Ben Greear wrote:
> On 05/05/2011 02:54 PM, Felix Fietkau wrote:
>>  On 2011-05-05 11:43 PM, Ben Greear wrote:
>>>  On 05/05/2011 02:15 PM, Ben Greear wrote:
>>>>  On 05/05/2011 02:03 PM, Felix Fietkau wrote:
>>>>>  On 2011-05-05 10:44 PM, Ben Greear wrote:
>>>>>>  I bisected the problem I was having with ath9k STA configured for WPA
>>>>>>  not being able to authenticate. I'm using nohwcrypt=1, which may
>>>>>>  be why no one else sees it.
>>>>
>>>>>>  I'll be happy to test patches, it seems very easy to reproduce on
>>>>>>  my setup.
>>>>>  How about this?
>>>>>
>>>>>  --- a/net/mac80211/tx.c
>>>>>  +++ b/net/mac80211/tx.c
>>>>>  @@ -1270,6 +1270,9 @@ ieee80211_tx_prepare(struct ieee80211_su
>>>>>  info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>>>>  else if (test_and_clear_sta_flags(tx->sta, WLAN_STA_CLEAR_PS_FILT))
>>>>>  info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>>>>  + else if (sdata->vif.type != NL80211_IFTYPE_AP&&
>>>>>  + sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
>>>>>  + info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
>>>>>
>>>>>  hdrlen = ieee80211_hdrlen(hdr->frame_control);
>>>>>  if (skb->len>  hdrlen + sizeof(rfc1042_header) + 2) {
>>>>
>>>>  Yes, that seems to fix the problem.
>>>>
>>>>  Thanks for the quick fix!
>>>
>>>  Well, that appeared to fix the problem on -rc1, but when I go
>>>  back to -rc6 and apply that patch, it still doesn't work.
>>>
>>>  Might be some other issue though...
>>  Odd. Please try bisecting by applying the patch for each test and
>>  reverting it before running git bisect again.
> 
> Unless I made a mistake, it's this patch that causes the next problem:
> 
> [greearb@build-32 linux.wt]$ git bisect bad
> 93ae2dd2230393566738a5f211ffbaa33b056d56 is the first bad commit
> commit 93ae2dd2230393566738a5f211ffbaa33b056d56
> Author: Felix Fietkau<nbd@openwrt.org>
> Date:   Sun Apr 17 23:28:10 2011 +0200
> 
>       ath9k: assign keycache slots to unencrypted stations
> 
> Makes me wonder if I'm the only one crazy enough to actually use
> wireless testing :P
I use compat-wireless based on wireless-testing all the time, but in my
tests, I did not encounter the issues that you're reporting, no idea
why.

This should fix the second issue:

--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1722,6 +1722,10 @@ static int ath9k_sta_add(struct ieee8021
 	struct ath_node *an = (struct ath_node *) sta->drv_priv;
 	struct ieee80211_key_conf ps_key = { };
 
+	if (vif->opmode != NL80211_IFTYPE_AP &&
+	    vif->opmode != NL80211_IFTYPE_AP_VLAN)
+		return 0;
+
 	ath_node_attach(sc, sta);
 	an->ps_key = ath_key_config(common, vif, sta, &ps_key);
 
