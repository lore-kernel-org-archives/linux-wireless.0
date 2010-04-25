Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:34903 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab0DYVaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Apr 2010 17:30:06 -0400
Received: by qyk9 with SMTP id 9so16202749qyk.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Apr 2010 14:30:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271890205.1730.588.camel@Joe-Laptop.home>
References: <1271889581-21352-1-git-send-email-steve@cozybit.com>
	 <1271890205.1730.588.camel@Joe-Laptop.home>
Date: Sun, 25 Apr 2010 14:30:05 -0700
Message-ID: <g2t446ae9281004251430t89236181p8f3d056181fb8b49@mail.gmail.com>
Subject: Re: [PATCH] Added configurable debug messages to libertastf
From: Steve deRosier <steve@cozybit.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe,

Thanks for the pointers.  Sorry it took so long to correct the patch,
but I'll post it asap.

Thanks,
- Steve

On Wed, Apr 21, 2010 at 3:50 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2010-04-21 at 15:39 -0700, Steve deRosier wrote:
>> Add the same type of configurable debug messages to libertas_tf as
>> already exist in the libertas driver.  This has facilitated creation of a interface
>> specification and will facilitate future development of this driver.
>>
>> Signed-off-by: Steve deRosier <steve@cozybit.com>
> []
>> +#define lbtf_pr_info(format, args...) \
>> +     printk(KERN_INFO DRV_NAME": " format, ## args)
>> +#define lbtf_pr_err(format, args...) \
>> +     printk(KERN_ERR DRV_NAME": " format, ## args)
>> +#define lbtf_pr_alert(format, args...) \
>> +     printk(KERN_ALERT DRV_NAME": " format, ## args)
>
> I think it'd be better to add
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
> and use the more standard pr_<level>s.
>
>> +#ifdef DEBUG
>> +static inline void lbtf_deb_hex(unsigned int grp, const char *prompt, u8 *buf, int len)
>> +{
>> +     int i = 0;
>> +
>> +     if (len &&
>> +         (lbtf_debug & LBTF_DEB_HEX) &&
>> +         (lbtf_debug & grp)) {
>> +             for (i = 1; i <= len; i++) {
>> +                     if ((i & 0xf) == 1) {
>> +                             if (i != 1)
>> +                                     printk("\n");
>> +                             printk(DRV_NAME " %s: ", prompt);
>> +                     }
>> +                     printk("%02x ", (u8) *buf);
>> +                     buf++;
>> +             }
>> +             printk("\n");
>> +     }
>> +}
>
> print_hex_dump_bytes
>
>
>
