Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:49430 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab3AaP23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:28:29 -0500
Received: by mail-bk0-f47.google.com with SMTP id jc3so1390584bkc.20
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2013 07:28:28 -0800 (PST)
Message-ID: <510A8D99.8050709@cozybit.com> (sfid-20130131_162833_736555_D0A12C42)
Date: Thu, 31 Jan 2013 16:28:25 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [RFC 1/3] mac80211: move mesh sync beacon handler into neighbour_update
References: <1358936360-7795-1-git-send-email-marco@cozybit.com>  <1358936360-7795-2-git-send-email-marco@cozybit.com>  (sfid-20130123_111931_474759_EEC1974B) <1359639780.8415.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359639780.8415.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2013 02:43 PM, Johannes Berg wrote:
> On Wed, 2013-01-23 at 11:19 +0100, Marco Porsch wrote:
>> Move the beacon handler into mesh_neighbour_update where the STA
>> pointer is already available. This avoids additional overhead
>> and simplifies the handler.
>> The repositioning will also benefit mesh PS which uses the
>> T_offset value right after it has been updated.
>>
>> Rename the handler to better reflect its purpose.
>>
>> Signed-off-by: Marco Porsch <marco@cozybit.com>
>> ---
>>   net/mac80211/ieee80211_i.h |   10 +++++-----
>>   net/mac80211/mesh.c        |    8 ++------
>>   net/mac80211/mesh.h        |    5 +++--
>>   net/mac80211/mesh_plink.c  |   16 ++++++++++++---
>>   net/mac80211/mesh_sync.c   |   47 +++++++++++++++-----------------------------
>>   5 files changed, 39 insertions(+), 47 deletions(-)
>>
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index d77d3f7..e08b4c0 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -560,11 +560,11 @@ struct ieee80211_if_ibss {
>>    */
>>   struct ieee802_11_elems;
>>   struct ieee80211_mesh_sync_ops {
>> -	void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata,
>> -			     u16 stype,
>> -			     struct ieee80211_mgmt *mgmt,
>> -			     struct ieee802_11_elems *elems,
>> -			     struct ieee80211_rx_status *rx_status);
>> +	void (*rx_bcn)(struct sta_info *sta,
>> +		       struct ieee80211_mgmt *mgmt,
>> +		       struct ieee802_11_elems *elems,
>> +		       struct ieee80211_rx_status *rx_status,
>> +		       u64 tsf);
>
> Is anyone actually planning to add more sync ops? I'm tempted to just
> remove the entire abstraction here, since there's only a single concrete
> implementation.

No plans to do so as of now. But since mesh networks are still a 
research topic, there may already be researchers somewhere, happy to 
have that extensible interface.
Also the standard explicitly defines an "Extensible synchronization 
framework" in 13.13.2.

--Marco
