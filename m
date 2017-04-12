Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:35957 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752286AbdDLPdB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 11:33:01 -0400
Received: by mail-pg0-f54.google.com with SMTP id g2so16380291pge.3
        for <linux-wireless@vger.kernel.org>; Wed, 12 Apr 2017 08:33:01 -0700 (PDT)
Subject: Re: [PATCH net-next v5 1/5] netlink: extended ACK reporting
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20170412123408.22012-1-johannes@sipsolutions.net>
 <20170412123408.22012-2-johannes@sipsolutions.net>
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>, jiri@resnulli.us,
        Johannes Berg <johannes.berg@intel.com>
From: David Ahern <dsa@cumulusnetworks.com>
Message-ID: <dd9f0bb0-df0d-bf04-9d17-90d611af7cbc@cumulusnetworks.com> (sfid-20170412_173305_932767_168C734C)
Date: Wed, 12 Apr 2017 09:32:59 -0600
MIME-Version: 1.0
In-Reply-To: <20170412123408.22012-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/12/17 6:34 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Add the base infrastructure and UAPI for netlink extended ACK
> reporting. All "manual" calls to netlink_ack() pass NULL for
> now and thus don't get extended ACK reporting.
> 
> Big thanks goes to Pablo Neira Ayuso for not only bringing up
> the whole topic at netconf (again) but also coming up with the
> nlattr passing trick and various other ideas.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  crypto/crypto_user.c              |  3 +-
>  drivers/infiniband/core/netlink.c |  5 +--
>  drivers/scsi/scsi_netlink.c       |  2 +-
>  include/linux/netlink.h           | 26 +++++++++++++-
>  include/net/netlink.h             |  3 +-
>  include/uapi/linux/netlink.h      | 32 ++++++++++++++++++
>  kernel/audit.c                    |  2 +-
>  net/core/rtnetlink.c              |  3 +-
>  net/core/sock_diag.c              |  3 +-
>  net/decnet/netfilter/dn_rtmsg.c   |  2 +-
>  net/hsr/hsr_netlink.c             |  4 +--
>  net/netfilter/ipset/ip_set_core.c |  2 +-
>  net/netfilter/nfnetlink.c         | 22 ++++++------
>  net/netlink/af_netlink.c          | 71 ++++++++++++++++++++++++++++++++++-----
>  net/netlink/af_netlink.h          |  1 +
>  net/netlink/genetlink.c           |  3 +-
>  net/xfrm/xfrm_user.c              |  3 +-
>  17 files changed, 153 insertions(+), 34 deletions(-)

Reviewed-by: David Ahern <dsa@cumulusnetworks.com>
