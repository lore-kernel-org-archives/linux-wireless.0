Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50300 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751356AbdAMKdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:33:11 -0500
Message-ID: <1484303560.8670.0.camel@sipsolutions.net> (sfid-20170113_113325_348317_D57D044D)
Subject: Re: [PATCH v2] mac80211: initialize SMPS field in HT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: onelektra@gmx.net
Date: Fri, 13 Jan 2017 11:32:40 +0100
In-Reply-To: <20170113102825.72047-1-nbd@nbd.name>
References: <20170113102825.72047-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-01-13 at 11:28 +0100, Felix Fietkau wrote:
> ibss and mesh modes copy the ht capabilites from the band without
> overriding the SMPS state. Unfortunately the default value 0 for the
> SMPS field means static SMPS instead of disabled.
> 
> This results in HT ibss and mesh setups using only single-stream
> rates,
> even though SMPS is not supposed to be active.
> 
> Initialize SMPS to disabled for all bands on ieee80211_hw_register to
> ensure that the value is sane where it is not overriden with the real
> SMPS state.
> 
> Reported-by: Elektra Wagenrad <onelektra@gmx.net>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
> v2: add comment about OR'ing the PS_DISABLED value

Applied, thanks.

I moved the TODO comment there around a bit.

johannes
