Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42546 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751839AbcJUT43 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 15:56:29 -0400
Message-ID: <1477079782.4068.50.camel@sipsolutions.net> (sfid-20161021_215633_140987_4E7B31C8)
Subject: Re: [PATCH 2/2] mac80211: use inline kernel-doc for struct
 ieee80211_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Jani Nikula <jani.nikula@intel.com>,
        linux-wireless@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Date: Fri, 21 Oct 2016 21:56:22 +0200
In-Reply-To: <a6fb17b3-0ec6-e23b-4ae3-f84385cf84ae@broadcom.com> (sfid-20161021_205937_290937_4C8B3DB1)
References: <1477054644-5945-1-git-send-email-jani.nikula@intel.com>
         <1477054644-5945-2-git-send-email-jani.nikula@intel.com>
         <1477054892.4068.44.camel@sipsolutions.net>
         <a6fb17b3-0ec6-e23b-4ae3-f84385cf84ae@broadcom.com>
         (sfid-20161021_205937_290937_4C8B3DB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-21 at 20:59 +0200, Arend van Spriel wrote:
> Me neither. I actually found it annoying to have all kernel-doc above
> the type definition and indeed easy to miss fields. Now struct
> ieee80211_hw is not alone and we have it all over the place in the
> wireless subsystem. Is this something we want to embrace and maybe
> find janitors/newbies/coccinelle-gurus to address it. Not sure if
> coccinelle could deal with this.

I don't think coccinelle can look into comments, though perhaps it
could be used to *place* them - use kernel-doc script to extract them
first, and then make that output a coccinelle script to place the
comment back at the right spot?

Overall though, not sure that's worth it over just doing it by hand
once? Then again, that could be used to mass-convert more ... :)

johannes
