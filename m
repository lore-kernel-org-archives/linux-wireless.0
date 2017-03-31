Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45378 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752489AbdCaLuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 07:50:04 -0400
Message-ID: <1490961001.6288.8.camel@sipsolutions.net> (sfid-20170331_135007_265928_45AFECD5)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Date: Fri, 31 Mar 2017 13:50:01 +0200
In-Reply-To: <5274c4b4-9bce-208c-e3f2-640d54b81a30@broadcom.com> (sfid-20170328_125041_391430_D9B7273C)
References: <20170221123758.5339-1-johannes@sipsolutions.net>
         <20170221123758.5339-2-johannes@sipsolutions.net>
         <5274c4b4-9bce-208c-e3f2-640d54b81a30@broadcom.com>
         (sfid-20170328_125041_391430_D9B7273C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-03-28 at 12:50 +0200, Arend Van Spriel wrote:
> 
> So looking at wpa_supplicant RFC patches I see that it now diverts
> driver_nl80211_set_key() for ALG_PMK case to the new api. So why not
> extending CMD_NEW_KEY to support ALG_PMK?

I don't really care what the supplicant does, but IMHO having
completely different types of keys in the same API isn't a good idea.
We'd have to invent (a) cipher suite(s), or new attributes, to even
encapsulate that in netlink - and the usage is completely different
etc.

johannes
