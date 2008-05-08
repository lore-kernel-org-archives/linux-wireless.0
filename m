Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:8083 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYEHOtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 10:49:00 -0400
Received: by nf-out-0910.google.com with SMTP id d3so415432nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 08 May 2008 07:48:54 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: 015-mac80211-tx-info-skb-cb.patch
Date: Thu, 8 May 2008 16:57:27 +0200
Cc: linux-wireless@vger.kernel.org
References: <200805081503.41025.IvDoorn@gmail.com> <1210257820.3547.50.camel@johannes.berg>
In-Reply-To: <1210257820.3547.50.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805081657.27976.IvDoorn@gmail.com> (sfid-20080508_164759_779133_A0A7D142)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 May 2008, Johannes Berg wrote:
> On Thu, 2008-05-08 at 15:03 +0200, Ivo van Doorn wrote:
> > Hi Johannes,
> > 
> > The following patch is intended to be ontop or integrated into your patch:
> > http://johannes.sipsolutions.net/patches/kernel/all/LATEST/015-mac80211-tx-info-skb-cb.patch
> > This fixes a compilation error when mac80211 debug output is disabled.
> > 
> > Ivo
> > ---
> > diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> > index 3b3592f..50edc9d 100644
> > --- a/net/mac80211/tx.c
> > +++ b/net/mac80211/tx.c
> > @@ -223,10 +223,9 @@ static ieee80211_tx_result
> >  ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
> >  {
> >  #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
> > -	struct sk_buff *skb = tx->skb;
> > -	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
> > +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
> >  #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
> > -	struct ieee80211_tx_info *info = (void *)skb->cb;
> > +	struct ieee80211_tx_info *info = (void *)tx->skb->cb;
> 
> Did you send me that before? I seem to have a similar fix already.

No I haven't, I had been compiling mac80211 with VERBOSE_DEBUG on ever
since I added the patches from your tree to rt2x00.git so I never noticed this
bug. I just received the bugreport from somebody at the rt2x00 forum. :)

Since rt2x00.git contains your patches from a week ago, I did check if the
bug was still present in your latest version.
Anyway the important thing is that you have the fix. ;)

Ivo
