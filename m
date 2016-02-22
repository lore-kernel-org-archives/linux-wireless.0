Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:33815 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbcBVVE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 16:04:28 -0500
MIME-Version: 1.0
In-Reply-To: <20160222.145344.1364935477504825011.davem@davemloft.net>
References: <1456141787-18143-1-git-send-email-emmanuel.grumbach@intel.com>
	<20160222.145344.1364935477504825011.davem@davemloft.net>
Date: Mon, 22 Feb 2016 23:04:26 +0200
Message-ID: <CANUX_P2iKJ+B7xCEnfd-Yko96e+z36ZSqF6eLWHxcZRkPrth1g@mail.gmail.com> (sfid-20160222_220436_451866_C5E0286D)
Subject: Re: [PATCH] codel: cast the output of MS2TIME to codel_time_t
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 22, 2016 at 9:53 PM, David Miller <davem@davemloft.net> wrote:
> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Date: Mon, 22 Feb 2016 13:49:47 +0200
>
>> This will allow to pass the typecheck in the comparators:
>> codel_time_{after,before}
>>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>
> I do not see any existing code where this would matter.  Maybe it was
> not meant to be fed directly?  And if you need to you should add the
> explicit casts yourself.

Well.. This header file is kinda special. As Eric pointed out, I
shouldn't include it since it contains huge inline functions. I only
really need small parts of it for iwlwifi and I copied those into the
driver. In iwlwifi I do need to feed MS2TIME output into the
comparators so I guess I'll do that there. I just thought it'd be nice
to feed this change back in the original implementation of the code.
If another user of the small helpers in this file comes up, it may
make sense to split this file into two header files: one that can be
included, and another one which can't. If that were to happen, I'd be
glad to have this patch in. We're not there yet.

Bottom line, I am perfectly fine if you don't apply this.

>
> I'm not applying this, sorry.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
