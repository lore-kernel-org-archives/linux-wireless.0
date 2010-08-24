Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39150 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab0HXViW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 17:38:22 -0400
Received: by qyk33 with SMTP id 33so6921273qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Aug 2010 14:38:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1282678054-10894-1-git-send-email-linville@tuxdriver.com>
References: <1282678054-10894-1-git-send-email-linville@tuxdriver.com>
Date: Tue, 24 Aug 2010 17:38:21 -0400
Message-ID: <AANLkTi=g2p8qOMg0Pq=N_tb6t3_6qWg5+WY9yySqPcoA@mail.gmail.com>
Subject: Re: [PATCH 2.6.36] ath5k: check return value of ieee80211_get_tx_rate
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 24, 2010 at 3:27 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> This avoids a NULL pointer dereference as reported here:
>
>        https://bugzilla.redhat.com/show_bug.cgi?id=625889
>
> When the WARN condition is hit in ieee80211_get_tx_rate, it will return
> NULL.  So, we need to check the return value and avoid dereferencing it
> in that case.

Yeah, it's ok with me, but get_tx_rate returning NULL always bugged me.
We could also make mac80211 return rate_lowest_index() here, perhaps?

> Of course, the better question is why are we hitting that condition at
> all...?

Some rate controller decided to stuff -1 in the rate set... no idea
why.

-- 
Bob Copeland %% www.bobcopeland.com
