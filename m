Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60138 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbZGTCJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 22:09:34 -0400
Subject: Re: iwmc3200wifi: using freed memory in iwm_hal_send_target_cmd()
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0907171555200.12306@bicker>
References: <alpine.DEB.2.00.0907171555200.12306@bicker>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 10:09:32 +0800
Message-Id: <1248055772.3747.0.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-07-19 at 19:53 +0800, Dan Carpenter wrote:
> Hello,
> 
> I found this with a source code checker (http://repo.or.cz/w/smatch.git).
> 
> We free "cmd" on line 390 and then dereference it on line 396.  I don't 
> know what we should return in that case or I would have sent a patch.  
> Sorry.
> 
> drivers/net/wireless/iwmc3200wifi/hal.c
>    390          if (!udma_cmd->resp)
>    391                  kfree(cmd);
>    392  
>    393          if (ret < 0)
>    394                  return ret;
>    395  
>    396          return cmd->seq_num;

Good catch! I'll send out a patch later.

Thanks,
-yi

