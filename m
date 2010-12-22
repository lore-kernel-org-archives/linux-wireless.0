Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:52781 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0LVS5X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 13:57:23 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 10:57:07 -0800
Date: Wed, 22 Dec 2010 13:57:18 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>, <it@atheros.com>
Subject: Re: [PATCH] compat-wireless: build led support conditionally
Message-ID: <20101222185718.GE8384@tux>
References: <1293041434-3594-1-git-send-email-hauke@hauke-m.de>
 <AANLkTik9=gSpE6sRoYZu-RZv3PjeQdtf_Y9hc=X-Z7w=@mail.gmail.com>
 <4D1247C2.6090500@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4D1247C2.6090500@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 10:47:30AM -0800, Hauke Mehrtens wrote:
> On 12/22/2010 07:23 PM, Luis R. Rodriguez wrote:
> > On Wed, Dec 22, 2010 at 1:10 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >> diff --git a/config.mk b/config.mk
> >> index 964c646..1f95908 100644
> >> --- a/config.mk
> >> +++ b/config.mk
> >> @@ -133,7 +133,9 @@ CONFIG_COMPAT_MAC80211_RC_DEFAULT=minstrel_ht
> >>  CONFIG_MAC80211_RC_PID=y
> >>  CONFIG_MAC80211_RC_MINSTREL=y
> >>  CONFIG_MAC80211_RC_MINSTREL_HT=y
> >> +ifdef CONFIG_LEDS_TRIGGERS
> >>  CONFIG_MAC80211_LEDS=y
> >> +endif #CONFIG_LEDS_TRIGGERS
> > 
> > Without using a space for the ifdef'd variable the
> > include/linux/compat_autoconf.h will end up still defining it but you
> > should not get it set on the local Makefiles, in this case we want it
> > to not be defined in the compat_autoconf.h as well so how about
> > instead (handing off to my atheros address as I use mutt there, one
> > second)
> 
> The script generating include/linux/compat_autoconf.h will also add the
> ifdefs into compat_autoconf.h. The generated entry looks like this:
> 
> #if defined(CONFIG_LEDS_TRIGGERS) || defined(CONFIG_LEDS_TRIGGERS_MODULE)
> #ifndef CONFIG_MAC80211_LEDS
> #define CONFIG_MAC80211_LEDS 1
> #endif /* CONFIG_MAC80211_LEDS */
> #endif /* CONFIG_LEDS_TRIGGERS */
> 
> I added this feature some months ago.

Ah neat thanks!

> Hauke
> 
> Your mail server at atheros did not accept my mail, because the IP
> address I got from my local ISP ( 91.97.249.71 ) is on some blacklist.
> But this is normal and the mail was sent throught my mail server which
> IP address is not on that blacklist. Your mail server seams to be mis
> configured.

Cc'ing our IT.

  Luis
