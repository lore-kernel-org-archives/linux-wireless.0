Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:43366 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbZFANa2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 09:30:28 -0400
Received: by fg-out-1718.google.com with SMTP id d23so569513fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2009 06:30:29 -0700 (PDT)
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Add sanity check for beacon_int in adhoc/mesh case
References: <20090528162528.GA8117@jm.kir.nu>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 01 Jun 2009 16:30:27 +0300
In-Reply-To: <20090528162528.GA8117@jm.kir.nu> (Jouni Malinen's message of "Thu\, 28 May 2009 19\:25\:28 +0300")
Message-ID: <87skikt72k.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen <jouni.malinen@atheros.com> writes:

> +	/*
> +	 * It looks like mac80211 may end up using beacon interval of zero in
> +	 * some cases (at least for mesh point). Avoid getting into an
> +	 * infinite loop by using a bit safer value instead..
> +	 */
> +	if (intval == 0)
> +		intval = 100;

Maybe a big fat warning here would help with debugging the issue?

-- 
Kalle Valo
