Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:42648 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHXVpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Aug 2014 17:45:39 -0400
MIME-Version: 1.0
In-Reply-To: <1408915485-8078-4-git-send-email-hauke@hauke-m.de>
References: <1408915485-8078-1-git-send-email-hauke@hauke-m.de>
	<1408915485-8078-4-git-send-email-hauke@hauke-m.de>
Date: Sun, 24 Aug 2014 21:45:38 +0000
Message-ID: <CACna6rx_V46wAAkRFA+XnZNX80tAdWkaYrTUV5VHxLwbC6GvfQ@mail.gmail.com> (sfid-20140824_234552_122558_8277092E)
Subject: Re: [RFC 2/7] bcm47xx-nvram: add new broadcom nvram driver with dt support
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 August 2014 21:24, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This was copied from arch/mips/bcm47xx/nvram.c and modified to interact
> with device tree. My plan is to make the MIPS bcm47xx also use this new
> driver some time later.

I don't like this.

First, you change API (_getenv call), without explanation why/if we
really need this. We decided we're very unlikely to ever find devices
with multiple (separated) NVRAMs. So what's the point of having nvram
per device?

Secondly, don't duplicate the code. If you're going to switch bcm47xx
to this new code, handle it smarter. Modify bcm47xx mode, move it to
the "misc" and re-use in bcm53xx.
