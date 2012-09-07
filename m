Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:51805 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab2IGMSs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 08:18:48 -0400
Message-ID: <5049E62B.3050305@lri.fr> (sfid-20120907_141851_587147_11A58E59)
Date: Fri, 07 Sep 2012 14:18:51 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mac80211: export ieee80211_send_deauth_disassoc
 for usage outside of mlme.c
References: <1346951275-32081-1-git-send-email-ordex@autistici.org>    (sfid-20120906_190828_405993_603EB9FF) <1347006332.4256.9.camel@jlt4.sipsolutions.net>   <5049C35A.1050601@lri.fr> <1347016689.4256.10.camel@jlt4.sipsolutions.net>  <5049E236.2020502@lri.fr> <1347019529.4256.20.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347019529.4256.20.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2012 14:05, Johannes Berg wrote:
> On Fri, 2012-09-07 at 14:01 +0200, Nicolas Cavallari wrote:
> 
>>>> Or just never set TX_INTFL_DONT_ENCRYPT at all and rely on
>>>> ieee80211_tx_h_select_key() to do the right thing ?
>>>
>>> I don't think it can do the right thing, it doesn't check whether MFP is
>>> enabled or not...
>>
>> It does; The first part try to encrypt everything, the second part
>> disable encryption if ccmp is selected and !ieee80211_is_data_present &&
>> !ieee80211_use_mfp,
>> which test, among other things, for the sta's WLAN_STA_MFP flag if sta
>> != null.
> 
> Good point.
> 
>> If tx_h_select_key does not select the right key in this case, i think
>> we have bigger problems.
> 
> Maybe, maybe not. But it looks like it would be safe.
> 
>>> unless you want to test all those cases I'd rather not
>>> change it :)
>>
>> Not worth the trouble in this case, but i think there is too much code
>> that sets TX_INTFL_DONT_ENCRYPT when it shouldn't.
> 
> I already applied the v3 patchset, but even if I hadn't I'd say it
> should be a separate patch(set), want to send some patches to remove
> them? :)

I'll do that later, along with some other 802.11 2012 crypto work.
