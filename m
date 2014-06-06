Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34985 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbaFFG4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 02:56:36 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/4] ath10k:  provide firmware crash info via debugfs.
References: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
Date: Fri, 6 Jun 2014 09:55:37 +0300
In-Reply-To: <1401904902-5842-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Wed, 4 Jun 2014 11:01:39
	-0700")
Message-ID: <87bnu6msra.fsf@kamboji.qca.qualcomm.com> (sfid-20140606_085644_108688_38E13776)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> Store the firmware crash registers and last 128 or so
> firmware debug-log ids and present them to user-space
> via debugfs.
>
> Should help with figuring out why the firmware crashed.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> +	dump_data->kernel_ver_code = LINUX_VERSION_CODE;
> +	strncpy(dump_data->kernel_ver, VERMAGIC_STRING,
> +		sizeof(dump_data->kernel_ver) - 1);

Other thing nice to have here is the kernel timestamp in the kernel log
"[123456.4321]". How difficult would it be to add that to the dump?

-- 
Kalle Valo
