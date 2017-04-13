Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50312 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756147AbdDMG1h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 02:27:37 -0400
Message-ID: <1492064850.19193.6.camel@sipsolutions.net> (sfid-20170413_082824_600984_0CBC0D24)
Subject: Re: [PATCH v2] mac80211: Fix clang warning about constant operand
 in logical operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>,
        Greg Hackmann <ghackmann@google.com>
Date: Thu, 13 Apr 2017 08:27:30 +0200
In-Reply-To: <20170406233141.123098-1-mka@chromium.org> (sfid-20170407_013202_907352_DB786B38)
References: <20170406233141.123098-1-mka@chromium.org>
         (sfid-20170407_013202_907352_DB786B38)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-06 at 16:31 -0700, Matthias Kaehlcke wrote:
> When clang detects a non-boolean constant in a logical operation it
> generates a 'constant-logical-operand' warning. In
> ieee80211_try_rate_control_ops_get() the result of strlen(<const
> str>)
> is used in a logical operation, clang resolves the expression to an
> (integer) constant at compile time when clang's builtin strlen
> function
> is used.
> 
> Change the condition to check for strlen() > 0 to make the constant
> operand boolean and thus avoid the warning.
> 
Applied.

johannes
