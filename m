Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:40274 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbeIQPGl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 11:06:41 -0400
Message-ID: <1537177194.2957.7.camel@sipsolutions.net> (sfid-20180917_114008_673731_492806E3)
Subject: Re: [PATCH 1/2] netlink: add NLA_REJECT policy type
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        mkubecek@suse.cz
Date: Mon, 17 Sep 2018 11:39:54 +0200
In-Reply-To: <20180913.155934.742447935316828936.davem@davemloft.net>
References: <20180913084603.7979-1-johannes@sipsolutions.net>
         <20180913.155934.742447935316828936.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-09-13 at 15:59 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 13 Sep 2018 10:46:02 +0200
> 
> > +                                     NL_SET_BAD_ATTR(extack, nla);
> > +                                     if (extack && !extack->_msg)
> > +                                             NL_SET_ERR_MSG(extack,
> > +                                                            "Attribute failed policy validation");
> 
> Given the lively discussion that resulted from this conditional I am
> pretty sure we want to override existing messages.
> 
> If we have an existing message, and we continued to process and
> parse anyways, then the existing message was informational or
> a warning.
> 
> The message should be overridden when the action will be to fail, as
> it will be here when we return -EINVAL.

Not just -EINVAL, but yeah, I've just reworked the patch to do this.

johannes
