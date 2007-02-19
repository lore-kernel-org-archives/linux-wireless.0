Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:31439 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932578AbXBSUkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 15:40:42 -0500
Message-ID: <45DA0A7C.5010001@linux.intel.com>
Date: Mon, 19 Feb 2007 12:37:16 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] d80211: Allow drivers to configure default regulatory  domain
References: <200702180031.38710.flamingice@sourmilk.net> <20070219204938.29520759@griffin.suse.cz>
In-Reply-To: <20070219204938.29520759@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> On Sun, 18 Feb 2007 00:31:33 -0500, Michael Wu wrote:
>> This patch allows drivers to configure the default set of channels if the
>> device reports its default regulatory domain.
> 
> How is a driver supposed to handle this? By walking through the channel
> list and based on some value obtained from its EEPROM (or firmware or
> whatever) set appropriate flags? 

Yes.

> That sounds like a need for duplicate code in drivers. 

Unfortunately it is vendor and device specific.  I think we can 
generalize things to provide helper functions and macros such that each 
driver does it roughly the same way, but the stack itself can't do it.

 > Shouldn't the stack accept a regdomain code (defined
> as an enum of integers or so) instead?

The hardware needs to tell the stack all the channels it supports and 
the restrictions on those channels.  The stack can then further restrict 
the set of channels based on the user input to a "standard" set of 
countries.

"regdomains" are not static maps; they evolve over time as governments 
change their regulations.  The channels and features supported by 
hardware is static based on what the device was certified for.

James
