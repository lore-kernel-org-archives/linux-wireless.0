Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43254 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbeH1PpF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 11:45:05 -0400
Subject: Re: [PATCH] mac80211: WFA Multi-AP backhaul STA Rx requirement
To: Johannes Berg <johannes@sipsolutions.net>,
        Sathishkumar Muruganandam <murugana@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <1534423635-28222-1-git-send-email-murugana@codeaurora.org>
 <1535450281.5895.34.camel@sipsolutions.net>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <4156a91b-cea4-8942-23ad-6377ac50a804@nbd.name> (sfid-20180828_135350_104520_931A7A29)
Date: Tue, 28 Aug 2018 13:53:42 +0200
MIME-Version: 1.0
In-Reply-To: <1535450281.5895.34.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-08-28 11:58, Johannes Berg wrote:
>> ---
>>  net/mac80211/rx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
>> index a16ba568e2a3..686e5586e1f4 100644
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -2313,7 +2313,7 @@ __ieee80211_data_to_8023(struct ieee80211_rx_data *rx, bool *port_control)
>>  
>>  		if (!sdata->u.mgd.use_4addr)
>>  			return -1;
>> -		else
>> +		else if (!ether_addr_equal(hdr->addr1, sdata->vif.addr))
>>  			check_port_control = true;
> 
> I guess I have no objection to this. Felix?
No objection from me.

- Felix
