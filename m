Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59241 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab1ANXTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 18:19:02 -0500
Received: by iyj18 with SMTP id 18so2962975iyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 15:19:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
Date: Sat, 15 Jan 2011 00:19:01 +0100
Message-ID: <AANLkTi=WTUiy1DYNhE12_KZp8QFUrWebY2Cpzud5P0b3@mail.gmail.com>
Subject: Re: [RFC 1/2] ath9k: Fix up hardware mode and beacons with multiple vifs.
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 14, 2011 at 6:27 PM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> When using a mixture of AP and Station interfaces,
> the hardware mode was using the type of the
> last VIF registered.  Instead, we should keep track
> of the number of different types of vifs and set the
> mode accordingly.

Thank you for your efforts to get multi-vifs working better.

This is another comment that is a little out of place but when I see
the identifier beacon_interval in this context I cannot help bringing
up per-vif settings as a related problem: If I read the code (or
rather the lack of code) correctly the beacon interval of the last (or
first?) beaconing vif added will be used to set up beacon tx, whereas
the actual beacon contents will reflect the beacon intervals
configured for individual vifs which may all be different... The same
goes for e.g. tx queue configuration, no?

It feels like we need a general multi-vif cleanup here but it's too
big for me unfortunately.

/Björn
