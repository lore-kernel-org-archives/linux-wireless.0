Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:35498 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbYA2PE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2008 10:04:27 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3653479wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2008 07:04:27 -0800 (PST)
Message-ID: <1ba2fa240801290704o63812983l1eca87eb2ad3a159@mail.gmail.com> (sfid-20080129_150432_478637_24EA9F40)
Date: Tue, 29 Jan 2008 17:04:25 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/2] cfg80211 API for channels/bitrates, mac80211 and driver conversion
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1201615517.4394.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080124183837.577631000@sipsolutions.net>
	 <20080124184357.839387000@sipsolutions.net>
	 <1ba2fa240801271649j3b337b1aq182c8fd8303d7606@mail.gmail.com>
	 <1201615517.4394.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 29, 2008 4:05 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Also inserting few, actually drawing it unusable. You are lucky we
> > like you here :)
> > The question is how we handle this?. Do you want  to resubmit this
> > huge patch or we fix it somehow over it...
>
> Can you point out any bugs? It works with my iwl4965 card (and the fix
> for the unfortunate bug for the scanning problem).
>

1. As I wait box we lost scanning in A mode, we have WARN_ON(1) on
every RX packet now because of invalid rate
2. There are few sparse bugs if you run it - don't remember exactly
3. HT doesn't compile bug  this I want to fix over HT AGG patches
4. Few problems in code I spotted but there are probably many
For example in RX path
  rate_idx = iwl4965_hw_get_rate(
				le32_to_cpu(rx_start->rate_n_flags)),

This is wrong
1. the le_to_cpu is redundant (it's aleardy done in hw)
2. it will give you rate in plcp format and not the index

I rather do better review of this... first I want to put this patch
above HT agg patches

Thanks
Tomas







> johannes
>
