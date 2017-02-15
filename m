Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57892 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751422AbdBOKlq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 05:41:46 -0500
Message-ID: <1487155302.4026.21.camel@sipsolutions.net> (sfid-20170215_114149_826811_E1E8B90A)
Subject: Re: [RFC v2 3/7] ieee80211: add new VHT capability fields/parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com
Date: Wed, 15 Feb 2017 11:41:42 +0100
In-Reply-To: <827a5262-4a4b-d550-d5fe-fd53f3bb53db@broadcom.com> (sfid-20170215_113501_291526_7BCB6C33)
References: <20170214132208.8715-1-johannes@sipsolutions.net>
         <20170214132208.8715-4-johannes@sipsolutions.net>
         <281180d5-2a7e-00b5-f12b-13bf568812da@broadcom.com>
         <1487150216.4026.18.camel@sipsolutions.net>
         <d050648f-df94-8138-b9af-1ec18ba4af28@broadcom.com>
         <1487152112.4026.19.camel@sipsolutions.net>
         <1f3197b6-2860-632c-bbbb-3afac16f6edc@broadcom.com>
         <827a5262-4a4b-d550-d5fe-fd53f3bb53db@broadcom.com>
         (sfid-20170215_113501_291526_7BCB6C33)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-15 at 11:34 +0100, Arend Van Spriel wrote:
> On 15-2-2017 11:34, Arend Van Spriel wrote:
> > On 15-2-2017 10:48, Johannes Berg wrote:
> > > On Wed, 2017-02-15 at 10:36 +0100, Arend Van Spriel wrote:
> > > > 
> > > > > I'm not really sure what to do - we don't really want to
> > > > > print a
> > > > > message on something that might have been received from the
> > > > > peer, I
> > > > > think? Though I suppose we should return 0 for the invalid
> > > > > combinations, indicating that they're not supported.
> > > > 
> > > > Ah. This is all non-functional code yet, right? At least having
> > > > a
> > > > static non-inline function in ieee80211.h will give build
> > > > issues I
> > > > would think.
> > > 
> > > No, I marked it __maybe_unused so it'll be fine. I didn't want to
> > > have
> > > it inlined if you use it multiple times in a single source file,
> > > but I
> > > didn't want to move it to somewhere else either ...
> > 
> > Ah. Now I understand the trickery ;-) Was there really no
> > "somewhere
> > else" to move it, because honestly it is confusing and a bit
> > wasteful if
> > used multiple times in cfg80211 and/or drivers.
> 
> Although exporting it also comes at a cost.

Yeah, we could put it into cfg80211 and export it. I haven't really
looked how big it is, but it does seem big.

The other thing is that the ieee80211.h file was pretty much standalone
definitions of the spec until now - if we move it to cfg80211, should
the function prototype really be declared in this file?

johannes
