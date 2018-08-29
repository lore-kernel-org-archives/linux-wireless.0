Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:35740 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbeH2KzF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 06:55:05 -0400
Message-ID: <1535525969.5215.3.camel@sipsolutions.net> (sfid-20180829_085943_680629_EC6C6D87)
Subject: Re: [PATCH v6 3/3] mac80211: Fix PTK rekey freezes and cleartext
 leaks
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander@wetzel-home.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Aug 2018 08:59:29 +0200
In-Reply-To: <0ed63254-cdb3-cefb-6074-d6a501809e8f@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
         <20180814104255.4183-4-alexander@wetzel-home.de>
         <1535446120.5895.6.camel@sipsolutions.net>
         <0ed63254-cdb3-cefb-6074-d6a501809e8f@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-28 at 18:27 +0200, Alexander Wetzel wrote:

> > This seems a bit weird - we know a likely dangerous thing is happening
> > and only print an info message? Why not just prevent this in the first
> > place?
> 
> The next version will upgrade that to a warning.

Maybe make it rate limited, and certainly not a WARN_ON() though.

> Rejecting it outright will break things for users with card/drivers
> where rekey currently is working. There is no error error message for
> "please re-associate as quick as you can" and tricking userspace to do
> that across versions and implementations would need code at I do not see
> belonging into the kernel. Here what I wrote in the cover letter of the
> v4 version of the patch about this decision:
> 
> > I do not see an acceptable way from the kernel to trigger a fast
> > reconnect. wpa_supplicant e.g. has some special code handling errors
> > during a 4-way-handshake differently. I assume we would have to add
> > code detecting if we are running as AP, Station Infrastructure, Ad-Hoc
> > or Mesh and then find and spoof an error which allows the userspace to
> > reconnect fast. For multiple different userspace implementations and
> > the different versions of them.
> > And we'll have that mess in the kernel for basically forever...
> > Seems to be a clear no go, correct?
> > 
> > So this patch (series) is giving up on a quick fix and will allow
> > broken rekeys to continue. It is instead providing an updated API for
> > both the userspace and the drivers to also do it correctly. Users
> > running a userspace not aware of the new API will get some
> > improvements but may
> > still leak cleartext packets and have connection freezes till we get
> > an updated userspace rolled out. On the plus side users running
> > updated userspace won't be able to rekey connections any longer,
> > avoiding the issues even with unpatched kernels.
> 
> Of course I may miss something and there may be a good way to get that
> working anyhow. But for me it looks like we either have to accept
> something which looks like a regression to users or accept that some
> drivers may not be fixed with this patch alone and will need either an
> updated userspace or drivers.

Ok, fair enough. I may be willing to accept something as a regression,
but at the same time perhaps it doesn't really belong into this patch
anyway, so we can always do it as a later one.

johannes
