Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:43217 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab1HXOSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:18:47 -0400
Subject: Re: [patch -next] wl12xx: fix recent change to
 wl1271_tm_cmd_nvs_push()
From: Luciano Coelho <coelho@ti.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Shahar Levi <shahar_levi@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:WL1271 WIRELESS D..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
In-Reply-To: <20110824113139.GE5975@shale.localdomain>
References: <20110824113139.GE5975@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 17:18:41 +0300
Message-ID: <1314195521.2296.204.camel@cumari> (sfid-20110824_161852_731022_69BC94ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Wed, 2011-08-24 at 14:31 +0300, Dan Carpenter wrote: 
> bc765bf3b9a "wl12xx: 1281/1283 support - Loading FW & NVS" had two
> problems.  The condition was written so that it failed if "len" was
> not equal to sizeof(struct wl1271_nvs_file).  Also we need to release
> the locks on these new error paths.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Thanks for your patch.  But we have just removed this function, since
the implementation was broken and the feature is not really used
anymore.

The patch that removes this function entirely is already queued for
inclusion on the 3.1-rc series:

http://git.kernel.org/?p=linux/kernel/git/linville/wireless.git;a=commit;h=80900d0140a7648587982c8f299830e900e49165


-- 
Cheers,
Luca.

