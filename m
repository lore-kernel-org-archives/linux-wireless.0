Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49335 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbcAaT0s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 14:26:48 -0500
Message-ID: <1454268405.5351.2.camel@sipsolutions.net> (sfid-20160131_202654_697393_996A801B)
Subject: Re: rtl8xxxu (mac80211) not working with rtl8723au
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <jes.sorensen@gmail.com>,
	=?ISO-8859-1?Q?Andr=E9?= Vitor <andrevdj@gmail.com>,
	linux-wireless@vger.kernel.org
Date: Sun, 31 Jan 2016 20:26:45 +0100
In-Reply-To: <56ABC964.10808@gmail.com> (sfid-20160129_211954_867665_4C860B5B)
References: <CAP1NbjnOYorDuoTcsEUX76Ei0jievissNNNf=WN_uuwZNiRkwg@mail.gmail.com>
	 <CAP1NbjmewVTQ6KbY7fkgdhJ6iMSg0tO9g1P6Usymi3EmfmVA8w@mail.gmail.com>
	 <56ABC964.10808@gmail.com> (sfid-20160129_211954_867665_4C860B5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-01-29 at 15:19 -0500, Jes Sorensen wrote:
> 
> > /home/andre64/m-x86/kernel/net/mac80211/rx.c:3619
> > ieee80211_rx_napi+0x63/0x60f [mac80211]()
> > 
> This part looks suspicious to me - this is the NAPI stack spitting
> out slowpath warnings.

No, it's not ... it's just a mac80211 warning:

                if (status->flag & RX_FLAG_HT) {
...
                } else if (status->flag & RX_FLAG_VHT) {
...
                } else {
                        if (WARN_ON(status->rate_idx >= sband->n_bitrates))
                                goto drop;


johannes
