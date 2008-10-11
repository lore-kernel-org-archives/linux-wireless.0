Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:33540 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbYJKOt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 10:49:57 -0400
Received: by ey-out-2122.google.com with SMTP id 6so377708eyi.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Oct 2008 07:49:56 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: provide sequence numbers
Date: Sat, 11 Oct 2008 16:49:51 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1223637719.17594.6.camel@johannes.berg>
In-Reply-To: <1223637719.17594.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810111649.51946.IvDoorn@gmail.com> (sfid-20081011_165002_966429_7810CE98)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 10 October 2008, Johannes Berg wrote:
> I've come to think that not providing sequence numbers for
> the normal STA mode case was a mistake, at least two drivers
> now had to implement code they wouldn't otherwise need, and
> I believe at76_usb and adm8211 might be broken.
> 
> This patch makes mac80211 assign a sequence number to all
> those frames that need one except beacons. That means that
> if a driver only implements modes that do not do beaconing
> it need not worry about the sequence number.

Very good news. :)

>  	if (!ieee80211_is_data_qos(hdr->frame_control)) {
> +		/* driver should assign sequence number */
>  		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
> +		/* for pure STA mode without beacons, we can do it */
> +		hdr->seq_ctrl = cpu_to_le16(tx->sdata->sequence_number);
> +		tx->sdata->sequence_number += 0x10;
> +		tx->sdata->sequence_number &= IEEE80211_SCTL_SEQ;
>  		return TX_CONTINUE;
>  	}

Shouldn't this be changed to only setting the IEEE80211_TX_CTL_ASSIGN_SEQ
flag when the sequence counter was _not_ set (with beacons)?

Ivo
