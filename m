Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0070.hostedemail.com ([216.40.44.70]:35085 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751981AbbCISvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 14:51:37 -0400
Message-ID: <1425927092.5428.49.camel@perches.com> (sfid-20150309_195142_355174_1B663994)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Mon, 09 Mar 2015 11:51:32 -0700
In-Reply-To: <wrfj385eqafd.fsf@ultrasam.lan.trained-monkey.org>
References: <1425920453-25099-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1425920453-25099-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1425925248.5428.39.camel@perches.com>
	 <wrfj385eqafd.fsf@ultrasam.lan.trained-monkey.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-09 at 14:43 -0400, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > On Mon, 2015-03-09 at 13:00 -0400, Jes.Sorensen@redhat.com wrote:
> >> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
> >> from scratch utilizing the mac80211 stack.
> >
> > Mostly trivial comments:
> >
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> > []
> >> +RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
> >> +M:	Jes Sorensen <Jes.Sorensen@redhat.com>
> >> +L:	linux-wireless@vger.kernel.org
> >> +W:	http://intellinuxwireless.org
> >> +T:	git git://git.Mkernel.org/pub/scm/linux/kernel/git/jes/linux.git
> >> +	git branch rtl8723au-mac80211
> >
> > please keep this on one line
> 
> Lines are 80 characters, and it won't fit.

For code yes, for MAINTAINERS no.
There are many lines > 80 chars there.
Please keep:
<TYPE>:	entry
on single lines.

> >> +static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
> >> +				     int result[][8], int t, bool is_2t)
> >> +{
> >> +	struct device *dev = &priv->udev->dev;
> >> +	u32 i, val32;
> >> +	int path_a_ok /*, path_b_ok */;
> >> +	int retry = 2;
> >> +
> >> +	u32 ADDA_REG[RTL8XXXU_ADDA_REGS] = {
> >> +		REG_FPGA0_XCD_SWITCH_CTRL, REG_BLUETOOTH,
> >> +		REG_RX_WAIT_CCA, REG_TX_CCK_RFON,
> >> +		REG_TX_CCK_BBON, REG_TX_OFDM_RFON,
> >> +		REG_TX_OFDM_BBON, REG_TX_TO_RX,
> >> +		REG_TX_TO_TX, REG_RX_CCK,
> >> +		REG_RX_OFDM, REG_RX_WAIT_RIFS,
> >> +		REG_RX_TO_RX, REG_STANDBY,
> >> +		REG_SLEEP, REG_PMPD_ANAEN
> >> +	};
> >
> > static const is generally better.
> 
> It's irrelevant

Not really, it requires an initialization on entry
and would make the object code smaller to use const.

> >> +struct rtl8xxxu_priv {
> > []
> >> +	u32 has_wifi:1;
> >> +	u32 has_bluetooth:1;
> >> +	u32 enable_bluetooth:1;
> >> +	u32 has_gps:1;
> >> +	u32 vendor_umc:1;
> >> +	u32 has_polarity_ctrl:1;
> >> +	u32 has_eeprom:1;
> >> +	u32 boot_eeprom:1;
> >> +	u32 ep_tx_high_queue:1;
> >> +	u32 ep_tx_normal_queue:1;
> >> +	u32 ep_tx_low_queue:1;
> >> +	u32 path_a_hi_power:1;
> >
> > These might be better as bool instead of packed bitfields.
> 
> bool wastes 4 bytes in the struct, so no that would be worse.

It's a used-once struct.  4 bytes, wow.

> If you have any *bugs* to report, I welcome those comments very much.
> However if you are just looking to nag, please do that somewhere else.

Imperious much?

