Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37271 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0EASen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 14:34:43 -0400
Received: by pvg7 with SMTP id 7so674369pvg.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 May 2010 11:34:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7F414AFA-E125-40AD-A745-30AEC442B1E8@kaon.com>
References: <7F414AFA-E125-40AD-A745-30AEC442B1E8@kaon.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 1 May 2010 11:34:23 -0700
Message-ID: <s2s43e72e891005011134p3c1c7362x4ae8afa5265d060b@mail.gmail.com>
Subject: Re: Issues setting up a 5GHz 802.11N AP
To: Joshua Smith <jesmith@kaon.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 29, 2010 at 10:17 AM, Joshua Smith <jesmith@kaon.com> wrote:
> Hello!  I hope this is the right mailing this for this question.  If not, please redirect me as you see fit!
>
> I am trying to put together a Linux PC that can act as a 5 GHz 802.11N Access Point.  I got a lot of conflicting info in my searches, so I figured I'd just buy some hardware and figure out what works.
>
> I am using this kernel:
>
>  Linux vosk 2.6.27.8 #1 SMP Sun Dec 7 08:30:31 i686 Intel(R) Core(TM) i7 CPU 930  @ 2.80GHz GenuineIntel GNU/Linux
>
> And I am using compat-wireless 2010-04-26 (complete build).
>
> So far, I have an Intel Wi-Fi Link 6300AGN:
>
>  iwlagn 0000:07:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
>
> An Atheros-based Belkin N1 Wireless ExpressCard:
>
>  phy1: Atheros AR5418 MAC/BB Rev:2 AR2122 RF Rev:81 mem=0xf9fa0000, irq=16
>
> And an RaLink-based Asus PCE-N13 PCI adapter:
>
>  03:00.0 Network controller: RaLink RT2860
>
> When I do 'iw list' for these three cards, I find:
>
> Intel: has 5GHz band, but does not support AP mode
> Atheros: supports AP mode, but does not show 5GHz band
> RaLink: supports AP mode, but does not show 5GHz band
>
> I think the Intel is correct.  I've found many sources that say this chipset simply does not support AP/Master mode.
>
> However, both the Atheros and RaLink claim to support 300Mbps speeds, which I believe means they should have some 5Ghz channels, right?

No, if you see no 5GHz information with 'iw list' then it means your
cards do not support 5 GHz. Its a physical limitation of the actual
hardware. To support 5 GHz your card would need a 5 GHz radio, and it
simply does not come with one. For your Atheros card specifically the
output shows a AR2122 RF, this is a 2.4 GHz radio only.

  Luis
