Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:23382 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572AbYHLFjK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 01:39:10 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/1] iwlwifi: fix printk newlines
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	ipw3945-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1218513565.25524.31.camel@californication>
References: <1218491381-1313-1-git-send-email-jirislaby@gmail.com>
	 <1218502555.25524.22.camel@californication>
	 <1218504137.3107.201.camel@debian.sh.intel.com>
	 <1218513565.25524.31.camel@californication>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 13:38:16 +0800
Message-Id: <1218519496.3107.235.camel@debian.sh.intel.com> (sfid-20080812_073916_438906_700B0C58)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-08-12 at 05:59 +0200, Marcel Holtmann wrote:
> > We should give the users more control to the style I think.
> 
> what kind of control do you expect? If you need two lines of debug or
> error output, call IWL_ERROR twice. This will also result in the
> KERN_ERR is set and not forgotten since that has to follow the
> newline.

I thought sometimes we might not need a new line between two IWL_ERRORs.
But your KERN_ERR garbaging the output in this case is correct. I think
when we wrote the macro, we just follow the style of dev_info() ...
dev_emerg() macros. Do you know why there is not a new line for them by
default?

Thanks,
-yi

