Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46590 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546Ab1EQUrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 16:47:15 -0400
Received: by iwn34 with SMTP id 34so744890iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 May 2011 13:47:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=8JtAEO+49sgEAAkmGVJNmZmqBog@mail.gmail.com>
References: <19922.8044.978298.696663@gargle.gargle.HOWL> <BANLkTi=RvaQcTuvi+sXxNpOv6qYU_FvoEQ@mail.gmail.com>
 <19922.38456.333268.853074@gargle.gargle.HOWL> <BANLkTi=8JtAEO+49sgEAAkmGVJNmZmqBog@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 17 May 2011 13:46:55 -0700
Message-ID: <BANLkTi=napNyMOSKT-cDR79X4ZMka9bMsg@mail.gmail.com> (sfid-20110517_224720_308210_647D6671)
Subject: Re: [ath9k-devel] [PATCH 0/8] ath9k_htc patches
To: Keith Berkoben <berkoben@gmail.com>
Cc: Sujith <m.sujith@gmail.com>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 17, 2011 at 8:58 AM, Keith Berkoben <berkoben@gmail.com> wrote:
> Thanks!
>
> When following this process (it has a couple steps...), is it generally a
> true statement that changes from
> wireless-testing->wireless-next-->net-next-->etc. are usually pushed by
> "Merges", or should I also be watching for changes filtering through in
> other ways?
>
> Stated another way, is the heuristic of:
> 1. look for patch in wireless-testing
> 2. look for subsequent Merge of that branch (or parent) in wireless-next
> 3. look for subsequent Merge of wireless-next branch in net-next
> 4. repeat all the way to the build I want
> and effective way to ensure what I want is in a build without reading all of
> the individual source files in each archive?

Patches go first into wireless-next, then stable stuff goes into
wirless-2.6 (current RC), and then both of these get pulled into
wireless-testing, which provides the RC fixes + the next bits, on a
stable kernel (RC).

Compat-wireless daily snapshots use linux-next so changes take a bit
to propagate there.

OpenWrt uses wireless-testing as the base tree, you can tell by
loading the compat module, it will tell you the base tree and git tree
tags that was used as source.

  Luis
