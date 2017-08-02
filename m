Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56280 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753130AbdHBMSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 08:18:31 -0400
Message-ID: <1501676308.11126.0.camel@sipsolutions.net> (sfid-20170802_141834_347997_8317AFEA)
Subject: Re: [PATCH v2] mac80211: remove mic_fail_no_key label
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Michael Skeffington <mike@astro.ai>
Date: Wed, 02 Aug 2017 14:18:28 +0200
In-Reply-To: <20170802105310.GB4777@redhat.com> (sfid-20170802_125429_754563_1668FB33)
References: <20170802105310.GB4777@redhat.com>
         (sfid-20170802_125429_754563_1668FB33)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-08-02 at 12:53 +0200, Stanislaw Gruszka wrote:
> For historic reasons we have separate cases for mic_fail and
> mic_fail_no_key. But with current code we can merge those cases,
> as we already have NULL key check since commit a66b98db570a
> ("mac80211: fix rx->key NULL dereference during mic failure").
> 
Uh, no. rx->key->u.tkip.mic_failures will still crash.

johannes
