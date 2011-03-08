Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50011 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab1CHRNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 12:13:37 -0500
Received: by mail-iw0-f174.google.com with SMTP id 34so5032822iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 09:13:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299602750.3734.2.camel@jlt3.sipsolutions.net>
References: <AANLkTin0PGOfHr3AvQk-BAhyMY7ihYMU1-wX4RJG=1YT@mail.gmail.com>
	<20110304134648.GB9866@tuxdriver.com>
	<1299251879.24333.3.camel@wwguy-ubuntu>
	<AANLkTinfCc0e4BtBxoq7MHtgv54HJk-yU=gQj9Xm_=R9@mail.gmail.com>
	<AANLkTi=+jfk5+tWewwnx+SHj+FQAXd03sPC3mDW32GUK@mail.gmail.com>
	<AANLkTikUE-LLSBNH=cNmPZ+Wenff5RxKcfK0kJXp9Wk+@mail.gmail.com>
	<1299334144.3826.8.camel@jlt3.sipsolutions.net>
	<AANLkTikQHUq95e9=3tG5WrayaxUu+K1FdAftJ3y72BTn@mail.gmail.com>
	<1299597447.4676.25.camel@jlt3.sipsolutions.net>
	<AANLkTinj1f0Kx5X6eqYEdyzT_3XLbtbLtwbp7jPN2LSH@mail.gmail.com>
	<1299602750.3734.2.camel@jlt3.sipsolutions.net>
Date: Tue, 8 Mar 2011 17:13:36 +0000
Message-ID: <AANLkTimBfOM8yxdh_Z4Bw_ww4WRtQXzdoEx6ZL_TT5YU@mail.gmail.com>
Subject: Re: 2.6.38-rc7, iwlagn warning
From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 March 2011 16:45, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-03-08 at 16:22 +0000, Mathias Burén wrote:
>
>> I'm using NetworkManager, I haven't started anything else manually. I
>> don't know why it switches modes like that, it happens on 2 laptops
>> (both Ubuntu 10.10) so it could very well be some NetworkManager
>> related issue.
>
> Actually, before you do the tracing, can we get the supplicant logs? See
> http://live.gnome.org/NetworkManager/Debugging under "Debugging WiFi
> connections".
>
> johannes
>
>

I've a trace file and a dmesg (iwlagn loaded without debug though)
which caught the warning again, up here:
trace http://www.2shared.com/file/XIqwsRt0/trace.html
dmesg http://www.2shared.com/file/vShUfLjr/dmesg-warning-no-connection.html

Here's the NetworkManager stuff:

$ ps aux |grep wpa
root      5320  0.0  0.0  28404  2828 ?        S    17:01   0:00
/sbin/wpa_supplicant -u -s -dddt -f /var/log/wpa_supplicant.log

dmesg from trying to connect:


[  852.538122] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)
[  856.519009] wlan0: Selected IBSS BSSID 2e:d2:7e:91:0b:75 based on
configured SSID
[  856.525468] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[  856.526236] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[  860.518782] wlan0: Selected IBSS BSSID 2e:d2:7e:91:0b:75 based on
configured SSID
[  860.525444] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[  860.526172] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
[  860.615831] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)


$ cat /var/log/wpa_supplicant.log
1299603957.708982: WPS: UUID based on MAC address - hexdump(len=16):
cc fa a1 31 39 a7 5c 33 96 d8 eb 09 dd fe 7f 0f
1299603957.721046: ssid - hexdump_ascii(len=11):
     55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc
1299603965.996780: ssid - hexdump_ascii(len=11):
     55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc
1299603975.655187: ssid - hexdump_ascii(len=11):
     55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc
1299603985.161298: ssid - hexdump_ascii(len=11):
     55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc
1299603994.696625: ssid - hexdump_ascii(len=11):
     55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc

[snip]

1299604089.756872: WPS: UUID based on MAC address - hexdump(len=16):
cc fa a1 31 39 a7 5c 33 96 d8 eb 09 dd fe 7f 0f
1299604089.768927: ssid - hexdump_ascii(len=11):
     55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc
1299604094.005785: ssid - hexdump_ascii(len=11):
     55 62 75 6e 74 75 41 64 68 6f 63                  UbuntuAdhoc

Anything else I can try/provide?

Thanks,
// Mathias
