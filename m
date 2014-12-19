Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:59803 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaLSP4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 10:56:40 -0500
Message-ID: <54944AB4.7050208@neratec.com> (sfid-20141219_165643_099599_EAF4C46E)
Date: Fri, 19 Dec 2014 16:56:36 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: DFS CAC time
References: <CAGXE3d8Uv01qjfvRQkMr1w_5wB6XKpC7d2VOR3UG0DMPHk6r9A@mail.gmail.com>	<54940B8C.5070801@neratec.com> <CAGXE3d9ZubxEoeV+uD9GHJiAa7aB_NM87OfddNa4SC5CQkjNuA@mail.gmail.com>
In-Reply-To: <CAGXE3d9ZubxEoeV+uD9GHJiAa7aB_NM87OfddNa4SC5CQkjNuA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/2014 02:19 PM, Helmut Schaa wrote:
> Hi Zefir,
> 
> On Fri, Dec 19, 2014 at 12:27 PM, Zefir Kurtisi
> <zefir.kurtisi@neratec.com> wrote:
>>
>> Hello Helmut,
>>
>> just forget about those aka 'weather channels' that require a pracitcally
>> impossible to achieve radar detection probability rate (99.99% during CAC, see
>> table D.5).
> 
> Hmm, ok :)
> 
> Would it make sense to mark these somehow in the wireless-regdb in a
> special way?
> 

To reflect the fact that channels are available from regulatory's point of view
but not usable from driver's perspective, the correct way would be to
* set the correct CAC time in crda
* disable them in the driver internal regdb

In practice, that's an overhead to manage channels that we know will never be
available for WLAN master devices.


Cheers,
Zefir

