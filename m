Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:46551 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaH2Tu7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2014 15:50:59 -0400
Message-ID: <5400D9A2.4060001@broadcom.com> (sfid-20140829_215102_559424_C7025B37)
Date: Fri, 29 Aug 2014 12:50:58 -0700
From: Franky Lin <frankyl@broadcom.com>
MIME-Version: 1.0
To: <brcm80211-dev-list@broadcom.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: BRCMFMAC should depend on HAS_DMA
References: <1409329464-768-1-git-send-email-geert@linux-m68k.org>	<5400C3E8.9040500@broadcom.com> <CAMuHMdXahUGQ1-4SvkCnt=BrAn6_Xge7RzieR2K8gDmj_pC-kw@mail.gmail.com>
In-Reply-To: <CAMuHMdXahUGQ1-4SvkCnt=BrAn6_Xge7RzieR2K8gDmj_pC-kw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/29/2014 12:23 PM, Geert Uytterhoeven wrote:
> Besides, msgbuf.o is part of the core.
> I've just tried moving it to brcmfmac-$(CONFIG_BRCMFMAC_PCIE),
> but that doesn't help. Other parts use msgbuf, too.
>

I was about to send my ACK but had a second thought. If the dependency 
is added, SDIO driver may not work on no DMA platform. Shall we separate 
the protocol as a selectable option that selects by bus option?

Thanks,
Franky
