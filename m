Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:64514 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbXI1VUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2007 17:20:23 -0400
Received: by nz-out-0506.google.com with SMTP id s18so2103747nze
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2007 14:20:22 -0700 (PDT)
Message-ID: <1ba2fa240709281420n6b32efa9ha8ffb1af6edc4264@mail.gmail.com>
Date: Fri, 28 Sep 2007 23:20:21 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi scan question
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1190980214.13581.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1190815228.4204.9.camel@johannes.berg>
	 <1ba2fa240709280441s3eceac51x74a8bb8e422808f2@mail.gmail.com>
	 <1190980214.13581.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/28/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2007-09-28 at 13:41 +0200, Tomas Winkler wrote:
> > On 9/26/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > When iwlwifi scans in firmware, which MAC address does it use? What if
> > > you've added multiple virtual interfaces as you said you could support?
> > >
> > Scanning is STA feature so only one MAC address is used in that case.
> > namely iwl_rxon_cmd.node_addr
>
> Whichever address that will be, ok :)
>
> Though, actually, scanning is not just a STA feature is it? APs will
> sometimes want to do a quick background scan too, I think.
>

We do monitor beacons on the same channels or channels for 11n
coexistence issues but I don't think protocol wise in AP mode it is
possible to stop listening on the channel. But I'm not the expert on
this issues WDS etc.
There are some other cases when you mix STA and AP mode but that's
another story.

> > Do you know any use case to support STA with multiple MAC addresses?
>
> Not really, unless you can implement a TSF adoption per local MAC
> address. I guess you could turn off powersave and do the backoff
> algorithm a bit out of spec and get by with just one timer too.
>
> johannes
>
>
