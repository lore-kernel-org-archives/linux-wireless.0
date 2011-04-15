Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28058 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab1DOHGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 03:06:24 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 00:05:58 -0700
Date: Fri, 15 Apr 2011 12:36:26 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k_htc: Cleanup HTC debugfs
Message-ID: <20110415070626.GB23429@vmraj-lnx.users.atheros.com>
References: <1302848033-7072-1-git-send-email-rmanoharan@atheros.com>
 <1302848033-7072-2-git-send-email-rmanoharan@atheros.com>
 <19879.59459.480384.309998@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19879.59459.480384.309998@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 15, 2011 at 12:10:03PM +0530, Sujith wrote:
> Rajkumar Manoharan wrote:
> > +	priv->debug.debugfs_phy = debugfs_create_dir("ath9k_htc",
> > +					     priv->hw->wiphy->debugfsdir);
> 
> KBUILD_MODNAME can be used.
> 
> > +	debugfs_create_file("debug", S_IRUSR, priv->debug.debugfs_phy,
> > +				priv, &fops_debug);
> >  
> 
> S_IWUSR.
> 
> >  static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
> >  {
> > -	ath9k_htc_exit_debug(priv->ah);
> >  	ath9k_hw_deinit(priv->ah);
> >  	kfree(priv->ah);
> >  	priv->ah = NULL;
> > @@ -150,6 +149,10 @@ static void ath9k_deinit_device(struct ath9k_htc_priv *priv)
> >  {
> >  	struct ieee80211_hw *hw = priv->hw;
> >  
> > +	if (priv->debug.debugfs_phy) {
> > +		debugfs_remove_recursive(priv->debug.debugfs_phy);
> > +		priv->debug.debugfs_phy = NULL;
> > +	}
> 
> It would be consistent to have this chunk of code in ath9k_htc_exit_debug().
>
I think mac80211 handles debugfs_remove_recursive. isn't it?
If so, Shall I remove it?

--
Rajkumar
