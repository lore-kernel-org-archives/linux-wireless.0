Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f52.google.com ([209.85.212.52]:36084 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab3ABQyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 11:54:15 -0500
Received: by mail-vb0-f52.google.com with SMTP id ez10so14239188vbb.39
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2013 08:54:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL1gcdMXNomEiPqJ5fKiQEB8Z02h=zYyYEUyDPvcaH4uEmd6jA@mail.gmail.com>
References: <50E42DBF.7070206@web.de>
	<20130102160534.GC2198@tuxdriver.com>
	<CAL1gcdMXNomEiPqJ5fKiQEB8Z02h=zYyYEUyDPvcaH4uEmd6jA@mail.gmail.com>
Date: Wed, 2 Jan 2013 17:54:14 +0100
Message-ID: <CAL1gcdN7TBS_yn5q5YsNVt8pkfLrxJLj=JSYQzM0J0jTEFAx-Q@mail.gmail.com> (sfid-20130102_175419_867420_629DB1C7)
Subject: Re: wireless regression with 3.7 on MSI MS-1013 notebook
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?ISO-8859-1?Q?J=F6rg=2DVolker_Peetz?= <jvpeetz@web.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	johannes.berg@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(resending in plain text to have message accepted by linux-wireless)

On Wed, Jan 2, 2013 at 5:05 PM, John W. Linville <linville@tuxdriver.com> wrote:
>
> On Wed, Jan 02, 2013 at 01:53:19PM +0100, Jörg-Volker Peetz wrote:
> > Hallo and happy new year.


Happy new year to you too!!

>
> >
> > With kernel 3.7 the wireless adapter in my MSI MS-1013 notebook stops working
> > and I see the following warning while booting:
> >
> > ---%<---
> >    cfg80211: Calling CRDA to update world regulatory domain
> >    ------------[ cut here ]------------
> >    WARNING: at net/wireless/core.c:389 wiphy_register+0x5c0/0x600 [cfg80211]()
> >    Hardware name: MS-1013
> >    Modules linked in: rt2500pci(+) eeprom_93cx6 rt2x00pci rt2x00lib mac80211
> > cfg80211 8250_pci 8250_core serial_core fuse snd_atiixp snd_atiixp_modem
> > snd_ac97_codec snd_pcm snd_page_alloc ac97_bus snd_seq snd_seq_device snd_timer
> > snd sdhci_pci 8139too soundcore sdhci mii pcmcia psmouse k8temp [last unloaded:
> > eeprom_93cx6]
> >    Pid: 10614, comm: modprobe Tainted: G        W    3.7.1 #1
> >    Call Trace:
> >    [<ffffffff81027c19>] ? warn_slowpath_common+0x79/0xc0
> >    [<ffffffffa02bd160>] ? wiphy_register+0x5c0/0x600 [cfg80211]
> >    [<ffffffffa0335112>] ? rt2x00queue_allocate+0x42/0x180 [rt2x00lib]
> >    [<ffffffff81098d04>] ? __kmalloc+0xe4/0x130
> >    [<ffffffff81098d04>] ? __kmalloc+0xe4/0x130
> >    [<ffffffffa02edc57>] ? ieee80211_register_hw+0x347/0x6d0 [mac80211]
> >    [<ffffffffa03322ed>] ? rt2x00lib_probe_dev+0x53d/0x720 [rt2x00lib]
> >    [<ffffffffa033f888>] ? rt2x00pci_probe+0x168/0x2e4 [rt2x00pci]
> >    [<ffffffff8117c0b0>] ? pci_device_probe+0xd0/0x170
> >    [<ffffffff81292b74>] ? driver_probe_device+0x64/0x210
> >    [<ffffffff81292db3>] ? __driver_attach+0x93/0xa0
> >    [<ffffffff81292d20>] ? driver_probe_device+0x210/0x210
> >    [<ffffffff812911d5>] ? bus_for_each_dev+0x45/0x80
> >    [<ffffffff81292310>] ? bus_add_driver+0x170/0x250
> >    [<ffffffff8129338e>] ? driver_register+0x6e/0x170
> >    [<ffffffff81045a24>] ? notifier_call_chain+0x44/0x60
> >    [<ffffffffa034e000>] ? 0xffffffffa034dfff
> >    [<ffffffff810002ca>] ? do_one_initcall+0x11a/0x160
> >    [<ffffffff8105b9a6>] ? sys_init_module+0x76/0x1c0
> >    [<ffffffff813cae10>] ? system_call_fastpath+0x16/0x1b
> >    ---[ end trace 5c109ae70c3f9955 ]---
> >    phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
> >    rt2500pci: probe of 0000:02:09.0 failed with error -22
> > --->%---
> >
> > and the module rt2500pci fails to load.
> >
> > The kernel config is appended.
> > --
> > Regards,
> > Jörg-Volker.
>
> It is probably better to send to linux-wireless@vger.kernel.org instead...
>
> Does this happen every time?  If not, what circumstances contribute to it?
>
> What version of the kernel were you using previously?
>

This is caused by the introduction of interface combinations. Helmut
Schaa has already submitted a patch to fix this, but this has
unfortunately not ended up in 3.7. I'm confident it will end up in one
of the upcoming 3.7.x stable releases.

See http://marc.info/?l=linux-wireless&m=135478723823922&w=2 for the
patch submitted by Helmut.

---
Gertjan
