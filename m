Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43764 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbZGEI7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 04:59:14 -0400
Received: by fxm18 with SMTP id 18so3124064fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 05 Jul 2009 01:59:16 -0700 (PDT)
Date: Sun, 5 Jul 2009 12:59:33 +0400
From: Alexander Barinov <alex.barinov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: BUG REPORT: libertas causing kernel lockups
Message-ID: <20090705125933.5a9f7ce4@dream>
In-Reply-To: <1246704102.16770.71.camel@johannes.local>
References: <20090704130346.01b2e869@dream>
	<1246704102.16770.71.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 04 Jul 2009 12:41:42 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2009-07-04 at 13:03 +0400, Alexander Barinov wrote:
> > The initial symptom of the bug was system lockup when executing
> > 'ifdown eth0' with 'BUG: scheduling while atomic'. Trying to
> > understand the cause of the bug and find a workaround I was able to
> > find an easier way to reproduce it. By executing
> > 'cat /proc/net/wireless' I get the same bug:
> This should have been fixed by
> 87057825824973f29cf2f37cff1e549170b2d7e6. For some reason everybody
> seems to have assumed that get_wireless_stats can sleep, which before
> that commit it could _not_.

The patch you have mentioned was not directly applicable to 2.6.30
kernel so I pulled wireless-testing git tree and compiled it. This
deteriorated the situation further - now after executing
'cat /proc/net/wireless' I get kernel lockup without any further
messages.
