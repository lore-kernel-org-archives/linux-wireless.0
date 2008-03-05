Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:51761 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbYCESbT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 13:31:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] mac80211: fix races between siwessid and siwencode
Date: Wed, 5 Mar 2008 19:30:14 +0100
Cc: Joonwoo Park <joonwpark81@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <1204710009-10040-1-git-send-email-joonwpark81@gmail.com> <1204741351.9378.11.camel@localhost.localdomain>
In-Reply-To: <1204741351.9378.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803051930.14693.mb@bu3sch.de> (sfid-20080305_183123_764009_90467717)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 March 2008 19:22:31 Dan Williams wrote:
> On Wed, 2008-03-05 at 18:40 +0900, Joonwoo Park wrote:
> > resolve: http://bughost.org/bugzilla/show_bug.cgi?id=1522
> > 
> > The function ieee80211_ioctl_siwencode shouldn't be called if
> > authentication process is not completed.
> > This patch makes the ieee80211_ioctl_siwessid to wait for authentication
> > is completed.
> > 
> > Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> > ---
> >  net/mac80211/ieee80211_ioctl.c |   10 +++++++++-
> >  1 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
> > index 5024d37..55a29f6 100644
> > --- a/net/mac80211/ieee80211_ioctl.c
> > +++ b/net/mac80211/ieee80211_ioctl.c
> > @@ -391,6 +391,7 @@ static int ieee80211_ioctl_siwessid(struct net_device *dev,
> >  	if (sdata->vif.type == IEEE80211_IF_TYPE_STA ||
> >  	    sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
> >  		int ret;
> > +		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
> >  		if (sdata->flags & IEEE80211_SDATA_USERSPACE_MLME) {
> >  			if (len > IEEE80211_MAX_SSID_LEN)
> >  				return -EINVAL;
> > @@ -405,8 +406,15 @@ static int ieee80211_ioctl_siwessid(struct net_device *dev,
> >  		ret = ieee80211_sta_set_ssid(dev, ssid, len);
> >  		if (ret)
> >  			return ret;
> > +
> > +		set_bit(IEEE80211_STA_REQ_RUN, &sdata->u.sta.request);
> > +
> >  		ieee80211_sta_req_auth(dev, &sdata->u.sta);
> > -		return 0;
> > +
> > +		ret = wait_event_interruptible_timeout(wq,
> > +			!test_bit(IEEE80211_STA_REQ_RUN, &sdata->u.sta.request),
> > +				HZ);
> > +		return (ret == HZ) ? 0 : ret;
> 
> NAK; setting the SSID should never block for long; it _certainly_
> shouldn't block waiting on other WEXT calls.  The association process
> needs to be asynchronous.

Doesn't this also cause a RTNL-lock deadlock?

-- 
Greetings Michael.
