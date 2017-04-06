Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38952 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752364AbdDFVMb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 17:12:31 -0400
Message-ID: <1491513145.11399.8.camel@sipsolutions.net> (sfid-20170406_231239_003718_4FA5BF38)
Subject: Re: [PATCH] mac80211: Fix clang warning about constant operand in
 logical operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias Kaehlcke <mka@chromium.org>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>,
        Greg Hackmann <ghackmann@google.com>
Date: Thu, 06 Apr 2017 23:12:25 +0200
In-Reply-To: <20170406192452.GE145051@google.com> (sfid-20170406_212455_006612_2E5FACCF)
References: <20170406185633.91065-1-mka@chromium.org>
         <1491505878.11399.4.camel@sipsolutions.net>
         <20170406192452.GE145051@google.com> (sfid-20170406_212455_006612_2E5FACCF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-06 at 12:24 -0700, Matthias Kaehlcke wrote:

> I agree that the code looks worse :( I hoped to find a fix using a
> preprocessor condition but wasn't successful.

It's actually easy - just remove the 'default ""' from Kconfig, and
then the symbol won't be defined at all if it doesn't get a proper
value. Then you can ifdef the whole thing.

> Some projects (like Chrome OS) build their kernel with all warnings
> being treated as errors. Besides changing the 'offending' code the
> alternatives are to disable the warning completely or to tell clang
> not to use the builtin(s). IMO changing the code is the preferable
> solution, especially since this is so far the only occurrence of the
> warning that I have encountered.
> 
> I used goto instead of nested ifs since other functions in this file
> use the same pattern. If nested ifs are preferred I can change that.

I don't really buy either argument. The warning is simply bogus - I'm
very surprised you don't hit it with more similar macros or cases, like
for example CONFIG_ENABLED(). Try

	git grep 'IS_ENABLED(' | grep '&&'

and you'll find lots of places that seem like they should trigger this
warning.

You're advocating to make the code worse - not very significantly in
this case, but still - just to quiet a compiler warning.

johannes
