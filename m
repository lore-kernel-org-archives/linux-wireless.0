Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:33404 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751808AbdDMSqd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 14:46:33 -0400
Received: by mail-pf0-f181.google.com with SMTP id s16so32231956pfs.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Apr 2017 11:46:33 -0700 (PDT)
Date: Thu, 13 Apr 2017 11:46:30 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v4 4/4] mwifiex: pcie: extract wifi part from combo
 firmware during function level reset
Message-ID: <20170413184629.GB66124@google.com> (sfid-20170413_204638_936553_5F560AC6)
References: <1492066102-31251-1-git-send-email-huxinming820@gmail.com>
 <1492066102-31251-4-git-send-email-huxinming820@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492066102-31251-4-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Xinming,

On Thu, Apr 13, 2017 at 06:48:22AM +0000, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> A seprate wifi-only firmware was download during pcie function level reset.
> It is in fact the tail part of wifi/bt combo firmware. Per Brian's and
> Dmitry's suggestion, this patch extract the wifi part from combo firmware.
> 
> After that, we can discard the redudant image in linux-firmware repo.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Please don't add my Reviewed-by tag unless I've provided it explicitly.
And especially not if you have to change the patch significantly. (It's
fair to carry an old tag I've provided, if you only have to make minor
changes, or if I suggest *exactly* what needs changed, along with a
conditional 'Reviewed-by'.)

As it stands, this patch is worse than the previous one. I replied to
some of your commnets on v3, but I'll carry some here.

> ---
> v2: extract wifi part from combo firmware(Dimtry and Brain)
>     add more description(Kalle)
> v3: same as v2
> v4: add sequence comments, code enhance(Brain)
> ---
>  drivers/net/wireless/marvell/mwifiex/fw.h   | 18 ++++++
>  drivers/net/wireless/marvell/mwifiex/pcie.c | 93 ++++++++++++++++++++++++++---
>  drivers/net/wireless/marvell/mwifiex/pcie.h |  3 +-
>  3 files changed, 106 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
> index 0b68374..6cf9ab9 100644
> --- a/drivers/net/wireless/marvell/mwifiex/fw.h
> +++ b/drivers/net/wireless/marvell/mwifiex/fw.h
> @@ -43,6 +43,24 @@ struct tx_packet_hdr {
>  	struct rfc_1042_hdr rfc1042_hdr;
>  } __packed;
>  
> +struct mwifiex_fw_header {
> +	__le32 dnld_cmd;
> +	__le32 base_addr;
> +	__le32 data_length;
> +	__le32 crc;
> +} __packed;
> +
> +struct mwifiex_fw_data {
> +	struct mwifiex_fw_header header;
> +	__le32 seq_num;
> +	u8 data[1];
> +} __packed;
> +
> +#define MWIFIEX_FW_DNLD_CMD_1 0x1
> +#define MWIFIEX_FW_DNLD_CMD_5 0x5
> +#define MWIFIEX_FW_DNLD_CMD_6 0x6
> +#define MWIFIEX_FW_DNLD_CMD_7 0x7
> +
>  #define B_SUPPORTED_RATES               5
>  #define G_SUPPORTED_RATES               9
>  #define BG_SUPPORTED_RATES              13
> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
> index a07cb0a..7b24bb4 100644
> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> @@ -1956,6 +1956,73 @@ static int mwifiex_pcie_event_complete(struct mwifiex_adapter *adapter,
>  	return ret;
>  }
>  
> +/* Combo firmware image is a combination of
> + * (1) combo crc heaer, start with CMD5
> + * (2) bluetooth image, start with CMD7, end with CMD6, data wrapped in CMD1.
> + * (3) wifi image.
> + *
> + * This function bypass the header and bluetooth part, return
> + * the offset of tail wifi-only part.
> + */
> +
> +static int mwifiex_extract_wifi_fw(struct mwifiex_adapter *adapter,
> +				   const void *firmware, u32 firmware_len) {
> +	const struct mwifiex_fw_data *fwdata;
> +	u32 offset = 0, data_len, dnld_cmd;
> +	int ret = 0;
> +	bool cmd7_before = false;
> +
> +	while (1) {
> +		if (offset >= firmware_len) {

This is worse than what you used to have. This should still be:

		if (offset + sizeof(fwdata->header) >= firmware_len) {

And you might add an overflow check here too, so:

		/* Check for integer and buffer overflow */
		if (offset + sizeof(fwdata->header) < sizeof(fwdata->header) ||
		    offset + sizeof(fwdata->header) >= firmware_len) {

> +			mwifiex_dbg(adapter, ERROR,
> +				    "extract wifi-only fw failure!");

Needs a '\n'.

> +			ret = -1;
> +			goto done;
> +		}
> +
> +		fwdata = firmware + offset;
> +		dnld_cmd = le32_to_cpu(fwdata->header.dnld_cmd);
> +		data_len = le32_to_cpu(fwdata->header.data_length);
> +

Then:

		offset += sizeof(fwdata->header);

> +		switch (dnld_cmd) {
> +		case MWIFIEX_FW_DNLD_CMD_1:
> +			if (!cmd7_before) {
> +				mwifiex_dbg(adapter, ERROR,
> +					    "no cmd7 before cmd1!");

Needs a '\n'.

> +				ret = -1;
> +				goto done;
> +			}
> +			offset += data_len + sizeof(fwdata->header);

Replace with:

			if (offset + data_len < data_len) {
				mwifiex_dbg(adapter, ERROR, "bad firmware\n");
				ret = -1;
				goto done;
			}
			offset += data_len;

> +			break;
> +		case MWIFIEX_FW_DNLD_CMD_5:
> +			offset += data_len + sizeof(fwdata->header);

Replace with:

			if (offset + data_len < data_len) {
				mwifiex_dbg(adapter, ERROR, "bad firmware\n");
				ret = -1;
				goto done;
			}
			offset += data_len;

> +			break;
> +		case MWIFIEX_FW_DNLD_CMD_6:
> +			offset += data_len + sizeof(fwdata->header);

Replace with:

			if (offset + data_len < data_len) {
				mwifiex_dbg(adapter, ERROR, "bad firmware\n");
				ret = -1;
				goto done;
			}
			offset += data_len;

> +			if (offset >= firmware_len) {
> +				mwifiex_dbg(adapter, ERROR,
> +					    "extract wifi-only fw failure!");

Needs a '\n'.

> +				ret = -1;
> +			} else {
> +				ret = offset;
> +			}
> +			goto done;
> +		case MWIFIEX_FW_DNLD_CMD_7:
> +			cmd7_before = true;
> +			offset += sizeof(fwdata->header);

Now you can delete this line.

> +			break;
> +		default:
> +			mwifiex_dbg(adapter, ERROR, "unknown dnld_cmd %d\n",
> +				    dnld_cmd);
> +			ret = -1;
> +			goto done;
> +		}
> +	}
> +
> +done:
> +	return ret;
> +}
> +
>  /*
>   * This function downloads the firmware to the card.
>   *

[...]

I might just rewrite this and send it myself, if I get the time.

Brian
