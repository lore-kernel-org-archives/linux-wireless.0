Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49950 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751871AbdLKMtF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 07:49:05 -0500
Message-ID: <1512996543.26976.76.camel@sipsolutions.net> (sfid-20171211_134909_080218_00C63006)
Subject: Re: [PATCH v2 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Dec 2017 13:49:03 +0100
In-Reply-To: <8264ae6e-7db6-53b0-88c0-4ac4e51d0ba3@uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
         <7ee141a4-8983-4da6-9c0f-f070fa6e5611@MAIL2.uni-rostock.de>
         <1512994493.26976.74.camel@sipsolutions.net>
         <8264ae6e-7db6-53b0-88c0-4ac4e51d0ba3@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-12-11 at 13:37 +0100, Benjamin Beichler wrote:
> Am 11.12.2017 um 13:14 schrieb Johannes Berg:
> > On Tue, 2017-11-21 at 13:17 +0100, Benjamin Beichler wrote:
> > > Make the dump operation aware of changes on radio list and corresponding
> > > inconsistent dumps. Change the dump iteration to be independent from
> > > increasing radio indices on radio list.
> > 
> > Looks like this should use nl_dump_check_consistent()?
> > 
> > johannes
> > 
> 
> It is called in mac80211_hwsim_get_radio, I didn't changed that.

But you added this:

+       /* list changed */
+       if (cb->prev_seq && cb->seq != cb->prev_seq)
+               goto cleanup;

which is mostly just a copy of the inline.

johannes
