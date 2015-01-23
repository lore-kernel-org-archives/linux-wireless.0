Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51345 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbbAWTms (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:42:48 -0500
Received: by mail-wi0-f169.google.com with SMTP id bs8so5038684wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2015 11:42:47 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: p54: add handling of the signal case
Date: Fri, 23 Jan 2015 20:42:43 +0100
Message-ID: <1592976.4uoRU7ZsF9@debian64> (sfid-20150123_204251_818968_1BB98E00)
In-Reply-To: <20150123122705.GA26214@opentech.at>
References: <1421731543-13290-1-git-send-email-der.herr@hofr.at> <12702639.FEnIjGW6UW@debian64> <20150123122705.GA26214@opentech.at>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, January 23, 2015 01:27:05 PM Nicholas Mc Guire wrote:
> On Thu, 22 Jan 2015, Christian Lamparter wrote:
> > On Tuesday, January 20, 2015 06:25:43 AM Nicholas Mc Guire wrote:
> > > @@ -249,9 +250,11 @@ int p54_download_eeprom(struct p54_common *priv, void *buf,
> > > +		wiphy_err(priv->hw->wiphy,
> > > +			"device does not respond or signal received!\n");
> 
> Tried fixing this up - but simply no clue what coding style
> rule that might have violated - and my attempts to fix this
> did not succeed - allignment seems righta - the complete siequence is:
> 
>         timeout = wait_for_completion_interruptible_timeout(
>                         &priv->eeprom_comp, HZ);
>         if (timeout <= 0) {
>                 wiphy_err(priv->hw->wiphy,
>                         "device does not respond or signal received!\n");
>                 ret = -EBUSY;
>         }
> 
> what am I overlooking ?
Not much, you might be confused simply because your editor and email program
doesn't use a fixed space font (or it is not enabled (yet)).

Fixing this is just a matter of adding a few extra spaces so the text lines
up with the open parenthesis.

original:
+		wiphy_err(priv->hw->wiphy,
+			"device does not respond or signal received!\n");

aligned:
+		wiphy_err(priv->hw->wiphy,
+				 "device does not respond or signal received!\n");

Regards,
Christian
