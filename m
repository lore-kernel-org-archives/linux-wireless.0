Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from posteo.de ([89.146.220.134]:45168 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965440Ab2LHR7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 12:59:41 -0500
Date: Sat, 8 Dec 2012 18:56:15 +0100
From: Felix Janda <felix.janda@posteo.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: Load initial firmware file asynchronously
Message-ID: <20121208175615.GA10664@gauss> (sfid-20121208_185949_252416_E7AAAA50)
References: <50C01558.8050102@lwfinger.net>
 <20121208143032.GA1903@gauss>
 <50C375BE.9050907@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
In-Reply-To: <50C375BE.9050907@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 12/08/12 at 11:15am, Larry Finger wrote:
> On 12/08/2012 08:30 AM, Felix Janda wrote:
> > Thanks, for coming back to this.
> >
> > It now gives me a kernel panic after 30 seconds.
> >
> > I did some debugging using ssleep and printk. b43_fw_cb seems
> > to be called several times and on the last time the "firmware"
> > argument seems to be zero. The execution then returns to
> > b43_do_request_fw, which tries to deference a zero pointer in
> > the line
> >
> >> +	if (ctx->blob->size < sizeof(struct b43_fw_header))
> >
> >
> > It is another machine then last time, has B4306 (rev 3) and a
> > kernel without modules. The firmware is in /lib/firmware/b43,
> > which is on the root partition. There is no udev installed.
> 
> Felix,
> 
> Curious. I would have expected a single call to b43_do_request_fw() with the 
> async flag set, and thus a single call to the callback routine.
> 
> Attached is a new version of the patch. It will give us some instrumentation on 
> the calls, and it should prevent the crash. I would like to see the dmesg output 
> showing the info.
> 
> Thanks for testing,
> 
> Larry

Sorry, I assumed that the callback routine was called several times only
by looking at how much delay I was producing by putting ssleep(10) into it.

There's no more panic with the new version and the dmesg output looks
interesting.

Am I missing some firmware? /lib/firmware/b43 contains:

a0g0bsinitvals5.fw a0g0initvals5.fw a0g1bsinitvals5.fw
a0g1initvals5.fw b0g0bsinitvals5.fw b0g0initvals5.fw pcm5.fw ucode5.fw

Thanks for fixing this,
Felix

--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.502490] b43-phy0: Broadcom 4306 WLAN found (core revision 5)
[    0.543046] b43-phy0: Found PHY: Analog 2, Type 2 (G), Revision 2
[    0.705141] async load of b43/ucode5.fw
[    0.738576] Broadcom 43xx driver loaded [ Features: PL ]
[   62.284701] In callback routine, firmware not available
[   62.284712] Pid: 643, comm: kworker/0:2 Not tainted 3.7.0-rc8 #20
[   62.284715] Call Trace:
[   62.284734]  [<c12eefaa>] b43_fw_cb+0x1a/0x30
[   62.284746]  [<c12b3c5b>] request_firmware_work_func+0x5b/0xb0
[   62.284753]  [<c104b540>] process_one_work+0x110/0x380
[   62.284758]  [<c12b3c00>] ? _request_firmware_prepare.isra.14+0x380/0x380
[   62.284762]  [<c104c2e9>] worker_thread+0x119/0x340
[   62.284766]  [<c104c1d0>] ? manage_workers+0x260/0x260
[   62.284774]  [<c1050abf>] kthread+0x8f/0xa0
[   62.284783]  [<c14dffb7>] ret_from_kernel_thread+0x1b/0x28
[   62.284788]  [<c1050a30>] ? __kthread_bind+0x30/0x30
[   62.284793] Firmware not found
[   62.284799] async load of b43-open/ucode5.fw
[   62.323259] In callback routine, firmware not available
[   62.323267] Pid: 643, comm: kworker/0:2 Not tainted 3.7.0-rc8 #20
[   62.323269] Call Trace:
[   62.323278]  [<c12eefaa>] b43_fw_cb+0x1a/0x30
[   62.323284]  [<c12b3c5b>] request_firmware_work_func+0x5b/0xb0
[   62.323289]  [<c104b540>] process_one_work+0x110/0x380
[   62.323295]  [<c12b3c00>] ? _request_firmware_prepare.isra.14+0x380/0x380
[   62.323298]  [<c104c2e9>] worker_thread+0x119/0x340
[   62.323302]  [<c104c1d0>] ? manage_workers+0x260/0x260
[   62.323308]  [<c1050abf>] kthread+0x8f/0xa0
[   62.323314]  [<c14dffb7>] ret_from_kernel_thread+0x1b/0x28
[   62.323318]  [<c1050a30>] ? __kthread_bind+0x30/0x30
[   62.323322] Firmware not found
[   62.323329] b43-phy0 ERROR: You must go to http://wireless.kernel.org/en/users/Drivers/b43#devicefirmware and download the correct firmware for this driver version. Please carefully read all instructions on this website.

--TB36FDmn/VVEgNH/--
