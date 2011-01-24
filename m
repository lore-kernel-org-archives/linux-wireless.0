Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23023 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1AXLWG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 06:22:06 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 03:21:47 -0800
Date: Mon, 24 Jan 2011 16:51:11 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Bruno Randolf <br1@einfach.org>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] RFC: ath: Fix WEP hardware encryption
Message-ID: <20110124112111.GF20058@vasanth-laptop>
References: <20110121101608.22697.88960.stgit@localhost6.localdomain6> <20110121151023.GE20058@vasanth-laptop> <201101221130.25322.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <201101221130.25322.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding  linux-wireless in CC
On Sat, Jan 22, 2011 at 08:00:25AM +0530, Bruno Randolf wrote:
> On Saturday 22 January 2011 00:10:23 Vasanthakumar Thiagarajan wrote:
> > On Fri, Jan 21, 2011 at 03:46:08PM +0530, Bruno Randolf wrote:
> > > I need this to enable HW encryption for WEP.
> > > Otherwise we fall back to software decryption - i only checked the
> > > decryption case.
> > 
> > Encryption/Decryption is done in hw by default. In which case are you
> > seeing it done in sw?.
> 
> Sorry i was not very verbose in my description yesterday.
> 
> I'm seeing the problem when i have an AP configured with WEP.
> 
> The reason is that the index returned by the "reserve_keycache_entry" function 
> (sorry i dont have the code here right now) is >= 4 (hw_key_index) while the 
> key index in the packet header is 0-3. This is ok for transmit but received 
> packets are not decrypted and therefore mac80211 has to decrypt it in SW - 
> this can be easily seen by adding some debug prints in mac80211/wep.c. I have 
> noticed it by watching the system CPU load under high traffic.
> 
> bruno
> 
> > > Any comments?
> > > 
> > > bruno
> > > ---
> > > 
> > >  drivers/net/wireless/ath/key.c |   14 +++++++++++---
> > >  1 files changed, 11 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/wireless/ath/key.c
> > > b/drivers/net/wireless/ath/key.c index 5d465e5..5748dae 100644
> > > --- a/drivers/net/wireless/ath/key.c
> > > +++ b/drivers/net/wireless/ath/key.c
> > > @@ -465,6 +465,16 @@ int ath_key_config(struct ath_common *common,
> > > 
> > >  	hk.kv_len = key->keylen;
> > >  	memcpy(hk.kv_val, key->key, key->keylen);
> > > 
> > > +	/* set WEP keys directly to index */
> > > +	if ((key->cipher == WLAN_CIPHER_SUITE_WEP40 ||
> > > +	     key->cipher == WLAN_CIPHER_SUITE_WEP104) && key->keyidx < 4) {
> > > +		ret = ath_hw_set_keycache_entry(common, key->keyidx, &hk, 
> NULL);
> > > +		if (!ret)
> > > +			return -EIO;
> > > +		set_bit(key->keyidx, common->keymap);
> > > +		return key->keyidx;
> > > +	}
> > > +
> > > 
> > >  	if (!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) {
> > >  	
> > >  		switch (vif->type) {
> > > 
> > >  		case NL80211_IFTYPE_AP:
> > > @@ -541,10 +551,8 @@ EXPORT_SYMBOL(ath_key_config);
> > > 
> > >  void ath_key_delete(struct ath_common *common, struct ieee80211_key_conf
> > >  *key) {
> > >  
> > >  	ath_hw_keyreset(common, key->hw_key_idx);
> > > 
> > > -	if (key->hw_key_idx < IEEE80211_WEP_NKID)
> > > -		return;
> > > -
> > > 
> > >  	clear_bit(key->hw_key_idx, common->keymap);
> > > 
> > > +
> > > 
> > >  	if (key->cipher != WLAN_CIPHER_SUITE_TKIP)
> > >  	
> > >  		return;
