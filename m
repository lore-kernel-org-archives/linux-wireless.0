Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63141 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1G3Pv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 11:51:26 -0400
Received: by fxh19 with SMTP id 19so3174768fxh.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 08:51:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: problem on ACS
Date: Sat, 30 Jul 2011 17:54:13 +0200
Cc: MingAnn Ng <devil_eddie01@hotmail.com>, nbd@openwrt.org,
	wireless testing <linux-wireless@vger.kernel.org>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <201107301317.14486.chunkeey@googlemail.com> <CAB=NE6V-=m+S2mkK5ugAfUnBUD_Wvttot6rndC6ToCi8hc2RGw@mail.gmail.com>
In-Reply-To: <CAB=NE6V-=m+S2mkK5ugAfUnBUD_Wvttot6rndC6ToCi8hc2RGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201107301754.13432.chunkeey@googlemail.com> (sfid-20110730_175130_232441_71E2A996)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 30 July 2011 13:29:52 Luis R. Rodriguez wrote:
> On Sat, Jul 30, 2011 at 4:17 AM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > Wait a sec... I guess you misunderstood my post about the cut-off.
> > I meant that you can cut of at the bottom by using log2(max(1, val)).
> > This ensures that the log2 will always be >= 0 anyway. In fact log2(1) = 0.
> 
> I get that now, but my point was that we also had to cap it for a
> higher value too. We now restrict the input to values within the data
> type and also ensure log2 will always be >= 0.
Doesn't acs [not to be confused with cisco acs] use u64 for all input
data? If so, why do we need to restrict those? After all 2^64-1 ms is
still around 584.9 million years.

(BTW: I don't understand the comment of log2_sane. 
log2(2^30) + log2(2^30) = 60. so this should work very well
with a long double. Even with just 80-bit, the range goes from
something like 3.65 * 10^-4951 to 1.19 x 10^4932.)

	Chr
