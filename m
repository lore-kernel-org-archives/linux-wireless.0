Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57219 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab0HYN7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 09:59:42 -0400
Date: Wed, 25 Aug 2010 09:46:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 2.6.36] ath5k: check return value of ieee80211_get_tx_rate
Message-ID: <20100825134626.GE2557@tuxdriver.com>
References: <1282678054-10894-1-git-send-email-linville@tuxdriver.com>
 <AANLkTi=g2p8qOMg0Pq=N_tb6t3_6qWg5+WY9yySqPcoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=g2p8qOMg0Pq=N_tb6t3_6qWg5+WY9yySqPcoA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 24, 2010 at 05:38:21PM -0400, Bob Copeland wrote:
> On Tue, Aug 24, 2010 at 3:27 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > This avoids a NULL pointer dereference as reported here:
> >
> >        https://bugzilla.redhat.com/show_bug.cgi?id=625889
> >
> > When the WARN condition is hit in ieee80211_get_tx_rate, it will return
> > NULL.  So, we need to check the return value and avoid dereferencing it
> > in that case.
> 
> Yeah, it's ok with me, but get_tx_rate returning NULL always bugged me.
> We could also make mac80211 return rate_lowest_index() here, perhaps?

Yeah, I was considering that as an alternative.

> > Of course, the better question is why are we hitting that condition at
> > all...?
> 
> Some rate controller decided to stuff -1 in the rate set... no idea
> why.

Well, I got that part already... :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
