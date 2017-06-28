Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:35967 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751642AbdF1Nhs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 09:37:48 -0400
Message-ID: <1498657062.8633.1.camel@perches.com> (sfid-20170628_153752_922516_EA6A55F6)
Subject: Re: [PATCH] mac80211_hwsim: use dyndbg for debug messages
From: Joe Perches <joe@perches.com>
To: Lubomir Rintel <lkundrak@v3.sk>,
        Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 28 Jun 2017 06:37:42 -0700
In-Reply-To: <20170628131726.15528-1-lkundrak@v3.sk>
References: <20170628131726.15528-1-lkundrak@v3.sk>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-06-28 at 15:17 +0200, Lubomir Rintel wrote:
> The mac80211_hwsim doesn't offer a way to disable the debugging output.
> Unfortunately, it's pretty chatty, dumping a  lot of stuff into the message
> buffer.
> 
> This patch changes it to use dyndbg for controlling the debug output.
> It's disabled by default, but can be enabled by a module parameter (1),
> at runtime (2) or persisted in modprobe.conf (3).
> 
>   (1) modprobe mac80211_hwsim dyndbg=+p
>   (2) echo "module mac80211_hwsim +p" >/sys/kernel/debug/dynamic_debug/control
>   (3) echo "options mac80211_hwsim dyndbg=+p" >>/etc/modprobe.d/my.conf

I wonder about the value at all of the 2 forms:

wiphy_dbg	-> only with #define DEBUG or dynamic_debug
wiphy_debug	-> always emitted at KERN_DEBUG

Is there any real value in wiphy_debug?

Should it just be converted to

#define wiphy_debug	wiphy_dbg

or maybe a global sed to remove it completely?
