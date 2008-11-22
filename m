Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:26352 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757631AbYKVNZ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Nov 2008 08:25:57 -0500
Received: by mu-out-0910.google.com with SMTP id g7so1403119muf.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Nov 2008 05:25:55 -0800 (PST)
Message-ID: <4928085F.7050404@gmail.com> (sfid-20081122_142601_850012_8EFEFF15)
Date: Sat, 22 Nov 2008 15:25:51 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: set mac address in add_interface
References: <20081118044037.GA18983@hash.localnet> <492710E6.7020506@gmail.com> <b6c5339f0811211201i384ee31dyb5b3998fe02136af@mail.gmail.com> <49271FD1.101@gmail.com> <49272BEE.2020106@gmail.com> <20081121231527.GA27720@hash.localnet>
In-Reply-To: <20081121231527.GA27720@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> On Fri, Nov 21, 2008 at 11:45:18PM +0200, Maxim Levitsky wrote:
>>> I double check that I use right kernel (install it again).
>> compiled kernel again, and installed it, same results.
> 
> Can you confirm that the proper mac address shows up if you do ifconfig
> or macchanger -s?  I think it's just not associating.  
> 
> Also can you try specifying the ap again to trigger a probe after 
> ifconfig up:
> 
>     $ iwconfig wlan0 ap <your AP's mac address>
> 
> Though I did forget about this gem, try this too:

Mystery solved, and sorry for the noise,
short answer is, wpa_supplicant.

My network is WPA2 protected, and I only test against it, and
it takes time to go to AP settings, change encryption to WEP, and not forget
to change it back, etc...

So, wpa_supplicant wasn't aware of new mac, but I remember that WPA uses mac as part
of encryption.

restarting it solved the problem.

I also applied (by hand) your latest patch, so maybe it did help, I'll check without it too.


Best regards,
	Maxim Levitsky


