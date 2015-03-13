Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a.ns.miles-group.at ([95.130.255.143]:65278 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906AbbCMNUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 09:20:09 -0400
Message-ID: <5502E3FD.50803@nod.at> (sfid-20150313_142031_677896_61AD1F05)
Date: Fri, 13 Mar 2015 14:19:57 +0100
From: Richard Weinberger <richard@nod.at>
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, sameo@linux.intel.com,
	aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	davem@davemloft.net, kadlec@blackhole.kfki.hu, kaber@trash.net
Subject: Re: [PATCH 3/4] netfilter: Fix portid types
References: <1426246276-15839-1-git-send-email-richard@nod.at> <1426246276-15839-4-git-send-email-richard@nod.at> <20150313130155.GA1044@salvia>
In-Reply-To: <20150313130155.GA1044@salvia>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 13.03.2015 um 14:01 schrieb Pablo Neira Ayuso:
> On Fri, Mar 13, 2015 at 12:31:15PM +0100, Richard Weinberger wrote:
>> The netlink portid is an unsigned integer, use this type
>> also in netfilter.
> 
> This small cleanup I can still take it but...
> 
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  net/netfilter/nfnetlink_log.c        | 4 ++--
>>  net/netfilter/nfnetlink_queue_core.c | 7 ++++---
>>  2 files changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
>> index 11d85b3..7f00846 100644
>> --- a/net/netfilter/nfnetlink_log.c
>> +++ b/net/netfilter/nfnetlink_log.c
>> @@ -62,7 +62,7 @@ struct nfulnl_instance {
>>  	struct timer_list timer;
>>  	struct net *net;
>>  	struct user_namespace *peer_user_ns;	/* User namespace of the peer process */
>> -	int peer_portid;			/* PORTID of the peer process */
>> +	unsigned int peer_portid;		/* PORTID of the peer process */
> 
> I think you have to use u32 for consistency. Other spots use the
> datatype for the netlink portid.
> 
> I think same thing applies to other patches.

Of course! Will re-spin with u32.

Thanks,
//richard
