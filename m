Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34728 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932416AbeARVHz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 16:07:55 -0500
Received: by mail-pf0-f195.google.com with SMTP id e76so15630462pfk.1
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jan 2018 13:07:55 -0800 (PST)
Date: Thu, 18 Jan 2018 13:07:47 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfg80211: stop demanding lots of new stuff
In-Reply-To: <1516258057.410.55.camel@sipsolutions.net>
Message-ID: <alpine.LSU.2.11.1801181242280.14771@eggly.anvils> (sfid-20180118_220807_851373_149FA885)
References: <alpine.LSU.2.11.1801171448510.5433@eggly.anvils> (sfid-20180117_235601_216213_A3BA62CE) <1516258057.410.55.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Jan 2018, Johannes Berg wrote:
> On Wed, 2018-01-17 at 14:55 -0800, Hugh Dickins wrote:
> > "make oldconfig" from 4.14 (when CONFIG_CFG80211_CERTIFICATION_ONUS
> > is not set) to 4.15-rc, gets into asking lots of new questions, and
> > configuring in unwanted stuff: I'm unsure of my Kconfig skills, but
> > it looks like CFG80211_REQUIRE_SIGNED_REGDB's "default y" needs to
> > be toned down when we don't even have CFG80211_CERTIFICATION_ONUS.
> 
> No, this is wrong - we want default configurations to be able to load a
> signed regulatory database and validate the signature.

Great to enable that, but not so great to force new stuff on everyone.
It doesn't surprise me at all if the patch here is the wrong one,
but something needs to be done differently in this configuration.

Perhaps you did not try on a system without SYSTEM_DATA_VERIFICATION
already enabled - that "select SYSTEM_DATA_VERIFICATION" seems to be
taking effect even when CFG80211_REQUIRE_SIGNED_REGDB is not enabled,
and pulls in a boatload.  I agree that seems strange: perhaps the
Kconfig problem is somewhere else entirely.

Attached my old 4.14 config, so you can see for yourself - thanks.

In fact, I cannot even build the resulting config, without scurrying
around to update userspace with stuff I never needed before:

  HOSTCC  scripts/extract-cert
scripts/extract-cert.c:21:25: fatal error: openssl/bio.h: No such file or directory

Hugh

> 
> johannes
> 
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > ---
> > 
> >  net/wireless/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > --- 4.15-rc8/net/wireless/Kconfig	2017-12-03 10:22:51.928845056 -0800
> > +++ linux/net/wireless/Kconfig	2018-01-14 19:20:22.595472965 -0800
> > @@ -89,7 +89,7 @@ config CFG80211_CERTIFICATION_ONUS
> >  
> >  config CFG80211_REQUIRE_SIGNED_REGDB
> >  	bool "require regdb signature" if CFG80211_CERTIFICATION_ONUS
> > -	default y
> > +	default CFG80211_CERTIFICATION_ONUS
> >  	select SYSTEM_DATA_VERIFICATION
> >  	help
> >  	  Require that in addition to the "regulatory.db" file a
