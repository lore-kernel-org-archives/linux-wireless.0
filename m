Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46546 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726320AbeIDQeO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:34:14 -0400
Message-ID: <f2e1d9b93487a74bccdbb680a1f43bae6271657f.camel@coelho.fi> (sfid-20180904_140925_121804_292D4D41)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
Date: Tue, 04 Sep 2018 15:09:18 +0300
In-Reply-To: <5B8CE1FB.1060402@broadcom.com>
References: <20180831095614.14099-1-luca@coelho.fi>
         <20180831095614.14099-13-luca@coelho.fi> <5B8CE1FB.1060402@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 12/16] iwlwifi: mvm: enable sending HE_AIR_SNIFFER
 command via debugfs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-09-03 at 09:25 +0200, Arend van Spriel wrote:
> On 8/31/2018 11:56 AM, Luca Coelho wrote:
> > From: Shaul Triebitz <shaul.triebitz@intel.com>
> > 
> > In order to receive TB (Trigger Based) PPDU in monitor mode,
> > the Driver must send the HE_AIR_SNIFFER_CONFIG_CMD host command.
> > Enable that via debugfs.
> > 
> > Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
> > Signed-off-by: Ido Yariv <idox.yariv@intel.com>
> > Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> >   .../wireless/intel/iwlwifi/fw/api/datapath.h  |  5 ++
> >   .../net/wireless/intel/iwlwifi/fw/api/mac.h   | 14 +++++
> >   .../net/wireless/intel/iwlwifi/mvm/debugfs.c  | 53
> > +++++++++++++++++++
> >   3 files changed, 72 insertions(+)
> 
> [snip]
> 
> > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> > b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> > index 202158d03d36..725b97ecb447 100644
> > --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> > @@ -1727,6 +1727,57 @@ iwl_dbgfs_send_echo_cmd_write(struct iwl_mvm
> > *mvm, char *buf,
> >   	return ret ?: count;
> >   }
> > 
> > +static ssize_t
> > +iwl_dbgfs_set_aid_read(struct file *file, char __user *user_buf,
> > +		       size_t count, loff_t *ppos)
> > +{
> > +	return 0;
> > +}
> > +
> > +static ssize_t
> > +iwl_dbgfs_set_aid_write(struct file *file, const char __user
> > *user_buf,
> > +			size_t count, loff_t *ppos)
> > +{
> > +	struct iwl_mvm *mvm = file->private_data;
> > +	struct iwl_he_monitor_cmd he_mon_cmd = {};
> > +	u8 tmp_buf[32];
> > +	u32 aid;
> > +	int ret;
> > +
> > +	if (!iwl_mvm_firmware_running(mvm))
> > +		return -EIO;
> > +
> > +	if (count > sizeof(tmp_buf))
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(tmp_buf, user_buf, count))
> > +		return -EIO;
> > +
> > +	ret = sscanf(tmp_buf, "%x %2hhx:%2hhx:%2hhx:%2hhx:%2hhx:%2hhx",
> > &aid,
> > +		     &he_mon_cmd.bssid[0], &he_mon_cmd.bssid[1],
> > +		     &he_mon_cmd.bssid[2], &he_mon_cmd.bssid[3],
> > +		     &he_mon_cmd.bssid[4], &he_mon_cmd.bssid[5]);
> > +	if (ret != 7)
> > +		return -EINVAL;
> > +
> > +	he_mon_cmd.aid = cpu_to_le16(aid);
> > +
> > +	mutex_lock(&mvm->mutex);
> > +	ret = iwl_mvm_send_cmd_pdu(mvm,
> > iwl_cmd_id(HE_AIR_SNIFFER_CONFIG_CMD,
> > +						   DATA_PATH_GROUP, 0),
> > 0,
> > +				   sizeof(he_mon_cmd), &he_mon_cmd);
> > +	mutex_unlock(&mvm->mutex);
> > +
> > +	return ret ?: count;
> > +}
> > +
> > +static const struct file_operations iwl_dbgfs_set_aid_ops = {
> > +	.read = iwl_dbgfs_set_aid_read,
> > +	.write = iwl_dbgfs_set_aid_write,
> > +	.open = simple_open,
> > +	.llseek = default_llseek,
> > +};
> 
> What's with the name 'set_aid'?

Hmmm... good point.  I'm actually the 4th "generation" touching this
patch, so I don't know where this came from.  We will think of a better
name and I'll resend.  We'll have to adjust some scripts and stuff we
have, but that shouldn't be a problem.

Thanks for the review, Arend!

--
Cheers,
Luca.
