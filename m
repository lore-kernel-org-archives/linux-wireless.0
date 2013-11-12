Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:46791 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab3KLXlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 18:41:52 -0500
Received: by mail-lb0-f179.google.com with SMTP id w6so5241346lbh.10
        for <linux-wireless@vger.kernel.org>; Tue, 12 Nov 2013 15:41:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384261527-6253-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1384261527-6253-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 13 Nov 2013 00:41:30 +0100
Message-ID: <CAB=NE6U1PspNUKEfrO4sN2MtQy=YY=_jSm7eCwZtBX4ttp5zkw@mail.gmail.com> (sfid-20131113_004155_820134_9CB4C3AE)
Subject: Re: [PATCH v2 1/3] cfg80211: DFS check dfs_region before CAC
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Martin Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 12, 2013 at 2:05 PM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> Before we will start radar detection check
> if we have correct DFS region. Fail in case
> we don't know DFS region (don't know CAC/NOP
> timing and how to configure DFS pattern detector).
>
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>

This doesn't address the complexity cases of intersection. From review
today with a few folks this should simply then set DFS as unset (as
you patches don't allow DFS then) if there is any intersection with
DFS regions. That is, intersection doesn't use dfs_regions yet, add
that and if we do an intersection with two regdoms with different
regodms or at least one unknown we can't IR on DFS. We can only DFS
when all regulatory hints agree on the DFS region. Make that happen.

  Luis
