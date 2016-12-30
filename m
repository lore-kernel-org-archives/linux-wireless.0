Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45854 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbcL3L3E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 06:29:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: iwlegacy: make il3945_mac_ops __ro_after_init
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161207063646.30969-1-johannes@sipsolutions.net>
References: <20161207063646.30969-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Message-Id: <20161230112903.97C1161469@smtp.codeaurora.org> (sfid-20161230_122906_948897_89BE08D4)
Date: Fri, 30 Dec 2016 11:29:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need for this to be only __read_mostly, since
> it's only written in a single way depending on the module
> parameter, so that can be moved into the module's __init
> function, and the ops can be __ro_after_init.
> 
> This is a little bit safer since it means the ops can't
> be overwritten (accidentally or otherwise), which would
> otherwise cause an arbitrary function or bad pointer to
> be called.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

ae3cf4764506 iwlegacy: make il3945_mac_ops __ro_after_init

-- 
https://patchwork.kernel.org/patch/9463999/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
