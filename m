Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35864 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab1GNKHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 06:07:54 -0400
Received: by pvg12 with SMTP id 12so81558pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 03:07:54 -0700 (PDT)
Date: Thu, 14 Jul 2011 13:06:13 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
Message-ID: <20110714100612.GW18655@shale.localdomain> (sfid-20110714_120758_145491_1F717035)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2011 at 04:32:44AM +0300, Kalle Valo wrote:
> The most important tasks left are:
> 
> o proper review of locking (currently 13 spin locks and one semaphore)

For example the DMA bounce buffer should probably be protected by
a lock so dueling threads don't corrupt it.

regards,
dan carpenter
