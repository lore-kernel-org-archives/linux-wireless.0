Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:32850 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194AbbFHIyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 04:54:31 -0400
Received: by obcej4 with SMTP id ej4so42192036obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2015 01:54:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj986CCryd1fK6NpoQYOmCiu+KRjq8RsSgvWqQOvLBPvFoeg@mail.gmail.com>
References: <CAEFj986CCryd1fK6NpoQYOmCiu+KRjq8RsSgvWqQOvLBPvFoeg@mail.gmail.com>
Date: Mon, 8 Jun 2015 16:54:30 +0800
Message-ID: <CAEFj987VjaQpwx2VMxYeH7TWcKVvjN6hSRsqTSbSXa1ZammezQ@mail.gmail.com> (sfid-20150608_105434_969689_36E28982)
Subject: Re: [PATCH] mac80211: Fix a case of incorrect metric used when
 forwarding a PREQ
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As mentioned in Section 13.10.9.3 Case E2, the PREQ forwarding should
use metric "as received + own metric toward transmitter of received
PREQ". So you are right.

Just MP_F_RF bit is no longer use. After replying with PREP,
forwarding the PREQ by setting the IEEE80211_PREQ_TO_FLAG in the per
target flags.

---
Chun-Yeow

On Mon, Jun 8, 2015 at 4:07 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Alexis Green
>
> I just take a look back on the code before implementing the Proactive
> PREQ for PREP. For the case of reply and forward (target_flags &
> MP_F_RF), the previous metric used is the one which resolved from
> mpath->metric.
>
> Refer here: https://github.com/o11s/open80211s/blob/o11s-0.4.2/net/mac80211/mesh_hwmp.c
>
> But to say that, I cannpt confirm whether this is correct. The
> standard 802.11-2012 has no longer specified bit-1 MP_F_RF (Refer
> section 8.4.2.115 per target flag). So maybe it is not relevant
> anymore. We may need to remove as well.
>
> ----
> Chun-Yeow
