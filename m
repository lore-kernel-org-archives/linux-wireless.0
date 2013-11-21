Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50064 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3KUNIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 08:08:30 -0500
Message-ID: <1385039307.14273.4.camel@jlt4.sipsolutions.net> (sfid-20131121_140837_232988_5862D8F8)
Subject: Re: [RFC] wireless, ipv4, ipv6: drop GTK-protected unicast IP
 packets
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Jouni Malinen <jouni@qca.qualcomm.com>
Date: Thu, 21 Nov 2013 14:08:27 +0100
In-Reply-To: <1385039154-20637-1-git-send-email-johannes@sipsolutions.net> (sfid-20131121_140611_855342_F7C001E6)
References: <1385039154-20637-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131121_140611_855342_F7C001E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-21 at 14:05 +0100, Johannes Berg wrote:

> @@ -498,7 +500,8 @@ struct sk_buff {
>  	 * headers if needed
>  	 */
>  	__u8			encapsulation:1;
> -	/* 7/9 bit hole (depending on ndisc_nodetype presence) */
> +	__u8			drop_unicast:1;

The obvious question is here, and for IPv4/IPv6 - should the wireless
stack be responsible for doing this instead?

The upside of this approach as-is is that all other protocols can easily
be extended to do this and no protocol-specific code is needed in
wireless; the downside is that it clobbers all protocol code. Thoughts?

johannes

