Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52947 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab1GaCgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 22:36:50 -0400
Received: by qwk3 with SMTP id 3so2350107qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 19:36:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110730205931.3cc8a004.ldarby@tuffmail.com>
References: <20110730181433.50bd32db.ldarby@tuffmail.com> <4E3442ED.90206@lwfinger.net>
 <20110730191422.3b2931ba.ldarby@tuffmail.com> <4E344F90.4040003@lwfinger.net> <20110730205931.3cc8a004.ldarby@tuffmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 31 Jul 2011 04:36:29 +0200
Message-ID: <CA+XFjipwu1WNXoYv8H8Vo+jHs600HKoOdfnvQDXi5CT--Xa=Ng@mail.gmail.com> (sfid-20110731_043657_278591_1CA9A1DA)
Subject: Re: I'm no longer confused and angry
To: Laurence Darby <ldarby@tuffmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 30, 2011 at 9:59 PM, Laurence Darby <ldarby@tuffmail.com> wrote:
> Larry Finger wrote:
>
>> On 07/30/2011 01:14 PM, Laurence Darby wrote:
>> >
>> > I have now enabled rfkill.  The hostapd error message is now:
>> >
>> > Hardware does not support configured mode
>> > wlan0: IEEE 802.11 Hardware does not support configured mode (2)
>> > Could not select hw_mode and channel. (-2)
>> > wlan0: Unable to setup interface.
>> > rmdir[ctrl_interface]: No such file or directory
>>
>> Please post your hostapd.conf. I don't have any ath9k hardware and
>> cannot check that it works with, but other wireless devices work with
>>
>> interface=wlan0
>> driver=nl80211
>> hw_mode=g
>> channel=1
>> ssid=test2
>> #wpa=2
>> #wpa_key_mgmt=WPA-PSK
>> #wpa_pairwise=CCMP
>> #wpa_passphrase="deleted"
>>
>> Larry
>
> Ah, thanks, that does work and my other devices can see it now!
>
> I was using the unmodified hostapd.conf, which has hw_mode=a, but
> this device only supports modes b,g & n.  That is what the error is
> talking about, not the Master/Ad-Hoc mode which I thought it was trying
> to configure (which it is as well, actually).  Would be good if the
> error message included the mode it's trying to configure, instead of
> "(2)", that would definitely have stopped me getting confused here.
>
> Some more reasons I didn't think this supported AP mode:
> http://linuxwireless.org/en/users/Drivers has 'no' for AP support for
> the ath9k_htc, that conflicts with the driver page, and
>
>  # iwconfig wlan0 mode Managed
>
> works, while
>
>  # iwconfig wlan0 mode Master
> always gives:
> Error for wireless request "Set Mode" (8B06) :
>    SET failed on device wlan0 ; Invalid argument.
>
> With hostapd running, iwconfig says:
>
> wlan0     IEEE 802.11bgn  Mode:Master  Frequency:2.412 GHz  Tx-Power=20
> dBm Retry  long limit:7   RTS thr:off   Fragment thr:off
>          Power Management:off
>
> and reverts to Mode:Managed if I stop hostapd, so I'm not sure why
> iwconfig can't change it...
>
> Ok, http://linuxwireless.org/en/users/Documentation/hostapd does say
> that hw_mode needs to be set correctly, but it wasn't obvious enough
> that's what the problem was.  The error and solution could be added to
> where ./hostapd gets started.  Also, it refers to a
> hostapd-minimal.conf, I couldn't see that anywhere, that's why I used
> the default hostapd.conf.
>
> Laurence
>

"iwconfig wlan0 mode master" means "Set wlan0 to use the in-kernel
master mode implementation." Since mac80211 has no in-kernel support
for master mode (that's why you need hostapd - master mode is
supported from userspace), it will always fail.

Also, iwconfig uses Wireless Extensions (AKA wext) to configure the
wireless card - access to AP mode through wext is intentionally
blocked, to help the migration of userspace utilities to nl80211.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
