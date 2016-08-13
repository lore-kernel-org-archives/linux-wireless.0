Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0154.hostedemail.com ([216.40.44.154]:41583 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299AbcHMEAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2016 00:00:37 -0400
Message-ID: <1471060827.3467.5.camel@perches.com> (sfid-20160813_060107_489755_34A4D2FB)
Subject: Re: [PATCH] Modify is_zero_ether_addr() to handle byte-aligned
 addresses
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>, pgynther@google.com
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	akarwar@marvell.com
Date: Fri, 12 Aug 2016 21:00:27 -0700
In-Reply-To: <20160812.202613.197744153887748230.davem@davemloft.net>
References: <1471047330-8153-1-git-send-email-pgynther@google.com>
	 <20160812.202613.197744153887748230.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-12 at 20:26 -0700, David Miller wrote:
> From: Petri Gynther <pgynther@google.com>
> Date: Fri, 12 Aug 2016 17:15:30 -0700
> 
> > Root cause:
> > mwifiex driver calls is_zero_ether_addr() against byte-aligned address:
> 
> MAC addresses really must be 16-bit aligned to be used with any of the
> ethernet address manipulation and test interfaces.
> 
> Therefore this driver should do whatever it takes to avoid passing
> a byte-aligned MAC address anywhere.
> 
> We _SHOULD NOT_ add support for byte aligned addresses to these
> interfaces, nor add routines which by-name can handle them.

My recollection is that batman uses unaligned addresses
and some form of _unaligned tests are required there.

It seems that other wireless drivers also use _unaligned
in various forms.

> Fix this driver instead of polluting out common interfaces
> unnecessarily.

One solution might be to copy a hardware interface structure
to another struct with appropriate alignment.
