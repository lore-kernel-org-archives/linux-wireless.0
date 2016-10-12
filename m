Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42387 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932284AbcJLJoK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 05:44:10 -0400
Message-ID: <1476262557.5271.18.camel@sipsolutions.net> (sfid-20161012_114413_584747_D0DE412C)
Subject: Re: [PATCH] cfg80211: Create structure for combination check/iter
 function parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
        usdutt@qti.qualcomm.com, amarnath@qca.qualcomm.com
Date: Wed, 12 Oct 2016 10:55:57 +0200
In-Reply-To: <1476101219-29599-1-git-send-email-pkushwah@qti.qualcomm.com>
References: <1476101219-29599-1-git-send-email-pkushwah@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-10 at 17:36 +0530, Purushottam Kushwaha wrote:
> Move growing parameter list to a structure for check/iter combination
> functions in cfg80211 and mac80211.

Looking at this, and how it changes brcmfmac, I'd prefer you did this
as the first patch in the series so we only have to touch that once.

Also, for the conversions, consider C99 initializers instead of the
memset() and setting values.

Then perhaps we can also consider squashing the first and third patch,
but let's keep them separate for now.

johannes
