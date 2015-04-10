Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:33740 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbbDJM40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 08:56:26 -0400
Received: by layy10 with SMTP id y10so12600619lay.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2015 05:56:25 -0700 (PDT)
Message-ID: <5527C877.6040700@cogentembedded.com> (sfid-20150410_145650_460763_09362DD8)
Date: Fri, 10 Apr 2015 15:56:23 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
CC: matti.gottlieb@intel.com, Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 3/4] ipv4: add option to drop gratuitous ARP packets
References: <1428652454-1224-1-git-send-email-johannes@sipsolutions.net> <1428652454-1224-3-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1428652454-1224-3-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 4/10/2015 10:54 AM, Johannes Berg wrote:

> From: Johannes Berg <johannes.berg@intel.com>

> In certain 802.11 wireless deployments, there will be ARP proxies
> that use knowledge of the network to correctly answer requests.
> To prevent gratuitous ARP frames on the shared medium from being
> a problem, on such deployments wireless needs to drop them.

> Enable this by providing an option called "drop_gratuitous_arp".

> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>   Documentation/networking/ip-sysctl.txt | 6 ++++++
>   include/uapi/linux/ip.h                | 1 +
>   net/ipv4/arp.c                         | 8 ++++++++
>   net/ipv4/devinet.c                     | 2 ++
>   4 files changed, 17 insertions(+)

[...]
> diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
> index 5f5c674e130a..5487d5e5191e 100644
> --- a/net/ipv4/arp.c
> +++ b/net/ipv4/arp.c
> @@ -715,6 +715,14 @@ static int arp_process(struct sk_buff *skb)
>   	    (!IN_DEV_ROUTE_LOCALNET(in_dev) && ipv4_is_loopback(tip)))
>   		goto out;
>
> + /*
> +  *	For some 802.11 wireless deployments (and possibly other networks),
> +  *	there will be an ARP proxy and gratuitous ARP frames are attacks
> +  *	and thus should not be accepted.
> +  */

    Hm, why this strange indentation?

> +	if (IN_DEV_CONF_GET(in_dev, DROP_GRATUITOUS_ARP) && sip == tip)
> +		goto out;
> +
>   /*
>    *     Special case: We must set Frame Relay source Q.922 address
>    */
[...]

WBR, Sergei

