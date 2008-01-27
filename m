Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:61808 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753818AbYA0PCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 10:02:52 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Stefano Brivio'" <stefano.brivio@polimi.it>
Cc: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 2/2] rc80211-pid: add sanity check
Date: Sun, 27 Jan 2008 14:53:00 +0100
Message-ID: <007a01c860eb$ee8231b0$0b3ca8c0@gotws1589> (sfid-20080127_150255_927409_8B226D07)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <20080127134252.776cebd6@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stefano,

What happens is that the while (newidx != sta->txrate) will continue 
until the newidx reaches 33. Reason is that BIT(33) is the same as BIT(1) 
In the rate_supported() function.

New sta->txrate will be 33 which is far beyond the valid size (12 in my
case).
In my system that happens to be a 11g speed :o).

I have a trace if you are intresting. Its about 260K data but it show 
How it happens. I think you need trafik (ping) in order for the relulator 
to operate.

Regards
Lars


-----Original Message-----
From: Stefano Brivio [mailto:stefano.brivio@polimi.it] 
Sent: den 27 januari 2008 13:43
To: Lars
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rc80211-pid: add sanity check

On Sat, 26 Jan 2008 19:40:14 +0000 (UTC) Lars <Lars_Ericsson@telia.com>
wrote:

> Hi,
> 
> I have spent some time debugging this problem from a different angle.
> 
> If you use a 'b/g' STA connecting to a 'b' AP you will run into this 
> loop in a few seconds. What also happens is that the STA will try 
> using 'g' speeds. That was the way I located the problem.

Thank you. I couldn't really figure out how to reproduce the bug.

> In other words, I do not think a WARN_ON is good solution.

Please could you try my 1/2 patch? In the meanwhile, I'll try to use your
information for more debugging.


--
Ciao
Stefano

