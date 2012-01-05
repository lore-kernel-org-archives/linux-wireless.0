Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:45144 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215Ab2AETP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 14:15:57 -0500
Date: Thu, 5 Jan 2012 11:15:54 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: [PATCH 2/2] brcmfmac: use existing net_device_stats
Message-ID: <20120105111554.57f411d0@nehalam.linuxnetplumber.net> (sfid-20120105_201600_831790_3FB97ACC)
In-Reply-To: <4F05F60C.5030406@broadcom.com>
References: <20120105183947.295358582@vyatta.com>
	<20120105184000.572918423@vyatta.com>
	<4F05F60C.5030406@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 5 Jan 2012 20:12:12 +0100
"Arend van Spriel" <arend@broadcom.com> wrote:

> On 01/05/2012 07:39 PM, Stephen Hemminger wrote:
> > Minor space savings. Compile tested only.
> > 
> 
> This is actually not going to work. The struct brcmf_if represents
> individual interfaces which each have their own device statistics.
> 
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> > 
> > 
> > --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c	2012-01-05 10:02:57.488495190 -0800
> > +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c	2012-01-05 10:09:58.536972268 -0800
> > @@ -56,7 +56,6 @@ struct brcmf_if {
> >  	struct brcmf_info *info;	/* back pointer to brcmf_info */
> >  	/* OS/stack specifics */
> >  	struct net_device *ndev;
> > -	struct net_device_stats stats;
> >  	int idx;		/* iface idx in dongle */
> >  	int state;		/* interface state */
> >  	u8 mac_addr[ETH_ALEN];	/* assigned MAC address */
> > @@ -526,7 +525,6 @@ static struct net_device_stats *brcmf_ne
> >  {
> >  	struct brcmf_info *drvr_priv = *(struct brcmf_info **)
> >  					netdev_priv(ndev);
> > -	struct brcmf_if *ifp;
> >  	int ifidx;
> >  
> 
> Gr. AvS
> 

Why not, if you  look it is only used during the aggregation and return
of netdevice stats.
