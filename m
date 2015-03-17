Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53168 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbbCQJ5V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 05:57:21 -0400
Message-ID: <1426586236.1985.1.camel@sipsolutions.net> (sfid-20150317_105729_717981_7C3C8983)
Subject: Re: Connection issues with BW Tracking in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 17 Mar 2015 10:57:16 +0100
In-Reply-To: <CABPxzYL1uvHG-MsXMiqrnyA8HuJ47AyuJG-fAM2Ok6GQjC_dtg@mail.gmail.com> (sfid-20150312_101811_932722_326ED06E)
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
	 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
	 <1424772587.2192.14.camel@sipsolutions.net>
	 <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
	 <1424774105.2192.29.camel@sipsolutions.net>
	 <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
	 <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com>
	 <1424810867.2192.60.camel@sipsolutions.net>
	 <CABPxzY+Z97Q4JSSaR2GfGnxbbR721qJ-v_AjG4Kc1TGetHF4ng@mail.gmail.com>
	 <1424851368.2050.8.camel@sipsolutions.net>
	 <CABPxzYKa5eR+UrinkqY99jxOpVR4mTYcW_3xZ5f2kf9hXHCznA@mail.gmail.com>
	 <1426090817.1904.6.camel@sipsolutions.net>
	 <CABPxzYK-DGLe+kCWnRroErfOMDb+hUHYyNdBiYvqhBmx2QJxUg@mail.gmail.com>
	 <CABPxzYL1uvHG-MsXMiqrnyA8HuJ47AyuJG-fAM2Ok6GQjC_dtg@mail.gmail.com>
	 (sfid-20150312_101811_932722_326ED06E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-12 at 14:47 +0530, Krishna Chaitanya wrote:

> 1.  Make the directed probe mandatory:
>          a. Check for successful probe resp without depending on proberesp_ies.
>          b. remove the proberesp_ies from the auth_data to trigger
> directed probe.
> 
> 2. Timestamps for proberesp and beacons and update the latest one to "ies".
> 
> 3. while update "ies" check only for beacon as its supposed to have latest
> information (This will trigger #1 automatically).
> 
> As a quick and minimal impact solution i am thinking 1-b.

Huh? No, that'd be one of the worst possible solution IMHO since it
would make the system behave differently *all the time* just because of
a very uncommon scenario.

Is this really a "real world" use case? I can't really think of any way
this would happen in practice.

The least impact would probably have #2.

johannes

