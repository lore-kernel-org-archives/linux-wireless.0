Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39346 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2IYS3Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2012 14:29:24 -0400
Received: by pbbrr4 with SMTP id rr4so540368pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2012 11:29:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <773DB8A82AB6A046AE0195C68612A3190138FB68@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A3190138FB68@sbs2003.acksys.local>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Tue, 25 Sep 2012 11:29:04 -0700
Message-ID: <CAG6hwVOXXBTyrixToYaFnpiq_WUhSt7uLyHRL=WqQHUdpg4G_g@mail.gmail.com> (sfid-20120925_202928_405780_DFE277D0)
Subject: Re: Unexpected periodical Wi-Fi speed drop
To: Cedric Debarge <cedric.debarge@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cedric,

On Mon, Sep 24, 2012 at 5:57 AM, Cedric Debarge
<cedric.debarge@acksys.fr> wrote:
>>I am encountering a periodic (each 1 second) Wi-Fi transmission speed drop (from 54Mbps to 6Mbps) during an iperf between two mesh portals.
>>The speed stays stuck to 6Mbps during about 300ms and then recovers its 54Mbps rate. About 1 second later this happen again.

This looks like a regression we had where peer rates were
re-initialized on each beacon and was fixed in
bae35d92b6a1b6fd8c699415ab90aeeea2a56bc3 "mac80211: don't re-init rate
control when receiving mesh beacon". You should be able to find this
fix in compat-wireless since 8/23.

Thomas
