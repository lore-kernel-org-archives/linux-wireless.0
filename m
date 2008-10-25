Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:56587 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751041AbYJYUph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 16:45:37 -0400
From: Alexey Fisher <bug-track@fisher-privat.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: why differnet wlan drivers need different settings?
Date: Sat, 25 Oct 2008 22:45:29 +0200
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	linux-wireless@vger.kernel.org
References: <200810251153.25533.bug-track@fisher-privat.net> <200810251303.35295.rjw@sisk.pl> <20081025135512.GG19057@tuxdriver.com>
In-Reply-To: <20081025135512.GG19057@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200810252245.30279.bug-track@fisher-privat.net> (sfid-20081025_224547_444010_4B96E77A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 25 October 2008 15:55:12 John W. Linville wrote:
> On Sat, Oct 25, 2008 at 01:03:34PM +0200, Rafael J. Wysocki wrote:
> > On Saturday, 25 of October 2008, Alexey Fisher wrote:
> > > May be this is the wrong plase to ask.
> >
> > Yeah, better ask that on linux-wireless@vger.kernel.org (CCed).
> >
> > > The question is: Why differnet wlan drivers use different settings to
> > > stay silent - powered on but not trying to associate to any accespoint?
> > > For example: ipw2200 - if wlan was connfigured like:
> > >
> > > iwconfig wlan1 essid "my-ap" chan 6 ap my:aps:mac ?key s:pass
> > >
> > > this will normaly connect to my secure ?AP. and if i set after this:
> > > ?
> > > iwconfig wlan1 essid off ap off
> > >
> > > it will connect to unsecure AP of my neighbour or of Dr.Evil :)
> > > to disable association on ipw2200 i need to set all this and plus "chan
> > > 0". With this cnowleg i want to set up iwl3945, and surprise it's not
> > > working. This driver do not accepted "chan 0" and instead of "essid
> > > off" it did "essid """
> > >
> > > Are there any unified way to keep adapter powered on but not trying to
> > > associate to some AP?
>
> That is from the bad-ole-days.  I could be wrong, but AFAIK only the
> ipw2x00 drivers do that anyway.  I recently merged a patch to change
> the default for that for ipw2200 into wireless-testing.  We should
> probably have one for ipw2100 as well.
>
> Anyway, there are module options for those.  Add "options ipw2200
> associate=0" to /etc/modprobe.conf.

I use associate=0 with smole workaround:

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index dcce354..92583c6 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -7582,7 +7582,7 @@ static int ipw_associate(void *data)
 
 	if (!(priv->config & CFG_ASSOCIATE) &&
 	    !(priv->config & (CFG_STATIC_ESSID |
-			      CFG_STATIC_CHANNEL | CFG_STATIC_BSSID))) {
+			      CFG_STATIC_BSSID))) {
 		IPW_DEBUG_ASSOC("Not attempting association (associate=0)\n");
 		return 0;
 	}

becouse networkmanager do not set channel=0 to be compartibel with other 
drivers. 
Are there any better solution?
