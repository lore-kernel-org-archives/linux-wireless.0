Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54534 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab1GNRFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 13:05:03 -0400
Received: by gwaa18 with SMTP id a18so186121gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jul 2011 10:05:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110714140503.GA2327@redhat.com>
References: <1310640029-22468-1-git-send-email-eliad@wizery.com>
	<20110714140503.GA2327@redhat.com>
Date: Thu, 14 Jul 2011 20:05:02 +0300
Message-ID: <CAB3XZEczvHokbqGKR5NK0KmyBkNHC1TFBNjGTLkXmL8u9cz0nQ@mail.gmail.com> (sfid-20110714_190508_342085_EF3CB7D0)
Subject: Re: [PATCH v2] mac80211: reconfigure tx on device reconfiguration
From: Eliad Peller <eliad@wizery.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 14, 2011 at 5:05 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Jul 14, 2011 at 01:40:29PM +0300, Eliad Peller wrote:
>> +     /* reconfigure tx conf */
>> +     for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
>> +             drv_conf_tx(local, i, &local->tx_conf[i]);
>
> Perhaps you should use hw->queues instead of IEEE80211_MAX_QUEUES ...

sure.
i also found another place in which drv_conf_tx was called but the new
tx configuration wasn't saved (ieee80211_set_txq_params).
i'll send a new version soon.

thanks,
Eliad.
