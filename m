Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:39934 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcDZQC1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 12:02:27 -0400
Date: Tue, 26 Apr 2016 12:02:24 -0400 (EDT)
Message-Id: <20160426.120224.155123476886174129.davem@davemloft.net> (sfid-20160426_180246_788348_8066ADBA)
To: nicolas.dichtel@6wind.com
Cc: netdev@vger.kernel.org, sd@queasysnail.net,
	johannes@sipsolutions.net, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, jack@suse.com,
	linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com
Subject: Re: [PATCH net-next 0/8] netlink: align attributes when needed
 (patchset #3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Tue, 26 Apr 2016 10:06:10 +0200

> The last user of nla_put_u64() is block/drbd. This module does not use
> standard netlink API (see all the stuff in include/linux/genl_magic_struct.h
> and include/linux/genl_magic_func.h).

Yet another example where doing things in a special unique way creates
headaches and pain for everyone... sigh.

> I didn't modify it because it's seems hard to do it whithout testing
> and fully understanding the context (for example, why
> include/linux/drbd_genl.h is not part of uapi?).  Any thoughts?

I think you'll need to work with the drbd maintainer(s) to resolve
this and test the result.

Series applied, thanks.
