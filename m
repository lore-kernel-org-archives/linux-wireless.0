Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37896 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753661AbdDFTL1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 15:11:27 -0400
Message-ID: <1491505878.11399.4.camel@sipsolutions.net> (sfid-20170406_211247_598039_9ED10F21)
Subject: Re: [PATCH] mac80211: Fix clang warning about constant operand in
 logical operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>,
        Greg Hackmann <ghackmann@google.com>
Date: Thu, 06 Apr 2017 21:11:18 +0200
In-Reply-To: <20170406185633.91065-1-mka@chromium.org> (sfid-20170406_205658_084798_12B3FAFB)
References: <20170406185633.91065-1-mka@chromium.org>
         (sfid-20170406_205658_084798_12B3FAFB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-06 at 11:56 -0700, Matthias Kaehlcke wrote:
> Clang raises a warning about the expression 'strlen(CONFIG_XXX)'
> being
> used in a logical operation. Clangs' builtin strlen function resolves
> the
> expression to a constant at compile time, which causes clang to
> generate
> a 'constant-logical-operand' warning.
> 
> Split the if statement in two to avoid using the const expression in
> a logical operation.
> 
I don't really see all much point in doing this for the warning's
sake... hopefully it doesn't actually generate worse code, but I think
the code ends up looking worse and people will forever wonder what the
goto is really doing there.

johannes
