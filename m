Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58262 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2FZMV5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:21:57 -0400
Received: by obbuo13 with SMTP id uo13so7953113obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jun 2012 05:21:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340712536.14634.13.camel@jlt3.sipsolutions.net>
References: <1340712213-10193-1-git-send-email-eyal@wizery.com> <1340712536.14634.13.camel@jlt3.sipsolutions.net>
From: Eyal Shapira <eyal@wizery.com>
Date: Tue, 26 Jun 2012 15:21:36 +0300
Message-ID: <CAF8O4-xVqME9B4_5EnTP-62x4Ly5mZUd8uF2MO_etBVqi6+Rpg@mail.gmail.com> (sfid-20120626_142210_814741_AC354329)
Subject: Re: [PATCH] mac80211: use legacy mode for all ACs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 June 2012 15:08, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2012-06-26 at 15:03 +0300, Eyal Shapira wrote:
> > AVM FritzBox 7390 has a weird behaviour where once we enable
> > U-APSD only on the VO AC it limits the rate of the packets
> > it sends to 39Mbps and doesn't do AMPDU aggregation.
> > This causes a big degradation in throughput obviously.
> > It's important to note that this isn't related to PS and happens
> > also when ACTIVE is forced. The traffic affected is sent in BE AC.
> > Once legacy mode for all ACs is used the AP begins using higher rates
> > as well as AMPDU aggregation which improves throughput significantly.
> >
> > In order to deal with this AP and potentially others switch to
> > using legacy mode for all ACs by default.
>
> This actually somewhat makes sense if they have a bad aggregation
> implementation, because you don't want VO to have latency, *especially*
> not when uAPSD was enabled, indicating that you want VO-like low-latency
> behaviour.
>
> I don't see why you're optimising for TPT on VO rather then latency?
>

The problem is that when we're requesting uAPSD on VO it messes up with
traffic sent on the BE AC which isn't supposed to get affected but it
does (probably
a bug). The effect is that any traffic we're doing gets very low TPT.
Apparently this AP
is quite common in Germany and other places so we can't just ignore it.

I was thinking that if someone wants uAPSD on the VO they can still
set it from userspace
through the nl80211.

>
> johannes
>
