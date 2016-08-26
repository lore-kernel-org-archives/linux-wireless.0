Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47420 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750929AbcHZINK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 04:13:10 -0400
Message-ID: <1472199187.390.21.camel@sipsolutions.net> (sfid-20160826_101314_967974_2E783201)
Subject: Re: [PATCH] nl80211: Fix unfiltered GET_INTERFACE dumps
From: Johannes Berg <johannes@sipsolutions.net>
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Date: Fri, 26 Aug 2016 10:13:07 +0200
In-Reply-To: <1472157884-3174-1-git-send-email-denkenz@gmail.com> (sfid-20160825_224636_108212_521AFE0B)
References: <1472157884-3174-1-git-send-email-denkenz@gmail.com>
         (sfid-20160825_224636_108212_521AFE0B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-08-25 at 15:44 -0500, Denis Kenzior wrote:
> dump_wiphy_parse only assigns filter_wiphy if one of the supported
> NL80211 attributes is present.  So for unfiltered dumps, filter_wiphy
> was always initialized to 0, and only interface 0 was dumped.
> 
> This was introduced in commit
> 2d75da13fbb957e955d212555b91101cef36f0ce.
> 
> Reported-by: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
> 
Thanks guys, I've squashed this (and moved it into the initializer we
already had.)

johannes
