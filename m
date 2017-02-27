Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37286 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbdB0PYj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 10:24:39 -0500
Message-ID: <1488207986.28431.17.camel@sipsolutions.net> (sfid-20170227_162545_431027_A7EFD4F9)
Subject: BUG_ON in sg code
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 27 Feb 2017 16:06:26 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ard,

Apologies for the non-follow-up - couldn't find the original patch.

Your patch "crypto: ccm - switch to separate cbcmac driver" causes a
BUG_ON when virtual stacks are used, in crypto_ccm_auth() is called,
because you put odata/idata on the stack. What's going on there? I
thought we knew we can't do that? Did I miss something?

johannes
