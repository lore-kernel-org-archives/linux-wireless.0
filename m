Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:40612 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaETHhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:37:21 -0400
Received: by mail-la0-f49.google.com with SMTP id pv20so58636lab.22
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2014 00:37:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399634618-3619-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1399634618-3619-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 20 May 2014 00:37:00 -0700
Message-ID: <CAB=NE6Vi0n-z3ci242fqe-r7vpnLw6i1QBqAmFQmS-deR7iyjQ@mail.gmail.com> (sfid-20140520_093725_264641_B14057F6)
Subject: Re: [PATCH] cfg80211: reg: get dfs region only from cfg80211_regd
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 9, 2014 at 4:23 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Scenario:
> 1) Driver register regd as "US"
> 2) cfg80211 set wiphy_regd->dfs_region = FCC
> 3) now I change country to FR
> 4) cfg80211_regd->dfs_region == ETSI
>    wiphy_regd->dfs_region == FCC
> 6) start CAC (this call get_dfs_region)
> 5) next get warning
> device specific dfs_region (FCC) disagrees with cfg80211's central dfs_region (ETSI)
>
> Seems checking wiphy_regd->dfs_region is not required, while
> there is no way to register more than one dfs_region from
> the driver when registering regd.
>
> With patch:
> cfg80211: allow restricting supported dfs regions
> driver will supported dfs regions using bitmap.
> This seems like a more correct approach.

Can you verify if we are not allowing combination of DFS wiphys to be
registered then, because it would be pointless to let a wiphy go up as
a master device if we have the use the central regulatory domain for
DFS and share it. If such checks are not in place your patch
implicates we need it.

 Luis
