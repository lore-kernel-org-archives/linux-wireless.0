Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992961AbXDRRwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 13:52:21 -0400
Subject: Re: [PATCH] Fix NetworkManager/wpa_supplicant race condition
From: Dan Williams <dcbw@redhat.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	kernel-team@lists.ubuntu.com, Ben Collins <ben.collins@ubuntu.com>,
	mjg59@cavan.codon.org.uk
In-Reply-To: <462649E3.4000208@canonical.com>
References: <462649E3.4000208@canonical.com>
Content-Type: text/plain
Date: Wed, 18 Apr 2007 13:22:34 -0400
Message-Id: <1176916954.20244.14.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-04-18 at 10:40 -0600, Tim Gardner wrote:
> This patch fixes an assumption made by wpa_supplicant. Any time
> wpa_supplicant requests to set an ESSID (e.g., associate), it expects an
> event notifying that association has completed. If the Networkmanager
> has already setup an association, such as for an open auth AP, then the
> request to associate by wpa_supplicant will be ignored.
> 
> If Networkmanager is requested to restart the connection, such as by
> clicking on the SSID, then wpa_supplicant is allowed to build the
> association from scratch, which always works.
> 
> https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.20/+bug/103768
> 
> By always emitting this event, am I causing any unintended side effects?

Interesting.  Setting the SSID should _always_ trigger a reassociation,
and therefore eventually trigger an SIOCGIWAP event to userspace.  So
this patch looks right from the behavioral point of view.

But it doesn't look right from the technical perspective.  Why isn't
softmac trying to reassociate?  Does it automatically reassociate if
parameters, like auth mode, keys, WPA, etc are set and so therefore,
when it comes around to the SSID being set it doesn't really matter?  If
so, we should still be sending the event, and this patch is OK.  But can
somebody _guarantee_ that if I authenticate to an AP, then later call
SIOCSIWENCODE, and then SIOCSIWESSID to the same SSID, that the new WEP
keys have been applied and a reassociation has occurred?  If the auth
mode is shared key, a reassociation attempt needs to happen.

WEXT convention is that setting the SSID or BSSID triggers reassociation
with the current parameters.  I'd argue that softmac should be starting
the association process over again when either SIOCSIWESSID or
SIOCSIWBSSID is called.

Dan

> rtg
> plain text document attachment (bug_103768)
> diff --git a/net/ieee80211/softmac/ieee80211softmac_wx.c b/net/ieee80211/softmac/ieee80211softmac_wx.c
> index fa2f7da..cc2e8ba 100644
> --- a/net/ieee80211/softmac/ieee80211softmac_wx.c
> +++ b/net/ieee80211/softmac/ieee80211softmac_wx.c
> @@ -88,6 +88,13 @@ ieee80211softmac_wx_set_essid(struct net_device *net_dev,
>  		   !memcmp(n->essid.data, extra, n->essid.len)) {
>  			dprintk(KERN_INFO PFX "Already associating or associated to "MAC_FMT"\n",
>  				MAC_ARG(sm->associnfo.bssid));
> +			/* wpa_supplicant expects an association event, regardless of prior
> +			 * association state. If associating, then the associnfo.work task
> +			 * will send the appropriate event.
> +			 */
> +			if (sm->associnfo.associated)
> +				ieee80211softmac_call_events_locked(sm,
> +					IEEE80211SOFTMAC_EVENT_ASSOCIATED, n);
>  			goto out;
>  		} else {
>  			dprintk(KERN_INFO PFX "Canceling existing associate request!\n");

