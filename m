Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:37873 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYLWUW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 15:22:26 -0500
Received: by ewy10 with SMTP id 10so2924267ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 12:22:24 -0800 (PST)
Message-ID: <49514874.8060605@gmail.com> (sfid-20081223_212231_173439_580D4D0C)
Date: Tue, 23 Dec 2008 20:22:12 +0000
MIME-Version: 1.0
To: Richard Farina <sidhayn@gmail.com>
CC: linux-wireless@vger.kernel.org, simon@thekelleys.org.uk,
	jussi.kivilinna@mbnet.fi, acme@ghostprotocols.net, pe1rxq@amsat.org
Subject: Re: [PATCH] wireless: Add channel/frequency conversions to ieee80211.h
References: <1230041018-13341-1-git-send-email-kilroyd@googlemail.com> <49510D4F.7060102@gmail.com>
In-Reply-To: <49510D4F.7060102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Richard Farina wrote:
> David Kilroy wrote:
>> Added mappings for FHSS, DSSS and OFDM channels - with macros to point
>> HR DSSS and ERP to the DSSS mappings. Currently just static inline
>> functions.

>> +/**
>> + * ieee80211_ofdm_chan_to_freq - get channel center frequency
>> + * @s_freq: starting frequency == (dotChannelStartingFactor/2) MHz
>> + * @channel: the OFDM channel
>> + *
>> + * Convert IEEE802.11 OFDM channel to center frequency (MHz)
>> + * Ref IEEE 802.11-2007 section 17.3.8.3.2
>> + */
>> +static inline int ieee80211_ofdm_chan_to_freq(int s_freq, int channel)
>> +{
>> +	if ((channel > 0) && (channel <= 200) &&
>> +	    (s_freq >= 4000))
>> +		return s_freq + (channel * 5);
>> +	else
>> +		return -1;
>> +}

> Any desire to make 184-196 work? These are the 4.9 GHz channels.

Do you see a reason why these channels wouldn't work with these
conversion routines? Or are you asking about corresponding driver support?

>From the ack I assume the latter. My main motivation is to put the
frequency conversions in a common place. In this case for old drivers
which only use the 2.4 GHz band. The 5GHz conversions are just for
completeness.

If drivers don't currently support those channels, I suspect there's a
more significant issue to be addressed first.

> I checked this all out pretty specifically, seems to work well. As if 
> anyone cares but:
> 
> ACKED-By: Rick Farina

Thanks for having a look.



Dave.
