Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65259 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753709AbaIEIKc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 04:10:32 -0400
From: Avinash Patil <patila@marvell.com>
To: James Cameron <quozl@laptop.org>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Marc Yang <yangyang@marvell.com>, Cathy Luo <cluo@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Date: Fri, 5 Sep 2014 01:08:29 -0700
Subject: RE: [PATCH 17/17] mwifiex: add rx workqueue support
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC4781147CEE@SC-VEXCH2.marvell.com> (sfid-20140905_101042_396272_BD4D1432)
References: <1409576345-13717-1-git-send-email-patila@marvell.com>
 <1409576345-13717-18-git-send-email-patila@marvell.com>,<20140904034758.GZ27002@us.netrek.org>
In-Reply-To: <20140904034758.GZ27002@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

Thanks for pointing out.

John,

Do you want me to send a follow up patch for this? Else I will fix this and send v2.

Thanks,
Avinash
________________________________________
From: quozl@laptop.org [quozl@laptop.org]
Sent: Thursday, September 04, 2014 9:17 AM
To: Avinash Patil
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; Amitkumar Karwar; Xinming Hu; Marc Yang; Cathy Luo; Maithili Hinge
Subject: Re: [PATCH 17/17] mwifiex: add rx workqueue support

On Mon, Sep 01, 2014 at 06:29:05PM +0530, Avinash Patil wrote:
> This patch adds RX work queue support to mwifiex.
> Packets received are queued to internal queue which are then
> processed by scheduling a work item for RX process.
>
> RX work is enabled only on SMP systems.
>
> Signed-off-by: Avinash Patil <patila@marvell.com>
> Signed-off-by: Marc Yang <yangyang@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> ---
>  drivers/net/wireless/mwifiex/11n_rxreorder.c | 14 ++++
>  drivers/net/wireless/mwifiex/init.c          | 19 ++++++
>  drivers/net/wireless/mwifiex/main.c          | 95 ++++++++++++++++++++++++++++
>  drivers/net/wireless/mwifiex/main.h          | 14 ++++
>  drivers/net/wireless/mwifiex/pcie.c          | 12 +++-
>  drivers/net/wireless/mwifiex/sdio.c          | 11 +++-
>  6 files changed, 163 insertions(+), 2 deletions(-)
>
> [...]
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index fb38d81..2ed59a0 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> [...]
> @@ -784,6 +858,15 @@ mwifiex_add_card(void *card, struct semaphore *sem,
>       adapter->cmd_wait_q.status = 0;
>       adapter->scan_wait_q_woken = false;
>
> +     if (num_possible_cpus() > 1) {
> +             adapter->rx_work_enabled = true;
> +             pr_debug("info: %s rx work enabled, cpus %d :\n", __func__,
> +                      num_possible_cpus());
> +             /*to ensure this is seen in dmesg logs*/
> +             pr_err("info: %s rx work enabled, cpus %d :\n", __func__,
> +                    num_possible_cpus());

Either pr_debug or pr_err, but not both.

(Would love to test, but stuck on 3.5, and don't know how to
backport mwifiex.)

--
James Cameron
http://quozl.linux.org.au/
