Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:50792 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751027AbYGVNCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 09:02:12 -0400
Message-ID: <4885DA49.50703@lwfinger.net> (sfid-20080722_150216_943047_5351142B)
Date: Tue, 22 Jul 2008 08:02:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kaber@trash.net, mingo@elte.hu, ischram@telenet.be,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: [crash] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000370
References: <4885104A.2070201@lwfinger.net>	<20080721.161517.27161039.davem@davemloft.net>	<48857F74.2040406@lwfinger.net> <20080722.043220.247312412.davem@davemloft.net>
In-Reply-To: <20080722.043220.247312412.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Miller wrote:
> From: Larry Finger <Larry.Finger@lwfinger.net>
> Date: Tue, 22 Jul 2008 01:34:28 -0500
> 
>> David Miller wrote:
>>> From: Larry Finger <Larry.Finger@lwfinger.net>
>>> Date: Mon, 21 Jul 2008 17:40:10 -0500
>>>
>>>> Sorry :(
>>>>
>>>> I used the davem patch, the second version of your first one, and your second 
>>>> one. Both problems persist.
>>>>
>>>> Still plugging away on bisection.
>>> GIT bisecting the lockdep problem is surely going the land you on:
>>>
>>> commit e308a5d806c852f56590ffdd3834d0df0cbed8d7
>> No. It landed on this one.
> 
> For the lockdep warnings?

When I was just one commit later, I got both the lockdep warning and the BUG. 
This is the commit in question.

commit 16361127ebed0fb8f9d7cc94c6e137eaf710f676
Author: David S. Miller <davem@davemloft.net>
Date:   Wed Jul 16 02:23:17 2008 -0700

     pkt_sched: dev_init_scheduler() does not need to lock qdisc tree.

     We are registering the device, there is no way anyone can get
     at this object's qdiscs yet in any meaningful way.

     Signed-off-by: David S. Miller <davem@davemloft.net>

Larry
