Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:33622 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752370AbdBNNdn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:33:43 -0500
Received: by mail-wr0-f181.google.com with SMTP id i10so170316540wrb.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2017 05:33:42 -0800 (PST)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
To: Johannes Berg <johannes@sipsolutions.net>
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
 <1485250815.7244.8.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <fbaa960e-b14a-e50c-c49e-913e823b1e74@broadcom.com> (sfid-20170214_143409_649609_25A2DC48)
Date: Tue, 14 Feb 2017 14:33:39 +0100
MIME-Version: 1.0
In-Reply-To: <1485250815.7244.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-1-2017 10:40, Johannes Berg wrote:
>> +	/* leave request id zero for legacy request
>> +	 * or if driver does not support multi-scheduled scan
>> +	 */
>> +	if (want_multi && rdev->wiphy.max_sched_scan_reqs > 1) {
> 
> Why do the >1 check here? It probably doesn't really make a difference
> since only one can be running at a time, but it might be nicer - at
> least for debug in userspace - to have a real value for all multi
> scans?

I added the check, because drivers not supporting multi-scheduled scan
might not bother using the request id in event reporting.

Regards,
Arend
