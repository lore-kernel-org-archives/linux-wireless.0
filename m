Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55752 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab1BYW4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 17:56:10 -0500
Received: by vxi39 with SMTP id 39so1824116vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 14:56:09 -0800 (PST)
Message-ID: <4D683386.4040407@lwfinger.net>
Date: Fri, 25 Feb 2011 16:56:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] iwlegacy: change some symbols duplicated from iwlwifi
 directory
References: <1298670606-1250-1-git-send-email-linville@tuxdriver.com>	 <20110225220504.GI15897@tuxdriver.com> <1298672550.28351.113.camel@wwguy-huron>
In-Reply-To: <1298672550.28351.113.camel@wwguy-huron>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2011 04:22 PM, Guy, Wey-Yi wrote:
> On Fri, 2011-02-25 at 14:05 -0800, John W. Linville wrote:
>> Sorry about the SPAM -- either I had some network issues here or I
>> _really_ meant for you to see this!! :-)
>>
>> On Fri, Feb 25, 2011 at 04:50:06PM -0500, John W. Linville wrote:
>>> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x29f0): multiple definition of `iwl_rates'
>>> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0xa68): first defined here
>>> powerpc64-linux-ld: Warning: size of symbol `iwl_rates' changed from 143 in drivers/net/wireless/iwlwifi/built-in.o to 130 in drivers/net/wireless/iwlegacy/built-in.o
>>> drivers/net/wireless/iwlegacy/built-in.o:(.data+0x0): multiple definition of `bt_coex_active'
>>> drivers/net/wireless/iwlwifi/built-in.o:(.data+0x668): first defined here
>>> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x750): multiple definition of `iwl_eeprom_band_1'
>>> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x27d0): first defined here
>>> drivers/net/wireless/iwlegacy/built-in.o:(.rodata+0x3f0): multiple definition of `iwl_bcast_addr'
>>> drivers/net/wireless/iwlwifi/built-in.o:(.rodata+0x24f8): first defined here
>>> drivers/net/wireless/iwlegacy/built-in.o:(.bss+0x3d48): multiple definition of `iwl_debug_level'
>>> drivers/net/wireless/iwlwifi/built-in.o:(.bss+0x21950): first defined here
>>>
> 
> Thank you very much for fix this, we just miss it :-(

I got hit earlier in the week with a similar issue on a patch of mine. It seems
that a "make allyesconfig && make" is worthwhile whenever large changes are
made, particularly when code is being moved.

Larry
