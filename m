Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57462 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751504AbdBOJsg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2017 04:48:36 -0500
Message-ID: <1487152112.4026.19.camel@sipsolutions.net> (sfid-20170215_105315_436036_780F8107)
Subject: Re: [RFC v2 3/7] ieee80211: add new VHT capability fields/parsing
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com
Date: Wed, 15 Feb 2017 10:48:32 +0100
In-Reply-To: <d050648f-df94-8138-b9af-1ec18ba4af28@broadcom.com> (sfid-20170215_103656_237359_A3F83E58)
References: <20170214132208.8715-1-johannes@sipsolutions.net>
         <20170214132208.8715-4-johannes@sipsolutions.net>
         <281180d5-2a7e-00b5-f12b-13bf568812da@broadcom.com>
         <1487150216.4026.18.camel@sipsolutions.net>
         <d050648f-df94-8138-b9af-1ec18ba4af28@broadcom.com>
         (sfid-20170215_103656_237359_A3F83E58)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-02-15 at 10:36 +0100, Arend Van Spriel wrote:
> 
> > I'm not really sure what to do - we don't really want to print a
> > message on something that might have been received from the peer, I
> > think? Though I suppose we should return 0 for the invalid
> > combinations, indicating that they're not supported.
> 
> Ah. This is all non-functional code yet, right? At least having a
> static non-inline function in ieee80211.h will give build issues I
> would think.

No, I marked it __maybe_unused so it'll be fine. I didn't want to have
it inlined if you use it multiple times in a single source file, but I
didn't want to move it to somewhere else either ...

> Anyway, I would indeed return 0 and have caller deal with that.

Yeah, I'll do that.

johannes
