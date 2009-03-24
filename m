Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:16192 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZCXDAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 23:00:20 -0400
Received: by fg-out-1718.google.com with SMTP id 16so482738fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 23 Mar 2009 20:00:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237859527.5714.60.camel@marvin>
References: <1237849455.16745.41.camel@marvin>
	 <43e72e890903231610k54ba0f15hf1e3146290c7d67a@mail.gmail.com>
	 <1237859527.5714.60.camel@marvin>
Date: Tue, 24 Mar 2009 03:00:17 +0000
Message-ID: <3ace41890903232000r165ed962o4a024050cd6c1a31@mail.gmail.com> (sfid-20090324_040028_582850_83410B35)
Subject: Re: [BUG] rtl8187, cfg80211 - unable to handle kernel NULL pointer
	dereference
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Martin Capitanio <martin@capitanio.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Larry.Finger@lwfinger.net,
	herton@mandriva.com.br, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 24, 2009 at 1:52 AM, Martin Capitanio <martin@capitanio.org> wrote:
> Am Montag, den 23.03.2009, 16:10 -0700 schrieb Luis R. Rodriguez:
>> On Mon, Mar 23, 2009 at 4:04 PM, Martin Capitanio <martin@capitanio.org> wrote:
>> > Setting the EU or DE regulatory domain (cfg80211 ieee80211_regdom=EU)
>> > seems to be working, but afterwards inserting the rtl8187 driver causes crash:
>>
>> Please try with today's wireless-testing a set of fixes went in to
>
> Sure, I tried "DE" with the same result as well.
>
> Fortunately, wireless-testing doesn't crash during the rtl8187 driver load
> anymore, but changing the regulatory domain seems to be no-op (see below).
<snipped>

I have yesterday's compat-wireless (v2.6.29-rc8-18669-g77f1f84), and
setting EU seems to make it stop responding to setting anything else
(no more CRDA dmesg messages after the EU entry) - the driver is still
operational though...
will give today's wireless-testing a try :-).

cfg80211: Calling CRDA for country: DE
cfg80211: Regulatory domain changed to country: DE
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
	(5150000 KHz - 5255000 KHz @ 40000 KHz), (N/A, 2301 mBm)
	(5470000 KHz - 5650000 KHz @ 40000 KHz), (N/A, 3000 mBm)
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
	(2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
	(5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
	(5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5490000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
	(5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: EU
