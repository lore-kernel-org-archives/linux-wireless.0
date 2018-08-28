Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:50624 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeH1MeU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 08:34:20 -0400
Message-ID: <1535445814.5895.1.camel@sipsolutions.net> (sfid-20180828_104347_070939_68A2B6D5)
Subject: Re: [PATCH 1/2] cfg80211: let's wmm_rule be part of reg_rule
 structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Grzegorz =?UTF-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>
Date: Tue, 28 Aug 2018 10:43:34 +0200
In-Reply-To: <20180822115854.GA2747@redhat.com>
References: <1534938742-9998-1-git-send-email-sgruszka@redhat.com>
         <1534938867.25523.92.camel@sipsolutions.net>
         <20180822115854.GA2747@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-22 at 13:58 +0200, Stanislaw Gruszka wrote:
> On Wed, Aug 22, 2018 at 01:54:27PM +0200, Johannes Berg wrote:
> > On Wed, 2018-08-22 at 13:52 +0200, Stanislaw Gruszka wrote:
> > > Make wmm_rule be part of reg_rule structure. This simplify code
> > > a lot at cost of having bigger memory usage. However in most cases
> > > we have only few reg_rule's and when we have many like in iwlwifi
> > > we do not save memory as we allocate wmm_rule for each channel.
> > 
> > So I think this is fine, but should we "sell" this to stable as well? I
> > guess we don't really have any other fix?
> 
> I wanted to delegate that decision to you :-)
> 
> It's not one-liner, but from other hand patch just remove bunch
> of code, so should be safe for -stable.

Yeah, I guess I'll try :)

johannes
