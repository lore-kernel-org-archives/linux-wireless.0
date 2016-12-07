Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58038 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751803AbcLGLFF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 06:05:05 -0500
Date: Wed, 7 Dec 2016 11:53:09 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] iwlegacy: make il3945_mac_ops __ro_after_init
Message-ID: <20161207105309.GA7865@redhat.com> (sfid-20161207_120507_901099_2470F1EA)
References: <20161207063646.30969-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161207063646.30969-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 07, 2016 at 07:36:46AM +0100, Johannes Berg wrote:
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

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
