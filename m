Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:50581 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXKZXtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 18:49:04 -0500
Received: by py-out-1112.google.com with SMTP id u77so1778796pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 15:49:02 -0800 (PST)
Message-ID: <43e72e890711261549s3d479e48s7a46da05a398c8ee@mail.gmail.com> (sfid-20071126_234909_663184_CFDC05DD)
Date: Mon, 26 Nov 2007 18:49:01 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: signal quality names
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
In-Reply-To: <200711231149.26047.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200711231149.26047.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 22, 2007 9:49 PM, bruno randolf <bruno@thinktube.com> wrote:
> On Sun Apr 15 06:22:46 CEST 2007 Larry Finger wrote:
> > The variables in mac80211 are confusing and should be renamed; however,
> > that may take, some time to reach a consensus.
>
> this was seven month ago. has there been any consensus reached?
>
> the current names are very misleading:
>
> /**
>  * struct ieee80211_rx_status - receive status
>  * [...]
>  * @ssi: signal strength when receiving this frame
>  * @signal: used as 'qual' in statistics reporting
>  * @noise: PHY noise when receiving this frame
>
> no units are specified. so this increases the confusion we have already
> because of poorly defined wireless extensions. please let's not repeat this
> mistake and let's try to standardize the reporting of signal and noise values
> across drivers at least up to mac80211.
>
> i see that most of the drivers already try to report signal and noise ('ssi'
> and 'noise' according to the current naming) in dBm values and calculate a
> quality percentage (current name: 'signal') based on different factors.
>
> so may i suggest to use variable names like
>
> signal_dbm
> noise_dbm
>
> then? or leave them as 'signal' and 'noise' and make it clear in the kerneldoc
> that we expect dBm.
>
> if there are drivers which cannot convert their internal values into dBm, we
> could provide an alternative 'ssi' (or similar, positive, unit-less,
> un-defined) to allow for that and handle the differences in reporting (to
> wext and for the radiotap headers) inside mac80211.
>
> and could we move the quality calculation up into mac80211 to have consistency
> and comparable values across drivers?
>
> i am willing to do the work.

Since you are, check out our TODO list:

http://linuxwireless.org/en/developers/todo-list

Specifically the section which mentions RCPI, "the 'Received Channel
Power Indicator' - which is defined in IEEE 802.11k (the Radio
Measurements amendment to 802.11)" and the thread that discussed this.
Simon had suggested we move to this for signal strength measurement.
It seems to be the right approach and perhaps there are other
adjustments we can make based on advancements of 802.11k.

  Luis
