Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail10.tpgi.com.au ([203.12.160.147]:33841 "EHLO
	mail10.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXK3FeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 00:34:15 -0500
Message-ID: <474FA03E.9090805@hotmail.com> (sfid-20071130_053422_148785_576E8AE3)
Date: Fri, 30 Nov 2007 16:31:42 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: linux-wireless@vger.kernel.org, David Miller <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>, jt@hpl.hp.com
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
References: <4740DF47.4040206@hotmail.com> <20071119.002755.77617097.davem@davemloft.net> <1195484582.8642.18.camel@johannes.berg> <20071119180423.GA19250@bougret.hpl.hp.com> <47443035.1070702@hotmail.com> <474432E8.90304@hotmail.com> <47443F78.60701@gentoo.org>
In-Reply-To: <47443F78.60701@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

Daniel Drake wrote:
>> Interestingly, after performing the above actions, I am now getting 
>> additional log messages:
>>
>> SoftMAC: Open Authentication completed with GG:GG:GG:GG:GG:GG
>> Kernel unaligned access at TPC[100df410] 
>> ieee80211softmac_handle_assoc_response]
>> Kernel unaligned access at TPC[100df548] 
>> ieee80211softmac_handle_assoc_response]
> 
> This one doesn't include any offsets, did the line get cut off?

Yes, it did. Sorry about that. Please find it extracted from syslog:

Kernel unaligned access at TPC[100df410] 
ieee80211softmac_handle_assoc_response+0x18/0x1fc [ieee80211softmac]
Kernel unaligned access at TPC[100df548] 
ieee80211softmac_handle_assoc_response+0x150/0x1fc [ieee80211softmac]

>> ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
>> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
>> [ieee802]
>> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
>> [ieee802]
>> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
>> [ieee802]
>> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
>> [ieee802]
>> Kernel unaligned access at TPC[100d03ec] ieee80211_copy_snap+0x74/0x78 
>> [ieee802]
> 
> This one should be fixed by the attached patch. Sorry for not sending it 
> sooner, the contributor has not yet solved all problems and I was 
> waiting to see if more patches would come.
> 
>> Kernel unaligned access at TPC[100ee624] do_rx+0x394/0x5ec [zd1211rw]
>> Kernel unaligned access at TPC[100ee62c] do_rx+0x39c/0x5ec [zd1211rw]
>> Kernel unaligned access at TPC[100ee638] do_rx+0x3a8/0x5ec [zd1211rw]
>> Kernel unaligned access at TPC[100ee668] do_rx+0x3d8/0x5ec [zd1211rw]
>> Kernel unaligned access at TPC[100ee670] do_rx+0x3e0/0x5ec [zd1211rw]
> 
> These might be solved by the patch David sent to the list a few days ago 
> (thanks!). Have you applied it? If you can confirm it helps I will send 
> it up through John.

I am catching up with patches at the moment, and will report back on 
this shortly.

Thanks for your help,
Shaddy

