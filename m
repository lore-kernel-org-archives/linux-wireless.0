Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755604Ab1AaL33 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:29:29 -0500
Date: Mon, 31 Jan 2011 12:29:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/8] iwlagn: remove
 CONFIG_IWLWIFI_DEBUG_EXPERIMENTAL_UCODE
Message-ID: <20110131112916.GA22367@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
 <1296229671-3041-7-git-send-email-sgruszka@redhat.com>
 <1296231817.7388.18.camel@wwguy-ubuntu>
 <20110128164136.GF2452@redhat.com>
 <1296256821.8832.1.camel@wwguy-ubuntu>
 <20110131094624.GA20641@redhat.com>
 <AANLkTinBneG0nqGFt=mnP0-ZSdLGzdxhfYpyo62WYJQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <AANLkTinBneG0nqGFt=mnP0-ZSdLGzdxhfYpyo62WYJQA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 31, 2011 at 11:23:33AM +0100, Rafał Miłecki wrote:
> >> > Not really. I believe someone who download a tarball, unpack it and copy
> >> > files to /lib/firmware is pretty much aware what he/she is doing.
> >> >
> >> Agree whoever download the tarball know what he/she is doing, but I am
> >> not fully agree the driver always use experimental uCode if it is in the
> >> firmware directory
> >
> > I do not understand what for you need that, but ok, I can live with it.
> >
> > John, please skip this patch.
> 
> Maybe make it module parameter? Like use_experimental_fw, default to 0?

For me that even worse. Now I can provide users with kernel binaries with
enabled experimental fw support. Telling them to install firmware is
enough, to get test results.

With module option:

sgruszka: download exp firmware and load module with use_experimental_fw=1
user: ok, but how to do this 
sgruszka: echo "options iwlagn use_experiental_fw=1" >> /etc/modprobe.d/iwlwifi.conf
sgruszka: and restart the system
user: hmm, I have error
user: bash: /etc/modprobe.d/iwlwifi.conf: Permission denied 
sgruszka: login as root
user: ok I did, but new firmware did not help me
sgruszka: show me dmesg please
user: dmesg
sgruszka: old firmware is used
sgruszka: gash, I made a typo, it should be
sgruszka: echo "options iwlagn use_experimental_fw=1" >> /etc/modprobe.d/iwlwifi.conf
sgruszka: grrrrrrr

Stanislaw
