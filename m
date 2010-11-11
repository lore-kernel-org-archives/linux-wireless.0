Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50774 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0KKScL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 13:32:11 -0500
Received: by iwn10 with SMTP id 10so2466808iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 10:32:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <11581781.1031289487462262.JavaMail.wlan@CHBU500181>
References: <7180198.951289487321198.JavaMail.wlan@CHBU500181> <11581781.1031289487462262.JavaMail.wlan@CHBU500181>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Nov 2010 10:31:49 -0800
Message-ID: <AANLkTi=pPi02QskWK3zMzuMBpzOhpD5sJGYTNn8hmRbK@mail.gmail.com>
Subject: Re: [PATCH 2/9] ath5k: AHB port. Use ath_bus_opts structure.
To: Wojciech Dubowik <dubowoj@neratec.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 11, 2010 at 6:57 AM, Wojciech Dubowik <dubowoj@neratec.com> wrote:
> In main ath folder ath_bus_opts is used to specify AHB/PCI/USB specific functions. Use it for ath5k since it's needed for AHB support.
> PCI initialization has been split to bus specific and common which have been moved to ath5k_attach.
>
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>

Your patch commit log entry is way too long. Please trim it to around
76 characters per line or less. Also I'd prefer to help the reader of
the code and make it clear that the work you do in ath5k_attach() is
just to initialize the softc struct so please instead rename the
routine to ath5k_init_softc() just as we do that in ath9k while you're
at it. Later on (on a separate patch or series) you can also then
rename ath5k_hw_attach() to ath5k_hw_init() as we did so on ath9k.

  Luis
