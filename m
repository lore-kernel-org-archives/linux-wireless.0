Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33799 "EHLO
	mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbcFBEzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2016 00:55:04 -0400
Received: by mail-oi0-f67.google.com with SMTP id e80so924795oig.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2016 21:55:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464815616-21551-1-git-send-email-arend@broadcom.com>
References: <1464815616-21551-1-git-send-email-arend@broadcom.com>
Date: Thu, 2 Jun 2016 06:55:03 +0200
Message-ID: <CACna6ryjUjwBerzq3L8Fd2HHw-GAkLsnuh=POOW9EDxCymtYyg@mail.gmail.com> (sfid-20160602_065509_895228_0DB912B9)
Subject: Re: [PATCH for-4.7] brcmfmac: add eth_type_trans back for PCIe full dongle
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Franky Lin <franky.lin@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 June 2016 at 23:13, Arend van Spriel <arend@broadcom.com> wrote:
> From: Franky Lin <franky.lin@broadcom.com>
>
> A regression was introduced in commit 9c349892ccc9 ("brcmfmac: revise
> handling events in receive path") which moves eth_type_trans() call
> to brcmf_rx_frame(). Msgbuf layer doesn't use brcmf_rx_frame() but invokes
> brcmf_netif_rx() directly. In such case the Ethernet header was not
> stripped out resulting in null pointer dereference in the networking
> stack.
>
> (...)
>
> Reported-by: Grey Christoforo <grey@christoforo.net>

Well, I reported this as well, over a month ago :(

https://patchwork.kernel.org/patch/8799231/
http://www.spinics.net/lists/linux-wireless/msg150110.html

Tested-by: Rafał Miłecki <zajec5@gmail.com>
