Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35906 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751009AbdBFGz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 01:55:27 -0500
Message-ID: <1486364124.14226.2.camel@sipsolutions.net> (sfid-20170206_075529_277779_47521D6B)
Subject: Re: [PATCH] mac80211: Fix FILS AEAD protection in Association
 Request frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Mon, 06 Feb 2017 07:55:24 +0100
In-Reply-To: <1486209562-23415-1-git-send-email-jouni@qca.qualcomm.com>
References: <1486209562-23415-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2017-02-04 at 13:59 +0200, Jouni Malinen wrote:
> Incorrect num_elem parameter value (1 vs. 5) was used in the
> aes_siv_encrypt() call. This resulted in only the first one of the
> five
> AAD vectors to SIV getting included in calculation. This does not
> protect all the contents correctly and would not interoperate with a
> standard compliant implementation.
> 
> Fix this by using the correct number. A matching fix is needed in the
> AP
> side (hostapd) to get FILS authentication working properly.

Applied, thanks.

johannes
