Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43955 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab2GFOGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 10:06:06 -0400
Received: by yenl2 with SMTP id l2so8600759yen.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 07:06:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341556785.4462.0.camel@jlt3.sipsolutions.net>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
 <1341394944.4482.9.camel@jlt3.sipsolutions.net> <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
 <1341474303.4455.5.camel@jlt3.sipsolutions.net> <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
 <1341556785.4462.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 6 Jul 2012 07:05:45 -0700
Message-ID: <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com> (sfid-20120706_160611_741192_1CE1C906)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 5, 2012 at 11:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Oh, that explains the extra flag there, I pretty much thought it was
> useless. I guess that could be useful for when you ship some device with
> builtin wireless but allow plugging in other wireless?

That, but also it means there are two hops for a device to use the
cell base station hint: onus option, and then the feature flag, which
could be wrapped itself around a driver specific kconfig option.
Reason for the feature flag is devices may need a firmware update in
order for them to work properly.

As for the onus and the cell base station hint though, it is true
though that the onus option would alone enable the core cell base
station hints, so the onus option itself would be flipping a switch
for a feature. I could extend the patch to include a core specific
base station hint kconfig option, because as you say there is no
specific switch to select the feature right now for the core.

That would mean at most 3 options that would need to be enabled for
the feature for a specific device. Thoughts ?

  Luis
