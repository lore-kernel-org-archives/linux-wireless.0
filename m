Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f177.google.com ([74.125.82.177]:37010 "EHLO
        mail-ot0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751345AbdKUWgD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Nov 2017 17:36:03 -0500
Received: by mail-ot0-f177.google.com with SMTP id s4so11967034ote.4
        for <linux-wireless@vger.kernel.org>; Tue, 21 Nov 2017 14:36:03 -0800 (PST)
MIME-Version: 1.0
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 21 Nov 2017 15:36:02 -0700
Message-ID: <CAJCQCtQUE6V6zQewVAQJRmDPHjqL=Mixq4nj0kZGZ67UKOTnKg@mail.gmail.com> (sfid-20171121_233722_067053_6DB917B7)
Subject: BCM4331 won't connect with WPA2
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Pretty much all the details and logs are here:

refuses to connect to WPA2 secured WiFi
https://bugzilla.redhat.com/show_bug.cgi?id=1516009

So I will just include a summary here:

Macbook Pro, Broadcom BCM4331
firmware version 784.2 (2012-08-15....
kernels 4.5.5 through 4.13.13
NetworkManager-1.8.4
wpa_supplicant-2.6

Access point is an Xfinity branded
Arris TG1682G, 802.11a/b/g/n/ac

Connecting to this AP's unsecured "xfinity" SSID succeeds, but fails
to its "altitude" WPA2 secured SSID. The user visible failure is
either no error other than three dots for the Wifi icon in the gnome
menu bar, or more often the modal passphrase dialog for the AP comes
up asking for the passphrase again.

No other devices (about 1/2 dozen) have this problem, including this
same laptop if I reboot to macOS and connect to this same "altitude"
SSID with the same entered passphrase.

There is an attached log (journal3) where a connection did succeed for
a very short amount of time, but then promptly was disconnected with
all subsequent attempts to connect failing while the user intervention
was zero (I was touching nothing, just monitoring and logging stuff).

The journal2 log attached to the bug report contains wpa_supplicant -d
output. Let me know if I need to retry with -dd and post that
somewhere. Also in the bug are the kernel config options, I don't see
any of the requested 80211 options in the reporting bugs guidelines.
https://wireless.wiki.kernel.org/en/users/documentation/reporting_bugs

So if I need to compile a kernel and enable options, no problem, just
let me know which ones.

If I change any of the three components: client (the laptop with
BCM4331) + linux + AP then the problem doesn't happen. Change the OS
and it works. All other devices work with this AP and WPA2. And
BCM4331 + linux work with other APs than this one. So it's something
of a trifecta bug.


-- 
Chris Murphy
