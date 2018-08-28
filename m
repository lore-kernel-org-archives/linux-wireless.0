Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:55522 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbeH1T4R (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 15:56:17 -0400
Message-ID: <1535472226.5895.58.camel@sipsolutions.net> (sfid-20180828_180400_521972_81B4944A)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Wetzel <alexander@wetzel-home.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 28 Aug 2018 18:03:46 +0200
In-Reply-To: <4cc30aa2-6235-f76c-485f-48fac8af3c1a@wetzel-home.de>
References: <20180814104255.4183-1-alexander@wetzel-home.de>
         <20180814104255.4183-2-alexander@wetzel-home.de>
         <1535446026.5895.5.camel@sipsolutions.net>
         <4cc30aa2-6235-f76c-485f-48fac8af3c1a@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-08-28 at 18:00 +0200, Alexander Wetzel wrote:

> > If you have a flag here, why say "userspace must not" rather than just
> > outright prevent userspace from doing it?
> 
> The userspace must not but currently of course is doing exactly that.
> Enforcing the new requirement would therefore cause user visible
> regressions till all drivers have been updated or the updated userspace
> software is deployed on all systems... Both will take years.
> 
> So the current approach is keep backward compatibility to not break
> rekeys for users it's currently working for.

Yeah but is it really working for them? They might have it "working",
but leak some frames in clear, like we said? So it might work for all
they notice, but leak frames once a while? I don't see how that's better
really.

johannes
