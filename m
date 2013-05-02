Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:45478 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760850Ab3EBQ4B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 12:56:01 -0400
Received: by mail-wg0-f41.google.com with SMTP id y10so808999wgg.4
        for <linux-wireless@vger.kernel.org>; Thu, 02 May 2013 09:55:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1367482308-9882-2-git-send-email-linux@rempel-privat.de>
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de>
	<1367482308-9882-2-git-send-email-linux@rempel-privat.de>
Date: Thu, 2 May 2013 09:55:59 -0700
Message-ID: <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> (sfid-20130502_185618_143572_2EA902F7)
Subject: Re: [PATCH 1/2] ath9k_htc: add STBC TX support
From: Adrian Chadd <adrian@freebsd.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 May 2013 01:11, Oleksij Rempel <linux@rempel-privat.de> wrote:

> +#define WLAN_RC_TX_STBC_FLAG 0x20 /* TX STBC */
> +#define WLAN_RC_RX_STBC_FLAG 0xC0 /* RX STBC ,2 bits */

I thought we covered this; why are you marking two bits here?

Atheros 11n hardware only supports 1-stream STBC RX.

Have you verified that we're actually negotiating 1-stream STBC RX
with a peer? (Ie, by looking at packet captures?)



Adrian
