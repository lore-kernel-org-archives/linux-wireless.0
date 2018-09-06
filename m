Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35849 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727724AbeIFM46 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 08:56:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1-v6so4844691pgo.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 01:22:41 -0700 (PDT)
Subject: Re: [PATCH 14/15] iwlwifi: mvm: Send LQ command as async when
 necessary
To: Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
References: <20180821063657.30071-1-luca@coelho.fi>
 <20180821063657.30071-15-luca@coelho.fi>
From: Hao Wei Tee <angelsl@in04.sg>
Message-ID: <2ee6e4d9-d555-c29b-815d-3e66890189bc@in04.sg> (sfid-20180906_103503_408831_CFFF4BDE)
Date: Thu, 6 Sep 2018 16:22:36 +0800
MIME-Version: 1.0
In-Reply-To: <20180821063657.30071-15-luca@coelho.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 21/8/18 2:36 PM, Luca Coelho wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> The parameter that indicated whether the LQ command should be sent
> as sync or async was removed, causing the LQ command to be sent as
> sync from interrupt context (e.g. from the RX path). This resulted
> in a kernel warning: "scheduling while atomic" and failing to send
> the LQ command, which ultimately leads to a queue hang.
> 
> Fix it by adding back the required parameter to send the command as
> sync only when it is allowed.
> 
> Fixes: d94c5a820d10 ("iwlwifi: mvm: open BA session only when sta is authorized")
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

I'm not sure whether you guys normally send fixes to stable, but this
really should go to stable. I run into this bug as often as a few times
an hour and sometimes it leads to IRQs from other devices being dropped
(e.g. touchpad, in turn causing the driver to timeout and quit, and the
touchpad dies).

Thanks.

-- 
Hao Wei
