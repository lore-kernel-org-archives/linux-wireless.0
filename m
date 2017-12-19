Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59046 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752624AbdLSULd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 15:11:33 -0500
Message-ID: <1513714290.26145.24.camel@sipsolutions.net> (sfid-20171219_211213_535539_ECABF817)
Subject: Re: [PATCH for-4.15] wireless: create, don't append, to
 shipped-certs.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Brian Norris <briannorris@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>,
        Damian Tometzki <damian.tometzki@icloud.com>
Date: Tue, 19 Dec 2017 21:11:30 +0100
In-Reply-To: <20171219192303.31395-1-briannorris@chromium.org> (sfid-20171219_202313_371734_5DF1684C)
References: <20171219192303.31395-1-briannorris@chromium.org>
         (sfid-20171219_202313_371734_5DF1684C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-12-19 at 11:23 -0800, Brian Norris wrote:
> 
> In practice, this is seen often by having a separate source and build
> directory, where the build artifacts remain but the source tree changes
> (even if Seth's cert doesn't change, it might get created/removed when
> checking out different source revisions).
> 
> I don't see why this rule should be an append; we're writing the file
> all in one go.

Yeah, that was an oversight from the code prior to my changes to make
it write it only once.

> Fixes: 90a53e4432b1 ("cfg80211: implement regdb signature checking")
> Signed-off-by: Brian Norris <briannorris@chromium.org>
> ---
> This is an error introduced in 4.15-rc1.
> 
> I've seen other errors reported by Paul and Damian (CC'd); I think Paul's
> failure was fixed already, but Damian might have still been having problems
> with not having a "clean" environment. Perhaps he was hitting this bug?

I'm not really sure what that problem was - I think a combination of
missing clean-files and this perhaps? Anyway, I applied another fix for
this today, and it's on the way to Linus's tree, along with the missing
clean-files and a conversion to non-binary files so that patches work
better.

johannes
