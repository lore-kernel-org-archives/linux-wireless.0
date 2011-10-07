Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64674 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1JGHyX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 03:54:23 -0400
Received: by qadb15 with SMTP id b15so2558276qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 00:54:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ-VmonYaTW3xX7CKzU4Okb1nW86mJMV0RRDnqkMSJ-mASJ+4Q@mail.gmail.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110041538.12885.chunkeey@googlemail.com> <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com>
 <201110061849.48838.chunkeey@googlemail.com> <CAB=NE6WbMi2GYJyFfvsdH-NSXn8dPBsgxgfdGXO_RHiJxwz2Fw@mail.gmail.com>
 <4E8E1062.1070206@neratec.com> <CAB=NE6XwNDc8v-qtQuQQZdh2ST-skpcZM7wqD32qHn3CgN-5Dw@mail.gmail.com>
 <4E8E18DB.5070002@neratec.com> <CAJ-VmonYaTW3xX7CKzU4Okb1nW86mJMV0RRDnqkMSJ-mASJ+4Q@mail.gmail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Fri, 7 Oct 2011 00:54:03 -0700
Message-ID: <CAB=NE6VzA4npmu8cKE3kkMfxBxGK+rUtoxOzjXyg0XjSj9C16Q@mail.gmail.com> (sfid-20111007_095426_910135_F6B23AF3)
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
To: Adrian Chadd <adrian@freebsd.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 6, 2011 at 8:06 PM, Adrian Chadd <adrian@freebsd.org> wrote:
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
> I'll then likely ship two DFS modules - dfs_null (no DFS support, just
> a placeholder for the API) and whatever code is ported from the
> reference driver. Maybe I'll also include the code from Neratec if
> it's dual-licenced. But I won't include radar patterns by default -
> I'll include those on a documentation page which explains the how and
> why of regulatory domain stuff.
>
> Once FreeBSD ships DFS radar detection code, I'll make sure it isn't
> compiled by default and even if enabled, it won't advertise DFS
> channel support unless a valid radar pattern and radar parameter
> configuration is loaded in. That way users won't inadvertently enable
> it without being compliant.

Neat, best of luck! FWIW, I've been moving along on the regulatory
simulator, feel free do send me patches in ways you want that to move
if that seems reasonable to you as place to share code between OSes,
that was at least my own goal, to help share as much test framework
and code to let us then cherry pick for our own OSes in whatever way
we want.

> Finally, I'm hoping to get all of this documented as much as possible
> so the community can pick this stuff up and run with it. I was hoping
> someone would throw me a 5ghz SDR (software defined radio) so I could
> prototype up some open source radar pulse generation code, just to
> lower the entry barrier to all of this.

You can use the Winlab Orbit GNU Radio SDRs, I think you can make a
reservation for them.

  Luis
