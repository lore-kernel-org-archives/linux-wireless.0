Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49995 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab2CDWte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 17:49:34 -0500
Received: by iagz16 with SMTP id z16so4782680iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2012 14:49:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330725351-3803-5-git-send-email-arend@broadcom.com>
References: <1330725351-3803-1-git-send-email-arend@broadcom.com> <1330725351-3803-5-git-send-email-arend@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 5 Mar 2012 09:49:12 +1100
Message-ID: <CAGRGNgXbkV-OkB5XG8+HqmmxG6f3RfgAkfnb_XxhXYU5+yN6Ug@mail.gmail.com> (sfid-20120304_234937_806805_8506333D)
Subject: Re: [PATCH 4/7] brcm80211: fmac: initialize host interface drivers
 regardless result
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On Sat, Mar 3, 2012 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
> The module init function of brcmfmac calls init functions for SDIO and
> USB doing driver registration. This patch removes terminating the module
> init when a driver registration for one host interface fails.

Would it be better to fail the module load if *none* of them succeed -
there's probably no point in having the module loaded if it's not
actually hooked up to anything.

You could write the init code like this:

static int __init brcmfmac_init(void)
{
       int ret = 0;
       bool loaded = false;

#ifdef CONFIG_BRCMFMAC_SDIO
       ret = brcmf_sdio_init();
       if (!ret)
               loaded = true;

       // An informative message could go here if it fails
#endif
#ifdef CONFIG_BRCMFMAC_USB
       ret = brcmf_usb_init();
       if (!ret)
               loaded = true;

       // An informative message could go here if it fails
#endif

       if (!loaded)
               return ret; // or -ENODEV

       return 0;
}

And you then wouldn't have to change any of the other code.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
