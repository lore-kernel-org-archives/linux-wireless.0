Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:57965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377AbZHJJCk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 05:02:40 -0400
Date: Mon, 10 Aug 2009 11:04:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Set WEP ciphers
Message-ID: <20090810090447.GA5421@sortiz.org>
References: <20090806190439.GA22647@sortiz.org> <1249680982.26088.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249680982.26088.48.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Fri, Aug 07, 2009 at 04:36:22PM -0500, Dan Williams wrote:
> On Thu, 2009-08-06 at 21:04 +0200, Samuel Ortiz wrote:
> > With iwconfig there is no way to properly set the ciphers when trying to
> > connect to a WEP SSID. Although mac80211 based drivers dont need it, several
> > fullmac drivers do.
> > This patch basically sets the WEP ciphers whenever they're not set at all.
> 
> If you're talking about Dynamic WEP, that's what wpa_supplicant is for,
> it will handle setting the ciphers through SIOCSIWENCODEEXT.
No, I'm not talking about dynamic WEP, but rather about "iwconfig wlan0 key
your_static_key".


> If you're talking about static WEP, then the ciphers are determined by
> the WEP keys that have been set with iwconfig, and you determine
> WEP40/WEP104 based on the length of the current WEP TX index.
In theory, yes, but our driver's UMAC wants to get the key cipher before
having actually set the keys, and with the latest key handling rework we get
our connect() handler called before keys are actually set.


> You should *not* be trying to do Dynamic WEP via iwconfig (which it
> seems is what you're doing below?)
No, that's not what we're trying to do.

Cheers,
Samuel.


> Dan
> 
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> >  net/wireless/sme.c |   18 ++++++++++++++++--
> >  1 files changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> > index 8a7dcbf..b78a111 100644
> > --- a/net/wireless/sme.c
> > +++ b/net/wireless/sme.c
> > @@ -638,14 +638,28 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
> >  
> >  	if (connkeys && connkeys->def >= 0) {
> >  		int idx;
> > +		u32 cipher;
> >  
> >  		idx = connkeys->def;
> > +		cipher = connkeys->params[idx].cipher;
> >  		/* If given a WEP key we may need it for shared key auth */
> > -		if (connkeys->params[idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
> > -		    connkeys->params[idx].cipher == WLAN_CIPHER_SUITE_WEP104) {
> > +		if (cipher == WLAN_CIPHER_SUITE_WEP40 ||
> > +		    cipher == WLAN_CIPHER_SUITE_WEP104) {
> >  			connect->key_idx = idx;
> >  			connect->key = connkeys->params[idx].key;
> >  			connect->key_len = connkeys->params[idx].key_len;
> > +
> > +			/*
> > +			 * If ciphers are not set (e.g. when going through
> > +			 * iwconfig), we have to set them appropriately here.
> > +			 */
> > +			if (connect->crypto.cipher_group == 0)
> > +				connect->crypto.cipher_group = cipher;
> > +
> > +			if (connect->crypto.n_ciphers_pairwise == 0) {
> > +				connect->crypto.n_ciphers_pairwise = 1;
> > +				connect->crypto.ciphers_pairwise[0] = cipher;
> > +			}					
> >  		}
> >  	}
> >  
> > -- 
> > 1.6.3.1
> > 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
