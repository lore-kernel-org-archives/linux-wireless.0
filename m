Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33016 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbeHOXUS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 19:20:18 -0400
Message-ID: <1534364728.3547.46.camel@sipsolutions.net> (sfid-20180815_222643_881353_72CB5837)
Subject: Re: [PATCH net-next v2 00/11] devlink: Add support for region access
From: Johannes Berg <johannes@sipsolutions.net>
To: Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alex Vesker <valex@mellanox.com>
Cc: netdev@vger.kernel.org, jiri@mellanox.com, dsahern@gmail.com,
        andrew@lunn.ch, rahul.lakkireddy@chelsio.com,
        linux-wireless@vger.kernel.org
Date: Wed, 15 Aug 2018 22:25:28 +0200
In-Reply-To: <20180711114821.1d50ba63@cakuba.lan> (sfid-20180711_204833_719898_307A4DC2)
References: <1531305788-29420-1-git-send-email-valex@mellanox.com>
         <20180711114821.1d50ba63@cakuba.lan> (sfid-20180711_204833_719898_307A4DC2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-07-11 at 11:48 -0700, Jakub Kicinski wrote:
> CC: linux-wireless, wifi chips used to have similar problem
> 
> On Wed, 11 Jul 2018 13:42:57 +0300, Alex Vesker wrote:
> > This is a proposal which will allow access to driver defined address
> > regions using devlink. Each device can create its supported address
> > regions and register them. A device which exposes a region will allow
> > access to it using devlink.


We usually just implement it for debug dumping, and use devcoredump for
that. How does this overlap? Some of the devcoredump data may be
"synthetic" in the sense that it doesn't really have to be strictly a
device memory region, so it's not quite the same, but what's the
intended use case for this?

johannes
