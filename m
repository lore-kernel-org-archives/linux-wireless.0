Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:33146 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756649AbdDFTY7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 15:24:59 -0400
Received: by mail-io0-f170.google.com with SMTP id t68so2902173iof.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 12:24:54 -0700 (PDT)
Date: Thu, 6 Apr 2017 12:24:52 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>,
        Greg Hackmann <ghackmann@google.com>
Subject: Re: [PATCH] mac80211: Fix clang warning about constant operand in
 logical operation
Message-ID: <20170406192452.GE145051@google.com> (sfid-20170406_212643_992628_054D4B8C)
References: <20170406185633.91065-1-mka@chromium.org>
 <1491505878.11399.4.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1491505878.11399.4.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

thanks for your comments

El Thu, Apr 06, 2017 at 09:11:18PM +0200 Johannes Berg ha dit:

> On Thu, 2017-04-06 at 11:56 -0700, Matthias Kaehlcke wrote:
> > Clang raises a warning about the expression 'strlen(CONFIG_XXX)'
> > being
> > used in a logical operation. Clangs' builtin strlen function resolves
> > the
> > expression to a constant at compile time, which causes clang to
> > generate
> > a 'constant-logical-operand' warning.
> > 
> > Split the if statement in two to avoid using the const expression in
> > a logical operation.
> > 
> I don't really see all much point in doing this for the warning's
> sake... hopefully it doesn't actually generate worse code, but I think
> the code ends up looking worse and people will forever wonder what the
> goto is really doing there.

I agree that the code looks worse :( I hoped to find a fix using a
preprocessor condition but wasn't successful.

Some projects (like Chrome OS) build their kernel with all warnings
being treated as errors. Besides changing the 'offending' code the
alternatives are to disable the warning completely or to tell clang
not to use the builtin(s). IMO changing the code is the preferable
solution, especially since this is so far the only occurrence of the
warning that I have encountered.

I used goto instead of nested ifs since other functions in this file
use the same pattern. If nested ifs are preferred I can change that.

Cheers

Matthias
