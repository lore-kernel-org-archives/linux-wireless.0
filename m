Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45808 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab1JJHsT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 03:48:19 -0400
Subject: Re: [PATCH 0/8] wireless: add DFS master support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <CAB=NE6UouofityugcjTvcXpBFx6cYEbAQ_FAe3gPO-GaS8Vh3w@mail.gmail.com> (sfid-20111008_202637_204055_B0D2AE63)
References: <1317772067-6998-1-git-send-email-mcgrof@qca.qualcomm.com>
	 <CAB=NE6V1gUSNc4L8sNv-NnDDVSzDB4A=cc_Z7tmZ79Q4LKtbwQ@mail.gmail.com>
	 <CAB=NE6VxNKJPQPBbkn9ha1EC6dWawj96B6f-R1XREN1JAcrOQQ@mail.gmail.com>
	 <CAB=NE6U6hFMBhgkjhpjpQk+FpMbDi4X6aW6i70MUWRH73K+AuQ@mail.gmail.com>
	 <CAB=NE6Xz26oOudnyw17_1ijqe+L8qwQAGH8qjZEocgHQOY54eg@mail.gmail.com>
	 <4E908C6D.7040703@neratec.com>
	 <CAB=NE6UouofityugcjTvcXpBFx6cYEbAQ_FAe3gPO-GaS8Vh3w@mail.gmail.com>
	 (sfid-20111008_202637_204055_B0D2AE63)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 09:48:13 +0200
Message-ID: <1318232893.4001.0.camel@jlt3.sipsolutions.net> (sfid-20111010_094822_850786_443FC56D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-08 at 11:26 -0700, Luis R. Rodriguez wrote:

> > 111 unknown / other
> >
> > to be able to mark special countrycodes that do not fully belong to the
> > three known domains.
> 
> I thought about this a bit more, so we'd have to define this as a U8
> attribute either way, so I would instead of calling NL80211_DFS_REGION
> call it something like NL80211_CTRY_REQS and for now only use 2 bits
> for the known DFS regions. We'd mask out the rest of the values. If we
> ever decide we need a new DFS region we could just extend the values
> on NL80211_CTRY_REQS after the last region. If we want to add a new
> requirement that is country specific other than DFS we could start at
> the end of the u8 instead of after the last DFS region. We could do
> this without making any explicit reservations.

I'm not sure I understand this fully, but the bitfield usage should
really be restricted to the database on-disk format; the nl80211 API
isn't restricted by byte shortages to start with :)

johannes

