Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47918
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417AbXBENba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 08:31:30 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] d80211: Add API to generate RTS and CTS-to-self frames
Date: Mon, 5 Feb 2007 14:31:23 +0100
Cc: linux-wireless@vger.kernel.org
References: <200702051412.50703.mb@bu3sch.de>
In-Reply-To: <200702051412.50703.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702051431.23796.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 February 2007 14:12, Michael Buesch wrote:
> +static u16 ieee80211_rts_duration(struct ieee80211_local *local,
> +				  size_t frame_len, int rate,
> +				  int erp, int short_preamble)
> +{
> +	u16 dur;
> +
> +	/* Data frame duration */
> +	dur = ieee80211_frame_duration(local, frame_len, rate, erp, short_preamble);
> +	/* ACK duration */
> +	dur += ieee80211_frame_duration(local, 14, rate, erp, short_preamble);
> +	/* CTS duration */
> +	dur += ieee80211_frame_duration(local, 14, rate, erp, short_preamble);

Ok, I just figured out that this is wrong.
It should be length 10, as the FCS length is added in ieee80211_frame_duration.

> +	return dur;
> +}
> +
> +static u16 ieee80211_ctstoself_duration(struct ieee80211_local *local,
> +					size_t frame_len, int rate,
> +					int erp, int short_preamble,
> +					int data_requires_ack)
> +{
> +	u16 dur;
> +
> +	/* Data frame duration */
> +	dur = ieee80211_frame_duration(local, frame_len, rate, erp, short_preamble);
> +	if (data_requires_ack) {
> +		/* ACK duration */
> +		dur += ieee80211_frame_duration(local, 14, rate, erp, short_preamble);
> +	}

Same here.


I will submit a corrected patch, soon.
But please still review this one for other bugs.

-- 
Greetings Michael.
