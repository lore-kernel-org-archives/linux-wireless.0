Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46192 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750835AbdH3HcO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 03:32:14 -0400
Message-ID: <1504078330.31031.3.camel@coelho.fi> (sfid-20170830_093216_787473_CAFE026C)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date: Wed, 30 Aug 2017 10:32:10 +0300
In-Reply-To: <87efruvl4e.fsf@kamboji.qca.qualcomm.com>
References: <20170825082730.31388-1-luca@coelho.fi>
         <20170825082730.31388-3-luca@coelho.fi>
         <87efruvl4e.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 2/2] iwlwifi: mvm: Avoid deffering non bufferable frames
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-08-29 at 11:22 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: David Spinadel <david.spinadel@intel.com>
> > 
> > Use bcast station for all non bufferable frames on AP and AD-HOC.
> > 
> > The host is no longer aware of STAs PS status because of buffer
> > station offload, so we can't rely on mac80211 to toggle on
> > IEEE80211_TX_CTL_NO_PS_BUFFER bit.
> > 
> > A possible issue with buffering such frames, beside the obvious spec
> > violation, is when a station disconnects while in PS but the AP isn't
> > aware of that. In such scenarios the AP won't be able to send probe
> > responses or auth frames so the STA won't be able to reconnect and
> > the AP will have a queue hang.
> > 
> > Fixes: 3e56eadfb6a1 ("iwlwifi: mvm: implement AP/GO uAPSD support")
> > Signed-off-by: David Spinadel <david.spinadel@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> "deffering"? Should it be deferring?

Yeah, sorry, I'll fix it before sending the pull-req.

--
Cheers,
Luca.
