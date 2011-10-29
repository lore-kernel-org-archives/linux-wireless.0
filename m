Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:50990 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472Ab1J2Kby (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 06:31:54 -0400
Date: Sat, 29 Oct 2011 12:25:02 +0200
From: Dominique Martinet <asmadeus@codewreck.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Julia Lawall <julia@diku.dk>,
	Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] brcm80211: smac: eliminate a null pointer dereference
 in dma.c
Message-ID: <20111029102502.GA10582@nautica> (sfid-20111029_123158_323929_C4A303AE)
References: <1319880615-3000-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1319880615-3000-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


Arend van Spriel wrote on Sat, Oct 29, 2011:
> Though it's unlikely, di may be null, so we can't dereference
> di->dma.dmactrlflags until we've checked it.

I've got no experience whatsoever in kernel coding so feel free to tell
me that's stupid, but if you say it's unlikely why not use the
unlikely() macro as well for the check?
(also, that's not the point of this patch, but can't hurt to point that
out)


>  	if (di == NULL) {
would change to
if (unlikely(di == NULL)) {


Regards,
-- 
Asmadeus | Dominique Martinet
