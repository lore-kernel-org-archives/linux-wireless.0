Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41648 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750949AbdJYFdx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Oct 2017 01:33:53 -0400
Message-ID: <1508909627.4135.27.camel@coelho.fi> (sfid-20171025_073417_255125_03D223AE)
From: Luca Coelho <luca@coelho.fi>
To: Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 25 Oct 2017 08:33:47 +0300
In-Reply-To: <20171024092937.GA47262@beast>
References: <20171024092937.GA47262@beast>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] drivers/wireless: iwlwifi/mvm: Convert timers to use
 timer_setup()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-24 at 02:29 -0700, Kees Cook wrote:
> In preparation for unconditionally passing the struct timer_list
> pointer to
> all timer callbacks, switch to using the new timer_setup() and
> from_timer()
> to pass the timer pointer explicitly.
> 
> The RCU lifetime on baid_data is unclear, so this adds a direct copy
> of the
> rcu_ptr passed to the original callback. It may be possible to
> improve this
> to just use baid_data->mvm->baid_map[baid_data->baid] instead.
> 
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Sara Sharon <sara.sharon@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Thanks, Kees.  I'm taking this for review on our internal tree.  If all
our checks pass, I'll apply it and it will reach the mainline following
our usual upstreaming process.

--
Cheers,
Luca.
