Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56804.mail.re3.yahoo.com ([66.196.97.78]:28142 "HELO
	web56804.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751435Ab0CaV4I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Mar 2010 17:56:08 -0400
Message-ID: <365137.1684.qm@web56804.mail.re3.yahoo.com>
Date: Wed, 31 Mar 2010 14:56:06 -0700 (PDT)
From: Golden <goldenstranger@yahoo.com>
Subject: Re: firmware_loading_store: vmap() failed, broken firmware with kernles .27 - .30
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1270005352.27938.14.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I was able to reproduce "unexpected value" with Linux
> 2.6.28.10 and
> ar9170usb.
> 
> After adding some debug printk's, I get this:
> 
> firmware_loading_store: loading = 1
> firmware_loading_store: loading = 1
> firmware_loading_store: loading = 0
> fw_priv->fw->data = ffffc2001027a000
> firmware_loading_store: loading = 0
> compat_firmware 1-7: firmware_loading_store: unexpected
> value (0)
> firmware_loading_store: abort
> usb 1-7: ar9170.fw firmware file not found, trying old
> firmware...
> 
> It looks like we have a race condition here.  Two
> processes try to load
> the firmware.
> 
> I remember vaguely that it was discussed before. 
> Google search for
> "firmware_loading_store race" finds some interesting links,
> but I cannot
> find a fix.  Likewise, search for
> "firmware_loading_store: unexpected
> value" finds a lot of stuff in the Linux 2.6.13 timeframe.
> 
> It looks like a race condition.  Adding dump_stack()
> to the beginning of
> firmware_loading_store() makes the problem disappear.
> 
> -- 
> Regards,
> Pavel Roskin



Hi, Pavel,

This appears to be an important bug fix for a variety of users with older kernels. Can you prepare proper patch for this and did you have a chance to test if these amendments cause trouble with newer kernels? 

Regards.


      
