Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:61346 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZAHRKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 12:10:12 -0500
Received: by wf-out-1314.google.com with SMTP id 27so9354159wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 09:10:11 -0800 (PST)
Message-ID: <b6c5339f0901080910x3d3b5758mae4e81411dcf1405@mail.gmail.com> (sfid-20090108_181017_884795_36A69550)
Date: Thu, 8 Jan 2009 12:10:11 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: [ath5k-devel] ath5k_tasklet_rx BUG_ON(bf->skb == NULL)
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	ath5k-devel@venema.h4ckr.net
In-Reply-To: <Pine.LNX.4.64.0901081603410.8411@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <Pine.LNX.4.64.0901081318190.22793@blonde.anvils>
	 <1231426017.922.2.camel@maxim-laptop>
	 <Pine.LNX.4.64.0901081603410.8411@blonde.anvils>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2009 at 11:18 AM, Hugh Dickins <hugh@veritas.com> wrote:
>> > So, that BUG_ON(bf->skb == NULL) appears to be unsafe under
>> > memory pressure; but the fix wasn't obvious to me, so over
>> > to you!

Thanks for the report... I guess the error paths haven't been tested
much when rx buf setup fails.

> (Of course, just removing the BUG_ON, and making sure there's
> no oops on the NULL pointer, would fix my immediate issue:
> but I doubt the right fix will be as simple as that.)

Are your memory load testing scripts available somewhere?

-- 
Bob Copeland %% www.bobcopeland.com
