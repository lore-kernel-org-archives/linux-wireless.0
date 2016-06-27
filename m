Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60330 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751033AbcF0HCM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 03:02:12 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: RE: [PATCH v3] mwifiex: Reduce endian conversion for REG Host
 Commands
Date: Mon, 27 Jun 2016 07:02:08 +0000
Message-ID: <39f33dff10344e53b0fbbc9681f90b33@SC-EXCH04.marvell.com> (sfid-20160627_090232_151785_2E2E020F)
References: <1466659753-13146-1-git-send-email-prasunmaiti87@gmail.com>
In-Reply-To: <1466659753-13146-1-git-send-email-prasunmaiti87@gmail.com>
Content-Type: multipart/mixed;
	boundary="_002_39f33dff10344e53b0fbbc9681f90b33SCEXCH04marvellcom_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_39f33dff10344e53b0fbbc9681f90b33SCEXCH04marvellcom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Prasun,

> From: Prasun Maiti [mailto:prasunmaiti87@gmail.com]
> Sent: Thursday, June 23, 2016 10:59 AM
> To: Amitkumar Karwar
> Cc: Nishant Sarmukadam; Linux Wireless; Linux Next; Linux Kernel; Kalle
> Valo
> Subject: [PATCH v3] mwifiex: Reduce endian conversion for REG Host
> Commands
>=20
> For multiple REG Host Commands (e.g HostCmd_CMD_802_11_EEPROM_ACCESS,
> HostCmd_CMD_MAC_REG_ACCESS etc.) "cpu_to_leX"-converted values are saved
> to driver. So, "leX_to_cpu" conversion is required too many times
> afterwards in driver.
>=20
> This patch reduces the endian: conversion without saving "cpu_to_leX"
> converted values in driver. This will convert endianness in prepare
> command and command response path.
>=20
> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
> ---
> Changes in v3:
> 	- Fixed the following warnings:
> 	* sta_ioctl.c:1339:34: warning: comparison of distinct pointer
> types lacks a cast [enabled by default]
> 	* sta_cmdresp.c:821:6: warning: comparison of distinct pointer
> types lacks a cast [enabled by default]
>=20
>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 28 +++++++--------
> -
>  drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 37 +++++++++++----
> -------
>  drivers/net/wireless/marvell/mwifiex/sta_ioctl.c   | 21 ++++++------
>  3 files changed, 41 insertions(+), 45 deletions(-)
>=20
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> index e436574..9df02ba 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> @@ -1130,9 +1130,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size =3D cpu_to_le16(sizeof(*mac_reg) + S_DS_GEN);
>  		mac_reg =3D &cmd->params.mac_reg;
>  		mac_reg->action =3D cpu_to_le16(cmd_action);
> -		mac_reg->offset =3D
> -			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		mac_reg->value =3D reg_rw->value;
> +		mac_reg->offset =3D cpu_to_le16((u16) reg_rw->offset);
> +		mac_reg->value =3D cpu_to_le32(reg_rw->value);
>  		break;
>  	}
>  	case HostCmd_CMD_BBP_REG_ACCESS:
> @@ -1142,9 +1141,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size =3D cpu_to_le16(sizeof(*bbp_reg) + S_DS_GEN);
>  		bbp_reg =3D &cmd->params.bbp_reg;
>  		bbp_reg->action =3D cpu_to_le16(cmd_action);
> -		bbp_reg->offset =3D
> -			cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		bbp_reg->value =3D (u8) le32_to_cpu(reg_rw->value);
> +		bbp_reg->offset =3D cpu_to_le16((u16) reg_rw->offset);
> +		bbp_reg->value =3D (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_RF_REG_ACCESS:
> @@ -1154,8 +1152,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size =3D cpu_to_le16(sizeof(*rf_reg) + S_DS_GEN);
>  		rf_reg =3D &cmd->params.rf_reg;
>  		rf_reg->action =3D cpu_to_le16(cmd_action);
> -		rf_reg->offset =3D cpu_to_le16((u16) le32_to_cpu(reg_rw-
> >offset));
> -		rf_reg->value =3D (u8) le32_to_cpu(reg_rw->value);
> +		rf_reg->offset =3D cpu_to_le16((u16) reg_rw->offset);
> +		rf_reg->value =3D (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_PMIC_REG_ACCESS:
> @@ -1165,9 +1163,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size =3D cpu_to_le16(sizeof(*pmic_reg) + S_DS_GEN);
>  		pmic_reg =3D &cmd->params.pmic_reg;
>  		pmic_reg->action =3D cpu_to_le16(cmd_action);
> -		pmic_reg->offset =3D
> -				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		pmic_reg->value =3D (u8) le32_to_cpu(reg_rw->value);
> +		pmic_reg->offset =3D cpu_to_le16((u16) reg_rw->offset);
> +		pmic_reg->value =3D (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_CAU_REG_ACCESS:
> @@ -1177,9 +1174,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>  		cmd->size =3D cpu_to_le16(sizeof(*cau_reg) + S_DS_GEN);
>  		cau_reg =3D &cmd->params.rf_reg;
>  		cau_reg->action =3D cpu_to_le16(cmd_action);
> -		cau_reg->offset =3D
> -				cpu_to_le16((u16) le32_to_cpu(reg_rw->offset));
> -		cau_reg->value =3D (u8) le32_to_cpu(reg_rw->value);
> +		cau_reg->offset =3D cpu_to_le16((u16) reg_rw->offset);
> +		cau_reg->value =3D (u8) reg_rw->value;
>  		break;
>  	}
>  	case HostCmd_CMD_802_11_EEPROM_ACCESS:
> @@ -1190,8 +1186,8 @@ static int mwifiex_cmd_reg_access(struct
> host_cmd_ds_command *cmd,
>=20
>  		cmd->size =3D cpu_to_le16(sizeof(*cmd_eeprom) + S_DS_GEN);
>  		cmd_eeprom->action =3D cpu_to_le16(cmd_action);
> -		cmd_eeprom->offset =3D rd_eeprom->offset;
> -		cmd_eeprom->byte_count =3D rd_eeprom->byte_count;
> +		cmd_eeprom->offset =3D cpu_to_le16(rd_eeprom->offset);
> +		cmd_eeprom->byte_count =3D cpu_to_le16(rd_eeprom->byte_count);
>  		cmd_eeprom->value =3D 0;
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
>  		r.mac =3D &resp->params.mac_reg;
> -		reg_rw->offset =3D cpu_to_le32((u32) le16_to_cpu(r.mac-
> >offset));
> -		reg_rw->value =3D r.mac->value;
> +		reg_rw->offset =3D (u32) le16_to_cpu(r.mac->offset);
> +		reg_rw->value =3D le32_to_cpu(r.mac->value);
>  		break;
>  	case HostCmd_CMD_BBP_REG_ACCESS:
>  		r.bbp =3D &resp->params.bbp_reg;
> -		reg_rw->offset =3D cpu_to_le32((u32) le16_to_cpu(r.bbp-
> >offset));
> -		reg_rw->value =3D cpu_to_le32((u32) r.bbp->value);
> +		reg_rw->offset =3D (u32) le16_to_cpu(r.bbp->offset);
> +		reg_rw->value =3D (u32) r.bbp->value;
>  		break;
>=20
>  	case HostCmd_CMD_RF_REG_ACCESS:
>  		r.rf =3D &resp->params.rf_reg;
> -		reg_rw->offset =3D cpu_to_le32((u32) le16_to_cpu(r.rf-
> >offset));
> -		reg_rw->value =3D cpu_to_le32((u32) r.bbp->value);
> +		reg_rw->offset =3D (u32) le16_to_cpu(r.rf->offset);
> +		reg_rw->value =3D (u32) r.bbp->value;
>  		break;
>  	case HostCmd_CMD_PMIC_REG_ACCESS:
>  		r.pmic =3D &resp->params.pmic_reg;
> -		reg_rw->offset =3D cpu_to_le32((u32) le16_to_cpu(r.pmic-
> >offset));
> -		reg_rw->value =3D cpu_to_le32((u32) r.pmic->value);
> +		reg_rw->offset =3D (u32) le16_to_cpu(r.pmic->offset);
> +		reg_rw->value =3D (u32) r.pmic->value;
>  		break;
>  	case HostCmd_CMD_CAU_REG_ACCESS:
>  		r.rf =3D &resp->params.rf_reg;
> -		reg_rw->offset =3D cpu_to_le32((u32) le16_to_cpu(r.rf-
> >offset));
> -		reg_rw->value =3D cpu_to_le32((u32) r.rf->value);
> +		reg_rw->offset =3D (u32) le16_to_cpu(r.rf->offset);
> +		reg_rw->value =3D (u32) r.rf->value;
>  		break;
>  	case HostCmd_CMD_802_11_EEPROM_ACCESS:
>  		r.eeprom =3D &resp->params.eeprom;
> -		pr_debug("info: EEPROM read len=3D%x\n", r.eeprom-
> >byte_count);
> -		if (le16_to_cpu(eeprom->byte_count) <
> -		    le16_to_cpu(r.eeprom->byte_count)) {
> -			eeprom->byte_count =3D cpu_to_le16(0);
> +		pr_debug("info: EEPROM read len=3D%x\n",
> +				le16_to_cpu(r.eeprom->byte_count));
> +		if (eeprom->byte_count < le16_to_cpu(r.eeprom->byte_count))
> {
> +			eeprom->byte_count =3D 0;
>  			pr_debug("info: EEPROM read length is too big\n");
>  			return -1;
>  		}
> -		eeprom->offset =3D r.eeprom->offset;
> -		eeprom->byte_count =3D r.eeprom->byte_count;
> -		if (le16_to_cpu(eeprom->byte_count) > 0)
> +		eeprom->offset =3D le16_to_cpu(r.eeprom->offset);
> +		eeprom->byte_count =3D le16_to_cpu(r.eeprom->byte_count);
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
>=20
> -	switch (le32_to_cpu(reg_rw->type)) {
> +	switch (reg_rw->type) {
>  	case MWIFIEX_REG_MAC:
>  		cmd_no =3D HostCmd_CMD_MAC_REG_ACCESS;
>  		break;
> @@ -1282,9 +1282,9 @@ mwifiex_reg_write(struct mwifiex_private *priv,
> u32 reg_type,  {
>  	struct mwifiex_ds_reg_rw reg_rw;
>=20
> -	reg_rw.type =3D cpu_to_le32(reg_type);
> -	reg_rw.offset =3D cpu_to_le32(reg_offset);
> -	reg_rw.value =3D cpu_to_le32(reg_value);
> +	reg_rw.type =3D reg_type;
> +	reg_rw.offset =3D reg_offset;
> +	reg_rw.value =3D reg_value;
>=20
>  	return mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw,
> HostCmd_ACT_GEN_SET);  } @@ -1302,14 +1302,14 @@ mwifiex_reg_read(struct
> mwifiex_private *priv, u32 reg_type,
>  	int ret;
>  	struct mwifiex_ds_reg_rw reg_rw;
>=20
> -	reg_rw.type =3D cpu_to_le32(reg_type);
> -	reg_rw.offset =3D cpu_to_le32(reg_offset);
> +	reg_rw.type =3D reg_type;
> +	reg_rw.offset =3D reg_offset;
>  	ret =3D mwifiex_reg_mem_ioctl_reg_rw(priv, &reg_rw,
> HostCmd_ACT_GEN_GET);
>=20
>  	if (ret)
>  		goto done;
>=20
> -	*value =3D le32_to_cpu(reg_rw.value);
> +	*value =3D reg_rw.value;
>=20
>  done:
>  	return ret;
> @@ -1328,15 +1328,16 @@ mwifiex_eeprom_read(struct mwifiex_private
> *priv, u16 offset, u16 bytes,
>  	int ret;
>  	struct mwifiex_ds_read_eeprom rd_eeprom;
>=20
> -	rd_eeprom.offset =3D cpu_to_le16((u16) offset);
> -	rd_eeprom.byte_count =3D cpu_to_le16((u16) bytes);
> +	rd_eeprom.offset =3D  offset;
> +	rd_eeprom.byte_count =3D bytes;
>=20
>  	/* Send request to firmware */
>  	ret =3D mwifiex_send_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
>  			       HostCmd_ACT_GEN_GET, 0, &rd_eeprom, true);
>=20
>  	if (!ret)
> -		memcpy(value, rd_eeprom.value, MAX_EEPROM_DATA);
> +		memcpy(value, rd_eeprom.value, min((u16)MAX_EEPROM_DATA,
> +		       rd_eeprom.byte_count));
>  	return ret;
>  }
>=20

I can see attached sparse compilation warnings with your patch.
Sparse info: https://www.kernel.org/doc/Documentation/sparse.txt
I suppose you need to change structure definitions as well. __le16/__le32 m=
embers should now be defined as u16/u32 to resolve the warnings. Please pre=
pare updated version with the change.

Regards,
Amitkumar

--_002_39f33dff10344e53b0fbbc9681f90b33SCEXCH04marvellcom_
Content-Type: text/plain; name="sparse.txt"
Content-Description: sparse.txt
Content-Disposition: attachment; filename="sparse.txt"; size=12349;
	creation-date="Mon, 27 Jun 2016 06:57:52 GMT";
	modification-date="Mon, 27 Jun 2016 06:57:52 GMT"
Content-Transfer-Encoding: base64

L2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfaW9jdGwuYzoxMjUwOjIzOiB3YXJuaW5nOiByZXN0
cmljdGVkIF9fbGUzMiBkZWdyYWRlcyB0byBpbnRlZ2VyCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgt
ZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgv
c3RhX2lvY3RsLmM6MTI1MDoyMzogd2FybmluZzogcmVzdHJpY3RlZCBfX2xlMzIgZGVncmFkZXMg
dG8gaW50ZWdlcgovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9pb2N0bC5jOjEyNTA6MjM6IHdh
cm5pbmc6IHJlc3RyaWN0ZWQgX19sZTMyIGRlZ3JhZGVzIHRvIGludGVnZXIKL2hvbWUvYW1pdC9n
aXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZl
bGwvbXdpZmlleC9zdGFfaW9jdGwuYzoxMjUwOjIzOiB3YXJuaW5nOiByZXN0cmljdGVkIF9fbGUz
MiBkZWdyYWRlcyB0byBpbnRlZ2VyCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmll
eC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6
MTI1MDoyMzogd2FybmluZzogcmVzdHJpY3RlZCBfX2xlMzIgZGVncmFkZXMgdG8gaW50ZWdlcgov
aG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9pb2N0bC5jOjEyODU6MjE6IHdhcm5pbmc6IGluY29y
cmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQovaG9tZS9hbWl0
L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFy
dmVsbC9td2lmaWV4L3N0YV9pb2N0bC5jOjEyODU6MjE6ICAgIGV4cGVjdGVkIHJlc3RyaWN0ZWQg
X19sZTMyIFt1c2VydHlwZV0gdHlwZQovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZp
ZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9pb2N0bC5j
OjEyODU6MjE6ICAgIGdvdCB1bnNpZ25lZCBpbnQgW3Vuc2lnbmVkXSBbdXNlcnR5cGVdIHJlZ190
eXBlCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25l
dC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6MTI4NjoyMzogd2FybmluZzog
aW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVyZW50IGJhc2UgdHlwZXMpCi9ob21l
L2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVz
cy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6MTI4NjoyMzogICAgZXhwZWN0ZWQgcmVzdHJp
Y3RlZCBfX2xlMzIgW3VzZXJ0eXBlXSBvZmZzZXQKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZl
bC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFf
aW9jdGwuYzoxMjg2OjIzOiAgICBnb3QgdW5zaWduZWQgaW50IFt1bnNpZ25lZF0gW3VzZXJ0eXBl
XSByZWdfb2Zmc2V0Ci9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9k
cml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6MTI4NzoyMjog
d2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVyZW50IGJhc2UgdHlw
ZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25l
dC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6MTI4NzoyMjogICAgZXhwZWN0
ZWQgcmVzdHJpY3RlZCBfX2xlMzIgW3VzZXJ0eXBlXSB2YWx1ZQovaG9tZS9hbWl0L2dpdC5td2lm
aWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lm
aWV4L3N0YV9pb2N0bC5jOjEyODc6MjI6ICAgIGdvdCB1bnNpZ25lZCBpbnQgW3Vuc2lnbmVkXSBb
dXNlcnR5cGVdIHJlZ192YWx1ZQovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgt
ZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9pb2N0bC5jOjEz
MDU6MjE6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBi
YXNlIHR5cGVzKQovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9pb2N0bC5jOjEzMDU6MjE6ICAg
IGV4cGVjdGVkIHJlc3RyaWN0ZWQgX19sZTMyIFt1c2VydHlwZV0gdHlwZQovaG9tZS9hbWl0L2dp
dC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVs
bC9td2lmaWV4L3N0YV9pb2N0bC5jOjEzMDU6MjE6ICAgIGdvdCB1bnNpZ25lZCBpbnQgW3Vuc2ln
bmVkXSBbdXNlcnR5cGVdIHJlZ190eXBlCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdp
ZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3Rs
LmM6MTMwNjoyMzogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVy
ZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZl
bC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6MTMwNjoy
MzogICAgZXhwZWN0ZWQgcmVzdHJpY3RlZCBfX2xlMzIgW3VzZXJ0eXBlXSBvZmZzZXQKL2hvbWUv
YW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L21hcnZlbGwvbXdpZmlleC9zdGFfaW9jdGwuYzoxMzA2OjIzOiAgICBnb3QgdW5zaWduZWQgaW50
IFt1bnNpZ25lZF0gW3VzZXJ0eXBlXSByZWdfb2Zmc2V0Ci9ob21lL2FtaXQvZ2l0Lm13aWZpZXgt
ZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgv
c3RhX2lvY3RsLmM6MTMxMjoxNjogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVu
dCAoZGlmZmVyZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdp
ZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3Rs
LmM6MTMxMjoxNjogICAgZXhwZWN0ZWQgdW5zaWduZWQgaW50IFt1bnNpZ25lZF0gW3VzZXJ0eXBl
XSA8bm9pZGVudD4KL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfaW9jdGwuYzoxMzEyOjE2OiAg
ICBnb3QgcmVzdHJpY3RlZCBfX2xlMzIgW2FkZHJlc3NhYmxlXSBbdXNlcnR5cGVdIHZhbHVlCi9o
b21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJl
bGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6MTMzMToyNjogd2FybmluZzogaW5jb3Jy
ZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVyZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQv
Z2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2
ZWxsL213aWZpZXgvc3RhX2lvY3RsLmM6MTMzMToyNjogICAgZXhwZWN0ZWQgcmVzdHJpY3RlZCBf
X2xlMTYgW3VzZXJ0eXBlXSBvZmZzZXQKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lm
aWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfaW9jdGwu
YzoxMzMxOjI2OiAgICBnb3QgdW5zaWduZWQgc2hvcnQgW3Vuc2lnbmVkXSBbdXNlcnR5cGVdIG9m
ZnNldAovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9u
ZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9pb2N0bC5jOjEzMzI6MzA6IHdhcm5pbmc6
IGluY29ycmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQovaG9t
ZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxl
c3MvbWFydmVsbC9td2lmaWV4L3N0YV9pb2N0bC5jOjEzMzI6MzA6ICAgIGV4cGVjdGVkIHJlc3Ry
aWN0ZWQgX19sZTE2IFt1c2VydHlwZV0gYnl0ZV9jb3VudAovaG9tZS9hbWl0L2dpdC5td2lmaWV4
LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4
L3N0YV9pb2N0bC5jOjEzMzI6MzA6ICAgIGdvdCB1bnNpZ25lZCBzaG9ydCBbdW5zaWduZWRdIFt1
c2VydHlwZV0gYnl0ZXMKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVs
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfaW9jdGwuYzoxMzM5OjQ4
OiBlcnJvcjogaW5jb21wYXRpYmxlIHR5cGVzIGluIGNvbXBhcmlzb24gZXhwcmVzc2lvbiAoZGlm
ZmVyZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1k
ZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZC5jOjExMzM6
MzU6IHdhcm5pbmc6IGNhc3QgZnJvbSByZXN0cmljdGVkIF9fbGUzMgovaG9tZS9hbWl0L2dpdC5t
d2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9t
d2lmaWV4L3N0YV9jbWQuYzoxMTM0OjM0OiB3YXJuaW5nOiBjYXN0IGZyb20gcmVzdHJpY3RlZCBf
X2xlMzIKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kLmM6MTE0NDozNTogd2FybmluZzog
Y2FzdCBmcm9tIHJlc3RyaWN0ZWQgX19sZTMyCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwv
bXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2Nt
ZC5jOjExNDU6MzU6IHdhcm5pbmc6IGNhc3QgZnJvbSByZXN0cmljdGVkIF9fbGUzMgovaG9tZS9h
bWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
bWFydmVsbC9td2lmaWV4L3N0YV9jbWQuYzoxMTU1OjM0OiB3YXJuaW5nOiBjYXN0IGZyb20gcmVz
dHJpY3RlZCBfX2xlMzIKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVs
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kLmM6MTE1NjozNDog
d2FybmluZzogY2FzdCBmcm9tIHJlc3RyaWN0ZWQgX19sZTMyCi9ob21lL2FtaXQvZ2l0Lm13aWZp
ZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZp
ZXgvc3RhX2NtZC5jOjExNjY6MzY6IHdhcm5pbmc6IGNhc3QgZnJvbSByZXN0cmljdGVkIF9fbGUz
MgovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQv
d2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWQuYzoxMTY3OjM2OiB3YXJuaW5nOiBjYXN0
IGZyb20gcmVzdHJpY3RlZCBfX2xlMzIKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lm
aWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kLmM6
MTE3NzozNTogd2FybmluZzogY2FzdCBmcm9tIHJlc3RyaWN0ZWQgX19sZTMyCi9ob21lL2FtaXQv
Z2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2
ZWxsL213aWZpZXgvc3RhX2NtZC5jOjExNzg6MzU6IHdhcm5pbmc6IGNhc3QgZnJvbSByZXN0cmlj
dGVkIF9fbGUzMgovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWQuYzoxMTg5OjM4OiB3YXJu
aW5nOiBjYXN0IGZyb20gcmVzdHJpY3RlZCBfX2xlMTYKL2hvbWUvYW1pdC9naXQubXdpZmlleC1k
ZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9z
dGFfY21kLmM6MTE5MDo0Mjogd2FybmluZzogY2FzdCBmcm9tIHJlc3RyaWN0ZWQgX19sZTE2Ci9o
b21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJl
bGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo3ODQ6MzI6IHdhcm5pbmc6IGluY29y
cmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQovaG9tZS9hbWl0
L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFy
dmVsbC9td2lmaWV4L3N0YV9jbWRyZXNwLmM6Nzg0OjMyOiAgICBleHBlY3RlZCByZXN0cmljdGVk
IF9fbGUzMiBbdXNlcnR5cGVdIG9mZnNldAovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213
aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWRy
ZXNwLmM6Nzg0OjMyOiAgICBnb3QgdW5zaWduZWQgaW50IFt1bnNpZ25lZF0gW3VzZXJ0eXBlXSA8
bm9pZGVudD4KL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5jOjc4NTozMTogd2Fy
bmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVyZW50IGJhc2UgdHlwZXMp
Ci9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93
aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo3ODU6MzE6ICAgIGV4cGVjdGVk
IHJlc3RyaWN0ZWQgX19sZTMyIFt1c2VydHlwZV0gdmFsdWUKL2hvbWUvYW1pdC9naXQubXdpZmll
eC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmll
eC9zdGFfY21kcmVzcC5jOjc4NTozMTogICAgZ290IHVuc2lnbmVkIGludCBbdW5zaWduZWRdIFt1
c2VydHlwZV0gPG5vaWRlbnQ+Ci9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1k
ZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo3
ODk6MzI6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBi
YXNlIHR5cGVzKQovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWRyZXNwLmM6Nzg5OjMyOiAg
ICBleHBlY3RlZCByZXN0cmljdGVkIF9fbGUzMiBbdXNlcnR5cGVdIG9mZnNldAovaG9tZS9hbWl0
L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFy
dmVsbC9td2lmaWV4L3N0YV9jbWRyZXNwLmM6Nzg5OjMyOiAgICBnb3QgdW5zaWduZWQgaW50IFt1
bnNpZ25lZF0gW3VzZXJ0eXBlXSA8bm9pZGVudD4KL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZl
bC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFf
Y21kcmVzcC5jOjc5MDozMTogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAo
ZGlmZmVyZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmll
eC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3Au
Yzo3OTA6MzE6ICAgIGV4cGVjdGVkIHJlc3RyaWN0ZWQgX19sZTMyIFt1c2VydHlwZV0gdmFsdWUK
L2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5jOjc5MDozMTogICAgZ290IHVuc2ln
bmVkIGludCBbdW5zaWduZWRdIFt1c2VydHlwZV0gPG5vaWRlbnQ+Ci9ob21lL2FtaXQvZ2l0Lm13
aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213
aWZpZXgvc3RhX2NtZHJlc3AuYzo3OTU6MzI6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFz
c2lnbm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRl
dmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0
YV9jbWRyZXNwLmM6Nzk1OjMyOiAgICBleHBlY3RlZCByZXN0cmljdGVkIF9fbGUzMiBbdXNlcnR5
cGVdIG9mZnNldAovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJp
dmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWRyZXNwLmM6Nzk1OjMyOiAg
ICBnb3QgdW5zaWduZWQgaW50IFt1bnNpZ25lZF0gW3VzZXJ0eXBlXSA8bm9pZGVudD4KL2hvbWUv
YW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNz
L21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5jOjc5NjozMTogd2FybmluZzogaW5jb3JyZWN0
IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVyZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQvZ2l0
Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxs
L213aWZpZXgvc3RhX2NtZHJlc3AuYzo3OTY6MzE6ICAgIGV4cGVjdGVkIHJlc3RyaWN0ZWQgX19s
ZTMyIFt1c2VydHlwZV0gdmFsdWUKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4
LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5j
Ojc5NjozMTogICAgZ290IHVuc2lnbmVkIGludCBbdW5zaWduZWRdIFt1c2VydHlwZV0gPG5vaWRl
bnQ+Ci9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25l
dC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo4MDA6MzI6IHdhcm5pbmc6
IGluY29ycmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQovaG9t
ZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxl
c3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWRyZXNwLmM6ODAwOjMyOiAgICBleHBlY3RlZCByZXN0
cmljdGVkIF9fbGUzMiBbdXNlcnR5cGVdIG9mZnNldAovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRl
dmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0
YV9jbWRyZXNwLmM6ODAwOjMyOiAgICBnb3QgdW5zaWduZWQgaW50IFt1bnNpZ25lZF0gW3VzZXJ0
eXBlXSA8bm9pZGVudD4KL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVs
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5jOjgwMToz
MTogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVyZW50IGJhc2Ug
dHlwZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJz
L25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo4MDE6MzE6ICAgIGV4
cGVjdGVkIHJlc3RyaWN0ZWQgX19sZTMyIFt1c2VydHlwZV0gdmFsdWUKL2hvbWUvYW1pdC9naXQu
bXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwv
bXdpZmlleC9zdGFfY21kcmVzcC5jOjgwMTozMTogICAgZ290IHVuc2lnbmVkIGludCBbdW5zaWdu
ZWRdIFt1c2VydHlwZV0gPG5vaWRlbnQ+Ci9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdp
ZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJl
c3AuYzo4MDU6MzI6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFzc2lnbm1lbnQgKGRpZmZl
cmVudCBiYXNlIHR5cGVzKQovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2
ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWRyZXNwLmM6ODA1
OjMyOiAgICBleHBlY3RlZCByZXN0cmljdGVkIF9fbGUzMiBbdXNlcnR5cGVdIG9mZnNldAovaG9t
ZS9hbWl0L2dpdC5td2lmaWV4LWRldmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxl
c3MvbWFydmVsbC9td2lmaWV4L3N0YV9jbWRyZXNwLmM6ODA1OjMyOiAgICBnb3QgdW5zaWduZWQg
aW50IFt1bnNpZ25lZF0gW3VzZXJ0eXBlXSA8bm9pZGVudD4KL2hvbWUvYW1pdC9naXQubXdpZmll
eC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmll
eC9zdGFfY21kcmVzcC5jOjgwNjozMTogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdu
bWVudCAoZGlmZmVyZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwv
bXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2Nt
ZHJlc3AuYzo4MDY6MzE6ICAgIGV4cGVjdGVkIHJlc3RyaWN0ZWQgX19sZTMyIFt1c2VydHlwZV0g
dmFsdWUKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5jOjgwNjozMTogICAgZ290
IHVuc2lnbmVkIGludCBbdW5zaWduZWRdIFt1c2VydHlwZV0gPG5vaWRlbnQ+Ci9ob21lL2FtaXQv
Z2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2
ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo4MTI6Mjc6IHdhcm5pbmc6IHJlc3RyaWN0ZWQgX19s
ZTE2IGRlZ3JhZGVzIHRvIGludGVnZXIKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lm
aWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVz
cC5jOjgxNzozMjogd2FybmluZzogaW5jb3JyZWN0IHR5cGUgaW4gYXNzaWdubWVudCAoZGlmZmVy
ZW50IGJhc2UgdHlwZXMpCi9ob21lL2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZl
bC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo4MTc6
MzI6ICAgIGV4cGVjdGVkIHJlc3RyaWN0ZWQgX19sZTE2IFt1c2VydHlwZV0gb2Zmc2V0Ci9ob21l
L2FtaXQvZ2l0Lm13aWZpZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVz
cy9tYXJ2ZWxsL213aWZpZXgvc3RhX2NtZHJlc3AuYzo4MTc6MzI6ICAgIGdvdCB1bnNpZ25lZCBz
aG9ydCBbdW5zaWduZWRdIFt1c2VydHlwZV0gPG5vaWRlbnQ+Ci9ob21lL2FtaXQvZ2l0Lm13aWZp
ZXgtZGV2ZWwvbXdpZmlleC1kZXZlbC9kcml2ZXJzL25ldC93aXJlbGVzcy9tYXJ2ZWxsL213aWZp
ZXgvc3RhX2NtZHJlc3AuYzo4MTg6MzY6IHdhcm5pbmc6IGluY29ycmVjdCB0eXBlIGluIGFzc2ln
bm1lbnQgKGRpZmZlcmVudCBiYXNlIHR5cGVzKQovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRldmVs
L213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0YV9j
bWRyZXNwLmM6ODE4OjM2OiAgICBleHBlY3RlZCByZXN0cmljdGVkIF9fbGUxNiBbdXNlcnR5cGVd
IGJ5dGVfY291bnQKL2hvbWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2Ry
aXZlcnMvbmV0L3dpcmVsZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5jOjgxODozNjog
ICAgZ290IHVuc2lnbmVkIHNob3J0IFt1bnNpZ25lZF0gW3VzZXJ0eXBlXSA8bm9pZGVudD4KL2hv
bWUvYW1pdC9naXQubXdpZmlleC1kZXZlbC9td2lmaWV4LWRldmVsL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL21hcnZlbGwvbXdpZmlleC9zdGFfY21kcmVzcC5jOjgxOToyNzogd2FybmluZzogcmVzdHJp
Y3RlZCBfX2xlMTYgZGVncmFkZXMgdG8gaW50ZWdlcgovaG9tZS9hbWl0L2dpdC5td2lmaWV4LWRl
dmVsL213aWZpZXgtZGV2ZWwvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWFydmVsbC9td2lmaWV4L3N0
YV9jbWRyZXNwLmM6ODIxOjMyOiBlcnJvcjogaW5jb21wYXRpYmxlIHR5cGVzIGluIGNvbXBhcmlz
b24gZXhwcmVzc2lvbiAoZGlmZmVyZW50IGJhc2UgdHlwZXMpCg==

--_002_39f33dff10344e53b0fbbc9681f90b33SCEXCH04marvellcom_--
