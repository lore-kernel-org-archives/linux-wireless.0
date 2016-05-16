Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34852 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcEPSPo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 14:15:44 -0400
MIME-Version: 1.0
In-Reply-To: <1463398895.25219.82.camel@coelho.fi>
References: <20160513085428.GA13194@mwanda>
	<1463398895.25219.82.camel@coelho.fi>
Date: Mon, 16 May 2016 11:15:43 -0700
Message-ID: <CAA93jw7hkK8+Zx+DJEWDUGxKhSkr6wTLpNmbXYiVc+8OZL-OVA@mail.gmail.com> (sfid-20160516_201547_517983_A26E00B2)
Subject: Re: iwlwifi: mvm: add reorder buffer per queue
From: Dave Taht <dave.taht@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Sara Sharon <sara.sharon@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't even describe how much I hate the concept of the reorder
buffer in general. Ordering is the endpoints problem.

Someday, after we get fq_codeled, short queues again, I'll be able to show why.

On Mon, May 16, 2016 at 4:41 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2016-05-13 at 11:54 +0300, Dan Carpenter wrote:
>> Hello Sara Sharon,
>>
>> The patch b915c10174fb: "iwlwifi: mvm: add reorder buffer per queue"
>> from Mar 23, 2016, leads to the following static checker warnings:
>>
>>       drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:912
>> iwl_mvm_rx_mpdu_mq()
>>       error: potential NULL dereference 'sta'.
>>
>>       drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:912
>> iwl_mvm_rx_mpdu_mq()
>>       error: we previously assumed 'sta' could be null (see line 796)
>
> Thanks for the analysis and report, Dan!
>
> I have queued a fix for this through our internal tree.
>
> --
> Cheers,
> Luca.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Dave Täht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
