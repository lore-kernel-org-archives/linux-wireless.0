Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab3AIKy4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 05:54:56 -0500
Date: Wed, 9 Jan 2013 11:54:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Johan Danielsson <joda@kth.se>, linux-wireless@vger.kernel.org
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
Message-ID: <20130109105437.GB13513@redhat.com> (sfid-20130109_115502_311300_CBB60B1C)
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com>
 <201301081715.49672.chunkeey@googlemail.com>
 <CAESKgcgN+ev0f-PewqP7k5E-Bq2uR2OPKDiYwrPot4B=CAiffA@mail.gmail.com>
 <201301090038.01984.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201301090038.01984.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Wed, Jan 09, 2013 at 12:38:01AM +0100, Christian Lamparter wrote:
> Yes, this sounds wrong. Was there a historic reason why RX_STOP was put before
> DELBA? I've traced the code back to Intel's initial A-MPDU RX contribution:
> 
> commit 07db218396650933abff3c5c1ad1e2a6e0cfedeb
> Author: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Date:   Tue Dec 25 17:00:33 2007 +0200
> 
>     mac80211: A-MPDU Rx adding basic functionality
> 
> 
> Stanislaw, do you know if iwlegacy needs AGG_RX_STOP before it can sent out
> the DELBA [Maybe something about flushing an FW internal RX reorder buffer,
> or anything]?

I think not, AGG_RX_STOP disable in firmware (ht-immediate) BA response,
when receive AMPDU (for particular station/tid). So ordering: DELBA, then
AGG_RX_STOP should be fine for iwlegacy and iwlwifi.

Thanks
Stanislaw

