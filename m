Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41818 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbdCPKEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 06:04:48 -0400
Message-ID: <1489658630.2370.4.camel@sipsolutions.net> (sfid-20170316_110543_189454_962DB713)
Subject: Re: [PATCH 2/2] mac80211: Drop new node with weak power
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Mar 2017 11:03:50 +0100
In-Reply-To: <1489629438-7087-2-git-send-email-masashi.honma@gmail.com> (sfid-20170316_025743_262084_63875C60)
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
         <1489629438-7087-2-git-send-email-masashi.honma@gmail.com>
         (sfid-20170316_025743_262084_63875C60)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 2017-03-16 at 10:57 +0900, Masashi Honma wrote:
> On some practical cases, it is useful to drop new node in the
> distance.
> Because mesh metric is calculated with hop count and without RSSI
> information, a node far from local peer and near to destination node
> could be used as best path.
> 
> For example, the nodes are located in linear. Distance of 0 - 1 and
> 1 - 2 and 2 - 3 is 20meters. 0 to 3 signal is very weak.
> 
>     0 --- 1 --- 2 --- 3
> 
> Though most robust path from 0 to 3 is 0 -> 1 -> 2 -> 3,
> unfortunately, node 0 could recognize node 3 as neighbor. Then node 3
> could be next of node 0. This patch aims to avoid such a case.

I'm not really sure this is the right solution?

It seems to me that it should be a function of the path selection to
take this into account, not prohibiting the longer path entirely?

It seems that this is really what the meshcfg.rssi_threshold was
intended for, and the plink code *does* take it into account. Can you
explain where that's breaking down?

The documentation for this als talks about it being a plink threshold,
so I'm not really sure we should use it to kick out stations entirely.

johannes
