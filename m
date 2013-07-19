Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:35602 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3GSBiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 21:38:24 -0400
Received: by mail-wi0-f176.google.com with SMTP id ey16so7300892wid.15
        for <linux-wireless@vger.kernel.org>; Thu, 18 Jul 2013 18:38:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51E6DE4D.50902@carestream.com>
References: <51E6DE4D.50902@carestream.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 18 Jul 2013 18:38:03 -0700
Message-ID: <CAB=NE6UPz=6NuCMvy5FEM9QBg9rhwFTw0mG2YVTX3r3dLG=1cQ@mail.gmail.com> (sfid-20130719_033827_844719_B0B31D4A)
Subject: Re: Wake-On-Wireless and Deauthentication
To: "greg.huber" <greg.huber@carestream.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	daniel.wagner@oss.bmw-carit.de, Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 17, 2013 at 11:11 AM, greg.huber <greg.huber@carestream.com> wrote:
> I'm trying to get Wake-on-wireless working with an Atheros AR9462.
> The problem I seem to be having is that there is a Deauth requested
> when the system is suspended. Does anyone know how to keep the
> association while suspended?? I'm using kernel 3.9.9.
>
> The log after waking (from keyboard)
>
> [  320.117062] wlp3s0: deauthenticating from 00:24:01:12:de:7a by local choice
> (reason=3)

Typical managers for networking will disassociate you (and therefore
deauth first) prior to kicking the system to suspend. To test WoW you
need to run the supplicant manually because as far as I can tell the
GUI managers don't consider if WoW was enabled or not. In such a case
that WoW was enabled the GUI managers should not send the
deauth/disassoc.

  Luis
