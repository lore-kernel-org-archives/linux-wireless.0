Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:52184 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936400AbaH1KFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 06:05:21 -0400
Message-ID: <53FEFEDE.5030505@broadcom.com> (sfid-20140828_120525_696791_33BC2E0F)
Date: Thu, 28 Aug 2014 12:05:18 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: add testmode
References: <20140828072642.14691.44313.stgit@potku.adurom.net>	<20140828073041.14691.15099.stgit@potku.adurom.net> <878um9ujn1.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <878um9ujn1.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/28/14 10:02, Kalle Valo wrote:
> Kalle Valo<kvalo@qca.qualcomm.com>  writes:
>
>> Add testmode interface for starting and using UTF firmware which is used to run
>> factory tests. This is implemented by adding new state ATH10K_STATE_UTF and user
>> space can enable this state with ATH10K_TM_CMD_UTF_START command. To go back to
>> normal mode user space can send ATH10K_TM_CMD_UTF_STOP.
>>
>> Signed-off-by: Kalle Valo<kvalo@qca.qualcomm.com>
>
> [...]
>
>> +/* "API" level of the ath10k testmode interface. Bump it after every
>> + * incompatible interface change. */
>> +#define ATH10K_TESTMODE_VERSION_MAJOR 1
>> +
>> +/* Bump this after every _compatible_ interface change, for example
>> + * addition of a new command or an attribute. */
>> +#define ATH10K_TESTMODE_VERSION_MINOR 0
>> +
>> +#define ATH10K_TM_DATA_MAX_LEN		5000
>> +
>> +enum ath10k_tm_attr {
>> +	__ATH10K_TM_ATTR_INVALID	= 0,
>> +	ATH10K_TM_ATTR_CMD		= 1,
>> +	ATH10K_TM_ATTR_DATA		= 2,
>> +	ATH10K_TM_ATTR_WMI_CMDID	= 3,
>> +	ATH10K_TM_ATTR_VERSION_MAJOR	= 4,
>> +	ATH10K_TM_ATTR_VERSION_MINOR	= 5,
>> +
>> +	/* keep last */
>> +	__ATH10K_TM_ATTR_AFTER_LAST,
>> +	ATH10K_TM_ATTR_MAX		= __ATH10K_TM_ATTR_AFTER_LAST - 1,
>> +};
>> +
>> +/* All ath10k testmode interface commands specified in
>> + * ATH10K_TM_ATTR_CMD */
>> +enum ath10k_tm_cmd {
>> +	/* Returns the supported ath10k testmode interface version in
>> +	 * ATH10K_TM_ATTR_VERSION. Always guaranteed to work. User space
>> +	 * uses this to verify it's using the correct version of the
>> +	 * testmode interface */
>> +	ATH10K_TM_CMD_GET_VERSION = 0,
>> +
>> +	/* Boots the UTF firmware, the netdev interface must be down at the
>> +	 * time. */
>> +	ATH10K_TM_CMD_UTF_START = 1,
>> +
>> +	/* Shuts down the UTF firmware and puts the driver back into OFF
>> +	 * state. */
>> +	ATH10K_TM_CMD_UTF_STOP = 2,
>> +
>> +	/* The command used to transmit a WMI command to the firmware and
>> +	 * the event to receive WMI events from the firmware. Without
>> +	 * struct wmi_cmd_hdr header, only the WMI payload. Command id is
>> +	 * provided with ATH10K_TM_ATTR_WMI_CMDID and payload in
>> +	 * ATH10K_TM_ATTR_DATA.*/
>> +	ATH10K_TM_CMD_WMI = 3,
>> +};
>
> Johannes suggested to put this to a separate file as that way it's
> easier for the user space. In v3 I'm planning to create testmode_uapi.h
> for this.

I suppose that file will/should end up in include/uapi/... so wouldn't 
it be better to call it ath10k_testmode.h?

Regards,
Arend
