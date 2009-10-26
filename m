Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42598 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZJZIT6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 04:19:58 -0400
Received: by ewy4 with SMTP id 4so3366346ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 01:20:01 -0700 (PDT)
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com
Subject: Re: [RFC 1/3] mac80211: WIP - add operating BSSID to device configuration struct
References: <1255696042-28413-1-git-send-email-luciano.coelho@nokia.com>
	<1255696042-28413-2-git-send-email-luciano.coelho@nokia.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 26 Oct 2009 10:19:58 +0200
In-Reply-To: <1255696042-28413-2-git-send-email-luciano.coelho@nokia.com> (Luciano Coelho's message of "Fri\, 16 Oct 2009 15\:27\:20 +0300")
Message-ID: <87tyxmh8i9.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luciano Coelho <luciano.coelho@nokia.com> writes:

> Some chips need to know the BSSID that we are interested in before we start
> the association process.  This patch adds an operating BSSID to the device
> configuration struct ieee80211_conf so that it can be passed to the driver
> when op_config is called.
>
> With this solution we also solve the problem of some chips that require
> an explicit disconnect command when disassociating.

You could explain here more how disconnection is possible. It's not
obvious from the commit log.

> + * @oper_bssid: BSSID on which we are operating; some chips need to know
> + *    which BSSID we are "tuned" to in order to improve power management,
> + *    coexistence with other technologies (such as Bluetooth) and other
> + *    filtering issues.

"Tuned" is confusing here. Also I think it's enough to specify the
reasons in the commit log, and here just explain what the parameters
is used for. Maybe something like this:

* @oper_bssid: BSSID on which we are operating; some chips need to
*    know the BSSID before association. If zero, there is no
*    association established nor any requests of it.

-- 
Kalle Valo
