Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:47730 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdKMJ2n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 04:28:43 -0500
Message-ID: <1510565321.30497.8.camel@sipsolutions.net> (sfid-20171113_103120_872444_D4367593)
Subject: Re: [PATCH] cfg80211: Include length of kek in rekey data
From: Johannes Berg <johannes@sipsolutions.net>
To: Vidyullatha Kanchanapally <vidyullatha@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        vkanchan@qti.qualcomm.com, amarnath@qti.qualcomm.com,
        usdutt@qti.qualcomm.com, vamsin@qti.qualcomm.com
Date: Mon, 13 Nov 2017 10:28:41 +0100
In-Reply-To: <1508923180-14558-1-git-send-email-vidyullatha@codeaurora.org>
References: <1508923180-14558-1-git-send-email-vidyullatha@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-10-25 at 14:49 +0530, Vidyullatha Kanchanapally wrote:
> With support for new AKM suites (example FILS-SHA256), the KEK length
> can now be more than NL80211_KEK_LEN and the KCK length can be zero.
> Add changes in cfg80211 to specify the length of KEK, and make KCK
> optional. Make NL80211_REKEY_DATA_KEK as NLA_BINARY to enforce a maximum
> length check.

It seems to me that some sort of feature negotiation would be required
here, since you can't just assume all (existing) drivers will
understand this?

johannes
