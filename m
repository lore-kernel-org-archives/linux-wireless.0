Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43199 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760322AbbBIIwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 03:52:37 -0500
Received: by pdev10 with SMTP id v10so7167885pde.10
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2015 00:52:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150209084142.GA15797@redhat.com>
References: <54D64337.7080005@kit.edu> <54D81624.9070705@lwfinger.net> <20150209084142.GA15797@redhat.com>
From: Yegor Yefremov <yegorslists@googlemail.com>
Date: Mon, 9 Feb 2015 09:52:16 +0100
Message-ID: <CAGm1_ktfSnwtWiEawqheZR+0OboB-AGzR_ev-=xoGu6Qz2RVQg@mail.gmail.com> (sfid-20150209_095248_736116_EE8CB82F)
Subject: Re: Ralink RT5390/RT5370 no longer works on more recent kernels
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"Simon Raffeiner (SCC)" <simon.raffeiner@kit.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 9, 2015 at 9:41 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Sun, Feb 08, 2015 at 08:06:28PM -0600, Larry Finger wrote:
>> On 02/07/2015 10:54 AM, Simon Raffeiner (SCC) wrote:
>> The second thing to verify is that your configuration contains the line
>> "CONFIG_RT2800USB_RT53XX=y". This parameter is marked as depending on
>> EXPERIMENTAL, and I'm not sure that Ubuntu enables those parameters in their
>> kernels. Again as the module was loaded, I think your kernel is OK, but that
>> parameter is something to check.
>
> I suggest check rfkill as well.
>
>> Finally, if your kernel configuration is OK, you will probably need to
>> bisect the problem between v3.18 and v3.16. I have a device that uses
>> rt2800usb, but it is not a 53XX. FWIW, it works.
>
> Between 3.16 and 3.18 we have only those rt2x00 changes:
>
> cfd9167 rt2x00: do not align payload on modern H/W
> 664d6a7 wireless: rt2x00: add new rt2800usb device
> 01f7fee rt2800: correct BBP1_TX_POWER_CTRL mask
> ac0372a rt2x00: support Ralink 5362.
> 9baa3c3 PCI: Remove DEFINE_PCI_DEVICE_TABLE macro use
> 6a06e55 wireless: rt2x00: add new rt2800usb devices
> d4150246 drivers/net/wireless/rt2x00/rt2x00dev.c: remove null test before kfree
> df6e633 rt2x00: Use dma_zalloc_coherent
> 19dcb76 rt2x00: do not initialize BCN_OFFSET registers
> ddb4055 rt2x00: change order when stop beaconing
> 88ff2f4 rt2x00: change default MAC_BSSID_DW1_BSS_BCN_NUM
> ba08910 rt2x00: change beaconing setup on RT2800
> 283dafa rt2x00: change beaconing locking
> 57eaeb6 net: wireless: rt2x00: rt2x00mac.c: Cleaning up uninitialized variables
>
> They could be reverted, even on top of 3.19-rc7, instead of doing
> full bisection. But this could be also mac80211 issue, then bisection
> will be necessary to figure out this bug.

I have two devices based on the same chip (at least IDs are the same)
and they are working on am335x board. See my mail
http://marc.info/?l=linux-omap&m=142313518724040&w=2

IDs: 148f:5370
Kernel: 3.18.1

Yegor
