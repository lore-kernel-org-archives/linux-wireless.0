Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:41987 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2DSLHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 07:07:38 -0400
Received: by vbbff1 with SMTP id ff1so5601405vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 04:07:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1334827233-32686-2-git-send-email-anisse@astier.eu>
References: <1334827233-32686-1-git-send-email-anisse@astier.eu>
	<1334827233-32686-2-git-send-email-anisse@astier.eu>
Date: Thu, 19 Apr 2012 13:07:36 +0200
Message-ID: <CAOZOX0UXc0OwhWOiM0PWbGfyynmrQ4kZRAVFJyxtiHe-veUg=g@mail.gmail.com> (sfid-20120419_130741_580875_2BA0429D)
Subject: Re: [PATCH RFC v2 2/2] rt2x00: Add debugfs access for rfcsr register
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Anisse Astier <anisse@astier.eu>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com, Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Apr 19, 2012 at 11:20 AM, Anisse Astier <anisse@astier.eu> wrote:
> RFCSR is only used in rt2800. For other chipsets, the debug struct
> for rfcsr should be zeroed, so it shouldn't be an issue.
>
> Signed-off-by: Anisse Astier <anisse@astier.eu>
> ---
> Changes since v1:
>  - removed initialization in chipsets other than rt2800, we now rely on
>   default initialization.

Thanks, it looks much cleaner now. :)

> diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
> index d91f4f6..9348521 100644
> --- a/drivers/net/wireless/rt2x00/rt2800.h
> +++ b/drivers/net/wireless/rt2x00/rt2800.h
> @@ -102,6 +102,8 @@
>  #define BBP_SIZE                       0x00ff
>  #define RF_BASE                                0x0004
>  #define RF_SIZE                                0x0010
> +#define RFCSR_BASE                     0x0000
> +#define RFCSR_SIZE                     0x0040
>
>  /*
>  * Number of TX queues.
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 6c95101..0cdbf2b 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -836,6 +836,13 @@ const struct rt2x00debug rt2800_rt2x00debug = {
>                .word_size      = sizeof(u32),
>                .word_count     = RF_SIZE / sizeof(u32),
>        },
> +       .rfcsr  = {
> +               .read           = rt2800_rfcsr_read,
> +               .write          = rt2800_rfcsr_write,
> +               .word_base      = RFCSR_BASE,
> +               .word_size      = sizeof(u8),
> +               .word_count     = RFCSR_SIZE / sizeof(u8),
> +       },
>  };
>  EXPORT_SYMBOL_GPL(rt2800_rt2x00debug);
>  #endif /* CONFIG_RT2X00_LIB_DEBUGFS */
> diff --git a/drivers/net/wireless/rt2x00/rt2x00debug.c b/drivers/net/wireless/rt2x00/rt2x00debug.c
> index 78787fc..128dac7 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00debug.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00debug.c
> @@ -70,6 +70,7 @@ struct rt2x00debug_intf {
>         *     - eeprom offset/value files
>         *     - bbp offset/value files
>         *     - rf offset/value files
> +        *     - rfcsr offset/value files
>         *   - queue folder
>         *     - frame dump file
>         *     - queue stats file
> @@ -89,6 +90,8 @@ struct rt2x00debug_intf {
>        struct dentry *bbp_val_entry;
>        struct dentry *rf_off_entry;
>        struct dentry *rf_val_entry;
> +       struct dentry *rfcsr_off_entry;
> +       struct dentry *rfcsr_val_entry;
>        struct dentry *queue_folder;
>        struct dentry *queue_frame_dump_entry;
>        struct dentry *queue_stats_entry;
> @@ -131,6 +134,7 @@ struct rt2x00debug_intf {
>        unsigned int offset_eeprom;
>        unsigned int offset_bbp;
>        unsigned int offset_rf;
> +       unsigned int offset_rfcsr;
>  };
>
>  void rt2x00debug_update_crypto(struct rt2x00_dev *rt2x00dev,
> @@ -448,6 +452,8 @@ static ssize_t rt2x00debug_read_##__name(struct file *file, \
>        if (*offset)                                            \
>                return 0;                                       \
>                                                                \
> +       /* This is should always be checked first because       \
> +        * debug->__name could be zeroed (when unspecified) */  \
>        if (index >= debug->__name.word_count)                  \
>                return -EINVAL;                                 \

Actually it would be nicer to not create these files at all when the
register was not provided.
This means checking during initialization if the files should be created or not.


> @@ -640,6 +649,10 @@ static struct dentry *rt2x00debug_create_file_chipset(const char *name,
>                        debug->rf.word_base,
>                        debug->rf.word_count,
>                        debug->rf.word_size);
> +       data += sprintf(data, "rfcsr\t%d\t%d\t%d\n",
> +                       debug->rfcsr.word_base,
> +                       debug->rfcsr.word_count,
> +                       debug->rfcsr.word_size);

This should only be done if the rfcsr is actually available.
So I think whole block should be changed to check the availability of
each register.
Also you are adding a line here, have you ensures that data contains
sufficient data?
I know by default we are allocating a couple of bytes extra, but we
reserve X bytes per line,
so adding a line should require some extra data to be allocated.

>        blob->size = strlen(blob->data);
>
>        return debugfs_create_blob(name, S_IRUSR, intf->driver_folder, blob);
> @@ -719,6 +732,7 @@ void rt2x00debug_register(struct rt2x00_dev *rt2x00dev)
>        RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, eeprom);
>        RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, bbp);
>        RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, rf);
> +       RT2X00DEBUGFS_CREATE_REGISTER_ENTRY(intf, rfcsr);

So if we update the RT2X00DEBUGFS_CREATE_REGISTER_ENTRY() define,
we can ensure the debugfs files are only created when the register is present
on the device.

Ivo
