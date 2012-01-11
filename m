Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59696 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757217Ab2AKN5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 08:57:21 -0500
Received: by pbdu13 with SMTP id u13so490450pbd.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 05:57:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1326285768-3073-1-git-send-email-ilane@ti.com>
References: <1326285768-3073-1-git-send-email-ilane@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 11 Jan 2012 15:57:00 +0200
Message-ID: <CAK=WgbanHKn3r9VYocmFpoCu9YKOf-hL20GKOgm=qmU1S6A_-A@mail.gmail.com> (sfid-20120111_145730_029298_463B0067)
Subject: Re: [PATCH] NFC: Download TI NFC init script
To: ilanelias78@gmail.com
Cc: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Wed, Jan 11, 2012 at 2:42 PM,  <ilanelias78@gmail.com> wrote:
> From: Ilan Elias <ilane@ti.com>
>
> Download TI NFC init script during nfcwilink open operation,
> after the NFC channel is registered with TI shared transport.
> TI NFC init script is written in BTS format.
> First, read the chip version via a special vendor specific command.
> Second, we request the relevant BTS file from the user space, and
> then send the BTS commands to the chip.

nfcwilink_open() begins by calling the shared transport's
st_register() function, which also seem to be loading, parsing and
sending a BTS firmware to the device.

Does it mean that two firmwares are needed for these NFC devices ?

>From a quick look it seems that much of the boilerplate code for the
BTS handling is quite similar; any way to avoid some of the code
duplication (something the shared transport code doesn't try very hard
to do ;) ?

Thanks,
Ohad.
