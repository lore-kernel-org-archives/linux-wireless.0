Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:44266 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750922AbdKFTs4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 14:48:56 -0500
Message-ID: <1509997730.4492.422.camel@coelho.fi> (sfid-20171106_204902_962794_D6BF1C25)
From: Luca Coelho <luca@coelho.fi>
To: Kees Cook <keescook@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Network Development <netdev@vger.kernel.org>
Date: Mon, 06 Nov 2017 21:48:50 +0200
In-Reply-To: <CAGXu5jLhCxwR1zntTYS_5X72kp-H8h++8PH-p5aKTC5oU-OaLw@mail.gmail.com>
References: <20171029122816.8802-1-luca@coelho.fi>
         <20171029122816.8802-14-luca@coelho.fi>
         <CAGXu5jLhCxwR1zntTYS_5X72kp-H8h++8PH-p5aKTC5oU-OaLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 13/17] iwlwifi: mvm: Convert timers to use timer_setup()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-06 at 11:45 -0800, Kees Cook wrote:
> On Sun, Oct 29, 2017 at 5:28 AM, Luca Coelho <luca@coelho.fi> wrote:
> > From: Kees Cook <keescook@chromium.org>
> > 
> > In preparation for unconditionally passing the struct timer_list
> > pointer to
> > all timer callbacks, switch to using the new timer_setup() and
> > from_timer()
> > to pass the timer pointer explicitly.
> > 
> > The RCU lifetime on baid_data is unclear, so this adds a direct
> > copy of the
> > rcu_ptr passed to the original callback. It may be possible to
> > improve this
> > to just use baid_data->mvm->baid_map[baid_data->baid] instead.
> > 
> > Cc: Johannes Berg <johannes.berg@intel.com>
> > Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Cc: Luca Coelho <luciano.coelho@intel.com>
> > Cc: Intel Linux Wireless <linuxwifi@intel.com>
> > Cc: Kalle Valo <kvalo@codeaurora.org>
> > Cc: Sara Sharon <sara.sharon@intel.com>
> > Cc: linux-wireless@vger.kernel.org
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> >  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 ++-
> >  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  4 ++--
> >  drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 18 +++++++++----
> > -----
> >  3 files changed, 13 insertions(+), 12 deletions(-)
> 
> Hi,
> 
> Thanks for taking this! I had a question on timing: is this expected
> to land for 4.15? If not, I would like to take this via the timers
> tree, since it is one of the few remaining conversions.

Hi Kees,

Yes, this should land for 4.15.  Kalle just pulled my pull-request
(which includes this) to wireless-drivers-next.  He told me he'll send
a pull-request for 4.15 during this week and hopefully Dave will pull
from him too.

I'll let you know if something doesn't go as planned.

--
Cheers,
Luca.
