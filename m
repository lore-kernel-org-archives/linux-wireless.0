Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46053 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaLSLFg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 06:05:36 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Y1vNG-0000gG-RS
	for linux-wireless@vger.kernel.org; Fri, 19 Dec 2014 12:05:35 +0100
Message-ID: <1418987132.1889.4.camel@sipsolutions.net> (sfid-20141219_120539_597543_99ADEE34)
Subject: Re: [PATCH 1/2] nl80211: support MSDU statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 19 Dec 2014 12:05:32 +0100
In-Reply-To: <1418919083-28297-1-git-send-email-johannes@sipsolutions.net> (sfid-20141218_171132_119479_078E1815)
References: <1418919083-28297-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20141218_171132_119479_078E1815)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> + * @rx_qos_msdu: QoS-MSDUs received from this station (per TID)
> + * @rx_nonqos_msdu: non-QoS-MSDUs received from this station
> + * @tx_qos_msdu: QoS-MSDUs sent to this station (per TID)
> + * @tx_nonqos_msdu: non-QoS-MSDUs sent to this station

Well, come to think of it, it looks like we'll probably want more
per-TID data in the future, I'll need at least retries and lost MSDUs.

As a consequence, I'm going to make this the other way around and have a
per-TID nesting (using idx 16 for non-QoS) and in there have the
different values. This will also affect the cfg80211 API.

johannes

