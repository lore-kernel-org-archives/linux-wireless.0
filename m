Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:43630 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965Ab3EKXKV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 May 2013 19:10:21 -0400
Received: by mail-oa0-f43.google.com with SMTP id o6so6256965oag.2
        for <linux-wireless@vger.kernel.org>; Sat, 11 May 2013 16:10:20 -0700 (PDT)
Message-ID: <518ECFDA.20208@lwfinger.net> (sfid-20130512_011025_448717_518C2F0F)
Date: Sat, 11 May 2013 18:10:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: JoSH Lehan <krellan@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: Using compat-drivers conflicts with kernel mac80211 and cfg80211
References: <CALOB5QZCeC7OTqkw5go6E_KUajVe5GDuCsSsc68cpZqE2YVfRQ@mail.gmail.com> <518DF4B1.3020706@broadcom.com> <518ECC39.9090401@gmail.com>
In-Reply-To: <518ECC39.9090401@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/11/2013 05:54 PM, JoSH Lehan wrote:
> Yes.  It's an embedded system, however, it has an exposed USB port and
> the user is free (within reason) to plug in a USB device.  I'm trying to
> add support for as many USB wireless adapters that I can find.  For some
> adapters (such as vt6656 and rtl8712), I use the vendor's tarball (which
> compiles directly against the kernel).  So, this is why I need to mix
> and match drivers compiled against the kernel's mac80211/cfg80211 with
> drivers compiled against the mac80211/cfg80211 from compat.
>

Neither driver r8712u, which has been in the kernel since 2.6.37, nor the 
equivalent vendor driver depends on anything from mac80211 or cfg80211. If it 
did, the kernel version would be in the drivers/net/wireless tree rather than in 
staging. I suspect the same is true for other wireless drivers from staging, 
which includes vt6656.

Larry



