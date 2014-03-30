Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:64997 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaC3KNI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Mar 2014 06:13:08 -0400
Received: by mail-lb0-f171.google.com with SMTP id w7so4939980lbi.16
        for <linux-wireless@vger.kernel.org>; Sun, 30 Mar 2014 03:13:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <554FD98DB8827B47BDFF0FDF5415A43B035FCF36@MBX13.d.ethz.ch>
References: <554FD98DB8827B47BDFF0FDF5415A43B035FCF36@MBX13.d.ethz.ch>
Date: Sun, 30 Mar 2014 13:13:06 +0300
Message-ID: <CANUX_P0ngyCde5E=QbAN-KBy_h6YyLzLJJrJhfuR+oNrrrLGmQ@mail.gmail.com> (sfid-20140330_121342_440463_31876077)
Subject: Re: tx_retries and tx_failures on iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sim Daniel <simd@student.ethz.ch>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> According to the documentation,
> - tx_failed is the "number of failed transmissions (retries exceeded, no ACK)".
> - tx_retries is the "cumulative retry counts".
>
> Since the default number of retries seems to be 7, I would expect tx_retries to be at least 7 times tx_failed. However, on my computer tx_retries is about 20 times **less**  tx_failed. This doesn't make sense to me. Shouldn't the tx_failed counter increment only after a certain number of retries? And therefore be less than tx_retries?

The default number of retries is 16. The reason you have odd numbers
is because we don't report this properly. The big problem is about
AMPDU mainly - the frames are picked up by the HW and retransmissions
are handled by the FW / HW. While we know how many packets failed vs.
how many were sent (for rate control purposes), we can't know exactly
what frame we retransmitted and how many times (well... we can - but
it is not trivial). Since the the only way to tell mac80211 / cfg80211
/ iw is per-packet (in ieee80211_tx_status in each Tx status for each
packet), the information there is not accurate.

I want to hope that if you disabled AMPDU (Tx) you'll get more
accurate results - I haven't tested myself though.
