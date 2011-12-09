Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40247 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1LINHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 08:07:19 -0500
Received: by qadc12 with SMTP id c12so400294qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Dec 2011 05:07:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111205103751.GA3775@jouni.qca.qualcomm.com>
References: <CAHW5WCL2V=wh43YYbiMo+rnh=-g4fobKEZHrCLvW03Q73=gzYA@mail.gmail.com>
	<4EC7E739.4080404@broadcom.com>
	<CAHW5WCLUefvgvRkgz7Nr+Rwu6_96t7EVVB33U0ED5g9a0cHFXw@mail.gmail.com>
	<CAHW5WCK7SU8CJRM8pLy9omEtrPu0_ES=SxWfYEWt30NCwBGEZw@mail.gmail.com>
	<CAHW5WCJhwGSM74nN5ivoEgP98y_hbbOB8yDO9+2ahhy2B4H7yw@mail.gmail.com>
	<20111205103751.GA3775@jouni.qca.qualcomm.com>
Date: Fri, 9 Dec 2011 21:07:17 +0800
Message-ID: <CAHW5WCLOk6b5HSYS-mtqgoS6mvdCOzR4NUL_ZpmzM46CTsreRw@mail.gmail.com> (sfid-20111209_140724_416020_156A5EFB)
Subject: Re: [ath9k-devel] Wireless stalled after a few minutes with Linux
 Kernel 3.1
From: Haohui Liao <liaohaohui@gmail.com>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Jouni Malinen,

>> Regarding https://bugs.archlinux.org/task/27406
>>
>> > The following is a portion of my wpa_supplicant.conf
>> >
>> >    ssid="LINUX-LINK"
>> >    proto=WPA2
>> >    key_mgmt=WPA-PSK
>> >    pairwise=TKIP
>> >    group=TKIP
>
> That's pretty strange configuration.. Do you have any
> particular reason for using TKIP as the pairwise cipher
> with WPA2? CCMP would be much more likely configuration
> for WPA2 in general..

The reason I am using TKIP is because my Wifi configuration
says the following:

Network Authentication: WPA2-PSK
WPA Encryption: TKIP

and I misunderstood the wpa_supplicant.conf and just change
the WPA-PSK to WPA2-PSK and have the TKIP remain.

>> Just wondering if I am the only one still doing the following from command line
>> to connect to wifi?
>
> I'm sure you are not the only one.. And in this particular
> case, I don't
> see how that would make a difference.

It DOES.  I tried yesterday with my Fedora 16 (which is using
kernel 3.1.2).

With XFCE + NetworkManager, there is no issue with my wifi.
But when I performed init 3 (shutting down X11) and tried the
following

wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant.conf -B
iwconfig wlan0 power off
dhclient wlan0

my wifi will ``stall''.  This is probably misleading because
my machine still runs, it is just that the following scenario
happens:

The debugging message wpa_supplicant is as follows:

WPA: Request PTK rekeying
WPA: Sending EAPOL-Key Request (en=0 pairwise=1 ptk_set=1 len=99)
WPA: TX EAPOL-Key-hexdump (len=99): 01 03 ...

And the is no more communication.  With Wireshark, I will
get the following (Reference:
https://bugs.archlinux.org/task/27406?getfile=7864):

Laptop Wifi (QuantaMi) will ask my wifi router (Shenzhen)
who has 192.168.1.1 tell 192.168.1.3 (my router) but the
process continues and all Internet connections seem broken.

So 10 minutes' connection to Internet will suddenly stop.

> Would you be able to provide some more details on what
> exactly you mean with "wifi stall"? Are you sure this is
> related to rekeying?

I am not sure if the term stall is correct.  But
wpa_supplicant seems to be hanging there asking (ARP protocol)
for response from my router but the router seems to be deaf
and is not responding.  So the ONLY way for me to get back
a connection is to kill the wpa_supplicant daemon and
the connection resumes.

This never happens to linux 3.0.7 but happens immediately
when I upgrade to linux 3.1. (This matter persists until
Linux 3.1.4)

> May I ask why you have configured the station to force PTK
> rekeying every 10 minutes? While TKIP is not really the
> most secure design out there, the proper way of addressing
> this would be to use CCMP instead of frequent rekeying with
> TKIP..

Thank you very much for pointing out this to me.  I did not
actually go through the wpa_supplicant.conf very thoroughly
and simply adapt the example I found below:

# WPA-Personal(PSK) with TKIP and enforcement for frequent PTK rekeying

I just change the WPA-PSK to WPA2 and everything just works.
So I thought I got things correct.   Apparently this is not
the case.  The PTK just happens to come from the
configuration.

Anyway, it is also good to learn that there is a TPK rekeying
since surrounding interference may cause wifi connection
to be broken and my wifi connection may be hanging at random.

I will change to CCMP as you suggested and inform you the
result.

A million thanks for all your suggestions and correction and
I hope you forgive my English.


Regards,
Liao Haohui
