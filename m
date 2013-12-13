Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:59861 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339Ab3LMKxR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 05:53:17 -0500
Received: by mail-bk0-f48.google.com with SMTP id r7so1314081bkg.21
        for <linux-wireless@vger.kernel.org>; Fri, 13 Dec 2013 02:53:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52A87FBD.4000901@candelatech.com>
References: <52A87FBD.4000901@candelatech.com>
Date: Fri, 13 Dec 2013 11:53:16 +0100
Message-ID: <CA+BoTQkO+FyuAnLfo473QH=QK1FKtS7bQ8ZTXdOj67xSqUxWOw@mail.gmail.com> (sfid-20131213_115320_915074_9F6C04B7)
Subject: Re: Question on software-crypt mode.
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 December 2013 16:07, Ben Greear <greearb@candelatech.com> wrote:
> Hello!
>
> I am trying to implement software-crypt for ath10k so that it can do crypt
> with multiple stations connected to same AP.
>
> I tried using ath9k's approach and just not setting keys, but that does not
> work at all
> (no stations can communicate).
>
> If I basically leave code as is, then secondary stations can associate but
> never
> get DHCP.  I see FCS and hw-crypt errored packets being received from the
> ath10k firmware/chip.  This is probably because the chip/firmware decodes
> the
> secondary station's packets with the first station's keys.
> Transmitted packets (as sniffed from the AP) do appear fine.

This sounds a lot like a multi-BSS issues that were discovered
recently on AP branch firmware.

See commit:

  ath10k: fix multi BSSID with WPA on FW 10.1

You could try applying the commit and remove the following code from it:

  if (arvif->vdev_type != WMI_VDEV_TYPE_AP)
    return;

The commit was originally only tested against AP interfaces but I was
suspecting the same thing (i.e. corrupted Tx) could be happening on
multi-STA.


Michał
