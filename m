Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:54307 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbZGXVk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 17:40:59 -0400
Received: by fxm18 with SMTP id 18so1669161fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 14:40:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1248459194-10239-13-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
	<1248459194-10239-13-git-send-email-reinette.chatre@intel.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 24 Jul 2009 23:40:38 +0200
Message-ID: <69e28c910907241440m470ee210v29ea1f971caf2f09@mail.gmail.com>
Subject: Re: [PATCH 12/14] iwlwifi: debugFs to enable/disable 40MHz channel
	support
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 24, 2009 at 8:13 PM, Reinette
Chatre<reinette.chatre@intel.com> wrote:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>
> Add debugfs file to enable/disable Fat(40MHz) channel support.
> By default, 40MHz is supported if AP can support the function.
>
> By echo "1" to "disable_fat_mode" file, iwlwifi driver will disable the 40MHz
> support and only allow 20MHz channel.

Please make that disable_ht40. The term "fat channel" is deprecated in
favor of "HT40".

>
> Because the information exchange happen during association time,
> so enable/disable fat channel only can be performed when it is not
> associated with AP.
>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c    |    4 ++
>  drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
>  drivers/net/wireless/iwlwifi/iwl-debugfs.c |   46 ++++++++++++++++++++++++++++
>  drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
>  4 files changed, 52 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 710dd41..edfdbe8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -632,6 +632,10 @@ u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
>                if (!sta_ht_inf->ht_supported)
>                        return 0;
>        }
> +#ifdef CONFIG_IWLWIFI_DEBUG
> +       if (priv->disable_fat)
> +               return 0;
> +#endif
>        return iwl_is_channel_extension(priv, priv->band,
>                        le16_to_cpu(priv->staging_rxon.channel),
>                        iwl_ht_conf->extension_chan_offset);
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
> index 609a681..2e10da3 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debug.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
> @@ -88,6 +88,7 @@ struct iwl_debugfs {
>  #ifdef CONFIG_IWLWIFI_LEDS
>                struct dentry *file_led;
>  #endif
> +               struct dentry *file_disable_fat_mode;
>        } dbgfs_data_files;
>        struct dir_rf_files {
>                struct dentry *file_disable_sensitivity;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> index 748dc31..03486d5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> @@ -653,6 +653,49 @@ static ssize_t iwl_dbgfs_thermal_throttling_read(struct file *file,
>        return ret;
>  }
>
> +static ssize_t iwl_dbgfs_disable_fat_mode_write(struct file *file,
> +                                        const char __user *user_buf,
> +                                        size_t count, loff_t *ppos)
> +{
> +       struct iwl_priv *priv = file->private_data;
> +       char buf[8];
> +       int buf_size;
> +       int fat_mode;
> +
> +       memset(buf, 0, sizeof(buf));
> +       buf_size = min(count, sizeof(buf) -  1);
> +       if (copy_from_user(buf, user_buf, buf_size))
> +               return -EFAULT;
> +       if (sscanf(buf, "%d", &fat_mode) != 1)
> +               return -EFAULT;
> +       if (!iwl_is_associated(priv))
> +               priv->disable_fat = fat_mode ? true : false;
> +       else {
> +               IWL_ERR(priv, "Sta associated with AP - "
> +                       "Change fat mode is not allowed\n");
> +               return -EINVAL;
> +       }
> +
> +       return count;
> +}
> +
> +static ssize_t iwl_dbgfs_disable_fat_mode_read(struct file *file,
> +                                        char __user *user_buf,
> +                                        size_t count, loff_t *ppos)
> +{
> +       struct iwl_priv *priv = (struct iwl_priv *)file->private_data;
> +       char buf[100];
> +       int pos = 0;
> +       const size_t bufsz = sizeof(buf);
> +       ssize_t ret;
> +
> +       pos += scnprintf(buf + pos, bufsz - pos,
> +                       "11n 40Mhz Mode: %s\n",
> +                       priv->disable_fat ? "Disabled" : "Enabled");
> +       ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
> +       return ret;
> +}
> +
>  DEBUGFS_READ_WRITE_FILE_OPS(sram);
>  DEBUGFS_WRITE_FILE_OPS(log_event);
>  DEBUGFS_READ_FILE_OPS(nvm);
> @@ -667,6 +710,7 @@ DEBUGFS_READ_FILE_OPS(qos);
>  DEBUGFS_READ_FILE_OPS(led);
>  #endif
>  DEBUGFS_READ_FILE_OPS(thermal_throttling);
> +DEBUGFS_READ_WRITE_FILE_OPS(disable_fat_mode);
>
>  /*
>  * Create the debugfs files and directories
> @@ -708,6 +752,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
>        DEBUGFS_ADD_FILE(led, data);
>  #endif
>        DEBUGFS_ADD_FILE(thermal_throttling, data);
> +       DEBUGFS_ADD_FILE(disable_fat_mode, data);
>        DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
>        DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
>                         &priv->disable_chain_noise_cal);
> @@ -747,6 +792,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
>        DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_led);
>  #endif
>        DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_thermal_throttling);
> +       DEBUGFS_REMOVE(priv->dbgfs->dbgfs_data_files.file_disable_fat_mode);
>        DEBUGFS_REMOVE(priv->dbgfs->dir_data);
>        DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
>        DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
> diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
> index facbc3d..6101d12 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-dev.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
> @@ -1164,6 +1164,7 @@ struct iwl_priv {
>        /* debugging info */
>        u32 framecnt_to_us;
>        atomic_t restrict_refcnt;
> +       bool disable_fat;
>  #ifdef CONFIG_IWLWIFI_DEBUGFS
>        /* debugfs */
>        struct iwl_debugfs *dbgfs;
> --
> 1.5.6.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
