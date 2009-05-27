Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f177.google.com ([209.85.222.177]:58695 "EHLO
	mail-pz0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbZE0VCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 17:02:06 -0400
Received: by pzk7 with SMTP id 7so3851837pzk.33
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 14:02:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1243450447-11749-1-git-send-email-lrodriguez@atheros.com>
References: <1243450447-11749-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 27 May 2009 14:01:46 -0700
Message-ID: <43e72e890905271401k67377bc5w28267060fd054b4b@mail.gmail.com>
Subject: Re: [PATCH] ar9170: add AVM FRITZ devices
To: linville@tuxdriver.com, Christian Lamparter <chunkeey@web.de>,
	Yuan-Gu Wei <Yuan-Gu.Wei@atheros.com>,
	Joerg Albert <jal2@gmx.de>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Peter Grabienski <Peter.Grabienski@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Michael Fortin <Michael.Fortin@atheros.com>,
	Johnny Cheng <Johnny.Cheng@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 11:54 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This adds:
>
> USB 0x057C:0x8401       AVM FRITZ!WLAN USB Stick N
> USB 0x057C:0x8402       AVM FRITZ!WLAN USB Stick N 2.4
>
> Cc: Peter Grabienski <Peter.Grabienski@Atheros.com>
> Cc: Stephen Chen <Stephen.Chen@Atheros.com>
> Cc: Michael Fortin <Michael.Fortin@Atheros.com>
> Cc: Johnny Cheng <Johnny.Cheng@Atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Actually please hold off on this.. Christian pointed out an issue
reported with these devices which would need to be addressed before
adding it to ar9170usb.

The issue seems to be related to the 2-stage firmware by the "linux"
solution and conflicts with the bootcode size used by the AVM fritz
cards. As it turns out the 2-stage firmware is no longer needed as the
regulatory control is not handled by ath.ko, the common shared module.
Keep in mind ar9170usb doesn't yet support setting TX power so it will
work with a default tx power setting, whatever that is for both the
2-stage firmware or the 1-stage firmware.

Anyway, a possible solution here is to try to add support for the
1-stage firmware. I had some initial patches for this [1] but didn't
get a chance to finish up on it. I was at least able to scan.
Christian, you also noted some differences on tx status reporting. I
suspect though that if the 1-stage firmware is used and issues
corrected (as done by the otus driver, see the patch e-mail) then
ar9170 would work well with the AVM devices.

[1] http://marc.info/?l=linux-wireless&m=124124074016450&w=2

  Luis
