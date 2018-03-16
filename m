Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40708 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbeCPMiR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 08:38:17 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 4/5] iwlwifi: mvm: fix array out of bounds reference
References: <20180316115136.1234-1-luca@coelho.fi>
        <20180316115136.1234-5-luca@coelho.fi>
Date: Fri, 16 Mar 2018 14:38:12 +0200
In-Reply-To: <20180316115136.1234-5-luca@coelho.fi> (Luca Coelho's message of
        "Fri, 16 Mar 2018 13:51:35 +0200")
Message-ID: <87a7v82o23.fsf@kamboji.qca.qualcomm.com> (sfid-20180316_133821_662595_CD43BBA8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> From: Avraham Stern <avraham.stern@intel.com>
>
> When starting aggregation, the code checks the status of the queue
> allocated to the aggregation tid, which might not yet be allocated
> and thus the queue index may be invalid.
> Fix this by reserving a new queue in case the queue id is invalid.
>
> While at it, clean up some unreachable code (a condition that is
> already handled earlier) and remove all the non-DQA comments since
> non-DQA mode is no longer supported.

Doing cleanup on a patch for 4.16 is not really a good idea, I guess
it's ok this time. But please do try to avoid that.

-- 
Kalle Valo
