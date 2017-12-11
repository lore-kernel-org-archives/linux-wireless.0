Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51458 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751400AbdLKNHr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 08:07:47 -0500
Message-ID: <1512997665.26976.78.camel@sipsolutions.net> (sfid-20171211_140750_524323_772991FB)
Subject: Re: [PATCH v2 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Dec 2017 14:07:45 +0100
In-Reply-To: <5afe6ce9-5d7a-2b8e-f2bc-32088aacb9fe@uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
         <7ee141a4-8983-4da6-9c0f-f070fa6e5611@MAIL2.uni-rostock.de>
         <1512994493.26976.74.camel@sipsolutions.net>
         <8264ae6e-7db6-53b0-88c0-4ac4e51d0ba3@uni-rostock.de>
         <1512996543.26976.76.camel@sipsolutions.net>
         <5afe6ce9-5d7a-2b8e-f2bc-32088aacb9fe@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-12-11 at 14:02 +0100, Benjamin Beichler wrote:
> 
> > But you added this:
> > 
> > +       /* list changed */
> > +       if (cb->prev_seq && cb->seq != cb->prev_seq)
> > +               goto cleanup;
> > 
> > which is mostly just a copy of the inline.
> > 
> > johannes
> 
> Year you are right, but for nl_dump_check_consistent() I also need a
> header struct to write the flag to it and I thought a ghost header only
> to this function is also misleading. But if you think this is better, I
> can do that. Or we introduce a function, which really only check
> consistency and not also set the flag. I also thought the line is
> readable at it's own, because it's simply inconsistent if the sequence
> numbers are not equal.

It's readable, but there should be an indication to userspace in this
case, no?

johannes
