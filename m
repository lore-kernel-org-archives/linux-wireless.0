Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37345 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907AbbKMGOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 01:14:48 -0500
Received: by wmww144 with SMTP id w144so16534014wmw.0
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 22:14:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <564535ED.6080703@candelatech.com>
References: <564535ED.6080703@candelatech.com>
Date: Fri, 13 Nov 2015 07:14:46 +0100
Message-ID: <CALhHN=qF55mHxqz6iX0PSHdBcMa_t6XYgXdkSt+Tt4W9gkFFYA@mail.gmail.com> (sfid-20151113_071522_687892_5E09E28D)
Subject: Re: Does mac80211 guarantee no data frames are sent to driver until
 encryption is setup?
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 November 2015 at 01:59, Ben Greear <greearb@candelatech.com> wrote:
> A certain firmware tries to do EAPOL inspection and only allow data pkts
> to be sent after the 4-way M4 has been sent, for instance.
>
> This was breaking .11r because in that case you don't do the 4-way after
> roaming, so the firmware was waiting forever for an M4 to be sent and
> thus all tx data was hung.
>
> I managed to get this working by just removing all of the EAPOL inspection
> from the firmware,
> but I am thinking that if the stack will send data packets to the driver
> before 4-way auth is completed and keys are set, then maybe I would
> be opening up a race where un-encrypted frames could hit the air.
>
> Any idea what protections, if any, the mac80211 stack provides
> for this case?
>
Check WLAN_STA_AUTHORIZED in mac80211.

BR
Janusz
