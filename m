Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34002 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750838AbdIOHSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 03:18:07 -0400
Message-ID: <1505459884.31630.25.camel@sipsolutions.net> (sfid-20170915_091818_406047_62F234EB)
Subject: Re: [PATCH] nl80211: check for the required netlink attributes
 presence
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladis Dronov <vdronov@redhat.com>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: "# v3 . 1-rc1" <stable@vger.kernel.org>
Date: Fri, 15 Sep 2017 09:18:04 +0200
In-Reply-To: <20170912222121.5032-1-vdronov@redhat.com>
References: <20170912222121.5032-1-vdronov@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-09-13 at 00:21 +0200, Vladis Dronov wrote:
> nl80211_set_rekey_data() does not check if the required attributes
> NL80211_REKEY_DATA_{REPLAY_CTR,KEK,KCK} are present when processing
> NL80211_CMD_SET_REKEY_OFFLOAD request. This request can be issued by
> users with CAP_NET_ADMIN privilege and may result in NULL dereference
> and a system crash. Add a check for the required attributes presence.
> This patch is based on the patch by bo Zhang.

Huh. Applied, thanks.

johannes
