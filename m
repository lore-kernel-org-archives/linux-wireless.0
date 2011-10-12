Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3527 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab1JLT0N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 15:26:13 -0400
Message-ID: <4E95E9C5.6060006@broadcom.com> (sfid-20111012_212616_511269_5EFC6B42)
Date: Wed, 12 Oct 2011 21:25:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the moduleh tree
References: <20111012172954.4d5a638ef2a399b72bce5bf1@canb.auug.org.au>
In-Reply-To: <20111012172954.4d5a638ef2a399b72bce5bf1@canb.auug.org.au>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2011 08:29 AM, Stephen Rothwell wrote:
> Hi Paul,
> 
> After merging the moduleh tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/wireless/brcm80211/brcmutil/utils.c:20:15: error: expected declaration specifiers or '...' before string constant
> drivers/net/wireless/brcm80211/brcmutil/utils.c:21:20: error: expected declaration specifiers or '...' before string constant
> drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:51:1: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE' [-Wimplicit-int]
> drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c:51:1: warning: parameter names (without types) in function declaration [enabled by default]
> 
> Caused by commit 5b435de0d786 ("net: wireless: add brcm80211 drivers")
> from the wireless tree interacting with the module.h split up.
> 
> These files clearly should include module.h (John, please apply this to the
> wireless tree):
> 
> From d89b14ffc84a2b8a54ffe89453b8bbf9cabf1468 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 12 Oct 2011 17:07:06 +1100
> Subject: [PATCH] net: wireless: brcm80211: include module.h
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Hi John,

Do you intend to take this patch as well. I used it to prepare the patch
series I sent earlier titled "[PATCH 00/22] brcm80211: mainline patch
related cleanup" identified by:

Message-ID: <1318445492-24207-1-git-send-email-arend@broadcom.com>

Gr. AvS

ps: If you want the bare patch file, I still have it on disk here.

