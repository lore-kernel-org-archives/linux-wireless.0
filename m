Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:27464 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYJJMVA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 08:21:00 -0400
Received: by fg-out-1718.google.com with SMTP id 19so324756fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 05:20:58 -0700 (PDT)
Message-ID: <1ba2fa240810100520h7d51624fr468aad2c6def62e2@mail.gmail.com> (sfid-20081010_142107_286658_9B42228A)
Date: Fri, 10 Oct 2008 14:20:58 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi: bug in iwl_tx_skb
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223543081.22490.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1223543081.22490.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 9, 2008 at 11:04 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> When iwl_txq_update_write_ptr fails, you have a huge problem: the skb is
> linked on the queue, the write_ptr has been incremented, but you pretend
> you can just free it.

It's not freed it's should be picket in the next round. We should
really return success to mac80211 in case
HW is not awake which is only sound reason it will fail.
Thanks
Tomas
