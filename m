Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab0JHSDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:03:07 -0400
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Steve deRosier <steve@cozybit.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTin6nwrhcGdnGxg_gMGSrD_GBc-R51qiendF4iAc@mail.gmail.com>
References: <201009210057.13297.chunkeey@googlemail.com>
	 <20100924180013.GD8077@tuxdriver.com>
	 <201009250002.21219.chunkeey@googlemail.com>
	 <AANLkTinCkWGs_KMz+QBUw2J5HUVU2hK1+8kVDr_PNZwP@mail.gmail.com>
	 <1286492072.20974.49.camel@jlt3.sipsolutions.net>
	 <AANLkTin6nwrhcGdnGxg_gMGSrD_GBc-R51qiendF4iAc@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 20:03:05 +0200
Message-ID: <1286560985.3612.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-08 at 10:56 -0700, Javier Cardona wrote:

> We believe Christian's second patch fixes a null-pointer de-reference
> that would be triggered by a PLINK_OPEN frame with
> mismatching/incompatible mesh configuration.  Let's analyze that case:
> 
> void mesh_rx_plink_frame(...)
> (...)
> sta = sta_info_get(sdata, mgmt->sa);    <-- will return null
> if (!sta && ftype != PLINK_OPEN) {       <-- false for PLINK_OPEN frames
> (...)
> if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
> <-- true for PLINK_OPEN, non-compatible mesh config
>              (...)
>              spin_lock_bh(&sta->lock);         <-- boom!

Good point. I glossed over the part here and just looked at the else
branch with !sta.

> The patch not only solves this problem, but also responds correctly to
> non-compatible PLINK_OPEN frames by generating a PLINK_CLOSE with the
> right reason code.

But then you can't ever actually properly process a *matching*
PLINK_OPEN frame, afaict, because those definitely do have
	"!sta && ftype == PLINK_OPEN"

which is how the "if (!sta && ftype != PLINK_OPEN) return" came about,
afaict.

So I still don't think it's quite correct to fix it this way.

johannes

