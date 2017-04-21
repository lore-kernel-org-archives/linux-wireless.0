Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47640 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1425770AbdDUT7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 15:59:41 -0400
Message-ID: <1492804774.19290.5.camel@sipsolutions.net> (sfid-20170421_215945_425478_A6BF64C8)
Subject: Re: [PATCH] iwlwifi: pcie: off by one in
 iwl_trans_pcie_dyn_txq_alloc()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Sara Sharon <sara.sharon@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Fri, 21 Apr 2017 21:59:34 +0200
In-Reply-To: <20170421194619.sjc33647odsfkcfl@mwanda> (sfid-20170421_214638_709112_32AE460F)
References: <20170421194619.sjc33647odsfkcfl@mwanda>
         (sfid-20170421_214638_709112_32AE460F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-04-21 at 22:46 +0300, Dan Carpenter wrote:
> The > should be >= or we are writing one space beyond the end of the
> array.

I think I just did the same fixes you did - after running smatch :)

This is on its way already (in our local tree), but since nobody can
actually run the code yet - the hardware doesn't exist - Luca hasn't
sent it out yet.

Thanks though!

johannes
