Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46472 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab2D3NW6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 09:22:58 -0400
Received: by vbbff1 with SMTP id ff1so2016066vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 06:22:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGxPR-8jATq7pOqe58fy3FspMKrE6K6KiA5cDFabv=T-YOzuLg@mail.gmail.com>
References: <CAGxPR-8jATq7pOqe58fy3FspMKrE6K6KiA5cDFabv=T-YOzuLg@mail.gmail.com>
Date: Mon, 30 Apr 2012 18:52:57 +0530
Message-ID: <CAD2nsn2eccmO_Fd0aBv8naLMVwF2qE_+9J7Beiw8pBwgxLW=Og@mail.gmail.com> (sfid-20120430_152302_095219_F630CE5F)
Subject: Re: AR9285 (ath9k) network adapter often deauthenticates from a
 certain network
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Bartosz Brachaczek <b.brachaczek@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 28, 2012 at 3:01 AM, Bartosz Brachaczek
<b.brachaczek@gmail.com> wrote:
> Hi,
>
> I am often deauthenticated from my network at home. When
> NetworkManager reconnects after this, the connection sometimes is
> unusable until full reconnect is manually requested. These
> deauthendications happen only with my home network (I have a custom
> "Netia Spot" wireless router from my ISP at home), I have no problems
> with my university networks.

providing some information regarding the difference between your home
network and university
network would be useful, like which is more congested and does your
home network has some
sort of security.

>
> I'm attaching syslog output which shows kernel and NetworkManager
> messages. Kernel was compiled with debugging output enabled for
> mac80211 and Atheros. As can be seen (use `grep '\(Reason:
> 6\|user-req\)'`), deauthentications happen quite often but only after
> two of them my connection was unusable - they are followed by manual
> disconnect+connect through nm-applet.
>
> When connection breaks, `ping` running in the background outputs
> nothing for a while, and then outputs "Destination Host Unreachable"
> messages. Trying to run `ping` when the connection is already broken
> ends in ping exiting after timeout or something.
>
> I don't have any problems on Windows 7 on the same machine, although I
> don't know whether it doesn't have problems with deauthentications or
> if it is able to always quickly restore the connection.
>
> I reported it also to NetworkManager as I suppose that
> deauthentications are driver bug and failures to restore the
> connection are NetworkManager bug:
> https://bugzilla.gnome.org/show_bug.cgi?id=674996

if you can disable the NM and see using supplicant with bg scan enabled helps
also pls try with the latest compat build
http://linuxwireless.org/en/users/Download#Where_to_download_bleeding_edge


>
> NetworkManager version: 0.9.4.0 (0.9.2.0 had the same problem, earlier
> not tested)
> Kernel version: 3.3.3 (3.0 had the same problem, earlier not tested)
>
> Wireless network adapter (lspci -vnn):
> 02:00.0 Network controller [0280]: Atheros Communications Inc. AR9285 Wireless
> Network Adapter (PCI-Express) [168c:002b] (rev 01)
>        Subsystem: AzureWave AW-NB037H 802.11bgn Wireless Half-size
> Mini PCIe Card [AR9002WB-1NGCD] [1a3b:2c37]
>        Flags: bus master, fast devsel, latency 0, IRQ 17
>        Memory at dea00000 (64-bit, non-prefetchable) [size=64K]
>        Capabilities: [40] Power Management version 3
>        Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>        Capabilities: [60] Express Legacy Endpoint, MSI 00
>        Capabilities: [100] Advanced Error Reporting
>        Capabilities: [140] Virtual Channel
>        Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
>        Capabilities: [170] Power Budgeting <?>
>        Kernel driver in use: ath9k
>
>
>
> Bartosz Brachaczek



-- 
thanks,
shafi
