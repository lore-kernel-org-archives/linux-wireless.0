Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48858 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbcGHLCw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 07:02:52 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH v4] mwifiex: Reduce endian conversion for REG Host
 Commands
Date: Fri, 8 Jul 2016 11:02:45 +0000
Message-ID: <8e1cc4765b4242a4a48f86abddbe40fc@SC-EXCH04.marvell.com> (sfid-20160708_130316_460918_A34D6FF7)
References: <39f33dff10344e53b0fbbc9681f90b33@SC-EXCH04.marvell.com>
 <1467022402-23990-1-git-send-email-prasunmaiti87@gmail.com>
In-Reply-To: <1467022402-23990-1-git-send-email-prasunmaiti87@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Prasun Maiti [mailto:prasunmaiti87@gmail.com]
> Sent: Monday, June 27, 2016 3:43 PM
> To: Amitkumar Karwar
> Cc: Nishant Sarmukadam; Linux Wireless; Linux Next; Linux Kernel; Kalle
> Valo
> Subject: [PATCH v4] mwifiex: Reduce endian conversion for REG Host
> Commands
> 
> For multiple REG Host Commands (e.g HostCmd_CMD_802_11_EEPROM_ACCESS,
> HostCmd_CMD_MAC_REG_ACCESS etc.) "cpu_to_leX"-converted values are saved
> to driver. So, "leX_to_cpu" conversion is required too many times
> afterwards in driver.
> 
> This patch reduces the endian: conversion without saving "cpu_to_leX"
> converted values in driver. This will convert endianness in prepare
> command and command response path.
> 
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> ---
> Changes in v3:
> 	- Fixed the following warnings:
> 	* sta_ioctl.c:1339:34: warning: comparison of distinct pointer
> types lacks a cast [enabled by default]
> 	* sta_cmdresp.c:821:6: warning: comparison of distinct pointer
> types lacks a cast [enabled by default]
> 
> Changes in v4:
> 	- Fixed the sparse compilation warnings:
> 	* warning: cast from restricted __le32
> 	* warning: cast from restricted __le16
> 
>  drivers/net/wireless/marvell/mwifiex/ioctl.h       | 10 +++---
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 28 +++++++--------
> -
>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 37 +++++++++++----
> -------
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 21 ++++++------
>  4 files changed, 46 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/ioctl.h
> b/drivers/net/wireless/marvell/mwifiex/ioctl.h
> index a5a48c1..4ce9330 100644
> --- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
> +++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
> @@ -341,16 +341,16 @@ enum {
>  };
> 
>  struct mwifiex_ds_reg_rw {
> -	__le32 type;
> -	__le32 offset;
> -	__le32 value;
> +	u32 type;
> +	u32 offset;
> +	u32 value;
>  };
> 
>  #define MAX_EEPROM_DATA 256
> 
>  struct mwifiex_ds_read_eeprom {
> -	__le16 offset;
> -	__le16 byte_count;
> +	u16 offset;
> +	u16 byte_count;
>  	u8 value[MAX_EEPROM_DATA];
>  };
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> index e436574..9df02ba 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> @@ -1130,9 +1130,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size = cpu_to_le16(sizeof(*mac_reg) + S_DS_GEN);
>  		mac_reg = &cmd->params.mac_reg;
>  		mac_reg->action = cpu_to_le16(cmd_action);
> -		mac_reg->offset =
> -			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		mac_reg->value = reg_rw->value;
> +		mac_reg->offset = cpu_to_le16((u16) reg_rw->offset);
> +		mac_reg->value = cpu_to_le32(reg_rw->value);
>  		break;
>  	}
>  	case HostCmd_CMD_BBP_REG_ACCESS:
> @@ -1142,9 +1141,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size = cpu_to_le16(sizeof(*bbp_reg) + S_DS_GEN);
>  		bbp_reg = &cmd->params.bbp_reg;
>  		bbp_reg->action = cpu_to_le16(cmd_action);
> -		bbp_reg->offset =
> -			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		bbp_reg->value = (u8) le32_to_cpu(reg_rw->value);
> +		bbp_reg->offset = cpu_to_le16((u16) reg_rw->offset);
> +		bbp_reg->value = (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_RF_REG_ACCESS:
> @@ -1154,8 +1152,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size = cpu_to_le16(sizeof(*rf_reg) + S_DS_GEN);
>  		rf_reg = &cmd->params.rf_reg;
>  		rf_reg->action = cpu_to_le16(cmd_action);
> -		rf_reg->offset = cpu_to_le16((u16) le32_to_cpu(reg_rw-
> >offset));
> -		rf_reg->value = (u8) le32_to_cpu(reg_rw->value);
> +		rf_reg->offset = cpu_to_le16((u16) reg_rw->offset);
> +		rf_reg->value = (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_PMIC_REG_ACCESS:
> @@ -1165,9 +1163,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size = cpu_to_le16(sizeof(*pmic_reg) + S_DS_GEN);
>  		pmic_reg = &cmd->params.pmic_reg;
>  		pmic_reg->action = cpu_to_le16(cmd_action);
> -		pmic_reg->offset =
> -				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		pmic_reg->value = (u8) le32_to_cpu(reg_rw->value);
> +		pmic_reg->offset = cpu_to_le16((u16) reg_rw->offset);
> +		pmic_reg->value = (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_CAU_REG_ACCESS:
> @@ -1177,9 +1174,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size = cpu_to_le16(sizeof(*cau_reg) + S_DS_GEN);
>  		cau_reg = &cmd->params.rf_reg;
>  		cau_reg->action = cpu_to_le16(cmd_action);
> -		cau_reg->offset =
> -				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		cau_reg->value = (u8) le32_to_cpu(reg_rw->value);
> +		cau_reg->offset = cpu_to_le16((u16) reg_rw->offset);
> +		cau_reg->value = (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_802_11_EEPROM_ACCESS:
> @@ -1190,8 +1186,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
> 
>  		cmd->size = cpu_to_le16(sizeof(*cmd_eeprom) + S_DS_GEN);
>  		cmd_eeprom->action = cpu_to_le16(cmd_action);
> -		cmd_eeprom->offset = rd_eeprom->offset;
> -		cmd_eeprom->byte_count = rd_eeprom->byte_count;
> +		cmd_eeprom->offset = cpu_to_le16(rd_eeprom->offset);
> +		cmd_eeprom->byte_count = cpu_to_le16(rd_eeprom->byte_count);
>  		cmd_eeprom->value = 0;
>  		break;
>  	}
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> index d18c797..1832511 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
> @@ -781,45 +781,44 @@ static int mwifiex_ret_reg_access(u16 type, struct
> host_cmd_ds_command *resp,
>  	switch (type) {
>  	case HostCmd_CMD_MAC_REG_ACCESS:
>  		r.mac = &resp->params.mac_reg;
> -		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.mac-
> >offset));
> -		reg_rw->value = r.mac->value;
> +		reg_rw->offset = (u32) le16_to_cpu(r.mac->offset);
> +		reg_rw->value = le32_to_cpu(r.mac->value);
>  		break;
>  	case HostCmd_CMD_BBP_REG_ACCESS:
>  		r.bbp = &resp->params.bbp_reg;
> -		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.bbp-
> >offset));
> -		reg_rw->value = cpu_to_le32((u32) r.bbp->value);
> +		reg_rw->offset = (u32) le16_to_cpu(r.bbp->offset);
> +		reg_rw->value = (u32) r.bbp->value;
>  		break;
> 
>  	case HostCmd_CMD_RF_REG_ACCESS:
>  		r.rf = &resp->params.rf_reg;
> -		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.rf-
> >offset));
> -		reg_rw->value = cpu_to_le32((u32) r.bbp->value);
> +		reg_rw->offset = (u32) le16_to_cpu(r.rf->offset);
> +		reg_rw->value = (u32) r.bbp->value;
>  		break;
>  	case HostCmd_CMD_PMIC_REG_ACCESS:
>  		r.pmic = &resp->params.pmic_reg;
> -		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.pmic-
> >offset));
> -		reg_rw->value = cpu_to_le32((u32) r.pmic->value);
> +		reg_rw->offset = (u32) le16_to_cpu(r.pmic->offset);
> +		reg_rw->value = (u32) r.pmic->value;
>  		break;
>  	case HostCmd_CMD_CAU_REG_ACCESS:
>  		r.rf = &resp->params.rf_reg;
> -		reg_rw->offset = cpu_to_le32((u32) le16_to_cpu(r.rf-
> >offset));
> -		reg_rw->value = cpu_to_le32((u32) r.rf->value);
> +		reg_rw->offset = (u32) le16_to_cpu(r.rf->offset);
> +		reg_rw->value = (u32) r.rf->value;
>  		break;
>  	case HostCmd_CMD_802_11_EEPROM_ACCESS:
>  		r.eeprom = &resp->params.eeprom;
> -		pr_debug("info: EEPROM read len=%x\n", r.eeprom-
> >byte_count);
> -		if (le16_to_cpu(eeprom->byte_count) <
> -		    le16_to_cpu(r.eeprom->byte_count)) {
> -			eeprom->byte_count = cpu_to_le16(0);
> +		pr_debug("info: EEPROM read len=%x\n",
> +				le16_to_cpu(r.eeprom->byte_count));
> +		if (eeprom->byte_count < le16_to_cpu(r.eeprom->byte_count))
> {
> +			eeprom->byte_count = 0;
>  			pr_debug("info: EEPROM read length is too big\n");
>  			return -1;
>  		}
> -		eeprom->offset = r.eeprom->offset;
> -		eeprom->byte_count = r.eeprom->byte_count;
> -		if (le16_to_cpu(eeprom->byte_count) > 0)
> +		eeprom->offset = le16_to_cpu(r.eeprom->offset);
> +		eeprom->byte_count = le16_to_cpu(r.eeprom->byte_count);
> +		if (eeprom->byte_count > 0)
>  			memcpy(&eeprom->value, &r.eeprom->value,
> -			       le16_to_cpu(r.eeprom->byte_count));
> -
> +			       min((u16)MAX_EEPROM_DATA, eeprom->byte_count));
>  		break;
>  	default:
>  		return -1;
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> index 8e08626..6dab5ca 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_ioctl.c
> @@ -1247,7 +1247,7 @@ static int mwifiex_reg_mem_ioctl_reg_rw(struct
> mwifiex_private *priv,  {
>  	u16 cmd_no;
> 
> -	switch (le32_to_cpu(reg_rw->type)) {
> +	switch (reg_rw->type) {
>  	case MWIFIEX_REG_MAC:
>  		cmd_no = HostCmd_CMD_MAC_REG_ACCESS;
>  		break;
> @@ -1282,9 +1282,9 @@ mwifiex_reg_write(struct mwifiex_private *priv,
> u32 reg_type,  {
>  	struct mwifiex_ds_reg_rw reg_rw;
> 
> -	reg_rw.type = cpu_to_le32(reg_type);
> -	reg_rw.offset = cpu_to_le32(reg_offset);
> -	reg_rw.value = cpu_to_le32(reg_value);
> +	reg_rw.type = reg_type;
> +	reg_rw.offset = reg_offset;
> +	reg_rw.value = reg_value;
> 
>  	return mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw,
> HostCmd_ACT_GEN_SET);  } @@ -1302,14 +1302,14 @@ mwifiex_reg_read(struct
> mwifiex_private *priv, u32 reg_type,
>  	int ret;
>  	struct mwifiex_ds_reg_rw reg_rw;
> 
> -	reg_rw.type = cpu_to_le32(reg_type);
> -	reg_rw.offset = cpu_to_le32(reg_offset);
> +	reg_rw.type = reg_type;
> +	reg_rw.offset = reg_offset;
>  	ret = mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw,
> HostCmd_ACT_GEN_GET);
> 
>  	if (ret)
>  		goto done;
> 
> -	*value = le32_to_cpu(reg_rw.value);
> +	*value = reg_rw.value;
> 
>  done:
>  	return ret;
> @@ -1328,15 +1328,16 @@ mwifiex_eeprom_read(struct mwifiex_private
> *priv, u16 offset, u16 bytes,
>  	int ret;
>  	struct mwifiex_ds_read_eeprom rd_eeprom;
> 
> -	rd_eeprom.offset = cpu_to_le16((u16) offset);
> -	rd_eeprom.byte_count = cpu_to_le16((u16) bytes);
> +	rd_eeprom.offset =  offset;
> +	rd_eeprom.byte_count = bytes;
> 
>  	/* Send request to firmware */
>  	ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
>  			       HostCmd_ACT_GEN_GET, 0, &rd_eeprom, true);
> 
>  	if (!ret)
> -		memcpy(value, rd_eeprom.value, MAX_EEPROM_DATA);
> +		memcpy(value, rd_eeprom.value, min((u16)MAX_EEPROM_DATA,
> +		       rd_eeprom.byte_count));
>  	return ret;
>  }

Any specific reason for dropping this patch?
I can see the status as "Deferred" on patchwork.

Regards,
Amitkumar
