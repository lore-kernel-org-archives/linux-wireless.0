Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbXJAOLF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 10:11:05 -0400
Subject: Re: userspace mlme configuration (was: Kernelspace --> Userspace  MLME move and related items)
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>,
	Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1191068858.22960.75.camel@johannes.berg>
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
	 <1191066581.22960.55.camel@johannes.berg>
	 <1191068858.22960.75.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 01 Oct 2007 10:06:31 -0400
Message-Id: <1191247591.4490.13.camel@xo-3E-67-34.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-09-29 at 14:27 +0200, Johannes Berg wrote:
> Ok, here are my thoughts on why alternative one is best. To recap, these
> are the alternatives I see when configuring the userspace MLME (copied
> from the wiki as I just wrote it there):
> 
>   Userspace MLME configuration (alternative 1)
>                    nl80211                     nl80211
>     { nm | iw } -------------> { cfg80211 } -------------> { umlme }
> 
>   Userspace MLME configuration (alternative 2)
>                    nl80211
>     { nm | iw } -------------> { umlme }
> 
>   Userspace MLME configuration (alternative 3)
>                   socket (*)
>     { nm | iw } -------------> { umlme }
> 
> 
> Currently, we have alternative three being used by nm and wpa_cli to
> configure wpa_supplicant via the control socket.

Note that NM 0.7 drives wpa_supplicant over D-Bus.  It doesn't use the
wpa_supplicant control socket any more.  It was ugly.

> As I said before, I favour alternative one, for the following reasons:
> 
> 1) it is transparent
> 
> Alternative one means that the userspace tools do not need to know
> whether a userspace MLME is used or not. It is completely transparent,
> the regular command line tools can be used, tools that need to scan with
> certain parameters can just request a scan via the regular mechanism and
> expect results.
> 
> 2) it helps us define the interfaces
> 
> With more processing power becoming available in smaller form factors
> and more MLME features required by new networked appliances like
> cameras, washing machines etc., I expect that full-mac chipsets will
> start to become more common again. Especially mesh-networking like used
> in the XO may be a push for this. However, it is not clear that
> everybody will have drivers for such hardware. Defining the full
> interface to the MLME in terms of nl80211 even when most of the MLME is
> implemented in userspace allows us to experiment with the full MLME
> interface even though we don't always have full-MAC chipsets or drivers
> available to experiment with.
> 
> 3) it is UMLME-agnostic
> 
> The current control socket implemented in wpa_supplicant was designed
> specifically for wpa_supplicant and much more for the actual WPA
> features than all the MLME features. I don't want to say that it is
> ill-defined or badly documented, neither seems to be the case, but I do
> think that it being defined for wpa_supplicant could be a stumbling
> block when you want to implement it within another UMLME.
> 
> 4) it can support wext
> 
> Since we go through the kernel, we can introduce a thunking layer that
> makes wext->nl80211 conversions for the userspace MLME and the other way
> around for the results. This requires some work and also requires making
> wext not take the RTNL so a userspace MLME can't block the RTNL, but is
> certainly possible and makes the userspace MLME even transparent to
> legacy tools.
> 
> 
> Arguments two and three really speak for both alternatives one and two,
> while one and four are unique to alternative one.

For NM, as long as wpa_supplicant gets ported to use nl80211 (maybe add
another driver_nl80211.c instead of driver_wext.c) then NM should work
fine.  I've punted almost all of the direct driver interface code to
wpa_supplicant; NM doesn't touch wireless devices much anymore at all.
Since wpa_supplicant has to get ported to nl80211 _anyway_,
independently of NetworkManager, I figured it would reduce overall work
to make the changes in one place.

Dan


