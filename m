Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40584 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757771AbZLEURg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Dec 2009 15:17:36 -0500
Received: by yxe17 with SMTP id 17so2962007yxe.33
        for <linux-wireless@vger.kernel.org>; Sat, 05 Dec 2009 12:17:43 -0800 (PST)
Message-ID: <4B1ABFE3.5090804@lwfinger.net>
Date: Sat, 05 Dec 2009 14:17:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: antti@kaijanmaki.net, Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Modify rfkill for new models
References: <4b1aaf22.c1/8Zgm/N0sxiN/O%Larry.Finger@lwfinger.net> <3ace41890912051155q722901ffx340ee8613ca465f8@mail.gmail.com>
In-Reply-To: <3ace41890912051155q722901ffx340ee8613ca465f8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2009 01:55 PM, Hin-Tak Leung wrote:

> The patch looks fine - I'll have a go later. Stylistically, I don't
> think you need to copy the vendor driver though. Since you are storing
> rfkill_mask in the device structure, there is no need to have the
> variable tmp (and it is an awkful name - although, I know, it is
> temp!), because you can simply set the rfkill_mask at the beginning,
> then override it for newer models. e.g.
> I suggest you change the logic to something like this:
> 
> priv->rfkill_mask = 0x02;
> if (newer product/gpio detection code) {
>      priv->rfkill_mask = 0x04;
> }
> 
> and while you are at it, called
> 0x02 RFKILL_MASK_FOR_MODEL_8187_89_97 and 0x04
> RFKILL_MASK_FOR_MODEL_8198 for clarity. Does it sound reasonable?

I got rid of the variable tmp; however due to the way that
eeprom_93cx6() returns its value, it is not possible to get all the
logic in one if statement. That section now looks like this:

   /* Handle the differing GPIO bit in different models */
   priv->rfkill_mask = RFKILL_MASK_8187_89_97;
   if (product_id == 0x8197 || product_id == 0x8198) {
       eeprom_93cx6_read(&eeprom, RTL8187_EEPROM_SELECT_GPIO, &reg);
       if (reg & 0xFF00)
           priv->rfkill_mask = RFKILL_MASK_8198;
   }
   printk(KERN_INFO "rtl8187: rfkill mask set to %d for Product ID 0x%x",
          priv->rfkill_mask, product_id);

Thanks for the suggestions.

Larry
