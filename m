Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49237 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874Ab2GFQxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 12:53:32 -0400
Received: by pbbrp8 with SMTP id rp8so14873202pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2012 09:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UDfeN6oj83o4rO6EUJeLnrop82WQswu1O2z=gSbVrcAw@mail.gmail.com>
References: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1341357315-8053-5-git-send-email-rodrigue@qca.qualcomm.com>
 <1341394944.4482.9.camel@jlt3.sipsolutions.net> <CAB=NE6UfGuOh843dSx7NG7UYtEiDVcLUJbu6nFnBJs-Qk4tszw@mail.gmail.com>
 <1341474303.4455.5.camel@jlt3.sipsolutions.net> <CAB=NE6Uw1pso+HmVAahMvT3BZ0AheWxXuhJFLedvsHKXsUn11g@mail.gmail.com>
 <1341556785.4462.0.camel@jlt3.sipsolutions.net> <CAB=NE6XmbAu+xkLHYaBt=z6zdxXME5cOoANUd_3yEr+va_jb8g@mail.gmail.com>
 <1341583919.16893.3.camel@jlt3.sipsolutions.net> <CAB=NE6XNmrS=kqoptMg67JhBQUJfYa=jUFz+aU-4E91vzqjnTg@mail.gmail.com>
 <1341589880.16893.11.camel@jlt3.sipsolutions.net> <CAB=NE6XaRZa4HKg25gd5zkWn=LrjcAXq4NMPVcFWn+PdtVwRdw@mail.gmail.com>
 <1341591350.16893.13.camel@jlt3.sipsolutions.net> <CAB=NE6UDfeN6oj83o4rO6EUJeLnrop82WQswu1O2z=gSbVrcAw@mail.gmail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 6 Jul 2012 09:53:11 -0700
Message-ID: <CAB=NE6UGACusnfLAoLOy7L_ofGKawBGHEh0VFJLu9eTWp1ZZmw@mail.gmail.com> (sfid-20120706_185338_377572_4DB53548)
Subject: Re: [PATCH 4/4] cfg80211: add cellular base station regulatory hint support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kvalo@qca.qualcomm.com, arend@broadcom.com, henry@logout.com,
	senthilb@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 6, 2012 at 9:31 AM, Luis R. Rodriguez
<rodrigue@qca.qualcomm.com> wrote:
> upon wiphy registration we could detect if
> a device has the feature enabled and peg core_base_hint_enabled++ or
> whatever and then allow them through. Upon deregistration we'd
> core_base_hint_enabled-- and only enable the feature if its > 0.
>
> Seems doable.

Yeah.. I like this -- it means we wouldn't have to add a kconfig for
the feature, instead each driver could define a kconfig of its own for
it. I'll respin, thanks!

  Luis
