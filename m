Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:32844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726053AbeHNIAd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 04:00:33 -0400
Date: Tue, 14 Aug 2018 07:14:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Grzegorz =?utf-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: Re: Cpu stall caused by hostapd running two interfaces
Message-ID: <20180814051448.GA2400@redhat.com> (sfid-20180814_071606_908224_0DB526F6)
References: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
 <20180813084123.GA18180@redhat.com>
 <87tvnycw2b.fsf@purkki.adurom.net>
 <CAD7cUuD8b_b3riHPTEXROW64HCF8S0F2_XHgikz1J_seq-QxXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAD7cUuD8b_b3riHPTEXROW64HCF8S0F2_XHgikz1J_seq-QxXQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 08:48:17PM +0200, Grzegorz Duszyński wrote:
> Can I help you somehow with this ?

Enable CONFIG_DEBUG_INFO=y in .config if not done already.
Then do:

make net/mac80211/util.o
gdb net/mac80211/util.o
l *(ieee80211_regulatory_limit_wmm_params+0x6e)

and provide output of gdb l command, this should show code
line number where oops occurs.

Thanks
Stanislaw
