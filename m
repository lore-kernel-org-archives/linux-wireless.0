Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:45501 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587Ab1JGIsr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 04:48:47 -0400
Message-ID: <4E8EBCEB.80705@neratec.com> (sfid-20111007_104851_431349_97E35798)
Date: Fri, 07 Oct 2011 10:48:43 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>	<201110041538.12885.chunkeey@googlemail.com>	<CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com>	<201110061849.48838.chunkeey@googlemail.com>	<CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>	<4E8E1062.1070206@neratec.com>	<CAB=NE6XwNDc8v-qtQuQQZdh2ST-skpcZM7wqD32qHn3CgN-5Dw@mail.gmail.com>	<4E8E18DB.5070002@neratec.com> <CAJ-VmonYaTW3xX7CKzU4Okb1nW86mJMV0RRDnqkMSJ-mASJ+4Q@mail.gmail.com>
In-Reply-To: <CAJ-VmonYaTW3xX7CKzU4Okb1nW86mJMV0RRDnqkMSJ-mASJ+4Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/07/2011 05:06 AM, Adrian Chadd wrote:
> Just FYI, that's what I'm likely to do for FreeBSD 10 (as I just don't
> have time to try and make all the required regulatory changes before
> the upcoming 9.0 release.)
> 
> Ie:
> 
> * DFS station mode (net80211) is going to be compiled and enabled by default;
> * DFS master mode (net80211) is going to be compiled and enabled by default;
> * The drivers which support radar detection in firmware (currently
> only if_mwl) will set the DFS net80211 flag (ie, for master mode radar
> detection);
> * ath won't ship with the DFS enable flag (for master mode);
> * I'll modify the regulatory database code to include per-band DFS
> information (DFS domain, CAC/NOL timeout, interference timeout, etc)
> and some device information (eg whether it supports HT20/HT40/etc DFS
> detection);
> * I'll then flip on the DFS channel enforcement in the net80211 code
> so disables master mode on channels requiring DFS.
> 
> The radar detection code and channel interference code will live in
> the ath driver but the DFS machinery (CAC, NOL, CSA, etc) is in
> net80211. That way other NICs (eg if_mwl Marvell NICs) with DFS radar
> detection support can leverage this.
> 
Quite some work ahead. Good luck on that!

So you are confident to get existing code re-factored and split into multiple layers?

> I'll then likely ship two DFS modules - dfs_null (no DFS support, just
> a placeholder for the API) and whatever code is ported from the
> reference driver. Maybe I'll also include the code from Neratec if
> it's dual-licenced. But I won't include radar patterns by default -
> I'll include those on a documentation page which explains the how and
> why of regulatory domain stuff.
> 
Initially we planned to have common pattern detectors in mac80211 to handle pulses reported by all drivers, but so far only TI is working on DFS -- with pattern matching done in firmware. So, no need yet for common detectors, we might end up going the other way around, i.e. taking your port and integrate in into ath9k -- if licensing allowed us to do.

> Once FreeBSD ships DFS radar detection code, I'll make sure it isn't
> compiled by default and even if enabled, it won't advertise DFS
> channel support unless a valid radar pattern and radar parameter
> configuration is loaded in. That way users won't inadvertently enable
> it without being compliant.
> 
> Finally, I'm hoping to get all of this documented as much as possible
> so the community can pick this stuff up and run with it. I was hoping
> someone would throw me a 5ghz SDR (software defined radio) so I could
> prototype up some open source radar pulse generation code, just to
> lower the entry barrier to all of this.
> 
Yeah, an AR9003 card used as cheap radar generator is on top of my wish list for DFS testing without our always otherwise occupied vector signal generator. But fur obvious reasons we wont get the required documentation for such unofficial hacks.

> HTH,
> 
> 
> Adrian

Thanks
Zefir
