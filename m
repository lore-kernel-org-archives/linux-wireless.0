Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:12755 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYJFQtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 12:49:01 -0400
Received: by yw-out-2324.google.com with SMTP id 9so438331ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Oct 2008 09:49:00 -0700 (PDT)
Message-ID: <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com> (sfid-20081006_184905_893309_CF75BF38)
Date: Mon, 6 Oct 2008 18:49:00 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223309405.15196.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223308831.15196.28.camel@johannes.berg>
	 <1223309405.15196.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 6, 2008 at 6:10 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> This patch cleans up the DMA code to be understandable and not
> completely wrong. In particular:
>  * there is no need to have a weird iwl_tfd_frame_data struct that is
>   used 10 times, just use an address struct 20 times

In the hardware this is defined as couples

>  * therefore, all the is_odd junk goes away
>  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
>   fragments of a descriptor rather than all descriptors (this may be
>   the cause of the dma unmapping problem I reported)
>  * some more cleanups

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> --


> Tested on 5000 hw, please apply.

Great job,  however do not apply this before I review it I had strong
feeling this will not
work with aggregation flows.
Thanks
Tomas
