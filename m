Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:60559 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbYD0RnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 13:43:20 -0400
Received: by wa-out-1112.google.com with SMTP id m16so7372068waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 10:43:19 -0700 (PDT)
Subject: Re: [PATCH] mac80211: incorrect shift direction
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240804270800t15c02830p56470fa8996b50d3@mail.gmail.com>
References: <1209293320.14173.63.camel@brick>
	 <1209295470.10943.65.camel@johannes.berg>
	 <1ba2fa240804270800t15c02830p56470fa8996b50d3@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 27 Apr 2008 10:43:26 -0700
Message-Id: <1209318206.14173.65.camel@brick> (sfid-20080427_194331_802339_0B5611F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-04-27 at 18:00 +0300, Tomas Winkler wrote:
> On Sun, Apr 27, 2008 at 2:24 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sun, 2008-04-27 at 03:48 -0700, Harvey Harrison wrote:
> >  > Looks like  5d2cdcd4e85c5187db30a6b29f79fbbe59f39f78 got the
> >  > shifts wrong.
> >
> >  Aha! Thanks for tracking this down. We had a patch to fix this but were
> >  confused why the bug hadn't been noticed before. So it looks like it
> >  wasn't *present* before :)
> >
> What to say.... Shame on me.
> Tomas

This is precisely why I wrote the new unaligned access helpers going in
soon, I'll have this converted at that time.

This line will become:
iv32 = get_unaligned_le32(data + 4);

Harvey

