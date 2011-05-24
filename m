Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:43361 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab1EXPku (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 11:40:50 -0400
Message-ID: <4DDBCE8C.5000608@gnu.org> (sfid-20110524_174103_039311_C11DE065)
Date: Tue, 24 May 2011 11:28:12 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
Subject: Re: Initial automatic channel selection implementation
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
In-Reply-To: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2011 08:48 AM, Luis R. Rodriguez wrote:

> I - Simple solution:
>
>    * Look for the frequency in a band that has the less amount of BSSes
> with the lowest link quality

I think it would be better to consider every BSS, but use weights based 
on speed, whether it's an ad-hoc node or an AP, and possibly on the 
supported features (power saving etc).

That algorithm may actually give acceptable results, even when there is 
traffic on all channels.

Speaking of channels, I think only some channels should be eligible for 
automatic selection (that would be 1, 6 and 11 in the 2.4 GHz range).

-- 
Regards,
Pavel Roskin
