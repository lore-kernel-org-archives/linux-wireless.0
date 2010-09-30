Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48836 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756775Ab0I3WmK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 18:42:10 -0400
MIME-Version: 1.0
In-Reply-To: <20100930211131.021309930@sipsolutions.net>
References: <20100930211013.472957770@sipsolutions.net> <20100930211131.021309930@sipsolutions.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 1 Oct 2010 08:41:48 +1000
Message-ID: <AANLkTik9+zA4PPPx=q6CRM-sgOjjECJdtJTgkCG9pGAY@mail.gmail.com>
Subject: Re: [RFC 1/2] genetlink: introduce pre_doit/post_doit hooks
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	tgraf@suug.ch
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 1, 2010 at 07:10, Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Each family may have some amount of boilerplate
> locking code that applies to most, or even all,
> commands.
>
> This allows a family to handle such things in
> a more generic way, by allowing it to
>  a) include private flags in each operation
>  b) specify a pre_doit hook that is called,
>    before an operation's doit() callback and
>    may return an error directly,
>  c) specify a post_doit hook that can undo
>    locking or similar things done by pre_doit,
>    and finally
>  d) include two private pointers in each info
>    struct passed between all these operations
>    including doit(). (It's two because I'll
>    need two in nl80211 -- can be extended.)

Stupid question:

Why not have a priv struct rather than an arbitrary array of two pointers?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
