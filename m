Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:38265 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbbEUI2a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 04:28:30 -0400
Received: by igcau1 with SMTP id au1so3148659igc.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2015 01:28:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACna6ryt5uNkBXAk8chFyMEQVJLdHELLdA_V5TrLcaAikrTZeg@mail.gmail.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
	<1432123792-4155-7-git-send-email-arend@broadcom.com>
	<CACna6ryt5uNkBXAk8chFyMEQVJLdHELLdA_V5TrLcaAikrTZeg@mail.gmail.com>
Date: Thu, 21 May 2015 10:28:29 +0200
Message-ID: <CACna6ryCgOwkj_nt6Gd1+r826OJu-suPk50YAS1eRVW+kkR7fQ@mail.gmail.com> (sfid-20150521_102835_534320_DDD52447)
Subject: Re: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2015 at 16:33, Rafał Miłecki <zajec5@gmail.com> wrote:
> I think the best way for achieving this is to rework your patch to
> modify include/linux/bcm47xx_nvram.h. You could modify it the same way
> you did in your patch for MIPS tree, except for
> bcm47xx_nvram_get_contents. Don't implement this function for real (in
> .c file), but instead make in dummy inline in a bcm47xx_nvram.h like:
> static inline char *bcm47xx_nvram_get_contents(size_t *val_len)
> {
>         /* TODO: Implement in .c file */
>         return NULL;
> }

One more note.
This of course will lead to conflict at some point, but I believe
Linus will handle it.

-- 
Rafał
