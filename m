Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:33885 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbbGIOJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 10:09:42 -0400
Received: by igoe12 with SMTP id e12so14657916igo.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 07:09:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436445980-22196-1-git-send-email-zajec5@gmail.com>
References: <1436445980-22196-1-git-send-email-zajec5@gmail.com>
Date: Thu, 9 Jul 2015 16:09:41 +0200
Message-ID: <CACna6ryy9-W4gTd65JS0BVPX_ewoG95uQXv8LCjMurWydLdxiA@mail.gmail.com> (sfid-20150709_160945_693471_00556F8B)
Subject: Re: [PATCH] brcmfmac: set wiphy's addr_mask to force using valid MACs
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2015 at 14:46, Rafał Miłecki <zajec5@gmail.com> wrote:
> Broadcom's firmware requires every BSS to use MAC address with unique
> last 2 bits. Otherwise it rejects submitted MAC which results in:
> brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52
>
> Set addr_mask properly to hint only last 2 bits can be modified. This
> isn't exactly true as all bits can be changed but that's the only way
> to force unique values in the last 2 bits.

I asked Felix about this and he pointed it may be not a good idea to
disallow using locally administrated bit.

I'll rework my fix to provide a full list of addresses that shall be
used. Please drop this one.
