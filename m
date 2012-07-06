Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50864 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab2GFOME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 10:12:04 -0400
Message-ID: <1341583919.16893.3.camel@jlt3.sipsolutions.net> (sfid-20120706_161208_993106_5ABE7754)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Date: Fri, 06 Jul 2012 16:11:59 +0200
In-Reply-To: <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com> (sfid-20120706_160608_656782_E1FD7845)
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
	 <1341394944.4482.9.camel@jlt3.sipsolutions.net>
	 <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
	 <1341474303.4455.5.camel@jlt3.sipsolutions.net>
	 <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
	 <1341556785.4462.0.camel@jlt3.sipsolutions.net>
	 <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
	 (sfid-20120706_160608_656782_E1FD7845)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-06 at 07:05 -0700, Luis R. Rodriguez wrote:

> That, but also it means there are two hops for a device to use the
> cell base station hint: onus option, and then the feature flag, which
> could be wrapped itself around a driver specific kconfig option.
> Reason for the feature flag is devices may need a firmware update in
> order for them to work properly.
> 
> As for the onus and the cell base station hint though, it is true
> though that the onus option would alone enable the core cell base
> station hints, so the onus option itself would be flipping a switch
> for a feature. I could extend the patch to include a core specific
> base station hint kconfig option, because as you say there is no
> specific switch to select the feature right now for the core.

I guess the question is -- what does that code really enable, if the
driver doesn't also set the feature flag? If it doesn't mean anything
without the flag I think we don't need the extra core option?

johannes

