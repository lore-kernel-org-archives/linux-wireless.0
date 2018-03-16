Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35282 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752167AbeCPNlU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 09:41:20 -0400
Message-ID: <1521207676.3786.27.camel@coelho.fi> (sfid-20180316_144123_837717_AE4A7485)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>
Date: Fri, 16 Mar 2018 15:41:16 +0200
In-Reply-To: <87a7v82o23.fsf@kamboji.qca.qualcomm.com>
References: <20180316115136.1234-1-luca@coelho.fi>
         <20180316115136.1234-5-luca@coelho.fi>
         <87a7v82o23.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 4/5] iwlwifi: mvm: fix array out of bounds reference
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, 2018-03-16 at 14:38 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Avraham Stern <avraham.stern@intel.com>
> > 
> > When starting aggregation, the code checks the status of the queue
> > allocated to the aggregation tid, which might not yet be allocated
> > and thus the queue index may be invalid.
> > Fix this by reserving a new queue in case the queue id is invalid.
> > 
> > While at it, clean up some unreachable code (a condition that is
> > already handled earlier) and remove all the non-DQA comments since
> > non-DQA mode is no longer supported.
> 
> Doing cleanup on a patch for 4.16 is not really a good idea, I guess
> it's ok this time. But please do try to avoid that.

Yeah, I noticed this cleanup in the fix patch, but since it just
removed dead code, I didn't think it would be an issue.

--
Cheers,
Luca.
