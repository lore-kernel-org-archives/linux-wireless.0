Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:5535 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901AbZADTbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 14:31:34 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1483796ika.5
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 11:31:31 -0800 (PST)
Message-ID: <49610E8D.9080807@gmail.com> (sfid-20090104_203138_906993_09DEB2FE)
Date: Sun, 04 Jan 2009 20:31:25 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: Re: [PATCH] ath5k: Add debug code for EEPROM
References: <20090104173252.GA5944@makis>
In-Reply-To: <20090104173252.GA5944@makis>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nick Kossifidis wrote:
>  * Add debug code for displaying EEPROM data. Tested on various chip combinations, on x86 and IXP43x (armv5te). It has many > 80cols warnings but i 
> don't think it'll be more readable if i start breaking lines, it's already messy, after all it's debug code. This code also replaces ath_info tool.

I think breaking lines in this case would be rather contraproductive.

> Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> ---
> diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
> index ccaeb5c..f0ef5b3 100644
> --- a/drivers/net/wireless/ath5k/debug.c
> +++ b/drivers/net/wireless/ath5k/debug.c
> @@ -324,6 +324,858 @@ static const struct file_operations fops_reset = {
>  	.owner = THIS_MODULE,
>  };
>  
> +/* debugfs: EEPROM stuff */
> +
> +/* EEPROM Header (common) */
> +static ssize_t read_file_eeprom_header(struct file *file, char __user *user_buf,
> +				   size_t count, loff_t *ppos)
> +{
> +
> +	struct ath5k_softc *sc = file->private_data;
> +	struct ath5k_hw *ah = sc->ah;
> +	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
> +	char buf[2000];

Please don't use that much memory from stack. 2k is way too much. Note that
you use yet another bunch of stack (next 3k here on 64-bit) by
ath5k_eeprom_info and 32-bit x86 can still be configured with 4k stacks.

Convert both of them to dynamically allocated buffers.

> +/* EEPROM Header (per mode) */
> +static unsigned int dump_calinfo_for_mode(struct ath5k_hw *ah, int mode,
> +				char __user *user_buf, size_t count, loff_t *ppos)
> +{
> +	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
> +	unsigned int len = 0;
> +	char buf[2000];

dtto

> +	int i;
...
> +	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);

simple_read_from_buffer can fail and returns negative errno in that case,
change dump_calinfo_for_mode return type appropriately.

> +	return len;
> +}
...
> +/* EEPROM channel power calibration info (per mode) */
> +static unsigned int dump_pcalinfo_for_mode_rf5111(struct ath5k_hw *ah, int mode,
> +				char __user *user_buf, size_t count, loff_t *ppos)

return ssize_t for the same reason

> +{
> +	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
> +	struct ath5k_chan_pcal_info *gen_chan_info;
> +	struct ath5k_chan_pcal_info_rf5111 *chan_pcal_info;
> +	unsigned int len = 0;
> +	char buf[4000];

Here you are almost out of stack even on 8k stacks ;).

> +static unsigned int dump_pcalinfo_for_mode_rf5112(struct ath5k_hw *ah, int mode,
> +				char __user *user_buf, size_t count, loff_t *ppos)

dtto and further too

> +{
> +	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
> +	struct ath5k_chan_pcal_info *gen_chan_info;
> +	struct ath5k_chan_pcal_info_rf5112 *chan_pcal_info;
> +	unsigned int len = 0;
> +	char buf[4000];

dtto and further too

Happy new year!
