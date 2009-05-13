Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:54805 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760021AbZEMNX7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 09:23:59 -0400
Subject: Re: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1242205482.14227.44.camel@johannes.local>
References: <1242125077.4331.0.camel@johannes.local>
	 <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
	 <3ace41890905121208s2029db39p730b2e174cd4b1e6@mail.gmail.com>
	 <1242156469.14227.7.camel@johannes.local>
	 <3ace41890905121259jeb504d7v78fe8f062fca7d21@mail.gmail.com>
	 <3ace41890905121400g471d14bfn3f60fba77e097079@mail.gmail.com>
	 <3ace41890905122056v2070d1actdc17f45cc1a3a693@mail.gmail.com>
	 <1242205482.14227.44.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 13 May 2009 09:24:44 -0400
Message-Id: <1242221084.11182.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-13 at 11:04 +0200, Johannes Berg wrote:
> Hi!
> 
> Thanks for the extensive debugging!
> 
> On Wed, 2009-05-13 at 04:56 +0100, Hin-Tak Leung wrote:
> > Hiya, I stuck in a few printk(KERN_DEBUG __LINE__) around the new
> > -EINVAL's and tried to see why setting things by iwconfig manually
> > works, but NM/wpa_supplicant does not,  and here is what I found.
> > Around line 600 of net/wireless/wext-compat.c (this is the hackish mod
> > version):
> > ------------------------------------------
> > int cfg80211_wext_siwencodeext(struct net_device *dev,
> > 	                       struct iw_request_info *info,
> >                                struct iw_point *erq, char *extra)
> > 
> >         switch (ext->alg) {
> > 
> >         case IW_ENCODE_ALG_WEP:
> >                 if (erq->length == 5)
> >                         cipher = WLAN_CIPHER_SUITE_WEP40;
> >                 else if (erq->length == 13)
> > 			cipher = WLAN_CIPHER_SUITE_WEP104;
> >                 else {
> >                   printk(KERN_DEBUG "line %d %d\n", __LINE__, erq->length);
> >                         cipher = WLAN_CIPHER_SUITE_WEP104;
> >                         /* return -EINVAL; */
> >                  }
> >                 break;
> >         }
> 
> Ok, so iwencodeext is used, presumably by wpa_supplicant because NM
> never uses that ioctl, at least not as far as I can tell.
> 
> > ------------------------------------------------
> > For some unknown reason, when run with NM/wpa_supplicant with the same
> > authentication credentials to the same AP, erq->length is 53 instead
> > of 13. 
> 
> That's strange. Do you know which wpa_supplicant version and NM you are
> using? Is it always 53, or could it be random?
> 
> > If I just modify it as above instead of returning EINVAL, then
> > I get to authenticate, etc. in the old mac80211 ioctls, the decision
> > of cipher is postponed a lot later, after playing with the default key
> > a bit?
> > 
> > Anyway, I think 53 is either 40+13 or 13 *4 +1, so is it a case of
> > wpa_supplicant putting more stuff at the end or an offset somewhere?
> 
> No, that's sizeof(struct iw_encode_ext) and now I'm confused as to why
> this actually worked for me. Ok, I see now I think, can you try this
> patch?
> 
> johannes
> 
> --- wireless-testing.orig/net/wireless/wext-compat.c	2009-05-13 11:03:12.000000000 +0200
> +++ wireless-testing/net/wireless/wext-compat.c	2009-05-13 11:03:35.000000000 +0200
> @@ -614,9 +614,9 @@ int cfg80211_wext_siwencodeext(struct ne
>  		cipher = 0;
>  		break;
>  	case IW_ENCODE_ALG_WEP:
> -		if (erq->length == 5)
> +		if (ext->key_len == 5)
>  			cipher = WLAN_CIPHER_SUITE_WEP40;
> -		else if (erq->length == 13)
> +		else if (ext->key_len == 13)
>  			cipher = WLAN_CIPHER_SUITE_WEP104;
>  		else
>  			return -EINVAL;

Yeah, you really do want ext->key_len there, not erq->length.
erq->length is the size of the whole WEXT request, not the key itself.

Dan


