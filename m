Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33828 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1EPVgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 17:36:02 -0400
Received: by iyb14 with SMTP id 14so4097023iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2011 14:36:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTika=8VetqGXMX7XbsVRM9dBe7AUKA@mail.gmail.com>
References: <BANLkTimDudEKPEjTrWxm1wNA00Cmyot+sA@mail.gmail.com>
 <BANLkTi=cx1CJkuBgvKkd9tm1u2hu7WGYYA@mail.gmail.com> <BANLkTika=8VetqGXMX7XbsVRM9dBe7AUKA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 16 May 2011 14:35:41 -0700
Message-ID: <BANLkTi=k_HQ2jh5dAeHs5PzWNmUtyhViNQ@mail.gmail.com> (sfid-20110516_233610_527793_8D86A0CE)
Subject: Re: what dictates the firmware directory of compat-wireless firmware?
To: George Nychis <gnychis@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 16, 2011 at 2:09 PM, George Nychis <gnychis@gmail.com> wrote:
>> compat-wireless uses a new module called compat_firmware so you need a
>> respective new udev rule for it, it uses the same path for firmware
>> though so you just need to slap on the right udev rule.
>>
>
> Thanks for the response, Luis!
>
> I'm not a udev expert, and my problem might be slightly
> Android-dependent, so feel free to punt the conversation at any point.
>
> I've tried setting up a set of rules on my Android device to handle
> this situation.  There was no /etc/udev or anything related, before I
> created them.  I created a udev.conf and a default set of rules, and
> then migrated the compat_firmware rules on over.  But, udev seems to
> be ignoring everything.
>
> Unfortunately, there's not a lot documented in terms of udev on
> Android.  I did manage to find a little bit of information on a page
> that's actually about root exploits on Android:
> http://intrepidusgroup.com/insight/2010/09/android-root-source-code-looking-at-the-c-skills/
>
> Apparently one of them is a udev exploit, and the author mentions that:
> "Android does not have a separate udev executable and process link
> [like] on standard Linux deployments. However, large portions of the
> udev code have been moved into the init daemon."
>
> I'm not sure if this customization of udev or migration of it into the
> init daemon is affecting anything here.
>
> Is there any simple backwards compatible way of bypassing
> compat_firmware?  If not, I will dig up some of the older
> compat-wireless code to try and remedy the problem and get around
> compat_firmware.

If android hacked udev into the init deamon then you will have to
modify the init daemon too but I doubt that they would have kept udev
rules statically in the init daemon, so try to find the udev rules.

  Luis
