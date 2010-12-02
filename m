Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:38942 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab0LBNki (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 08:40:38 -0500
Received: by qyk11 with SMTP id 11so3960305qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 05:40:37 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTin5nSy4uopY8z2ncKgwpPUYV+YG1V7aJLKnFQGg@mail.gmail.com>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
	<AANLkTin5nSy4uopY8z2ncKgwpPUYV+YG1V7aJLKnFQGg@mail.gmail.com>
Date: Thu, 2 Dec 2010 14:40:36 +0100
Message-ID: <AANLkTim7c03maZWEkj5VcJWYOQSZQT8+9zXRZQgs3Z=E@mail.gmail.com>
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Bruno Randolf <br1@einfach.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 2, 2010 at 1:17 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> On Wed, Dec 1, 2010 at 11:09 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> Hi,
>>
>> I have built today a linux-next (next-20101201) kernel which includes
>> wireless-next-2.6 up to master-2010-11-30.
>>
> [...]
>> Unfortunately, my wlan network connection is totally unstable.
> [...]
>> My wlan device is an ath5k:
>>
>> $ lspci -nnvv | grep "Ethernet controller" | grep -i ath
>> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
>> 802.11abg NIC [168c:1014] (rev 01)
>>
>> Any idea what's wrong? (Just speculating on the last patch-set from Nick...)
>
> So it is definitely not Nick's patchset causing the troubles here.
> I have built compat-wireless-2010-11-30 which does not contain this
> ath5 patchset.
>
> $ grep ath5k compat-wireless-2010-11-29_compat-wireless-2010-11-30.diff
>
> $ grep ath5k compat-wireless-2010-11-30_compat-wireless-2010-12-01.diff | wc -l
> 1229
>
> # modinfo ath5k | grep filename
> filename:
> /lib/modules/2.6.37-rc4-686/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
>
> So I try backwards the c-w-2.6 tarballs and report again.
>

I am very very sorry to say this was a false "positive" (or negative?).

After 1st reboot and trying to restart networking, things look
different with c-w (2010-11-30):

# /etc/init.d/networking start
Configuring network interfaces...ioctl[SIOCGIFFLAGS]: No such device
Could not get interface 'wlan0' flags
ioctl[SIOCSIWPMKSA]: No such device
ioctl[SIOCSIWMODE]: No such device
Could not configure driver to use managed mode
ioctl[SIOCGIWRANGE]: No such device
ioctl[SIOCGIWMODE]: No such device
ioctl[SIOCSIWAP]: No such device
ioctl[SIOCSIWESSID]: No such device
ioctl[SIOCGIFINDEX]: No such device
ioctl[SIOCSIWENCODEEXT]: No such device
ioctl[SIOCSIWENCODE]: No such device
ioctl[SIOCSIWENCODEEXT]: No such device
ioctl[SIOCSIWENCODE]: No such device
ioctl[SIOCSIWENCODEEXT]: No such device
ioctl[SIOCSIWENCODE]: No such device
ioctl[SIOCSIWENCODEEXT]: No such device
ioctl[SIOCSIWENCODE]: No such device
ioctl[SIOCGIWMODE]: No such device
ioctl[SIOCSIWAP]: No such device
ioctl[SIOCSIWESSID]: No such device
ioctl[SIOCGIFFLAGS]: No such device
wpa_supplicant: /sbin/wpa_supplicant daemon failed to start
run-parts: /etc/network/if-pre-up.d/wpasupplicant exited with return code 1
SIOCSIFADDR: No such device
wlan0: ERROR while getting interface flags: No such device
SIOCSIFNETMASK: No such device
SIOCSIFBRDADDR: No such device
wlan0: ERROR while getting interface flags: No such device
wlan0: ERROR while getting interface flags: No such device
Failed to bring up wlan0.
done.

What is really working stable is compat-wireless-2.6.37-rc3-1
(confirmed after several reboots). I will stay on this as I need a
reliable network connection.

- Sedat -
