Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:52446 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab3IWQBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Sep 2013 12:01:25 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Andrew Lutomirski <andy@luto.us>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] Intel 6300 crashes hard (3.11 regression?)
Date: Mon, 23 Sep 2013 16:01:06 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301DB3584@HASMSX103.ger.corp.intel.com> (sfid-20130923_180131_508762_41AC3EBC)
References: <CAObL_7HXC8qQ54O5QPAo7cQT2yeK-etgKD-7aoaL3dkT4qcOow@mail.gmail.com>
In-Reply-To: <CAObL_7HXC8qQ54O5QPAo7cQT2yeK-etgKD-7aoaL3dkT4qcOow@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> I've had a failure twice on 3.11.1-200.fc19.x86_64.  I've never seen it on
> earlier Fedora kernels or on 3.11-rc3.  The computer hangs for a minute or so.
> When it comes back, wireless doesn't work.  rmmoding and modprobing
> iwldvm doesn't help (it's at the bottom of the attachment).
> 
> Even rebooting doesn't fix it unless I pull the battery.  Otherwise iwlwifi loads
> but wlan0 doesn't appear and the only log line is the one saying that iwlwifi
> loaded.
> 
> The messages on startup are:
> 
> [   11.440725] iwlwifi 0000:03:00.0: can't disable ASPM; OS doesn't
> have ASPM control
> [   11.440788] iwlwifi 0000:03:00.0: irq 51 for MSI/MSI-X
> [   11.455653] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1
> build 25532 op_mode iwldvm
> [   11.517924] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   11.517930] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   11.517932] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING
> disabled
> [   11.517934] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
> [   11.517936] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R)
> Ultimate-N 6300 AGN, REV=0x74
> [   11.519626] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> 
> (Both failures happened with pcie_aspm=force, but this is without it.
> I want to see if disabling that option fixes it.)

Please do and report back - what I can see here is that we kinda can't access the NIC - so I would be curious if pcie_aspm=force changes the game here.

