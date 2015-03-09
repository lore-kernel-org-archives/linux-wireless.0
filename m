Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0173.hostedemail.com ([216.40.44.173]:47050 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751652AbbCITHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 15:07:42 -0400
Message-ID: <1425928057.5428.53.camel@perches.com> (sfid-20150309_200745_498522_19CEF2B5)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Mon, 09 Mar 2015 12:07:37 -0700
In-Reply-To: <wrfjtwxuouyx.fsf@ultrasam.lan.trained-monkey.org>
References: <1425920453-25099-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1425920453-25099-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1425925248.5428.39.camel@perches.com>
	 <wrfj385eqafd.fsf@ultrasam.lan.trained-monkey.org>
	 <1425927092.5428.49.camel@perches.com>
	 <wrfjtwxuouyx.fsf@ultrasam.lan.trained-monkey.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 15:02 -0400, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > On Mon, 2015-03-09 at 14:43 -0400, Jes Sorensen wrote:
> >> Joe Perches <joe@perches.com> writes:
> >> > On Mon, 2015-03-09 at 13:00 -0400, Jes.Sorensen@redhat.com wrote:
> >> >> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
> >> >> from scratch utilizing the mac80211 stack.
> >> >
> >> > Mostly trivial comments:
> >> >
> >> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> > []
> >> >> +RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
> >> >> +M:	Jes Sorensen <Jes.Sorensen@redhat.com>
> >> >> +L:	linux-wireless@vger.kernel.org
> >> >> +W:	http://intellinuxwireless.org
> >> >> +T:	git git://git.Mkernel.org/pub/scm/linux/kernel/git/jes/linux.git
> >> >> +	git branch rtl8723au-mac80211
> >> >
> >> > please keep this on one line
> >> 
> >> Lines are 80 characters, and it won't fit.
> >
> > For code yes, for MAINTAINERS no.
> > There are many lines > 80 chars there.
> > Please keep:
> > <TYPE>:	entry
> > on single lines.
> 
> Longer than 80 characters is ugly and you haven't provided any
> justification for putting it on one line.

<TYPE>: entries are single line.

> >> >> +struct rtl8xxxu_priv {
> >> > []
> >> >> +	u32 has_wifi:1;
> >> >> +	u32 has_bluetooth:1;
> >> >> +	u32 enable_bluetooth:1;
> >> >> +	u32 has_gps:1;
> >> >> +	u32 vendor_umc:1;
> >> >> +	u32 has_polarity_ctrl:1;
> >> >> +	u32 has_eeprom:1;
> >> >> +	u32 boot_eeprom:1;
> >> >> +	u32 ep_tx_high_queue:1;
> >> >> +	u32 ep_tx_normal_queue:1;
> >> >> +	u32 ep_tx_low_queue:1;
> >> >> +	u32 path_a_hi_power:1;
> >> >
> >> > These might be better as bool instead of packed bitfields.
> >> 
> >> bool wastes 4 bytes in the struct, so no that would be worse.
> >
> > It's a used-once struct.  4 bytes, wow.
> 
> Once per device - but it all comes down to a matter of style and taste
> of the developer in the end. You seem to be obsessed with imposing your
> ideas on everybody, rather than actually looking for real bugs.

I'm not imposing anything.
You can accept it or not.

btw: every use of any bitfield requires more code
     for RMW than a byte access does.


