Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65338 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab1LLJbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 04:31:51 -0500
Received: by dajs34 with SMTP id s34so1527021daj.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2011 01:31:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323680444.3442.5.camel@jlt3.sipsolutions.net>
References: <CAMG6FYgGB12s+vTGRuKb1E8qzwMa3=kV2pm5ZFQ=BO4WqqZSRQ@mail.gmail.com>
	<1323680444.3442.5.camel@jlt3.sipsolutions.net>
Date: Mon, 12 Dec 2011 10:31:46 +0100
Message-ID: <CAMG6FYgO_LPwMWL1K1+PPVqZJkVj4gaQiyB+PX-NtOe1aPH1aw@mail.gmail.com> (sfid-20111212_103154_617411_6B62D340)
Subject: Re: [PATCH] mac80211: Do not request FIF_BCN_PRBRESP_PROMISC for HW scan.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Bartosz.Markowski@tieto.com,
	Janusz.Dziedzic@tieto.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 12, 2011 at 10:00 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2011-12-11 at 22:47 +0100, Dmitry Tarnyagin wrote:
>> ieee80211_configure_filter code used local->scanning as a boolean value
>> when it was a bit mask. Bits SCAN_HW_SCANNING, SCAN_COMPLETED, SCAN_ABORTED
>> should not set FIF_BCN_PRBRESP_PROMISC filter.
>
> Seems right -- although the probresp-promisc filter thing is debatable
> and I think the changelog should be more explicit about it, maybe saying
> that the driver can always change that by itself in the hw scan callback
> if it requires it... That part isn't really only bugfix, it's a semantic
> change.
>
Well, then the semantic should be at least consistent. Scan code does
not specially
configure filter for hw scans, nor after scan complete. But any 3rd
party config-filter
requests during an active scan enable probresp-promisc.
