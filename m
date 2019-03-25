Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9888FC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 20:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F1E20848
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 20:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NeA0qOyz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbfCYU1L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 16:27:11 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44239 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729283AbfCYU1L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 16:27:11 -0400
Received: by mail-pl1-f195.google.com with SMTP id g12so486152pll.11
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 13:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dZZxmKk/qnVsdh8r3L9faw3rDLJbKPPDIxucJjES/kQ=;
        b=NeA0qOyzrk0ojq3hfR0jK3Ncjtz2XX2KD4lpPaAcO7lX/DaVs7AHxIXKEskJynN9n1
         A5UfdKY+FMI1AL8OBAzY1V4MtwTX57qG5Kp0sCXJZU1Bqec6qDYetn9uY+fjbmrDaEiv
         5OuCKNPQh+pE4kErQ1qLMJvoyUNWLCc3OdOes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dZZxmKk/qnVsdh8r3L9faw3rDLJbKPPDIxucJjES/kQ=;
        b=eKM+9249CtKEHqPTP7Y68JgsyLQ5qgutKeGCdiyBTNzsOgSDdl7shop1sENGe/ciVQ
         XOFSoUcaHytfki+XRRMYNzdKNMTIDA7z6kiHZReY5lcZ8cUDZMkIc7h0MrpXOHW0CwRA
         YIsHq7jkTPRTtPjjsRMZIHU3pSHdyLeo3oRe0nGQKVOVdpDgFDLRhOoNcVY4v9wYwsyZ
         60tjNbAMuhZVsPiLIoLcWy7HTU4JFtuamseBqL5L/k32fR0Xx+uHn+P4AaBneCs2mQdp
         tqmkD3ezA7/52YkSa1r1T/aN7+fABKTQVxunQU5W0nJrC8SzsT/De6G6ta3THAlWz/Iq
         lrOQ==
X-Gm-Message-State: APjAAAVRra3YqeWCRhBoUzhRBzFQWv665hzj7bF/SISTeSe8KMvemXzr
        EZvArPiATyi7hBvyIcUrqVvTog==
X-Google-Smtp-Source: APXvYqy3n3cridkQ4OjXeH81xhECtcRCnxljLqOB/u+RXXnokLeavB9yU9pkLOhJgrHnhi90qIhFUQ==
X-Received: by 2002:a17:902:694b:: with SMTP id k11mr27817491plt.288.1553545630443;
        Mon, 25 Mar 2019 13:27:10 -0700 (PDT)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id v6sm3066013pgv.92.2019.03.25.13.27.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 13:27:09 -0700 (PDT)
Date:   Mon, 25 Mar 2019 13:27:07 -0700
From:   Brian Norris <briannorris@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, Carl Huang <cjhuang@codeaurora.org>,
        Wen Gong <wgong@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: pci: use mutex for diagnostic window CE polling
Message-ID: <20190325202706.GA68720@google.com>
References: <20190207014143.41529-1-briannorris@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190207014143.41529-1-briannorris@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

On Wed, Feb 06, 2019 at 05:41:43PM -0800, Brian Norris wrote:
> The DIAG copy engine is only used via polling, but it holds a spinlock
> with softirqs disabled. Each iteration of our read/write loops can
> theoretically take 20ms (two 10ms timeout loops), and this loop can be
> run an unbounded number of times while holding the spinlock -- dependent
> on the request size given by the caller.
> 
> As of commit 39501ea64116 ("ath10k: download firmware via diag Copy
> Engine for QCA6174 and QCA9377."), we transfer large chunks of firmware
> memory using this mechanism. With large enough firmware segments, this
> becomes an exceedingly long period for disabling soft IRQs. For example,
> with a 500KiB firmware segment, in testing QCA6174A, I see 200 loop
> iterations of about 50-100us each, which can total about 10-20ms.
> 
> In reality, we don't really need to block softirqs for this duration.
> The DIAG CE is only used in polling mode, and we only need to hold
> ce_lock to make sure any CE bookkeeping is done without screwing up
> another CE. Otherwise, we only need to ensure exclusion between
> ath10k_pci_diag_{read,write}_mem() contexts.
> 
> This patch moves to use fine-grained locking for the shared ce_lock,
> while adding a new mutex just to ensure mutual exclusion of diag
> read/write operations.
> 
> Tested on QCA6174A, firmware version WLAN.RM.4.4.1-00132-QCARMSWPZ-1.
> 
> Fixes: 39501ea64116 ("ath10k: download firmware via diag Copy Engine for QCA6174 and QCA9377.")
> Signed-off-by: Brian Norris <briannorris@chromium.org>

It would appear that this triggers new warnings

  BUG: sleeping function called from invalid context

when handling firmware crashes. The call stack is

  ath10k_pci_fw_crashed_dump
    -> ath10k_pci_dump_memory
    ...
      -> ath10k_pci_diag_read_mem

and the problem is that we're holding the 'data_lock' spinlock with
softirqs disabled, while later trying to grab this new mutex.

Unfortunately, data_lock is used in a lot of places, and it's unclear if
it can be migrated to a mutex as well. It seems like it probably can be,
but I'd have to audit a little more closely.

Any thoughts on what the short- and long-term solutions should be? I can
send a revert, to get v5.1 fixed. But it still seems like we should
avoid disabling softirqs for so long.

Brian
