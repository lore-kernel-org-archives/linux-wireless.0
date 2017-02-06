Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:38508 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752148AbdBFObe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 09:31:34 -0500
Message-ID: <1486391488.26003.129.camel@coelho.fi> (sfid-20170206_153138_094141_0DE01049)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Mon, 06 Feb 2017 16:31:28 +0200
In-Reply-To: <87zihz8leo.fsf@codeaurora.org>
References: <20170203143812.7525-1-luca@coelho.fi>
         <20170203143812.7525-16-luca@coelho.fi> <87zihz8leo.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 15/25] iwlwifi: mvm/pcie: adjust A-MSDU tx_cmd length in
 PCIe
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-02-06 at 16:05 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Instead of setting the tx_cmd length in the mvm code, which is
> > complicated by the fact that DQA may want to temporarily store
> > the SKB on the side, adjust the length in the PCIe code which
> > also knows about this since it's responsible for duplicating
> > all those headers that are account for in this code.
> > 
> > As the PCIe code already relies on the tx_cmd->len field, this
> > doesn't really introduce any new dependencies.
> > 
> > To make this possible we need to move the memcpy() of the TX
> > command until after it was updated.
> > 
> > This does even simplify the code though, since the PCIe code
> > already does a lot of manipulations to build A-MSDUs correctly
> > and changing the length becomes a simple operation to see how
> > much was added/removed, rather than predicting it.
> > 
> > Fixes: commit 24afba7690e4 ("iwlwifi: mvm: support bss dynamic alloc/dealloc of queues")
> 
> Ditto.

Oh no! I copied this from another commit, that's why... I'll fix these
two.

And sorry for the trouble (again!)

--
Luca.
