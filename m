Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:53399 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619AbbDMK13 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2015 06:27:29 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Avinash Patil <patila@marvell.com>
Date: Mon, 13 Apr 2015 03:27:25 -0700
Subject: RE: [PATCH 2/2] mwifiex: sdio: bug: dead-lock in card reset
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5951B16DFB8F9@SC-VEXCH1.marvell.com> (sfid-20150413_122733_320562_97DB0134)
References: <1428916704-9635-1-git-send-email-afenkart@gmail.com>
 <1428916704-9635-2-git-send-email-afenkart@gmail.com>
In-Reply-To: <1428916704-9635-2-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

Thanks for the patch series.

> 
> Card reset is implemented by removing/re-adding the adapter instance.
> This is implemented by removing the mmc host, which will then trigger a
> cascade of removal callbacks including mwifiex_sdio_remove.
> The dead-lock results in the latter function, trying to cancel the work
> item executing the mmc host removal. This patch adds a driver level, not
> adapter level, work struct to break the dead-lock
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
> ---
>  drivers/net/wireless/mwifiex/main.h |  1 -
> drivers/net/wireless/mwifiex/sdio.c | 63 +++++++++++++++++++++++++++++--
> ------
>  2 files changed, 50 insertions(+), 14 deletions(-)
> 

We had recently submitted a patch to address this issue. So these two patches won't be needed now.
http://www.spinics.net/lists/linux-wireless/msg135146.html

Could you please check and let us know if you have any suggestions for improvement?

Regards,
Amit
