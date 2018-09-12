Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbeILNTs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Sep 2018 09:19:48 -0400
Date: Wed, 12 Sep 2018 10:16:22 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] netlink: add NLA_REJECT policy type
Message-ID: <20180912081621.GC29691@unicorn.suse.cz> (sfid-20180912_101630_152628_264E770A)
References: <20180912073245.8047-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180912073245.8047-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 12, 2018 at 09:32:45AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In some situations some netlink attributes may be used for output
> only (kernel->userspace) or may be reserved for future use. It's
> then helpful to be able to prevent userspace from using them in
> messages sent to the kernel, since they'd otherwise be ignored and
> any future will become impossible if this happens.
> 
> Add NLA_REJECT to the policy which does nothing but reject (with
> EINVAL) validation of any messages containing this attribute.
> 
> The specific case I have in mind now is a shared nested attribute
> containing request/response data, and it would be pointless and
> potentially confusing to have userspace include response data in
> the messages that actually contain a request.

I find this feature very useful. Actually, I was a bit surprised when
I found I can't mark an attribute "forbidden" using policy.

IMHO it would be even nicer if one could also specify an error message
to use in extack if NLA_REJECT is applied; the easiest way would be
using .validation_data and passing extack to validate_nla() but I'm not
sure if it wouldn't qualify as an abuse.

Michal Kubecek
