Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.190]:36789 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762564AbXK2XCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 18:02:23 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1725216rvb
        for <linux-wireless@vger.kernel.org>; Thu, 29 Nov 2007 15:02:23 -0800 (PST)
Message-ID: <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com> (sfid-20071129_230229_964342_AEEAE973)
Date: Fri, 30 Nov 2007 01:02:23 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: coding style lesson: iwlwifi vs. endianness
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Reinette Chatre" <reinette.chatre@intel.com>
In-Reply-To: <20071129005810.GA6161@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
	 <1196286192.4967.29.camel@localhost.localdomain>
	 <20071129005810.GA6161@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> ACK
>
> While I can understand why you might think that Johannes was being
> smug, I doubt if he really meant to be.  Please try to presume the
> best intent. :-)
>
Here I'm speaking for myself here not for Intel.
He is a smug,  he has 'everything is a crap' attitude yet that's good
for revolution and I honestly appreciate Johannes' work on mac80211.
Things are finally moving somewhere. Thanks Johannes.

> As Dan points-out, Johannes main point (i.e. convert data at system
> boundaries) makes plenty of sense.  Please do take the time to tell
> us what he is missing?
>
Since all of also hold a CS degree the first thing that come to  us is
to create a clean cut, to translate the data from native order to
little endian just before submitting to HW and same on the opposite
direction.

Iwlwifi driver talks to firmware using so called host command
structures defined naturally in little endian. Statistically most of
the operations are setting and testing bits which is endianity
agnostic meaning no run time swap operations are needed.
The few computation including the shifting one visible in Johannes
example are the trade off of run time efficiency and 'ugliness'. It
was better bargain for us.  Iwlwifi keeps that in host command
structures through the driver operation so we don't need to keep
shadow native layered structures and there is quite a few of them.
Also number swap operation is much lower then the other approach.
We rather think of all constants for host commands as liitle endian.
As we stick consistently to this paradigma it becomes natural.
I'm not sure if this was a good decision for a long run as we are
adding more hardware and we are need more abstraction, at that point
it looked correct.
As Stephan is pressing for splitting the driver. If I look from his
point it seams like a right way  but as I see it now  from my point he
just made us few weeks of work more. And don't take me wrong I also
share his opinion that those ifdefs were evil.
So I'm not saying that Johannes is wrong in general he just came with
different assumptions.

Thanks for your attentions and I'm waiting for your flames, just
remember I don't answers to insults :)

Thanks
Tomas..

> Thanks,
>
> John
> --
> John W. Linville
> linville@tuxdriver.com
>
