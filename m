Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35475
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751252AbZHAFXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 01:23:42 -0400
Date: Fri, 31 Jul 2009 22:23:50 -0700 (PDT)
Message-Id: <20090731.222350.254918321.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: linuxrocks123@netscape.net, linux-wireless@vger.kernel.org,
	dsd@gentoo.org, kune@deine-taler.de
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
From: David Miller <davem@davemloft.net>
In-Reply-To: <1249029583.29587.46.camel@johannes.local>
References: <4A72A462.6060107@netscape.net>
	<1249029583.29587.46.camel@johannes.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 31 Jul 2009 10:39:43 +0200

> On Fri, 2009-07-31 at 01:59 -0600, Patrick Simmons wrote:
>> I'm running zd1211rw on SPARC64 and was getting a lot of "unaligned 
>> access" messages in dmesg.  I tracked the problem down to this line, and 
>> changing the cast to a memcpy fixes the issue.
>>  
>> -       fc = *(__le16 *)buffer;
>> +       memcpy(&fc,buffer,sizeof(__le16));
>>         need_padding = ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc);
> 
> Please use get_unaligned instead.

And, more specifically, one of the endian get_unaligned variants.
