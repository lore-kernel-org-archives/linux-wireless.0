Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:36201 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbYBYXZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 18:25:57 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1016908wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 15:25:57 -0800 (PST)
Subject: Re: [PATCH 18/18] mac80211: enable mesh in Kconfig
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1203974647.13162.174.camel@johannes.berg>
References: <20080223141703.194775000@sipsolutions.net>
	 <20080223142018.468705000@sipsolutions.net>
	 <1203973083.6929.79.camel@localhost>
	 (sfid-20080225_205634_226995_07239062)  <1203974647.13162.174.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 15:27:36 -0800
Message-Id: <1203982056.6929.101.camel@localhost> (sfid-20080225_232600_986969_4CE437D6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-25 at 22:24 +0100, Johannes Berg wrote:
> #define PREQ_IE_ORIG_DSN(x) le32_to_cpu(*((u32 *) (x + 13)))
> 
> Would it be possible to define the preq IE as a struct? Not sure if it
> is. Either way, this should be converted to a static inline instead of a
> macro.

The problem is that preq and prep IEs do not have a fixed size.
Depending on the address extension bit, they can have or not a 6 byte
proxied address in the middle, so I would need 4 structures. 

> 
> Also, you need to add a lot of get_unaligned() to the code. Please read
> Daniel's excellent Documentation/unaligned-memory-access.txt

Will do.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


