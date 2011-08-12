Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33689 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591Ab1HLOMR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 10:12:17 -0400
Received: by yxj19 with SMTP id 19so1950452yxj.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 07:12:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1313156101-16817-3-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
	<1313156101-16817-3-git-send-email-arend@broadcom.com>
Date: Fri, 12 Aug 2011 16:12:16 +0200
Message-ID: <CACna6rwTHx7Fb5Gj4b3XOAzmz3_pqYf4u25naj33qD8FEG8tjQ@mail.gmail.com> (sfid-20110812_161220_630756_65C03814)
Subject: Re: [PATCH 02/14] staging: brcm80211: remove iovar IOV_BLOCKSIZE in brcmfmac
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/12 Arend van Spriel <arend@broadcom.com>:
> @@ -273,7 +270,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
>  /* IOVar table */
>  enum {
>        IOV_MSGLEVEL = 1,
> -       IOV_BLOCKSIZE,
>        IOV_NUMINTS,
>        IOV_DEVREG,
>        IOV_HCIREGS,

You are forcing IOV_MSGLEVEL to 1, so I expected values of IOV_* are
really important in some piece of code. Now you change them. AFAIU it
means you break something, or you can drop " = 1".

-- 
Rafał
