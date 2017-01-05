Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49192 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762249AbdAELtt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 06:49:49 -0500
Message-ID: <1483616947.4394.10.camel@sipsolutions.net> (sfid-20170105_125042_878434_86896C3C)
Subject: Re: [PATCH v2 3/4] cfg80211: Accept multiple RSSI thresholds for CQM
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jan 2017 12:49:07 +0100
In-Reply-To: <CAOq732JfxTx7KrPhic+2aej0ddj6igaqjcGzg+9MJ6=zDYfWAw@mail.gmail.com> (sfid-20170104_211949_638423_3D0195CD)
References: <20161212015213.21323-2-andrew.zaborowski@intel.com>
         <20161212015213.21323-3-andrew.zaborowski@intel.com>
         <1483545210.7312.17.camel@sipsolutions.net>
         <CAOq732JfxTx7KrPhic+2aej0ddj6igaqjcGzg+9MJ6=zDYfWAw@mail.gmail.com>
         (sfid-20170104_211949_638423_3D0195CD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-04 at 15:19 -0500, Andrew Zaborowski wrote:
> Hi,
> 
> On 4 January 2017 at 10:53, Johannes Berg <johannes@sipsolutions.net>
> wrote:
> > Should userspace really just get -EOPNOTSUPP back?
> 
> In what circumstance?

When multiple levels aren't supported, and it's requesting them. Rather
than, for example, being able to determine up-front (through a feature
flag) whether it's supported or not.

> > Also, this whole business with using an array in the existing
> > NL80211_ATTR_CQM_RSSI_THOLD is not very backward compatible,
> > because an old kernel would interpret this as just a single value
> > (the first one in your array) - ignoring entirely the fact that you
> > requested multiple.
> > 
> > Thus, you either need an nl80211 protocol feature bit (enum
> > nl80211_protocol_features) or a new attribute, or so, I think.
> 
> True, I'd assumed that netlink would check for exact attribute length
> with NLA_S32.
> 
> I'll add the feature bit but I wonder if it's better as a
> driver/device feature (enum nl80211_ext_feature_index) so that it can
> take into account whether rdev->set_cqm_rssi_range_config is set.

Well, it's even more complicated than that because mac80211 may have
the callback but still not be able to support it, with filtering,
perhaps? Not quite sure now.

Doing an (extended) feature flag this would address both points (also
the first, see above) in a single feature flag. Adding the protocol
feature flag would've addressed only the basic netlink attribute length
issue - so if we agree on the first point that a feature flag would be
useful for userspace to predict usability of the feature then we should
have it per device.

johannes
