Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30374 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab1AaPDR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:03:17 -0500
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110131112916.GA22367@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
	 <1296231817.7388.18.camel@wwguy-ubuntu> <20110128164136.GF2452@redhat.com>
	 <1296256821.8832.1.camel@wwguy-ubuntu> <20110131094624.GA20641@redhat.com>
	 <AANLkTinBneG0nqGFt=mnP0-ZSdLGzdxhfYpyo62WYJQA@mail.gmail.com>
	 <20110131112916.GA22367@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 07:01:41 -0800
Message-ID: <1296486101.10026.7.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 03:29 -0800, Stanislaw Gruszka wrote:
> On Mon, Jan 31, 2011 at 11:23:33AM +0100, Rafał Miłecki wrote:
> > >> > Not really. I believe someone who download a tarball, unpack it and copy
> > >> > files to /lib/firmware is pretty much aware what he/she is doing.
> > >> >
> > >> Agree whoever download the tarball know what he/she is doing, but I am
> > >> not fully agree the driver always use experimental uCode if it is in the
> > >> firmware directory
> > >
> > > I do not understand what for you need that, but ok, I can live with it.
> > >
> > > John, please skip this patch.
> > 
> > Maybe make it module parameter? Like use_experimental_fw, default to 0?
> 
> For me that even worse. Now I can provide users with kernel binaries with
> enabled experimental fw support. Telling them to install firmware is
> enough, to get test results.
> 
> With module option:
> 
> sgruszka: download exp firmware and load module with use_experimental_fw=1
> user: ok, but how to do this 
> sgruszka: echo "options iwlagn use_experiental_fw=1" >> /etc/modprobe.d/iwlwifi.conf
> sgruszka: and restart the system
> user: hmm, I have error
> user: bash: /etc/modprobe.d/iwlwifi.conf: Permission denied 
> sgruszka: login as root
> user: ok I did, but new firmware did not help me
> sgruszka: show me dmesg please
> user: dmesg
> sgruszka: old firmware is used
> sgruszka: gash, I made a typo, it should be
> sgruszka: echo "options iwlagn use_experimental_fw=1" >> /etc/modprobe.d/iwlwifi.conf
> sgruszka: grrrrrrr
> 
there is a "ucode_alternative" module parameter already there which
doing the similar thing

I agree there will be mistake, but whoever want to use the experimental
uCode should know what they are doing, otherwise, regular uCode
works.right?

Wey


