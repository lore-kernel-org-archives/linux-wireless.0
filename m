Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42629 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab0GLSyK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jul 2010 14:54:10 -0400
Received: by bwz1 with SMTP id 1so2541664bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jul 2010 11:54:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilFB6o-Qq0VTVNhd01TpdLX4JUYCAlZu-RgKH1I@mail.gmail.com>
References: <AANLkTinubmjYu9FyDU0B81F0gHmFPLnDUWYGmZ9Rodss@mail.gmail.com>
	<AANLkTilFB6o-Qq0VTVNhd01TpdLX4JUYCAlZu-RgKH1I@mail.gmail.com>
Date: Mon, 12 Jul 2010 20:54:09 +0200
Message-ID: <AANLkTilTr6OkquGQJtMCu4_yur3NLu8JFThLVpLrWaMU@mail.gmail.com>
Subject: Re: Rate control & USB
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I don't know much about the details of either the rate control
> algorithms, or other USB devices, but the usb8388 with the libertas_tf
> driver _does_ report per skb tx feedback, not just that the frame has
> been sent to the hardware.  Perhaps there's other USB devices that
> also have good feedback?

Ah ok, I wasn't aware that libertas had a working TX status reporting. :)

> In any case, I'm just asking that nothing gets broken in the case
> where the USB devices _do_ provide the tx feedback information.  I
> assume you weren't going to break anything, but I just wanted to make
> sure you knew that some USB devices did have this feature.

Well my plans were to enable the batch TX updating through a mac80211 flag,
or some other methoed where it is up to the driver to enable the batch TX
status updating. So nothing should change for the other drivers which do not
need this feature. :)

But it is good to know that at least some USB hardware do not have the
TX status problem. :)

Ivo
