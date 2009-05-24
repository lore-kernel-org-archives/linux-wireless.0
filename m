Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZEXNTB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 09:19:01 -0400
Subject: Re: [PATCH 2/4] rndis_wlan: explain bits used in key setup code.
From: Dan Williams <dcbw@redhat.com>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090523095659.148960arcvdbb20w@hayate.sektori.org>
References: <20090522144012.8134.27669.stgit@fate.lan>
	 <20090522144020.8134.76073.stgit@fate.lan>
	 <1243004755.2461.10.camel@localhost.localdomain>
	 <20090523095659.148960arcvdbb20w@hayate.sektori.org>
Content-Type: text/plain
Date: Sun, 24 May 2009 09:18:57 -0400
Message-Id: <1243171137.24236.0.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-05-23 at 09:56 +0300, Jussi Kivilinna wrote:
> Quoting "Dan Williams" <dcbw@redhat.com>:
> 
> > On Fri, 2009-05-22 at 17:40 +0300, Jussi Kivilinna wrote:
> >> Driver uses some unnamed bits to control encryption setup. Move these to
> >> enumerations with proper names explaining their meaning.
> >>
> >> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
> >> ---
> >>
> >>  drivers/net/wireless/rndis_wlan.c |   23 ++++++++++++++++++-----
> >>  1 files changed, 18 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/rndis_wlan.c  
> >> b/drivers/net/wireless/rndis_wlan.c
> >> index f9b0a35..8609d28 100644
> >> --- a/drivers/net/wireless/rndis_wlan.c
> >> +++ b/drivers/net/wireless/rndis_wlan.c
> >> @@ -196,6 +196,18 @@ enum ndis_80211_priv_filter {
> >>  	ndis_80211_priv_8021x_wep
> >>  };
> >>
> >> +enum ndis_80211_addkey_bits {
> >> +	ndis_80211_addkey_8021x_auth = cpu_to_le32(1 << 28),
> >> +	ndis_80211_addkey_set_init_recv_seq = cpu_to_le32(1 << 29),
> >> +	ndis_80211_addkey_pairwise_key = cpu_to_le32(1 << 30),
> >> +	ndis_80211_addkey_transmit_key = cpu_to_le32(1 << 31),
> >> +};
> >
> > Enums and defines are usually capitalized in Linux, ie
> > NDIS_80211_ADDKEY_8021X_AUTH, so that they can be separated from
> > non-constant stuff and from function names.  Makes the code more
> > readable.  Any chance you'd mind doing that in this patch since you're
> > touching these bits?
> >
> > Dan
> 
> All the ndis_80211_* enums in rndis_wlan.c are lower case now, so I'd  
> keep it consistent here and change all the enums upper case in  
> separate patch.

Ok, sounds fine.

Dan


