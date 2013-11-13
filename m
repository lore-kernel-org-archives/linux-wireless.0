Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:46497 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758677Ab3KMJt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 04:49:58 -0500
Received: by mail-la0-f43.google.com with SMTP id n7so134009lam.2
        for <linux-wireless@vger.kernel.org>; Wed, 13 Nov 2013 01:49:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6U1PspNUKEfrO4sN2MtQy=YY=_jSm7eCwZtBX4ttp5zkw@mail.gmail.com>
References: <1384261527-6253-1-git-send-email-janusz.dziedzic@tieto.com> <CAB=NE6U1PspNUKEfrO4sN2MtQy=YY=_jSm7eCwZtBX4ttp5zkw@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 13 Nov 2013 10:49:36 +0100
Message-ID: <CAB=NE6VPvRu8OM6y0pLSbqCNoZmReUQzCRdWe-91=it-FJ7mSw@mail.gmail.com> (sfid-20131113_105002_242292_81E87C58)
Subject: Re: [PATCH v2 1/3] cfg80211: DFS check dfs_region before CAC
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Martin Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 13, 2013 at 12:41 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> This doesn't address the complexity cases of intersection. From review
> today with a few folks this should simply then set DFS as unset (as
> you patches don't allow DFS then) if there is any intersection with
> DFS regions. That is, intersection doesn't use dfs_regions yet, add
> that and if we do an intersection with two regdoms with different
> regodms or at least one unknown we can't IR on DFS. We can only DFS
> when all regulatory hints agree on the DFS region. Make that happen.

I'll just go ahead and add some patches for this today.

 Luis
