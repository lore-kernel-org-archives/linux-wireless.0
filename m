Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23101.mail.ird.yahoo.com ([217.146.189.41]:25619 "HELO
	web23101.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932665Ab0DPWd1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 18:33:27 -0400
Message-ID: <30211.6195.qm@web23101.mail.ird.yahoo.com>
Date: Fri, 16 Apr 2010 22:26:44 +0000 (GMT)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: [zd1211-devs] timeout in zd1211rw with zotac mini-itx (geforce 9300)
To: zd1211-devs@lists.sourceforge.net, Tsuwei Chen <tsuwei@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <k2r8108ad761004161334x894f9298xf3728846ff69b36b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I suspect it is just poor hardware. The more power-drawing devices you have got, the current/power available to each can drop, and some devices are more sensitive to drop in voltage than others. That seems to be the obvious conclusion - the more bus-powered devices plugged in, the more likely the wireless device fails to initialise.

You probably would find that you will need a independently-powered hub (i.e. a USB hub which has its own power-plug that you need to plug into the mains) for it to work reliably, since your motherboard doesn't seem to be able to do it. 

--- On Fri, 16/4/10, Tsuwei Chen <tsuwei@gmail.com> wrote:

> From: Tsuwei Chen <tsuwei@gmail.com>
> Subject: [zd1211-devs] timeout in zd1211rw with zotac mini-itx (geforce 9300)
> To: zd1211-devs@lists.sourceforge.net
> Cc: linux-wireless@vger.kernel.org
> Date: Friday, 16 April, 2010, 21:34
> Has anyone use the zd1211 usb adapter
> with mini-itx board based on
> geforce 9300? I have been experience some annoying issues
> ever since I
> got this motherboard. The problem is that sometime the card
> just
> cannot be switched on. It complains about ioread32() error
> -110. And I
> have spent a few days and try a few different combination,
> and here is
> what I have found so far:
> 
> 1, with 1 wifi adapter directly plugged into the board, the
> wifi
> adapter works fine most of the time (have seen a couple
> failure, but
> is hard to reproduce)
> 2. with 1 wifi adapter, plugged in through a USB hub, the
> driver
> complains ioread32 error. I've try 2 USB hubs: a cheap
> 4-port USB
> dongle and also the USB hubs built into my DELL monitor.
> Both showed
> the same problem.
> 3. If I plugged in 2 wifi adapters directly to the board,
> more than
> 50% of chance one of the wifi adapter would fail during the
> 'ifconifg
> up'.
> 
> I tried to dig our more on this. I am using kernel
> 2.6.24-26 (ubuntu).
> I had turned on the debug message output and I have traced
> out that
> the failure was first detected in the zd_mac_open().
> Probably around
> the call to zd_chip_switch_radio_on(). The error message is
> printed in
> the zd_usb_ioread16v(), and probably indicate the driver
> is
> experiencing a timeout while it is trying to read the
> register from
> the adapter.
> 
> What exactly does this mean? Why adding a usb hub cause
> such a huge
> differnce? Has anyone experienced similar problem before?
> Any pointer
> that can help me solve this problem is appreciated.
> 
> BTW, I never had this problem before when I was still using
> a regular
> HP desktop PC, even with the same version of kernel and
> same USB hub.
> I switched to mini-itx because I am building a small
> system. So if
> anyone is currently using this adapter with a mini-ITX
> board, please
> also let me know which model you use.
> 
> TIA,
> Tsuwei
> 
> ------------------------------------------------------------------------------
> Download Intel® Parallel Studio Eval
> Try the new software tools for yourself. Speed compiling,
> find bugs
> proactively, and fine-tune applications for parallel
> performance.
> See why Intel Parallel Studio got high marks during beta.
> http://p.sf.net/sfu/intel-sw-dev
> _______________________________________________
> Zd1211-devs mailing list - http://zd1211.wiki.sourceforge.net/
> Unsubscribe: https://lists.sourceforge.net/lists/listinfo/zd1211-devs
> 


      
