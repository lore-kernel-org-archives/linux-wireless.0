Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:38084 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791AbaJIJCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:02:41 -0400
Received: by mail-ig0-f180.google.com with SMTP id uq10so2967684igb.7
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2014 02:02:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1412843867-26563-1-git-send-email-zajec5@gmail.com>
References: <1412843867-26563-1-git-send-email-zajec5@gmail.com>
Date: Thu, 9 Oct 2014 11:02:41 +0200
Message-ID: <CACna6ry-+hzMJ4n5PG7GJq9fZ+zwU38HGt-xZkUqKEP8yX6avA@mail.gmail.com> (sfid-20141009_110250_016878_5326B6D5)
Subject: Re: [PATCH][RTF][RFC] brcmsmac: add workaround for old BCM4313
 devices with Bluetooth
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Seth Forshee <seth.forshee@canonical.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 October 2014 10:37, Rafał Miłecki <zajec5@gmail.com> wrote:
> +       /* TODO: Fix the condition. Only for boards >= P250 */
> +       if (ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM4313 && (wlc_hw->boardflags & BFL_FEM_BT)) {
> +               pr_info("Applying BCM4313 WL/BT workaround\n");
> +               ai_btcombo_p250_4313_war(wlc_hw->sih);
> +       }

This of course have to be checked in some hardware documentation for
the correct condition. We already have some workaround (right above
the newly added code) for boards with boardrev >= 0x1250. So my guess
is the code I added applies to some other cards. The board this patch
is supposed to fix is:
board vendor: 14e4
board type: 608
board revision: 1109
board flags: 402201
board flags2: 884
firmware revision: 262032c

So whatever condition we will need it'll likely need to cover above
case (maybe boardrev == 0x1109?).

-- 
Rafał
