Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:49771 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYIHSfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 14:35:05 -0400
Date: Mon, 8 Sep 2008 11:32:03 -0700
To: Pavel Roskin <proski@gnu.org>
Cc: Dan Williams <dcbw@redhat.com>, kilroyd@googlemail.com,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
Message-ID: <20080908183203.GA7090@bougret.hpl.hp.com> (sfid-20080908_203511_526099_7AE2EA03)
Reply-To: jt@hpl.hp.com
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <1217672073-7094-2-git-send-email-kilroyd@gmail.com> <1217825304.10989.20.camel@dv> <1217864060.3139.10.camel@localhost.localdomain> <20080805162238.GA6294@bougret.hpl.hp.com> <20080902230621.GA28885@bougret.hpl.hp.com> <1220878110.2369.3.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220878110.2369.3.camel@dv>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 08:48:30AM -0400, Pavel Roskin wrote:
> On Tue, 2008-09-02 at 16:06 -0700, Jean Tourrilhes wrote:
> 
> > 	By the way, the breakage of iwlist scan in Wireless Tools 30
> > on 64 bits should be fixed in 30.pre7.
> 
> No, it's still not fixed on x86_64.  scanflags in print_scanning_info()
> in iwlist.c is 2, but srq->flags is 0 in orinoco_ioctl_setscan() in
> orinoco.c.
> 
> On i386,  srq->flags is 2 as expected and the scan results are correctly
> influenced by the ESSID.
> 
> -- 
> Regards,
> Pavel Roskin

	Try the attached patch.

	Jean

---------------------------------------------------

diff -u -p linux/drivers/net/wireless/orinoco.p1.c linux/drivers/net/wireless/orinoco.c
--- linux/drivers/net/wireless/orinoco.p1.c	2008-09-08 11:28:01.000000000 -0700
+++ linux/drivers/net/wireless/orinoco.c	2008-09-08 11:29:59.000000000 -0700
@@ -3953,7 +3953,7 @@ static int orinoco_ioctl_getrid(struct n
 /* Trigger a scan (look for other cells in the vicinity */
 static int orinoco_ioctl_setscan(struct net_device *dev,
 				 struct iw_request_info *info,
-				 struct iw_param *srq,
+				 struct iw_point *srq,
 				 char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
