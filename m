Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42318 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYKSUQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 15:16:14 -0500
Date: Wed, 19 Nov 2008 15:08:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: sysfs was displaying different values for
	level and noise than procfs
Message-ID: <20081119200856.GH3485@tuxdriver.com> (sfid-20081119_211618_374240_B56BC66B)
References: <200811151831.26403.arvidjaar@mail.ru> <1227122019.2196.14.camel@dv> <200811192245.29487.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200811192245.29487.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 19, 2008 at 10:45:21PM +0300, Andrey Borzenkov wrote:
> On Wednesday 19 November 2008, Pavel Roskin wrote:
> > On Sat, 2008-11-15 at 18:31 +0300, Andrey Borzenkov wrote:
> > > Subject: [PATCH] wireless: sysfs was displaying different values for level and noise than procfs
> > > From: Andrey Borzenkov <arvidjaar@mail.ru>
> > > 
> > > /proc/net/wireless asjusts display of signal and noise level depending on
> > > whether units are percentage or dBm. Use the same format in sysfs. This
> > > makes it easy to know unit - below zero is dBm, above zero is percent.
> > 
> > I've seen received power up to 3 dBm.  The AP was using an amplifier
> > (it's specialized hardware), and it's possible that the card on the
> > station side was exaggerating the signal.  However, the data we report
> > should not need any guesswork to be interpreted.  It may be parsed by
> > userspace software.
> > 
> 
> But positive dBm is not even possible to represnt right now. It is u8 and
> is displayed as ((s32)level - 256); so it is *always* negative.
> 
> > Receiving 1 mW out of 200 mW is not impossible in some antenna
> > configurations even with consumer devices.
> > 
> > > Before:
> > > {pts/1}% cat /sys/class/net/eth1/wireless/level
> > > 203
> > > {pts/1}% cat /sys/class/net/eth1/wireless/noise
> > > 166
> > 
> > > +	return sprintf(buf, format_string, (__s32)iw->field -		\
> > > +			((iw->qual.updated & IW_QUAL_DBM) ? 0x100 : 0)); \
> > 
> > I think non-dBm data should be shown in a special format: "203/255"
> > where 255 is the maximal value, and the dBm data should be shown as
> > numbers: "-48".  This way, we encourage use of dBm data by making it
> > easier to parse.
> > 
> 
> Well, I do not have any strong opinion regarding this; I just noticed
> discrepancy between procfs and sysfs for what effectively is the same raw
> value.

And what is your perspective regarding potential 'userland ABI'
issues of either this patch or of Pavel's suggestion?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
