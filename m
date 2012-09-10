Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57804 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab2IJPND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 11:13:03 -0400
Received: by ieje11 with SMTP id e11so3325558iej.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2012 08:13:02 -0700 (PDT)
Message-ID: <504E037B.9030801@lwfinger.net> (sfid-20120910_171324_363654_0389275B)
Date: Mon, 10 Sep 2012 10:12:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marc MERLIN <marc@merlins.org>, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, linux-wireless@vger.kernel.org,
	netdev@ger.kernel.org
Subject: Re: kernel 3.5.2/amd64: iwlwifi 0000:03:00.0: failed to allocate
 pci memory
References: <20120908161038.GF3347@merlins.org>  <1347122927.1234.849.camel@edumazet-glaptop>  <20120904003014.GB6287@merlins.org> <20120908170128.GK3347@merlins.org>  (sfid-20120908_190214_109241_625AC686) <1347130641.11167.0.camel@jlt4.sipsolutions.net>  (sfid-20120908_205654_374994_2998A2BE) <1347272641.4272.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347272641.4272.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2012 05:24 AM, Johannes Berg wrote:
> On Sat, 2012-09-08 at 20:57 +0200, Johannes Berg wrote:
>
>>> [856806.497959]  [<ffffffff810cf54c>] warn_alloc_failed+0x117/0x12c
>>> [856806.497963]  [<ffffffff810d23af>] __alloc_pages_nodemask+0x6e3/0x792
>>> [856806.497969]  [<ffffffff812b7f41>] ? pfn_to_dma_pte+0x116/0x15e
>>> [856806.497976]  [<ffffffff810ff58b>] alloc_pages_current+0xcd/0xee
>>> [856806.497979]  [<ffffffff810cecca>] __get_free_pages+0x9/0x45
>>> [856806.497982]  [<ffffffff812ba67d>] intel_alloc_coherent+0x84/0xe7
>>> [856806.497986]  [<ffffffff81085cf8>] ? arch_local_irq_save+0x15/0x1b
>>> [856806.497999]  [<ffffffffa0b84afc>] iwl_ucode_callback+0xa49/0xc0d [iwlwifi]
>>
>> Yes, unfortunately we need a whole bunch of contiguous memory to load
>> the firmware.
>>
>>> Any ideas?
>>
>> Nothing we can do from the driver side, I'm afraid.
>
> Turns out I was wrong. Here's a patch you can test. Note that we still
> need a lot of DMA-coherent memory for other things, but at least for the
> firmware image we don't.
>
> http://p.sipsolutions.net/11ea33b376a5bac5.txt

That patch looks like a good way to solve the problem; however, some 
architectures need an explicit "#include <linux/vmalloc.h>" somewhere in the 
headers, even though x86 does not, and I did not see it in the patch. I didn't 
do a lot of checking, but grep did not find one in the existing code.

Larry


