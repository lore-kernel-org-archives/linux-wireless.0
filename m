Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53583 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaESP6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 11:58:23 -0400
Message-ID: <537A2A1E.2040402@candelatech.com> (sfid-20140519_175844_180441_289916C6)
Date: Mon, 19 May 2014 08:58:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Park, Kyeyoon" <kyeyoonp@qca.qualcomm.com>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211/mac80211: Add support for Proxy ARP
References: <1400180784-26008-1-git-send-email-kyeyoonp@qca.qualcomm.com> <53751630.2030501@candelatech.com> <E3DE377D7E4999489B304A8FF33FC0D103A211C0@nasanexd01g.na.qualcomm.com>
In-Reply-To: <E3DE377D7E4999489B304A8FF33FC0D103A211C0@nasanexd01g.na.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2014 04:04 PM, Park, Kyeyoon wrote:
> Hi Ben,
> 
>>> +#define STA_IPV4_HASH_SIZE 32
>>> +#define STA_IPV4_HASH(ipv4) (((u8 *)&ipv4)[3] & 0x1F)
>>
>> This should be a better hash I think.  Use an existing hash
>> method or at least mix in the higher bits manually?
> 
> I assume that there is an existing IP address hash function
> somewhere in the TCP/IP stack. I have a hard time finding
> an externally available API that does this for me. Could you
> point me to it?

Maybe jhash_1word?

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

