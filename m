Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47501 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab0EMBGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 21:06:35 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:06:35 -0700
Date: Wed, 12 May 2010 18:06:34 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH 2/2] compat-wireless: make patches apply again
Message-ID: <20100513010633.GC2717@tux>
References: <1273526650-26282-1-git-send-email-hauke@hauke-m.de>
 <201005121720.50514.br1@einfach.org>
 <AANLkTinkg1lG6Zc-9CfxABp0DVpTsym1YFKlcFCHTMTE@mail.gmail.com>
 <201005131000.57369.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201005131000.57369.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 12, 2010 at 06:00:57PM -0700, Bruno Randolf wrote:
> On Thursday 13 May 2010 01:28:18 Luis R. Rodriguez wrote:
> > On Wed, May 12, 2010 at 1:20 AM, Bruno Randolf <br1@einfach.org> wrote:
> > > On Tuesday 11 May 2010 06:24:10 Hauke Mehrtens wrote:
> > >> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> > >> ---
> > >>  patches/07-change-default-rate-alg.patch |    4 ++--
> > >>  1 files changed, 2 insertions(+), 2 deletions(-)
> > >> 
> > >> diff --git a/patches/07-change-default-rate-alg.patch
> > >> b/patches/07-change-default-rate-alg.patch index af65207..f0ccbce 100644
> > >> --- a/patches/07-change-default-rate-alg.patch
> > >> +++ b/patches/07-change-default-rate-alg.patch
> > >> @@ -21,7 +21,7 @@ at compilation time.
> > >>   module_param(ieee80211_default_rc_algo, charp, 0644);
> > >>   MODULE_PARM_DESC(ieee80211_default_rc_algo,
> > >>                "Default rate control algorithm for mac80211 to use");
> > >> -@@ -118,8 +118,8 @@ ieee80211_rate_control_ops_get(const cha
> > >> +@@ -119,8 +119,8 @@ ieee80211_rate_control_ops_get(const cha
> > >>               ops =
> > > 
> > > ieee80211_try_rate_control_ops_get(ieee80211_default_rc_algo);
> > > 
> > >>       /* try built-in one if specific alg requested but not found */
> > >> @@ -29,6 +29,6 @@ at compilation time.
> > >>  -            ops =
> > > 
> > > ieee80211_try_rate_control_ops_get(CONFIG_MAC80211_RC_DEFAULT);
> > > 
> > >>  +    if (!ops && strlen(CONFIG_COMPAT_MAC80211_RC_DEFAULT))
> > >>  +            ops =
> > >> ieee80211_try_rate_control_ops_get(CONFIG_COMPAT_MAC80211_RC_DEFAULT); +
> > >>       kparam_unblock_sysfs_write(ieee80211_default_rc_algo);
> > >> 
> > >>       return ops;
> > >> - }
> > > 
> > > this is somehow messed up and doesn't apply. here is a fixed version of
> > > the patch (not a patch for a patch)...
> > 
> > Odd, it applied, here with git am and all. Hm, oh well.
> 
> sorry, i wasn't clear about it. the patch from the mail obviously applied and 
> i got it by git pull. but the resulting patch "07-change-default-rate-
> alg.patch" does not apply any more, so i sent a fixed up version of that file.

Sorry I'm still a little lost still, can you post any pending patch on a
new e-mail ?

  Luis
