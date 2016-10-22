Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56942 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754877AbcJVUYQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Oct 2016 16:24:16 -0400
Message-ID: <1477167850.4123.0.camel@sipsolutions.net> (sfid-20161022_222427_470058_6CB6FD81)
Subject: Re: [PATCH v3 3/9] cfg80211: add add_nan_func / del_nan_func
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
        ayala.beker@intel.com, andrei.otcheretianski@intel.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 22 Oct 2016 22:24:10 +0200
In-Reply-To: <6fb30815-b8c8-aff4-86af-d7f496da91b5@broadcom.com> (sfid-20161022_211735_173825_72A3F61D)
References: <20160920143121.28247-1-luca@coelho.fi>
         <20160920143121.28247-4-luca@coelho.fi>
         <6fb30815-b8c8-aff4-86af-d7f496da91b5@broadcom.com>
         (sfid-20161022_211735_173825_72A3F61D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-10-22 at 21:17 +0200, Arend van Spriel wrote:
> On 20-09-16 16:31, Luca Coelho wrote:
> > 
> > +		.flags = GENL_ADMIN_PERM,

> Recently the nl80211_ops flags were changed to GENL_UNS_ADMIN_PERM so
> should the NAN commands use that as well?

The dangers of having such code non-upstream for too long...

It probably doesn't really matter, since most namespace uses are
probably hwsim where this isn't available, but yeah, I guess it should
be allowed to a namespace owner since he already "owns" the device if
it's in the namespace.

johannes
