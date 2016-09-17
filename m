Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752185AbcIQP0U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 11:26:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: fix error handling in mwifiex_create_custom_regdomain
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160914124236.1951-1-me@bobcopeland.com>
References: <20160914124236.1951-1-me@bobcopeland.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>
Message-Id: <20160917152620.41D326175D@smtp.codeaurora.org> (sfid-20160917_172623_932373_B00D000E)
Date: Sat, 17 Sep 2016 15:26:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
> smatch reports:
> 
> sta_cmdresp.c:1053 mwifiex_create_custom_regdomain() warn: possible memory leak of 'regd'
> 
> Indeed, mwifiex_create_custom_regdomain() returns NULL in the
> case that channel is missing in the TLV without freeing regd.
> 
> Moreover, some other error paths in this function return ERR_PTR
> values which are assigned without checking to the regd field in
> the mwifiex_adapter struct.  The latter is only null-checked where
> used.
> 
> Fix by freeing regd in the error path, and only update
> priv->adapter->regd if the returned pointer is valid.
> 
> Cc: Amitkumar Karwar <akarwar@marvell.com>
> Cc: Nishant Sarmukadam <nishants@marvell.com>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

92ca4f92eca7 mwifiex: fix error handling in mwifiex_create_custom_regdomain

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9331337/
