Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:35107 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbcECOQ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 10:16:28 -0400
Received: by mail-yw0-f177.google.com with SMTP id g133so19259435ywb.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2016 07:16:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1462281243.2251.2.camel@sipsolutions.net>
References: <CABPxzYLtu53V79O--eDJEdRfn-zw3Wq9Po04F=uFp_FrfJjuiA@mail.gmail.com>
 <1462281243.2251.2.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 3 May 2016 19:46:07 +0530
Message-ID: <CABPxzYJjRMMaUn+zzpzm8Zv8XAn8nfA8FgMTr7bkZve3XWs8ow@mail.gmail.com> (sfid-20160503_161631_537544_4574B797)
Subject: Re: dynamic ps + offchannel mgmt_tx + HW RoC
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 3, 2016 at 6:44 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2016-05-03 at 18:23 +0530, Krishna Chaitanya wrote:
>> Hi,
>>
>> When the HW is in PS and Dynamic PS is enabled we are dropping
>> all the offchannel frames. Sequence is as below
>>
>> if hw is in PS: stop_queues reason=PS, queue dynamic_ps_disable_work
>> send Offchannel mgmt_tx
>> drop the packet because offchanel + stop_reasons[q] !=0
>>
>> How should we handle this? SW RoC is handling this
>> by checking for offchannel and bringing the HW out of PS before
>> handing the packet to TX path, so it works fine.
>
> You should handle this by not doing such a non-sensical thing and
> finally implementing powersave properly in the driver :)
i don't see any issues in the powersave w.r.t driver. Isn't it a
valid case? you meant implementing dynamic_ps?
