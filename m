Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44952 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728619AbeHVPXe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 11:23:34 -0400
Date: Wed, 22 Aug 2018 13:58:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Grzegorz =?utf-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: let's wmm_rule be part of reg_rule
 structure
Message-ID: <20180822115854.GA2747@redhat.com> (sfid-20180822_135858_984904_A0AFA746)
References: <1534938742-9998-1-git-send-email-sgruszka@redhat.com>
 <1534938867.25523.92.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534938867.25523.92.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2018 at 01:54:27PM +0200, Johannes Berg wrote:
> On Wed, 2018-08-22 at 13:52 +0200, Stanislaw Gruszka wrote:
> > Make wmm_rule be part of reg_rule structure. This simplify code
> > a lot at cost of having bigger memory usage. However in most cases
> > we have only few reg_rule's and when we have many like in iwlwifi
> > we do not save memory as we allocate wmm_rule for each channel.
> 
> So I think this is fine, but should we "sell" this to stable as well? I
> guess we don't really have any other fix?

I wanted to delegate that decision to you :-)

It's not one-liner, but from other hand patch just remove bunch
of code, so should be safe for -stable.

Regards
Stanislaw
