Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41686 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932312AbeEWLDe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 May 2018 07:03:34 -0400
Message-ID: <1527073388.3759.21.camel@sipsolutions.net> (sfid-20180523_130348_596208_2C608DD2)
Subject: Re: [v8, bpf-next, 4/9] net/wireless/iwlwifi: fix
 iwlwifi_dev_ucode_error tracepoint
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org,
        peterz@infradead.org, rostedt@goodmis.org,
        mathieu.desnoyers@efficios.com, netdev@vger.kernel.org,
        kernel-team@fb.com, linux-api@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date: Wed, 23 May 2018 13:03:08 +0200
In-Reply-To: <20180328190540.370956-5-ast@kernel.org>
References: <20180328190540.370956-5-ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-03-28 at 12:05 -0700, Alexei Starovoitov wrote:
> fix iwlwifi_dev_ucode_error tracepoint to pass pointer to a table
> instead of all 17 arguments by value.
> dvm/main.c and mvm/utils.c have 'struct iwl_error_event_table'
> defined with very similar yet subtly different fields and offsets.
> tracepoint is still common and using definition of 'struct iwl_error_event_table'
> from dvm/commands.h while copying fields.
> Long term this tracepoint probably should be split into two.

It would've been nice to CC the wireless list for wireless related
patches ...

> --- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.c
> @@ -30,6 +30,7 @@
>  #ifndef __CHECKER__
>  #include "iwl-trans.h"
>  
> +#include "dvm/commands.h"

In particular, this breaks the whole driver abstraction.

> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
> @@ -549,12 +549,7 @@ static void iwl_mvm_dump_lmac_error_log(struct iwl_mvm *mvm, u32 base)
>  
>         IWL_ERR(mvm, "Loaded firmware version: %s\n", mvm->fw->fw_version);
>  
> -       trace_iwlwifi_dev_ucode_error(trans->dev, table.error_id, table.tsf_low,
> -                                     table.data1, table.data2, table.data3,
> -                                     table.blink2, table.ilink1,
> -                                     table.ilink2, table.bcon_time, table.gp1,
> -                                     table.gp2, table.fw_rev_type, table.major,
> -                                     table.minor, table.hw_ver, table.brd_ver);
> +       trace_iwlwifi_dev_ucode_error(trans->dev, &table, table.hw_ver, table.brd_ver);

This is also utterly wrong because mvm has - for better or worse - a
different type "struct iwl_error_event_table" in this file ...

This really should never have gotten into the tree.

johannes
