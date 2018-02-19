Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59840 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752657AbeBSM4g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 07:56:36 -0500
Message-ID: <1519044993.7832.105.camel@coelho.fi> (sfid-20180219_135639_529202_C17E42C6)
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Mon, 19 Feb 2018 14:56:33 +0200
In-Reply-To: <20180219124847.27169-3-luca@coelho.fi>
References: <20180219124847.27169-1-luca@coelho.fi>
         <20180219124847.27169-3-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 02/13] mac80211: ibss: send a probe request instead
 of allocating station
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-02-19 at 14:48 +0200, Luca Coelho wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> When we hear frames from IBSS that we don't have a station
> for, we allocate the station in the RX path with incomplete
> data.
> 
> Instead, send a probe request to the station.
> 
> This helps to solve an issue with iwlwifi, which cannot allocate
> stations in atomic paths, and has the added values of having full
> data of the station and getting rid from some code.
> 
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

I forgot Nicolas' comment about this patch when I sent v2.  So please
don't take this yet (as we agreed) and I'll ask Sari to look into the
issue.

Just for the record.

--
Cheers,
Luca.
