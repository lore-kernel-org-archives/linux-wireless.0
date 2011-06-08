Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53553 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab1FHToc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 15:44:32 -0400
Received: by pzk9 with SMTP id 9so400397pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2011 12:44:32 -0700 (PDT)
Date: Wed, 8 Jun 2011 22:44:04 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/5] ath6kl: cache firmware
Message-ID: <20110608194031.GA4069@shale.localdomain> (sfid-20110608_214436_876468_D25823BA)
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
 <20110608115440.32208.75072.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110608115440.32208.75072.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 08, 2011 at 02:54:40PM +0300, Kalle Valo wrote:
> From: Kalle Valo <kalle.valo@atheros.com>
> 
> Drivers should not request firmware during resume. Fix ath6kl to
> cache the firmware instead.
> 
> Signed-off-by: Kalle Valo <kalle.valo@atheros.com>
> ---
>  drivers/staging/ath6kl/os/linux/ar6000_drv.c       |   53 ++++++++++++++------
>  .../staging/ath6kl/os/linux/include/ar6000_drv.h   |    9 +++
>  2 files changed, 47 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/ath6kl/os/linux/ar6000_drv.c b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> index 30ae63b..74aa343 100644
> --- a/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> +++ b/drivers/staging/ath6kl/os/linux/ar6000_drv.c
> @@ -954,9 +954,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
>      const char *filename;
>      const struct firmware *fw_entry;
>      u32 fw_entry_size;
> +    u8 **buf;
> +    size_t *buf_len;

Don't make buf_len a pointer that just makes the code messier.

[snip]

> +
> +    if (WARN_ON((buf == NULL) || (buf_len == NULL)))
> +	    return A_ERROR;

This test is a nonsense.  "buf" and buf_len are always valid
pointers here.  Generally, I'd almost prefer a oops with a stack
trace instead of adding in bogus error handling code for stuff that
can't happen.

Also "buf" is never initialized to NULL, so if there were a
programming bug introduced, it would generate an uninitialized
variable warning even without the superflous test.  So lets remove
it.

> +
> +    if (*buf == NULL) {
> +	    if ((A_REQUEST_FIRMWARE(&fw_entry, filename, ((struct device *)ar->osDevInfo.pOSDevice))) != 0)
> +	    {
            ^

This is on the wrong line.

> +		    AR_DEBUG_PRINTF(ATH_DEBUG_ERR, ("Failed to get %s\n", filename));
> +		    return A_ENOENT;
> +	    }
> +
> +	    *buf = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
> +	    *buf_len = fw_entry->size;
> +	    A_RELEASE_FIRMWARE(fw_entry);
>      }
>  
>  #ifdef SOFTMAC_FILE_USED
> -    if (file==AR6K_BOARD_DATA_FILE && fw_entry->data) {
> -        ar6000_softmac_update(ar, (u8 *)fw_entry->data, fw_entry->size);
> +    if (file==AR6K_BOARD_DATA_FILE && *buf_len) {
              ^^^^
White space.

> +        ar6000_softmac_update(ar, *buf, *buf_len);
>      }
>  #endif 
>  
>  
> -    fw_entry_size = fw_entry->size;
> +    fw_entry_size = *buf_len;
>  
>      /* Load extended board data for AR6003 */
> -    if ((file==AR6K_BOARD_DATA_FILE) && (fw_entry->data)) {
> +    if ((file==AR6K_BOARD_DATA_FILE) && *buf) {
               ^^^^
White space is wrong here.

>          u32 board_ext_address;
>          u32 board_ext_data_size;
>          u32 board_data_size;
> @@ -1089,14 +1109,13 @@ ar6000_transfer_bin_file(struct ar6_softc *ar, AR6K_BIN_FILE file, u32 address,
>          AR_DEBUG_PRINTF(ATH_DEBUG_INFO, ("Board extended Data download address: 0x%x\n", board_ext_address));
>  
>          /* check whether the target has allocated memory for extended board data and file contains extended board data */
> -        if ((board_ext_address) && (fw_entry->size == (board_data_size + board_ext_data_size))) {
> +        if ((board_ext_address) && (*buf_len == (board_data_size + board_ext_data_size))) {
               ^                 ^

Those parenthesis are not needed.

>              u32 param;
>  
> -            status = BMIWriteMemory(ar->arHifDevice, board_ext_address, (u8 *)(fw_entry->data + board_data_size), board_ext_data_size);
> +            status = BMIWriteMemory(ar->arHifDevice, board_ext_address, (u8 *)(*buf + board_data_size), board_ext_data_size);
                                                                           ^^^^^^
This cast isn't needed by the way.

regards,
dan carpenter
