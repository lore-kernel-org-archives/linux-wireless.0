Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33173 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756793AbaGWQel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2014 12:34:41 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: <ath10k@lists.infradead.org>,
	<mathias.kretschmer@fokus.fraunhofer.de>,
	<kgiori@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<sven@narfation.org>
Subject: Re: [PATCHv2 2/2] ath10k: add spectral scan feature
References: <1405945943-8303-1-git-send-email-sw@simonwunderlich.de>
	<1405945943-8303-3-git-send-email-sw@simonwunderlich.de>
	<87zjg1tfjd.fsf@kamboji.qca.qualcomm.com>
	<201407231712.43500.sw@simonwunderlich.de>
Date: Wed, 23 Jul 2014 19:34:33 +0300
In-Reply-To: <201407231712.43500.sw@simonwunderlich.de> (Simon Wunderlich's
	message of "Wed, 23 Jul 2014 17:12:43 +0200")
Message-ID: <8738dst4o6.fsf@kamboji.qca.qualcomm.com> (sfid-20140723_183444_831807_B01CD6D2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> Hey Kalle,
>
> thanks for all the comments!
>
> I'll make the changes as you suggested, although I'd like to point out that 
> the "empty line before comment" and the "no indentation for WMI command 
> parameters" things are not really consistent - there are also empty lines 
> missing (e.g. struct wmi_start_scan_cmd) and indentation present (e.g. 
> ath10k_wmi_peer_assoc and many others). Maybe that should be cleaned up at 
> some point if you think that's important. :)

Yeah, I have been sloppy in reviewing those part before but not anymore
:) Also struct ath10k is quite a mess now. Sorry for the confusion.

I'm planning to fix these at some point, but if someone else wants to do
it I'm very happy to take patches.

>> > +struct fft_sample_ath10k {
>> > +	struct fft_sample_tlv tlv;
>> > +	u8 chan_width_mhz;
>> > +	__be16 freq1;
>> > +	__be16 freq2;
>> > +	__be16 noise;
>> > +	__be16 max_magnitude;
>> > +	__be16 total_gain_db;
>> > +	__be16 base_pwr_db;
>> > +	__be64 tsf;
>> > +	s8 max_index;
>> > +	u8 rssi;
>> > +	u8 relpwr_db;
>> > +	u8 avgpwr_db;
>> > +	u8 max_exp;
>> > +
>> > +	u8 data[0];
>> > +} __packed;
>> 
>> __be16, that's a first. Just making sure that this really is big endian?
>
> As the __le32 you use in other ath10k structs, this is just for checking - at 
> least sparse should check that, maybe other tools as well.

Sorry, I didn't understand your comment here. But basically I was asking
is the fft sample really in big endian? I assume it would be little
endian as everything else coming from the firmware.

-- 
Kalle Valo
