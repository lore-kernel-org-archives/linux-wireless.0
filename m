Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41863 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932088AbcI3JsC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Sep 2016 05:48:02 -0400
Message-ID: <1475228878.17481.10.camel@sipsolutions.net> (sfid-20160930_114805_713727_041C49F9)
Subject: Re: [PATCH 3/3] mac80211: cache the only AP_VLAN station
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 30 Sep 2016 11:47:58 +0200
In-Reply-To: <1474821596-12155-4-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_184003_115938_F92E1D65)
References: <1474821596-12155-1-git-send-email-michael-dev@fami-braun.de>
         <1474821596-12155-4-git-send-email-michael-dev@fami-braun.de>
         (sfid-20160925_184003_115938_F92E1D65)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-09-25 at 18:39 +0200, Michael Braun wrote:
> If an AP_VLAN is only used with one station, cache a pointer to this
> station to avoid lookup. This should speed up station lookup when 

"should speed up"? Do you have numbers to back that up?

Read this as - you need to do more to convince me that the double
accounting and software complexity is worth it.

And then, if we really want/need to have the double accounting and all
the associated complexity and potential problems, perhaps making per-
interface lists, perhaps even replacing the global list (since we still
have a global hash table), or something similar would make more sense?

johannes
