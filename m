Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:46296 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760235AbZD3IUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 04:20:18 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: iwlwifi: remove EXPORT_SYMBOL for static symbol
References: <m24ow6vah1.fsf@igel.home>
	<1241078967.25477.8.camel@johannes.local>
Date: Thu, 30 Apr 2009 10:20:15 +0200
In-Reply-To: <1241078967.25477.8.camel@johannes.local> (Johannes Berg's
	message of "Thu, 30 Apr 2009 10:09:26 +0200")
Message-ID: <m28wlih7sw.fsf@igel.home> (sfid-20090430_102039_046386_D5D57BC3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2009-04-30 at 09:58 +0200, Andreas Schwab wrote:
>> It does not make sense to apply EXPORT_SYMBOL to a static symbol.  Fixes
>> this build error:
>> 
>> drivers/net/wireless/iwlwifi/iwl3945-base.c:1697: error:
>> __ksymtab_iwl3945_rx_queue_reset causes a section type conflict
>> 
>> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
>> ---
>> This obsoletes 6269b731560d69c5eaa929909891edec39496d71, which was
>> misattributed as a compiler bug.
>
> At least in my tree the function isn't static...(yet I still got the
> compiler error)?

The static function is iwl3945_rx_queue_free.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
