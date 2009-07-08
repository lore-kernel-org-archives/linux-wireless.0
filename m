Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mrs.ro ([207.192.75.59]:46445 "EHLO li37-59.members.linode.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753273AbZGHHag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 03:30:36 -0400
Message-ID: <4A544B15.8030106@mrs.ro>
Date: Wed, 08 Jul 2009 10:30:29 +0300
From: Valentin Manea <linux-wireless@mrs.ro>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	David Ross <dave@antacs.com>, linux-wireless@vger.kernel.org
Subject: Re: mac80211 and broadcast frames
References: <4A49EEC3.3060108@mrs.ro> <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com> 	<4A4B056B.9000602@mrs.ro> <43e72e890907011033r52c4256dtecf603f56213a825@mail.gmail.com> 	<4A530131.9050207@mrs.ro> <4A532D3C.5060601@antacs.com> <20090707144851.GA2768@tuxdriver.com> <43e72e890907070915y5fd131b7l6aa845a0785f8c76@mail.gmail.com>
In-Reply-To: <43e72e890907070915y5fd131b7l6aa845a0785f8c76@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/07/2009 07:15 PM, Luis R. Rodriguez wrote:
> On Tue, Jul 7, 2009 at 7:48 AM, John W. Linville<linville@tuxdriver.com>  wrote:
>> On Tue, Jul 07, 2009 at 09:10:52PM +1000, David Ross wrote:
>>> Actually it is required to be a mutual BASIC rate (not extended rates) -
>>> not necessarily the "lowest possible" - David.
>> True, but FWIW I think all of our rate scaling algorithms choose the
>> lowest rate.
>
> And then iwlwifi and ath9k have their own rate control algo, and at
> least ath9k uses the lowest valid rate IIRC.
>
>    Luis


   I've found the code in ath9k and you are right, it always chooses the 
lowest rate.
   So, basically to transmit multicast frames at a better bitrate I have 
to hack the rate control algorithm, right?


Thanks,
Valentin
