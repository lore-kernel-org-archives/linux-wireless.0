Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34454 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752480AbeBJVMW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Feb 2018 16:12:22 -0500
Message-ID: <1518297139.2029.9.camel@sipsolutions.net> (sfid-20180210_221225_381387_3D20137C)
Subject: Re: Regulatory: reg.c : wiphy_apply_custom_regulatory()
From: Johannes Berg <johannes@sipsolutions.net>
To: Neelansh Mittal <neelansh@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Sat, 10 Feb 2018 22:12:19 +0100
In-Reply-To: <CANg=XDQ0g1=BzJnbbKYyH=Jyx7hTRRem2YL5hqEM0tiB-buwLA@mail.gmail.com> (sfid-20180124_200846_028108_F8C231E6)
References: <CANg=XDQ0g1=BzJnbbKYyH=Jyx7hTRRem2YL5hqEM0tiB-buwLA@mail.gmail.com>
         (sfid-20180124_200846_028108_F8C231E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Can wiphy_apply_custom_regulatory() be called after wiphy registeration?
> The documentation(comment) says "/* Used by drivers prior to wiphy
> registration */"
> Whys is there a restriction to call this after registration? Is the
> comment outdated? After Tracing the regulatory code in the cfg80211,
> it seems that there should be no restriction.

Well, I think nothing gets reported to userspace when you call this
function, which I think is the reason for this.

If you want to update on the fly you should call
regulatory_set_wiphy_regd() instead?

johannes
