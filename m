Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:46136 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbeAVNYP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 08:24:15 -0500
Message-ID: <1516627453.2508.31.camel@sipsolutions.net> (sfid-20180122_142417_851699_8DA9B32A)
Subject: Re: [PATCH v3 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Jan 2018 14:24:13 +0100
In-Reply-To: <3c846ba5-a017-1993-79c6-2e33d78dfcf4@uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <44644db1-58a4-4b6e-a77e-37c72ee2e4a6@MAIL2.uni-rostock.de>
         <1516018121.410.13.camel@sipsolutions.net>
         <3c846ba5-a017-1993-79c6-2e33d78dfcf4@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-01-15 at 15:28 +0100, Benjamin Beichler wrote:
> Am 15.01.2018 um 13:08 schrieb Johannes Berg:
> > On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
> > >  Change the dump iteration to be independent from
> > > increasing radio indices on radio list.
> > 
> > You can't do that, data structures can be deleted while the dump is
> > ongoing.
> 
> That's what I try to address with this patch. In the past there were
> corner cases, which might have failed while deletion.

Hah, ok.

> Nonetheless, the radio count is in the current version strictly
> monotonic, maybe the description is misleading. :-)
> So in the inner loop there is no deletion possible because of the
> spinlock, and multiple calls of nl_dump check the generation count and
> cancel if it have changed.

Ah, I missed that you cancel when it's changed, we don't usually do
that normally.

I'd still prefer if you could have the code not rely on the pointers,
because if somebody gets it wrong (forgets to update the generation
count) I'm not sure I want that to crash in some corner cases...

johannes
