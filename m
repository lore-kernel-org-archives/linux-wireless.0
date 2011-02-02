Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:41808 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832Ab1BBLb2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 06:31:28 -0500
Date: Wed, 2 Feb 2011 13:30:52 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Amod Bodas <Amod.Bodas@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>,
	Sree Durbha <Sree.Durbha@atheros.com>,
	Deepak Dhamdhere <Deepak.Dhamdhere@atheros.com>,
	Xin Jin <Xin.Jin@atheros.com>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
Message-ID: <20110202113052.GA14126@jm.kir.nu>
References: <AANLkTikbrzLeeY8Gosw+7Aic1=V=5f+sD382sXwGDWbA@mail.gmail.com>
 <AANLkTi=_gHfEKKC2rsA0pc6Otu5FU4CtVKA2UR85b+GV@mail.gmail.com>
 <AANLkTim9uNH8BzjDM5Ekt3ayBe+7QfE4vnXR0bc-=-Yn@mail.gmail.com>
 <AANLkTikasAe2H+HyoWDr=NbuxW6LJAET-JqATWMmMmq0@mail.gmail.com>
 <1296633772.3624.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296633772.3624.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 02, 2011 at 09:02:52AM +0100, Johannes Berg wrote:
> On Tue, 2011-02-01 at 21:41 -0500, Bob Copeland wrote:
> > From the wiki:
> > 
> > "The proper approach would be to provide a custom driver_nl80211_android.c
> > wrapper for the modified wpa_supplicant in Android."
> > 
> > I just don't think it's strictly necessary to ship a modified wpa_s.
> > Why is Android special when bog standard Linux gets by ok with
> > driver_nl80211?
> 
> Agree, that is a dumb idea. What's that driver going to do? Use custom
> nl80211 extensions?! That way lies insanity.

The only reason for that is to be able to support the wpa_supplicant
modifications used in Android that are not acceptable for upstream
hostap.git (mainly, driver_cmd). This would not add any custom nl80211
extensions; the needed functionality should be added properly to
upstream nl80211.

If it is fine to remove the custom wpa_supplicant modifications from
Android, this is obviously a moot point, but until that happens, the
easiest approach seems to be to provide a custom driver_*.c based on
nl80211 to isolate the custom changes to user space and to small part of
it at that. I don't really want to see new drivers trying to provide
WEXT support with private ioctls to address need for making it work with
Android..

-- 
Jouni Malinen                                            PGP id EFC895FA
