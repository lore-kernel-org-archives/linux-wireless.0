Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:45619 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932442AbdKFUkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 15:40:12 -0500
Received: by mail-it0-f66.google.com with SMTP id n195so6996464itg.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 12:40:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1509997730.4492.422.camel@coelho.fi>
References: <20171029122816.8802-1-luca@coelho.fi> <20171029122816.8802-14-luca@coelho.fi>
 <CAGXu5jLhCxwR1zntTYS_5X72kp-H8h++8PH-p5aKTC5oU-OaLw@mail.gmail.com> <1509997730.4492.422.camel@coelho.fi>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 Nov 2017 12:40:11 -0800
Message-ID: <CAGXu5j+X1Pyfhv9f+==EVdMjOi8ks+pzXEe2=uQVHtJjKLAEaA@mail.gmail.com> (sfid-20171106_214021_140437_B91FA5FE)
Subject: Re: [PATCH 13/17] iwlwifi: mvm: Convert timers to use timer_setup()
To: Luca Coelho <luca@coelho.fi>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 6, 2017 at 11:48 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Mon, 2017-11-06 at 11:45 -0800, Kees Cook wrote:
>> On Sun, Oct 29, 2017 at 5:28 AM, Luca Coelho <luca@coelho.fi> wrote:
>> > From: Kees Cook <keescook@chromium.org>
>> >
>> > In preparation for unconditionally passing the struct timer_list
>> > pointer to
>> > all timer callbacks, switch to using the new timer_setup() and
>> > from_timer()
>> > to pass the timer pointer explicitly.
>> >
>> > The RCU lifetime on baid_data is unclear, so this adds a direct
>> > copy of the
>> > rcu_ptr passed to the original callback. It may be possible to
>> > improve this
>> > to just use baid_data->mvm->baid_map[baid_data->baid] instead.
>> >
>> > Cc: Johannes Berg <johannes.berg@intel.com>
>> > Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> > Cc: Luca Coelho <luciano.coelho@intel.com>
>> > Cc: Intel Linux Wireless <linuxwifi@intel.com>
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Cc: Sara Sharon <sara.sharon@intel.com>
>> > Cc: linux-wireless@vger.kernel.org
>> > Cc: netdev@vger.kernel.org
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> > ---
>> >  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 ++-
>> >  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c |  4 ++--
>> >  drivers/net/wireless/intel/iwlwifi/mvm/sta.c  | 18 +++++++++----
>> > -----
>> >  3 files changed, 13 insertions(+), 12 deletions(-)
>>
>> Hi,
>>
>> Thanks for taking this! I had a question on timing: is this expected
>> to land for 4.15? If not, I would like to take this via the timers
>> tree, since it is one of the few remaining conversions.
>
> Hi Kees,
>
> Yes, this should land for 4.15.  Kalle just pulled my pull-request
> (which includes this) to wireless-drivers-next.  He told me he'll send
> a pull-request for 4.15 during this week and hopefully Dave will pull
> from him too.
>
> I'll let you know if something doesn't go as planned.

Awesome, thanks very much!

-Kees

-- 
Kees Cook
Pixel Security
