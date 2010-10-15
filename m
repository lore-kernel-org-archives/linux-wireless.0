Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58482 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755044Ab0JOFVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 01:21:53 -0400
Received: from kpbe16.cbf.corp.google.com (kpbe16.cbf.corp.google.com [172.25.105.80])
	by smtp-out.google.com with ESMTP id o9F5LqjS028065
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 22:21:52 -0700
Received: from iwn37 (iwn37.prod.google.com [10.241.68.101])
	by kpbe16.cbf.corp.google.com with ESMTP id o9F5LhBp013624
	for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 22:21:51 -0700
Received: by iwn37 with SMTP id 37so589483iwn.15
        for <linux-wireless@vger.kernel.org>; Thu, 14 Oct 2010 22:21:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101014224326.9E9912005F@glenhelen.mtv.corp.google.com>
References: <20101014224326.9E9912005F@glenhelen.mtv.corp.google.com>
Date: Thu, 14 Oct 2010 22:21:50 -0700
Message-ID: <AANLkTinyc56O-xeYEMSD+B=yWNnd_Ch-NUrPv5uGQyr1@mail.gmail.com>
Subject: Re: [PATCH 2/2] mac80211: Add support for CQM tx bitrate monitoring
From: Paul Stewart <pstew@google.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 14, 2010 at 2:40 PM, Paul Stewart <pstew@google.com> wrote:
> +       if (mcs_rate_table_cache[mcs] == 0) {
> +               modulation = mcs & 7;
> +               streams = (mcs >> 3) + 1;
> +               base_rate = (rate_ptr->flags & IEEE80211_TX_RC_40_MHZ_WIDTH) ?
> +                 13500000 : 6500000;
> +               gi_div = (rate_ptr->flags & IEEE80211_TX_RC_SHORT_GI) ? 9 : 10;
> +               rate_val = base_rate * mod_table[modulation] * streams / gi_div;
> +               mcs_rate_table_cache[mcs] = (rate_val + 5000) / 10000;
> +       }
> +
> +       return  mcs_rate_table_cache[mcs] * 100;
> +}

Um, that doesn't work right.  The cache needs to be 4 times as big to
account for account from 40MHZ and SHORT_GI.  I'll send a revised
version of this tomorrow.

--
Paul
