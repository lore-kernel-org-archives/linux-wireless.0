Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:65131 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933124Ab2EOPHg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 11:07:36 -0400
Date: Tue, 15 May 2012 17:07:33 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
cc: Arend van Spriel <arend@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] brcm80211: brcmu_pkt_buf_free_skb() should handle NULL
In-Reply-To: <20120515144443.GH16999@mwanda>
Message-ID: <alpine.DEB.2.02.1205151706360.2356@hadrien> (sfid-20120515_170832_024840_A74CF987)
References: <20120515090027.GG30265@elgon.mountain> <4FB26664.2080008@broadcom.com> <20120515144443.GH16999@mwanda>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 15 May 2012, Dan Carpenter wrote:

> On Tue, May 15, 2012 at 04:21:24PM +0200, Arend van Spriel wrote:
>> On 05/15/2012 11:00 AM, Dan Carpenter wrote:
>>> This is potentially called with NULL pointers, for example, look at
>>> brcmf_c_prec_enq().  Since it's a free() function, probably people
>>> expect it to handle NULL pointers.
>>
>> Acked-by: Arend van Spriel <arend@broadcom.com>
>>
>>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>>
>>> diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
>>> index b45ab34..3e6405e 100644
>>
>> Is the diff command filtered properly here. In most patches I usually
>> see '---' immediatly after the Signed-off-by line.
>>
>
> Yeah.  Normally git puts the diffstat there, but my scripts leave
> it out.  All my patches are tiny anyway.  ;)

The documentation says:

The canonical patch message body contains the following:

   - A "from" line specifying the patch author.

   - An empty line.

   - The body of the explanation, which will be copied to the
     permanent changelog to describe this patch.

   - The "Signed-off-by:" lines, described above, which will
     also go in the changelog.

   - A marker line containing simply "---".

   - Any additional comments not suitable for the changelog.

   - The actual patch (diff output).


The --- is not attached to the diffstat, as far as I can see.

julia
