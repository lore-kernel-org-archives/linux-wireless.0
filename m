Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41217 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab0JAVtW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 17:49:22 -0400
Received: by iwn5 with SMTP id 5so4310604iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 14:49:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101001214201.0122B404FC@repository3.orbit-lab.org>
References: <20101001214201.0122B404FC@repository3.orbit-lab.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 1 Oct 2010 14:49:00 -0700
Message-ID: <AANLkTimgn=ORK2ECoayerhJQXvy-RSbiLLSvfrRQbcpe@mail.gmail.com>
Subject: Re: Compat-wireless release for 2010-10-01 v2 with RX filter for
 carl9170 on -p release
To: Senthil Balasubramanian <senthilkumar@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 1, 2010 at 2:42 PM, Compat-wireless cronjob account
<compat@orbit-lab.org> wrote:
>
> compat-wireless code metrics
>
>    747282 - Total upstream lines of code being pulled
>      2153 - backport code changes
>      1902 - backport code additions
>       251 - backport code deletions
>      6242 - backport from compat module
>      8395 - total backport code
>    1.1234 - % of code consists of backport work
>       128 - Code changes posted but not yet merged
>        95 - Code additions posted but not yet merged
>        33 - Code deletions posted but not yet merged
>    0.0171 - % of code not yet merged
>      1219 - Crap changes not yet posted
>      1181 - Crap additions not yet posted
>        38 - Crap deletions not yet posted
>    0.1631 - % of crap code
>
> Base tree: linux-next.git
> Base tree version: next-20101001
> compat-wireless release: compat-wireless-2010-10-01-6-g6d8961c-pc

The e-mail always send the code-metrics of the -pc release, but note
that there is also a -p release that does not have the crap/ patches
applied. This is what we want for testing carl9170.

Senthil, please consider using this tarball for testing carl9170:

http://www.orbit-lab.org/kernel/compat-wireless-2.6/2010/10/compat-wireless-2010-10-01-p.tar.bz2
sha1sum: 5ee396743482e8573a0b6eea33eabf0f532d995b

It has the following patches cherry picked from the mailing list into
linux-next-pending/ directory as the assumption is they will make it
into 2.6.37:

mcgrof@tux ~/tmp/compat-wireless-2010-10-01-p $ head -10
linux-next-pending/*.patch
==> linux-next-pending/0001-mac80211-perform-scan-cancel-in-hw-reset-work.patch
<==

Reason for adding to linux-next-pending/ :

On Fri, Oct 01, 2010 at 05:47:53AM -0700, Christian Lamparter wrote:
> Currently, everyone is waiting for:
> "[PATCH 1/6] mac80211: perform scan cancel in hw reset work"
> (hopefully, it fixes the dreaded ieee80211_hw_restart deadlock.)

We need this for testing purposes for carl9170 which may
get done this weekend.

==> linux-next-pending/0002-carl9170-support-firmware-based-rx-filter.patch <==

Reason for it not being merged upstream yet: backlog.
Since this will help with load and memory we want this for
final testing and evaluation of the driver.

>From 8f56ba52913d4260fd7148a5919d913561e62cbd Mon Sep 17 00:00:00 2001
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Tue, 28 Sep 2010 23:00:59 +0200
Subject: [PATCH] carl9170: support firmware-based rx filter


Now, the code-metrics change a bit and the ID for this release does as well:

mcgrof@tux ~/tmp/compat-wireless-2010-10-01-p $ cat code-metrics.txt

compat-wireless code metrics

    747282 - Total upstream lines of code being pulled
      2153 - backport code changes
      1902 - backport code additions
       251 - backport code deletions
      6242 - backport from compat module
      8395 - total backport code
    1.1234 - % of code consists of backport work
       128 - Code changes posted but not yet merged
        95 - Code additions posted but not yet merged
        33 - Code deletions posted but not yet merged
    0.0171 - % of code not yet merged

Base tree: linux-next.git
Base tree version: next-20101001
compat-wireless release: compat-wireless-2010-10-01-6-g6d8961c-p

I've test-compiled this release with `./scripts/driver-select
carl9170` against 2.6.32.

  Luis
