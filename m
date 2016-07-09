Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33650 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932844AbcGIDwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 23:52:23 -0400
Subject: Re: [RFC 0/7] netlink: Add allocation flag to netlink_unicast()
To: David Teigland <teigland@redhat.com>
References: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
 <577DA3E1.6020103@gmail.com> <20160708160821.GA2048@redhat.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-audit@redhat.com, cluster-devel@redhat.com,
	johannes@sipsolutions.net, pablo@netfilter.org, kaber@trash.net,
	kadlec@blackhole.kfki.hu, dledford@redhat.com,
	sean.hefty@intel.com, hal.rosenstock@gmail.com,
	paul@paul-moore.com, eparis@redhat.com, zbr@ioremap.net,
	pshelar@nicira.com, ccaulfie@redhat.com, bsingharora@gmail.com
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <578074F0.9030809@gmail.com> (sfid-20160709_055227_971172_278DD91C)
Date: Sat, 9 Jul 2016 12:52:16 +0900
MIME-Version: 1.0
In-Reply-To: <20160708160821.GA2048@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年07月09日 01:08, David Teigland wrote:
> On Thu, Jul 07, 2016 at 09:35:45AM +0900, Masashi Honma wrote:
>> At the fs/dlm/netlink.c#dlm_timeout_warn(),
>> prepare_data allocates buffer with GFP_NOFS
>> and send_data() sends the buffer.
>>
>> But send_data() uses GFP_KERNEL or GFP_ATOMIC inside it.
>> Should it be replaced by GFP_NOFS ?
> That's old code that's never been used so it doesn't really matter.
>
I see. Thank you.

