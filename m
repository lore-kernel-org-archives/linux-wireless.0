Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.89]:44904 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752157AbZFWLfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:35:07 -0400
Date: Tue, 23 Jun 2009 13:37:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 2/2 RFC] mac80211: connect API port
Message-ID: <20090623113712.GA5349@sortiz.org>
References: <20090622170409.GB30147@sortiz.org> <20090622175154.GC30147@sortiz.org> <1245755947.4184.42.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245755947.4184.42.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Jun 23, 2009 at 01:19:07PM +0200, Johannes Berg wrote:
> On Mon, 2009-06-22 at 19:51 +0200, Samuel Ortiz wrote:
> > With the connect()/disconnect() API, some of the mac80211 STA wext
> > hooks can now move to cfg80211.
> > 
> > Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
> > ---
> >  net/mac80211/cfg.c  |   40 +++++++++++++++++----------
> >  net/mac80211/mlme.c |   15 ----------
> 
> ---
>  net/mac80211/mlme.c |   54 ----------------------------------------------------
>  1 file changed, 54 deletions(-)
I thought about this one, but wasnt sure since we're now sending an
IWEVASSOCRESPIE event while the current code is sending a custom one. I guess
it's fine, just wanted to know if Jouni is fine with it.

Cheers,
Samuel.


> --- wireless-testing.orig/net/mac80211/mlme.c	2009-06-23 13:18:25.000000000 +0200
> +++ wireless-testing/net/mac80211/mlme.c	2009-06-23 13:18:37.000000000 +0200
> @@ -868,59 +868,6 @@ static u32 ieee80211_handle_bss_capabili
>  	return changed;
>  }
>  
> -static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata)
> -{
> -	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> -	char *buf;
> -	size_t len;
> -	int i;
> -	union iwreq_data wrqu;
> -
> -	if (!ifmgd->assocreq_ies && !ifmgd->assocresp_ies)
> -		return;
> -
> -	buf = kmalloc(50 + 2 * (ifmgd->assocreq_ies_len +
> -				ifmgd->assocresp_ies_len), GFP_KERNEL);
> -	if (!buf)
> -		return;
> -
> -	len = sprintf(buf, "ASSOCINFO(");
> -	if (ifmgd->assocreq_ies) {
> -		len += sprintf(buf + len, "ReqIEs=");
> -		for (i = 0; i < ifmgd->assocreq_ies_len; i++) {
> -			len += sprintf(buf + len, "%02x",
> -				       ifmgd->assocreq_ies[i]);
> -		}
> -	}
> -	if (ifmgd->assocresp_ies) {
> -		if (ifmgd->assocreq_ies)
> -			len += sprintf(buf + len, " ");
> -		len += sprintf(buf + len, "RespIEs=");
> -		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
> -			len += sprintf(buf + len, "%02x",
> -				       ifmgd->assocresp_ies[i]);
> -		}
> -	}
> -	len += sprintf(buf + len, ")");
> -
> -	if (len > IW_CUSTOM_MAX) {
> -		len = sprintf(buf, "ASSOCRESPIE=");
> -		for (i = 0; i < ifmgd->assocresp_ies_len; i++) {
> -			len += sprintf(buf + len, "%02x",
> -				       ifmgd->assocresp_ies[i]);
> -		}
> -	}
> -
> -	if (len <= IW_CUSTOM_MAX) {
> -		memset(&wrqu, 0, sizeof(wrqu));
> -		wrqu.data.length = len;
> -		wireless_send_event(sdata->dev, IWEVCUSTOM, &wrqu, buf);
> -	}
> -
> -	kfree(buf);
> -}
> -
> -
>  static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
>  				     u32 bss_info_changed)
>  {
> @@ -953,7 +900,6 @@ static void ieee80211_set_associated(str
>  
>  	ifmgd->flags |= IEEE80211_STA_PREV_BSSID_SET;
>  	memcpy(ifmgd->prev_bssid, sdata->u.mgd.bssid, ETH_ALEN);
> -	ieee80211_sta_send_associnfo(sdata);
>  
>  	ifmgd->last_probe = jiffies;
>  	ieee80211_led_assoc(local, 1);
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
