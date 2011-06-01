Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53642 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab1FAXTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 19:19:09 -0400
Received: by iwn34 with SMTP id 34so239203iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 16:19:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306928768-7501-42-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com> <1306928768-7501-42-git-send-email-rvossen@broadcom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 2 Jun 2011 09:18:48 +1000
Message-ID: <BANLkTikwxTCiG1nChMJKgWcUouk9A5_4qg@mail.gmail.com> (sfid-20110602_011919_860886_47286779)
Subject: Re: [PATCH 42/83] staging: brcm80211: remove dependency on pci core
 difinitions from aiutils.c
To: Roland Vossen <rvossen@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 1, 2011 at 21:45, Roland Vossen <rvossen@broadcom.com> wrote:
> From: Arend van Spriel <arend@broadcom.com>
>
> The file aiutils.c included the register definition includes for the
> PCI and PCIe core. This was for two functions which have been partly
> moved to nicpci.c. This means that nicpci.h is the only include file
> to provide interface to aiutils.c for PCI core related functions.
>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Reviewed-by: Roland Vossen <rvossen@broadcom.com>
> ---
> diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
> index bae40fe..43320b4 100644
> --- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
> +++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
> @@ -1915,7 +1913,7 @@ void ai_pci_down(si_t *sih)
>  void ai_pci_setup(si_t *sih, uint coremask)
>  {
>        si_info_t *sii;
> -       struct sbpciregs *pciregs = NULL;
> +       void *regs = NULL;
>        u32 siflag = 0, w;
>        uint idx = 0;
>

Is changing this to void* necessarily a good idea? - the regs variable
appears to only be used by PCI code, so having it declared as a struct
sdpciregs* isn't going to make it any less generic - and having it
declared as a structure would help to spot bugs in the code.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
