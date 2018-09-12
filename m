Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:34584 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbeILNxf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 09:53:35 -0400
Received: by mail-qt0-f172.google.com with SMTP id m13-v6so1053829qth.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2018 01:50:02 -0700 (PDT)
Subject: Re: [RFC v2 2/2] netlink: add ethernet address policy types
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20180912083610.20857-1-johannes@sipsolutions.net>
 <20180912083610.20857-2-johannes@sipsolutions.net>
Cc: Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B98D336.4090107@broadcom.com> (sfid-20180912_105009_979443_14993FF1)
Date: Wed, 12 Sep 2018 10:49:58 +0200
MIME-Version: 1.0
In-Reply-To: <20180912083610.20857-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/12/2018 10:36 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Commonly, ethernet addresses are just using a policy of
> 	{ .len = ETH_ALEN }
> which leaves userspace free to send more data than it should,
> which may hide bugs.
>
> Introduce NLA_ETH_ADDR which checks for exact size, and rejects
> the attribute if the length isn't ETH_ALEN.
>
> Also add NLA_ETH_ADDR_COMPAT which can be used in place of the
> policy above, but will, in addition, warn on an address that's
> too long.

Not sure if this is correctly described here. It seems longer addresses 
are not rejected, but only result in a warning message. I guess the 
problem is in the reference to the "policy above" ;-)

Regards,
Arend
