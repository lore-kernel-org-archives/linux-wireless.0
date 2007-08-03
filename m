Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58649
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762684AbXHCPag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 11:30:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [RFC 2/10] Port of bcm43xx from softmac to mac80211
Date: Fri, 3 Aug 2007 17:30:27 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46b1fded.0g4ZHvU7XwSzeJVs%Larry.Finger@lwfinger.net> <20070803163836.7ef9622b@morte>
In-Reply-To: <20070803163836.7ef9622b@morte>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708031730.27767.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007, Stefano Brivio wrote:
> On Thu, 02 Aug 2007 10:53:17 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> > +static char big_buffer[1024*256];
> 
> static char big_buffer[1024 * 256];
> 
> > +		bcmerr(dev->wl, "debugfs: Board not initialized.\n");
> >  		res = -EFAULT;
> >  		goto out_unlock;
> >  	}
> > -	if (sscanf(buf, "%lli", &tsf) != 1) {
> > -		printk(KERN_INFO PFX "debugfs: invalid values for
> > \"tsf\"\n");
> > +	if (sscanf(buf, "%llu", (unsigned long long *)(&tsf)) != 1) {
> > +		bcmerr(dev->wl, "debugfs: invalid values for \"tsf\"\n");
> 
> "debugfs: Invalid values for TSF.\n"
> 
> > +	int i;
> > +	int idx;
> 
> int i, idx;

No, checkpatch complains about multiple variables per line.

> > +void bcm43xx_debugfs_add_device(struct bcm43xx_wldev *dev)
> >  {
> >  	struct bcm43xx_dfsentry *e;
> > -	char devdir[IFNAMSIZ];
> > +	struct bcm43xx_txstatus_log *log;
> > +	char devdir[16];
> >  
> > -	assert(bcm);
> > +	BCM43xx_BUG_ON(!dev);
> >  	e = kzalloc(sizeof(*e), GFP_KERNEL);
> >  	if (!e) {
> > -		printk(KERN_ERR PFX "out of memory\n");
> > +		bcmerr(dev->wl, "debugfs: add device OOM\n");
> 
> "debugfs: OOM while adding device.\n"
> 
> > +		bcmerr(dev->wl, "debugfs: add device txstatus OOM\n");
> 
> "debugfs: OOM while adding device txstatus.\n"
> 
> And the same for all the debugfs messages, please be consistent.
> 
> 

All your comments address code that's not written my larry, but me.
So if you want that fixed, please send patches.
