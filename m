Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:35811 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab2KVTNT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 14:13:19 -0500
Message-ID: <50ADE320.3010403@neratec.com> (sfid-20121122_201326_272952_1523E8DC)
Date: Thu, 22 Nov 2012 09:32:32 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: support radiotap vendor namespace RX data
References: <1353061591-22284-1-git-send-email-johannes@sipsolutions.net>   <87ehjtygci.fsf@purkki.adurom.net>  <1353063966.9490.1.camel@jlt4.sipsolutions.net>  <50ADE0E3.2020909@neratec.com> <1353573266.9806.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353573266.9806.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/22/2012 09:34 AM, Johannes Berg wrote:
> On Thu, 2012-11-22 at 09:22 +0100, Wojciech Dubowik wrote:
>> Shouldn't all functions between ieee80211_rx
>> and remove_monitor_info map header with
>> (struct ieee80211_hdr *)(skb->data + status->vendor_radiotap_len) ?
>>
>> Otherwise function like should_drop_frame uses header mapped over
>> potential vendor data.
> Huh, yes, how did I miss that. It only applies to should_drop_frame()
> though, or do you see any other place?
Actually it seems that should_drop_frame is the only one.

Wojtek
> johannes
>

