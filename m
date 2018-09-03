Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33893 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbeICLol (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 07:44:41 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15-v6so5095518qkc.1
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2018 00:25:49 -0700 (PDT)
Subject: Re: [PATCH 12/16] iwlwifi: mvm: enable sending HE_AIR_SNIFFER command
 via debugfs
To: Luca Coelho <luca@coelho.fi>, kvalo@codeaurora.org
References: <20180831095614.14099-1-luca@coelho.fi>
 <20180831095614.14099-13-luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Ido Yariv <idox.yariv@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B8CE1FB.1060402@broadcom.com> (sfid-20180903_092553_395518_3BFC2C8D)
Date: Mon, 3 Sep 2018 09:25:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180831095614.14099-13-luca@coelho.fi>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/31/2018 11:56 AM, Luca Coelho wrote:
> From: Shaul Triebitz <shaul.triebitz@intel.com>
>
> In order to receive TB (Trigger Based) PPDU in monitor mode,
> the Driver must send the HE_AIR_SNIFFER_CONFIG_CMD host command.
> Enable that via debugfs.
>
> Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
> Signed-off-by: Ido Yariv <idox.yariv@intel.com>
> Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
>   .../wireless/intel/iwlwifi/fw/api/datapath.h  |  5 ++
>   .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 14 +++++
>   .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 53 +++++++++++++++++++
>   3 files changed, 72 insertions(+)

[snip]

> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> index 202158d03d36..725b97ecb447 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> @@ -1727,6 +1727,57 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm *mvm, char *buf,
>   	return ret ?: count;
>   }
>
> +static ssize_t
> +iwl_dbgfs_set_aid_read(struct file *file, char __user *user_buf,
> +		       size_t count, loff_t *ppos)
> +{
> +	return 0;
> +}
> +
> +static ssize_t
> +iwl_dbgfs_set_aid_write(struct file *file, const char __user *user_buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct iwl_mvm *mvm = file->private_data;
> +	struct iwl_he_monitor_cmd he_mon_cmd = {};
> +	u8 tmp_buf[32];
> +	u32 aid;
> +	int ret;
> +
> +	if (!iwl_mvm_firmware_running(mvm))
> +		return -EIO;
> +
> +	if (count > sizeof(tmp_buf))
> +		return -EINVAL;
> +
> +	if (copy_from_user(tmp_buf, user_buf, count))
> +		return -EIO;
> +
> +	ret = sscanf(tmp_buf, "%x %2hhx:%2hhx:%2hhx:%2hhx:%2hhx:%2hhx", &aid,
> +		     &he_mon_cmd.bssid[0], &he_mon_cmd.bssid[1],
> +		     &he_mon_cmd.bssid[2], &he_mon_cmd.bssid[3],
> +		     &he_mon_cmd.bssid[4], &he_mon_cmd.bssid[5]);
> +	if (ret != 7)
> +		return -EINVAL;
> +
> +	he_mon_cmd.aid = cpu_to_le16(aid);
> +
> +	mutex_lock(&mvm->mutex);
> +	ret = iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(HE_AIR_SNIFFER_CONFIG_CMD,
> +						   DATA_PATH_GROUP, 0), 0,
> +				   sizeof(he_mon_cmd), &he_mon_cmd);
> +	mutex_unlock(&mvm->mutex);
> +
> +	return ret ?: count;
> +}
> +
> +static const struct file_operations iwl_dbgfs_set_aid_ops = {
> +	.read = iwl_dbgfs_set_aid_read,
> +	.write = iwl_dbgfs_set_aid_write,
> +	.open = simple_open,
> +	.llseek = default_llseek,
> +};

What's with the name 'set_aid'?

Regards,
Arend
