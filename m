Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54361 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398Ab1HYMie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 08:38:34 -0400
Received: by qwk3 with SMTP id 3so1236964qwk.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 05:38:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGXE3d9mB_jjg38Mmf+B-1RYXjFp0h2hJDkRa+c2wO_OG+BDSw@mail.gmail.com>
References: <1314265865-20208-1-git-send-email-arik@wizery.com> <CAGXE3d9mB_jjg38Mmf+B-1RYXjFp0h2hJDkRa+c2wO_OG+BDSw@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 25 Aug 2011 15:38:19 +0300
Message-ID: <CA+XVXfd4fjtvptRJdcfqYHCkwwreFk7WfGdq9uSjVYpF6zKWcw@mail.gmail.com> (sfid-20110825_143837_970237_519987A2)
Subject: Re: [PATCH 1/2] mac80211: add flag to indicate HW only Tx-agg support
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 25, 2011 at 15:18, Helmut Schaa <helmut.schaa@googlemail.com> wrote:
> Hi,
>
> On Thu, Aug 25, 2011 at 11:51 AM, Arik Nemtsov <arik@wizery.com> wrote:
>> When this flag is set, Tx aggregations will not be initiated even
>> if the hardware supports A-MPDU aggregation in general. This flag
>> is required for devices supporting (partial) software Rx-aggregation.
>
> Is the hardware unable to do TX aggregation?
> Or is it just not implemented?
> Or is it entirely done in hw?

Tx aggregations are done entirely in HW.

>
> Instead of cluttering mac80211 with hw flags you could also just disallow tx
> aggregation sessions in the ampdu_action callback in the driver.

Well the driver is doing some pretty heavy lifting before even calling
the ampdu_action callback. Namely, ieee80211_start_tx_ba_session()
doesn't call it. AFAICT, the return from the callback is only used as
an indication that Tx BA session are temporary unavailable, and
mac80211 should try again. This is not the case here.

Regards,
Arik
