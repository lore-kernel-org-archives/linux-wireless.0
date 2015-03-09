Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbbCITCW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 15:02:22 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1425920453-25099-1-git-send-email-Jes.Sorensen@redhat.com>
	<1425920453-25099-2-git-send-email-Jes.Sorensen@redhat.com>
	<1425925248.5428.39.camel@perches.com>
	<wrfj385eqafd.fsf@ultrasam.lan.trained-monkey.org>
	<1425927092.5428.49.camel@perches.com>
Date: Mon, 09 Mar 2015 15:02:14 -0400
In-Reply-To: <1425927092.5428.49.camel@perches.com> (Joe Perches's message of
	"Mon, 09 Mar 2015 11:51:32 -0700")
Message-ID: <wrfjtwxuouyx.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150309_200225_287781_8C1E3BA4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Mon, 2015-03-09 at 14:43 -0400, Jes Sorensen wrote:
>> Joe Perches <joe@perches.com> writes:
>> > On Mon, 2015-03-09 at 13:00 -0400, Jes.Sorensen@redhat.com wrote:
>> >> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
>> >> from scratch utilizing the mac80211 stack.
>> >
>> > Mostly trivial comments:
>> >
>> >> diff --git a/MAINTAINERS b/MAINTAINERS
>> > []
>> >> +RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
>> >> +M:	Jes Sorensen <Jes.Sorensen@redhat.com>
>> >> +L:	linux-wireless@vger.kernel.org
>> >> +W:	http://intellinuxwireless.org
>> >> +T:	git git://git.Mkernel.org/pub/scm/linux/kernel/git/jes/linux.git
>> >> +	git branch rtl8723au-mac80211
>> >
>> > please keep this on one line
>> 
>> Lines are 80 characters, and it won't fit.
>
> For code yes, for MAINTAINERS no.
> There are many lines > 80 chars there.
> Please keep:
> <TYPE>:	entry
> on single lines.

Longer than 80 characters is ugly and you haven't provided any
justification for putting it on one line.

>> >> +static void rtl8xxxu_phy_iqcalibrate(struct rtl8xxxu_priv *priv,
>> >> +				     int result[][8], int t, bool is_2t)
>> >> +{
>> >> +	struct device *dev = &priv->udev->dev;
>> >> +	u32 i, val32;
>> >> +	int path_a_ok /*, path_b_ok */;
>> >> +	int retry = 2;
>> >> +
>> >> +	u32 ADDA_REG[RTL8XXXU_ADDA_REGS] = {
>> >> +		REG_FPGA0_XCD_SWITCH_CTRL, REG_BLUETOOTH,
>> >> +		REG_RX_WAIT_CCA, REG_TX_CCK_RFON,
>> >> +		REG_TX_CCK_BBON, REG_TX_OFDM_RFON,
>> >> +		REG_TX_OFDM_BBON, REG_TX_TO_RX,
>> >> +		REG_TX_TO_TX, REG_RX_CCK,
>> >> +		REG_RX_OFDM, REG_RX_WAIT_RIFS,
>> >> +		REG_RX_TO_RX, REG_STANDBY,
>> >> +		REG_SLEEP, REG_PMPD_ANAEN
>> >> +	};
>> >
>> > static const is generally better.
>> 
>> It's irrelevant
>
> Not really, it requires an initialization on entry
> and would make the object code smaller to use const.

As I said, it's irrelevant. The gain from this is microscopic, sure it
can be done, but it's not a priority.

>> >> +struct rtl8xxxu_priv {
>> > []
>> >> +	u32 has_wifi:1;
>> >> +	u32 has_bluetooth:1;
>> >> +	u32 enable_bluetooth:1;
>> >> +	u32 has_gps:1;
>> >> +	u32 vendor_umc:1;
>> >> +	u32 has_polarity_ctrl:1;
>> >> +	u32 has_eeprom:1;
>> >> +	u32 boot_eeprom:1;
>> >> +	u32 ep_tx_high_queue:1;
>> >> +	u32 ep_tx_normal_queue:1;
>> >> +	u32 ep_tx_low_queue:1;
>> >> +	u32 path_a_hi_power:1;
>> >
>> > These might be better as bool instead of packed bitfields.
>> 
>> bool wastes 4 bytes in the struct, so no that would be worse.
>
> It's a used-once struct.  4 bytes, wow.

Once per device - but it all comes down to a matter of style and taste
of the developer in the end. You seem to be obsessed with imposing your
ideas on everybody, rather than actually looking for real bugs.

>> If you have any *bugs* to report, I welcome those comments very much.
>> However if you are just looking to nag, please do that somewhere else.
>
> Imperious much?

So far you have reported one real bug (the endian issue) and a couple of
trailing whitespace and messed up indentation issues. If you find more
*real* issues to report, I would welcome those reports very much.

However you are clearly on a mission to have the last word on every
patch posted to the kernel - how about looking at real bugs or writing
code instead, that would be a lot more constructive for the kernel as a
whole!

Jes
