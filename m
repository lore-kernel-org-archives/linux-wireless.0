Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:46844 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYFROzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 10:55:45 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1K8z4Y-00041D-Ll
	for linux-wireless@vger.kernel.org; Wed, 18 Jun 2008 14:55:42 +0000
Received: from cpc3-cwma2-0-0-cust15.swan.cable.ntl.com ([81.96.204.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 14:55:42 +0000
Received: from andy by cpc3-cwma2-0-0-cust15.swan.cable.ntl.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jun 2008 14:55:42 +0000
To: linux-wireless@vger.kernel.org
From: Andrew Price <andy@andrewprice.me.uk>
Subject: Re: BUG: mac80211: Some connections hanging in 2.6.26-rc6...
Date: Wed, 18 Jun 2008 15:55:28 +0100
Message-ID: <g3b7l1$t1o$1@ger.gmane.org> (sfid-20080618_165548_538551_7C9BA1D8)
References: <g38o2j$1uh$1@ger.gmane.org>	 (sfid-20080617_181742_447297_198DA5E5) <1213773749.3803.155.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <1213773749.3803.155.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18/06/08 08:22, Johannes Berg wrote:
>> This also affects some http requests such as loading slashdot but not
>> others (perhaps small ones?) such as twitter API http requests. It does
>> not seem to affect connections to other machines on my LAN, only ones
>> over the internet.
>>
>> I've tried tcpdumping to get more info but when I run tcpdump the
>> connections work again (if a tiny bit slower).
> 
> Can you try tcpdump with the -p flag? promisc mode might affect things.

I tried using -p and it made the bug go away again. However, I have some
packet captures from running tcpdump on the router while the bug was
occuring and from loading them into wireshark it seems there are some
(suspected) retransmissions with bad checksums. I've posted my packet
captures here:

http://sucs.org/~welshbyte/lw/tcpdump_bad0.pcap
http://sucs.org/~welshbyte/lw/tcpdump_bad1.pcap
http://sucs.org/~welshbyte/lw/tcpdump_good0.pcap

The two 'bad' ones were captured on the router while the bug was
occuring. The 'good' one is for comparison and was captured on the
router like the others but while running tcpdump on my laptop made the
bug go away (I hope that makes sense).

In all cases, the test was to ssh to a remote server. The two bad cases
were closed before the password prompt was reached and the good case was
^C'd at the password prompt.

I hope this helps,

--
Andy Price

