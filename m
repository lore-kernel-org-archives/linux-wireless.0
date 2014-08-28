Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1800 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936301AbaH1ICb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 04:02:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add testmode
References: <20140828072642.14691.44313.stgit@potku.adurom.net>
	<20140828073041.14691.15099.stgit@potku.adurom.net>
Date: Thu, 28 Aug 2014 11:02:26 +0300
In-Reply-To: <20140828073041.14691.15099.stgit@potku.adurom.net> (Kalle Valo's
	message of "Thu, 28 Aug 2014 10:30:41 +0300")
Message-ID: <878um9ujn1.fsf@kamboji.qca.qualcomm.com> (sfid-20140828_100434_874543_174B64CC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Add testmode interface for starting and using UTF firmware which is used to run
> factory tests. This is implemented by adding new state ATH10K_STATE_UTF and user
> space can enable this state with ATH10K_TM_CMD_UTF_START command. To go back to
> normal mode user space can send ATH10K_TM_CMD_UTF_STOP.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

> +/* "API" level of the ath10k testmode interface. Bump it after every
> + * incompatible interface change. */
> +#define ATH10K_TESTMODE_VERSION_MAJOR 1
> +
> +/* Bump this after every _compatible_ interface change, for example
> + * addition of a new command or an attribute. */
> +#define ATH10K_TESTMODE_VERSION_MINOR 0
> +
> +#define ATH10K_TM_DATA_MAX_LEN		5000
> +
> +enum ath10k_tm_attr {
> +	__ATH10K_TM_ATTR_INVALID	= 0,
> +	ATH10K_TM_ATTR_CMD		= 1,
> +	ATH10K_TM_ATTR_DATA		= 2,
> +	ATH10K_TM_ATTR_WMI_CMDID	= 3,
> +	ATH10K_TM_ATTR_VERSION_MAJOR	= 4,
> +	ATH10K_TM_ATTR_VERSION_MINOR	= 5,
> +
> +	/* keep last */
> +	__ATH10K_TM_ATTR_AFTER_LAST,
> +	ATH10K_TM_ATTR_MAX		= __ATH10K_TM_ATTR_AFTER_LAST - 1,
> +};
> +
> +/* All ath10k testmode interface commands specified in
> + * ATH10K_TM_ATTR_CMD */
> +enum ath10k_tm_cmd {
> +	/* Returns the supported ath10k testmode interface version in
> +	 * ATH10K_TM_ATTR_VERSION. Always guaranteed to work. User space
> +	 * uses this to verify it's using the correct version of the
> +	 * testmode interface */
> +	ATH10K_TM_CMD_GET_VERSION = 0,
> +
> +	/* Boots the UTF firmware, the netdev interface must be down at the
> +	 * time. */
> +	ATH10K_TM_CMD_UTF_START = 1,
> +
> +	/* Shuts down the UTF firmware and puts the driver back into OFF
> +	 * state. */
> +	ATH10K_TM_CMD_UTF_STOP = 2,
> +
> +	/* The command used to transmit a WMI command to the firmware and
> +	 * the event to receive WMI events from the firmware. Without
> +	 * struct wmi_cmd_hdr header, only the WMI payload. Command id is
> +	 * provided with ATH10K_TM_ATTR_WMI_CMDID and payload in
> +	 * ATH10K_TM_ATTR_DATA.*/
> +	ATH10K_TM_CMD_WMI = 3,
> +};

Johannes suggested to put this to a separate file as that way it's
easier for the user space. In v3 I'm planning to create testmode_uapi.h
for this.

-- 
Kalle Valo
