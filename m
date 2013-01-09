Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plout10-02.prod.sin2.secureserver.net ([182.50.145.5]:41242
	"EHLO sg2plout10-02.prod.sin2.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236Ab3AIQyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 11:54:37 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20717.41108.36571.933800@gargle.gargle.HOWL> (sfid-20130109_175444_380530_4168D00F)
Date: Wed, 9 Jan 2013 22:23:40 +0530
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Fix memory leak
In-Reply-To: <50ED9E7B.8050702@lwfinger.net>
References: <1357727868-3892-1-git-send-email-sujith@msujith.org>
	<50ED9E7B.8050702@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Yes, your fix handles the normal case, and you can add a
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks.

> I still have one remaining question. It is possible for the timeout code in 
> htc_config_pipe_credits() to be executed, as shown below:
> 
>          time_left = wait_for_completion_timeout(&target->cmd_wait, HZ);
>          if (!time_left) {
>                  dev_err(target->dev, "HTC credit config timeout\n");
>                  return -ETIMEDOUT;
>          }
> 
> When this timeout happens, is the skb leaked?

No, the submitted SKB (via htc_issue_send()) will always have a TX completion
invocation. The actual completion of target->cmd_wait happens via a different
code-path, htc_process_conn_rsp() in ath9k_htc_rx_msg().

Sujith
