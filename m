Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35948 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbaDXJJC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 05:09:02 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH 2/5] mwifiex: add firmware dump feature for PCIe
References: <1397760423-11455-1-git-send-email-bzhao@marvell.com>
	<1397760423-11455-2-git-send-email-bzhao@marvell.com>
Date: Thu, 24 Apr 2014 12:08:59 +0300
In-Reply-To: <1397760423-11455-2-git-send-email-bzhao@marvell.com> (Bing
	Zhao's message of "Thu, 17 Apr 2014 11:47:00 -0700")
Message-ID: <87a9bb5c2c.fsf@purkki.adurom.net> (sfid-20140424_110914_269696_96A2565A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing Zhao <bzhao@marvell.com> writes:

> From: Amitkumar Karwar <akarwar@marvell.com>
>
> Firmware dump feature is added for PCIe based chipsets.
> Separate file will be created at /var/log/fw_dump_*
> for each memory segment.
>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Sorry for commenting so late, I was on holidays and then got lagged
behind with email.

> +			memset(filename, 0, sizeof(filename));
> +			memcpy(filename, name_prefix, strlen(name_prefix));
> +			strcat(filename, entry->mem_name);
> +			do_gettimeofday(&t);
> +			entry->file_mem = filp_open(filename, O_CREAT | O_RDWR,
> +						    0644);
> +			if (IS_ERR(entry->file_mem)) {
> +				dev_info(adapter->dev,
> +					 "Create %s file failed at %s, opening another dir /tmp\n",
> +					 entry->mem_name, filename);
> +				memset(filename, 0, sizeof(filename));
> +				sprintf(filename, "%s%s", "/tmp/fw_dump_",
> +					entry->mem_name);
> +				entry->file_mem =
> +					filp_open(filename,
> +						  O_CREAT | O_RDWR, 0644);
> +			}
> +			if (!IS_ERR(entry->file_mem)) {
> +				dev_info(adapter->dev,
> +					 "Start to save the output : %u.%06u, please wait...\n",
> +					 (u32)t.tv_sec, (u32)t.tv_usec);

Like I said in my previous email, IMHO a wireless driver should not save
any files to the filesystem. For example, I don't see any other uses of
filp_open() in drivers/net. Ugly hacks like this belong to staging
drivers, not to proper upstream drivers.

-- 
Kalle Valo
