Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab3FRJgT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 05:36:19 -0400
Message-ID: <1371548163.8318.2.camel@jlt4.sipsolutions.net> (sfid-20130618_113624_696931_05E0EB9D)
Subject: Re: [PATCH] mac80211: allow key deletion for mesh interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Date: Tue, 18 Jun 2013 11:36:03 +0200
In-Reply-To: <CAEFj987DCjNuv+W3oSq6ubHwjnkmKgKvcDThhP8s9ZXBsKmcjg@mail.gmail.com> (sfid-20130618_110728_700495_DC4DE8F2)
References: <CAEFj9864ioXkUy3Sg24k6vFTNR8ZfWj=to54J2VS=dvte+ExNA@mail.gmail.com>
	 <CAEFj987DCjNuv+W3oSq6ubHwjnkmKgKvcDThhP8s9ZXBsKmcjg@mail.gmail.com>
	 (sfid-20130618_110728_700495_DC4DE8F2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 17:07 +0800, Yeoh Chun-Yeow wrote:
> In sta_info_get_bss, should it be:
> 
> if ((sta->sdata == sdata &&
>                      (sta->sdata->bss && sta->sdata->bss == sdata->bss))
> 
> in stead of
> 
> if ((sta->sdata == sdata ||
>                      (sta->sdata->bss && sta->sdata->bss == sdata->bss))

What would the point be? Then we could just as well make it *only*
	sta->sdata == sdata
and it'd be the same as sta_info_get(). This is intentional for VLAN
handling.

> Otherwise, it seems that we still manage to get sta pointer even the
> bss is NULL.

What's the problem with that? But if this is a problem maybe we need to
explicitly check for non-NULL?

johannes

