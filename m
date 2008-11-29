Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s36.bay0.hotmail.com ([65.54.246.236]:61464 "EHLO
	bay0-omc3-s36.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751306AbYK2NAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 08:00:55 -0500
Message-ID: <BAY104-DAV123037CA3209C851B0946199070@phx.gbl> (sfid-20081129_140059_113748_5F7544F1)
Message-ID: <49313CFF.4070005@hotmail.com>
Date: Sun, 30 Nov 2008 00:00:47 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2] zd1211rw: use unaligned safe memcmp() in-place of compare_ether_addr()
References: <BAY104-DAV2759DEF86863A0B2E73A299040@phx.gbl> <200811291240.50958.hs4233@mail.mn-solutions.de>
In-Reply-To: <200811291240.50958.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 29/11/08 23:40, Holger Schurig wrote:
>> -        if (likely(!compare_ether_addr(tx_hdr->addr2,
>> rx_hdr->addr1))) +        if (likely(!memcmp(tx_hdr->addr2,
>> rx_hdr->addr1, ETH_ALEN))) {
>>              __skb_unlink(skb, q);
> 
> Wouldn't it be better to fix compile_ether_addr instead?

 From Documentation/unaligned-memory-access.txt in reference to 
compare_ether_addr():

Despite the potential unaligned access problems with the above function, it
is included in the kernel anyway but is understood to only work on
16-bit-aligned addresses. It is up to the caller to ensure this alignment or
not use this function at all. This alignment-unsafe function is still useful
as it is a decent optimization for the cases when you can ensure alignment,
which is true almost all of the time in ethernet networking context.

Hope that helps,
Shaddy


