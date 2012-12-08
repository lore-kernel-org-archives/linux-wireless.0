Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from posteo.de ([89.146.220.134]:35490 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab2LHVpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2012 16:45:22 -0500
Date: Sat, 8 Dec 2012 22:41:57 +0100
From: Felix Janda <felix.janda@posteo.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] b43: Load initial firmware file asynchronously
Message-ID: <20121208214157.GA21034@gauss> (sfid-20121208_224526_164006_C1B57262)
References: <50C01558.8050102@lwfinger.net>
 <20121208143032.GA1903@gauss>
 <50C375BE.9050907@lwfinger.net>
 <20121208175615.GA10664@gauss>
 <50C399A9.2060304@lwfinger.net>
 <20121208202435.GA14973@gauss>
 <50C3AF0C.8000607@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
In-Reply-To: <50C3AF0C.8000607@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 12/08/12 at 03:20pm, Larry Finger wrote:
> On 12/08/2012 02:24 PM, Felix Janda wrote:
> >
> > Not much has changed. Say, if you want to have the complete dmesg output.
> 
> Yes, I messed that one up. Try this one - it is different in the error recovery.
> 
> Larry

Now I have a wlan0. Haven't tested it though yet. dmesg still prints some errors.

Felix

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.504374] b43-phy0: Broadcom 4306 WLAN found (core revision 5)
[    0.545047] b43-phy0: Found PHY: Analog 2, Type 2 (G), Revision 2
[    0.707107] async load of b43/ucode5.fw
[    0.740558] Broadcom 43xx driver loaded [ Features: PL ]
[   62.284907] In callback routine, firmware not available
[   62.284919] Pid: 632, comm: kworker/0:2 Not tainted 3.7.0-rc8 #22
[   62.284921] Call Trace:
[   62.284941]  [<c12eefaa>] b43_fw_cb+0x1a/0x30
[   62.284953]  [<c12b3c5b>] request_firmware_work_func+0x5b/0xb0
[   62.284960]  [<c104b540>] process_one_work+0x110/0x380
[   62.284966]  [<c12b3c00>] ? _request_firmware_prepare.isra.14+0x380/0x380
[   62.284970]  [<c104c2e9>] worker_thread+0x119/0x340
[   62.284974]  [<c104c1d0>] ? manage_workers+0x260/0x260
[   62.284982]  [<c1050abf>] kthread+0x8f/0xa0
[   62.284992]  [<c14dffb7>] ret_from_kernel_thread+0x1b/0x28
[   62.284996]  [<c1050a30>] ? __kthread_bind+0x30/0x30
[   62.299141] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[   62.300427] Registered led device: b43-phy0::tx
[   62.300690] Registered led device: b43-phy0::rx
[   62.300950] Registered led device: b43-phy0::radio

--FL5UXtIhxfXey3p5--
