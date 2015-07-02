Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34346 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbbGBMNx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 08:13:53 -0400
Received: by igcsj18 with SMTP id sj18so159991013igc.1
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 05:13:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435838499.2285.14.camel@sipsolutions.net>
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
 <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
 <1435082418.2777.11.camel@ipeer-box> <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
 <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
 <1435822032.2285.2.camel@sipsolutions.net> <CALhHN=ojLBA1AFGz=atjJhv+fJAr-Rkhd0cgYpma_4Rx+HYOaw@mail.gmail.com>
 <1435837168.2285.8.camel@sipsolutions.net> <CABPxzY+P+p18gVG-o9WhuQy_VVvR3QaS-CQMr8RuiD_2iSTFgw@mail.gmail.com>
 <1435838499.2285.14.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 2 Jul 2015 17:43:33 +0530
Message-ID: <CABPxzYLgYqL1M6tKx5fo7eJ_=_DJPNS0ttDvUpC3BKH+SyAEiA@mail.gmail.com> (sfid-20150702_141357_301929_C250F716)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 2, 2015 at 5:31 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2015-07-02 at 17:20 +0530, Krishna Chaitanya wrote:
>> On Thu, Jul 2, 2015 at 5:09 PM, Johannes Berg <
>> johannes@sipsolutions.net> wrote:
>> > On Thu, 2015-07-02 at 11:44 +0200, Janusz Dziedzic wrote:
>> > >
>> > > > The issue above can probably easily fixed by doing the BSS
>> > > > update
>> > > > after
>> > > > the "direct probe responded" though, no? Like this:
>> > > > https://p.sipsolutions.net/67f9212f0f9f3642.txt
>> > > >
>> > > This was my first idea, but in such case I suspect we will send
>> > > another direct probe while  bss->proberesp_ies will be not set
>> > > and
>> > > ieee80211_probe_auth() will send second probe_req?
>> Yes, if the seuqnce number is not set the second probe resp
>> also gets dropped.
>>
>> > But why would it not be set? We do rely on ieee80211_rx_bss_info()
>> > setting it, after all.
>> The probe resp is dropped early in the rx_path so this call is not
>> made.
>
> Yeah but that way Janusz's patch makes the whole probe step pointless -
> we *want* that information, if it doesn't show up we have another
> problem
If the probe response is valid then Janusz's patch make sense.

> That said, the original patch introducing this was:
>
> commit 9859b81eaeb8d48563b5fbd90215c0ae606455a3
> Author: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Date:   Sat Aug 9 03:02:19 2008 +0300
>
>     mac80211: add direct probe before association
>
>     This patch adds a direct probe request as first step in the association
>     flow if data we have is not up to date. Motivation of this step is to make
>     sure that the bss information we have is correct, since last scan could
>     have been done a while ago, and beacons do not fully answer this need as
>     there are potential differences between them and probe responses (e.g.
>     WMM parameter element)
>
>     Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
>     Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
>
> This addresses two things
>
> 1) potentially stale data (scan)
> 2) potential differences in IEs between beacons/probe responses
>
> I think the stale data issue is not all that relevant, since it's
> unlikely that the BSS actually got torn down and re-created with
> entirely different parameters.
Thismight still be relevant, if you remember our discussion
(http://permalink.gmane.org/gmane.linux.kernel.wireless.general/135533)
a while ago, in a passive scan environment beacon might have
the latest information than probe response but we end up using
probe response, so in those cases direct probe helps to
get the right capabilities.

But i remember your argument about changing AP config is not
much of a use case :-)

> The differences in IEs are also debatable - in particular the one that
> he gave as an example isn't all that relevant since we take it from the
> association response (unless the AP is broken and not including it
> there).
>
> HT/VHT information we don't take from the assoc response since that's
> also frequently broken, but we now (unlike at the time when that patch
> was written) update HT/VHT operation when it changes in the beacon.
>
> Overall I'm thus wondering if this direct probe step really buys us
> much today?

In an environment where AP config is changed this might be helpful
else not needed. Given the enterprise wifi deployments using controllers
auto-changing of AP config based on the environemnt may not be far away
