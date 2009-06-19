Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f192.google.com ([209.85.210.192]:48560 "EHLO
	mail-yx0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZFSR72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 13:59:28 -0400
Received: by yxe30 with SMTP id 30so2691950yxe.4
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 10:59:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245421739.16399.22.camel@johannes.local>
References: <1245421739.16399.22.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 19 Jun 2009 10:59:01 -0700
Message-ID: <43e72e890906191059m321907dbr98395dda9e16b139@mail.gmail.com>
Subject: Re: [PATCH] wext: optimise, comment and fix event sending
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 19, 2009 at 7:28 AM, Johannes Berg<johannes@sipsolutions.net> wrote:
> The current function for sending events first allocates the
> event stream buffer, and then an skb to copy the event stream
> into. This can be done in one go. Also, the current function
> leaks kernel data to userspace in a 4 uninitialised bytes,
> initialise those explicitly. Finally also add a few useful
> comments, as opposed to the current comments.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/wireless/wext.c |  114 ++++++++++++++++++++++++++--------------------------
>  1 file changed, 57 insertions(+), 57 deletions(-)
>
> --- wireless-testing.orig/net/wireless/wext.c   2009-06-19 08:01:29.000000000 +0200
> +++ wireless-testing/net/wireless/wext.c        2009-06-19 16:27:57.000000000 +0200
> @@ -1300,22 +1300,15 @@ static void wireless_nlevent_process(str
>
>  static DECLARE_WORK(wireless_nlevent_work, wireless_nlevent_process);
>
> -/* ---------------------------------------------------------------- */
> -/*
> - * Fill a rtnetlink message with our event data.
> - * Note that we propage only the specified event and don't dump the
> - * current wireless config. Dumping the wireless config is far too
> - * expensive (for each parameter, the driver need to query the hardware).
> - */
> -static int rtnetlink_fill_iwinfo(struct sk_buff *skb, struct net_device *dev,
> -                                int type, char *event, int event_len)
> +static struct nlmsghdr *rtnetlink_ifinfo_prep(struct net_device *dev,
> +                                             struct sk_buff *skb)
>  {
>        struct ifinfomsg *r;
>        struct nlmsghdr  *nlh;
>
> -       nlh = nlmsg_put(skb, 0, 0, type, sizeof(*r), 0);
> -       if (nlh == NULL)
> -               return -EMSGSIZE;
> +       nlh = nlmsg_put(skb, 0, 0, RTM_NEWLINK, sizeof(*r), 0);
> +       if (!nlh)
> +               return NULL;
>
>        r = nlmsg_data(nlh);
>        r->ifi_family = AF_UNSPEC;
> @@ -1326,45 +1319,14 @@ static int rtnetlink_fill_iwinfo(struct
>        r->ifi_change = 0;      /* Wireless changes don't affect those flags */
>
>        NLA_PUT_STRING(skb, IFLA_IFNAME, dev->name);
> -       /* Add the wireless events in the netlink packet */
> -       NLA_PUT(skb, IFLA_WIRELESS, event_len, event);
> -
> -       return nlmsg_end(skb, nlh);
>
> -nla_put_failure:
> +       return nlh;
> + nla_put_failure:
>        nlmsg_cancel(skb, nlh);
> -       return -EMSGSIZE;
> +       return NULL;
>  }
>
> -/* ---------------------------------------------------------------- */
> -/*
> - * Create and broadcast and send it on the standard rtnetlink socket
> - * This is a pure clone rtmsg_ifinfo() in net/core/rtnetlink.c
> - * Andrzej Krzysztofowicz mandated that I used a IFLA_XXX field
> - * within a RTM_NEWLINK event.
> - */
> -static void rtmsg_iwinfo(struct net_device *dev, char *event, int event_len)
> -{
> -       struct sk_buff *skb;
> -       int err;
> -
> -       skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> -       if (!skb)
> -               return;
> -
> -       err = rtnetlink_fill_iwinfo(skb, dev, RTM_NEWLINK, event, event_len);
> -       if (err < 0) {
> -               WARN_ON(err == -EMSGSIZE);
> -               kfree_skb(skb);
> -               return;
> -       }
> -
> -       NETLINK_CB(skb).dst_group = RTNLGRP_LINK;
> -       skb_queue_tail(&dev_net(dev)->wext_nlevents, skb);
> -       schedule_work(&wireless_nlevent_work);
> -}
>
> -/* ---------------------------------------------------------------- */
>  /*
>  * Main event dispatcher. Called from other parts and drivers.
>  * Send the event on the appropriate channels.
> @@ -1383,6 +1345,9 @@ void wireless_send_event(struct net_devi
>        int wrqu_off = 0;                       /* Offset in wrqu */
>        /* Don't "optimise" the following variable, it will crash */
>        unsigned        cmd_index;              /* *MUST* be unsigned */
> +       struct sk_buff *skb;
> +       struct nlmsghdr *nlh;
> +       struct nlattr *nla;
>
>        /* Get the description of the Event */
>        if (cmd <= SIOCIWLAST) {
> @@ -1430,25 +1395,60 @@ void wireless_send_event(struct net_devi
>        hdr_len = event_type_size[descr->header_type];
>        event_len = hdr_len + extra_len;
>
> -       /* Create temporary buffer to hold the event */
> -       event = kmalloc(event_len, GFP_ATOMIC);

Hm, for stable purposes can this be fixed with a kzalloc here? If so
can this patch be split it up in 2 for that purpose?

  Luis
