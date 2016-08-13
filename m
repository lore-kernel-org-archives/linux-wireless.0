Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:47941 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751583AbcHMEMF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2016 00:12:05 -0400
Message-ID: <1471061519.3467.7.camel@perches.com> (sfid-20160813_061209_218370_C93EAD93)
Subject: Re: [PATCH 1/2] etherdevice: add is_zero_ether_addr_unaligned()
From: Joe Perches <joe@perches.com>
To: Petri Gynther <pgynther@google.com>, linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, davem@davemloft.net, akarwar@marvell.com
Date: Fri, 12 Aug 2016 21:11:59 -0700
In-Reply-To: <1471057200-58166-1-git-send-email-pgynther@google.com>
References: <1471057200-58166-1-git-send-email-pgynther@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-12 at 19:59 -0700, Petri Gynther wrote:
> Add a generic routine to test if possibly unaligned to u16
> Ethernet address is a zero address.
[]
> diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
[]
> +static inline bool is_zero_ether_addr_unaligned(const u8 *addr)
> +{
> +#if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
> +	return is_zero_ether_addr(addr);
> +#else
> +	return (addr[0] | addr[1] | addr[2] | addr[3] | addr[4] | addr[5]) == 0;
> +#endif

Because the return is bool, the == 0 is unnecessary.

