Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45300 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab1EPVJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 17:09:35 -0400
Received: by bwz15 with SMTP id 15so4211586bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 14:09:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=cx1CJkuBgvKkd9tm1u2hu7WGYYA@mail.gmail.com>
References: <BANLkTimDudEKPEjTrWxm1wNA00Cmyot+sA@mail.gmail.com>
	<BANLkTi=cx1CJkuBgvKkd9tm1u2hu7WGYYA@mail.gmail.com>
Date: Mon, 16 May 2011 17:09:33 -0400
Message-ID: <BANLkTika=8VetqGXMX7XbsVRM9dBe7AUKA@mail.gmail.com> (sfid-20110516_230938_451674_C45476CB)
Subject: Re: what dictates the firmware directory of compat-wireless firmware?
From: George Nychis <gnychis@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> compat-wireless uses a new module called compat_firmware so you need a
> respective new udev rule for it, it uses the same path for firmware
> though so you just need to slap on the right udev rule.
>

Thanks for the response, Luis!

I'm not a udev expert, and my problem might be slightly
Android-dependent, so feel free to punt the conversation at any point.

I've tried setting up a set of rules on my Android device to handle
this situation.  There was no /etc/udev or anything related, before I
created them.  I created a udev.conf and a default set of rules, and
then migrated the compat_firmware rules on over.  But, udev seems to
be ignoring everything.

Unfortunately, there's not a lot documented in terms of udev on
Android.  I did manage to find a little bit of information on a page
that's actually about root exploits on Android:
http://intrepidusgroup.com/insight/2010/09/android-root-source-code-looking-at-the-c-skills/

Apparently one of them is a udev exploit, and the author mentions that:
"Android does not have a separate udev executable and process link
[like] on standard Linux deployments. However, large portions of the
udev code have been moved into the init daemon."

I'm not sure if this customization of udev or migration of it into the
init daemon is affecting anything here.

Is there any simple backwards compatible way of bypassing
compat_firmware?  If not, I will dig up some of the older
compat-wireless code to try and remedy the problem and get around
compat_firmware.

Thanks again
