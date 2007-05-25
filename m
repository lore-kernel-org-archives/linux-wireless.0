Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47987
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761019AbXEYQ0i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2007 12:26:38 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
Date: Fri, 25 May 2007 18:26:04 +0200
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
References: <20070525115244.GA23364@mail.intel.com> <20070525092008.287b5ecd.randy.dunlap@oracle.com>
In-Reply-To: <20070525092008.287b5ecd.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200705251826.04821.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 25 May 2007 18:20:08 Randy Dunlap wrote:
> On Fri, 25 May 2007 19:52:44 +0800 Zhu Yi wrote:
> 
> >  net/mac80211/debugfs_netdev.c |  332 +++++++++++++++++++++++++++++++++++++++++
> >  net/mac80211/ieee80211_i.h    |   33 ++++
> >  2 files changed, 365 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> > index 9e39646..e0f77f9 100644
> > --- a/net/mac80211/debugfs_netdev.c
> > +++ b/net/mac80211/debugfs_netdev.c
> 
> > +#define DEBUGFS_QOS_DEL(name)						\
> > +	debugfs_remove(sdata->debugfs.sta.qos.name);			\
> > +	sdata->debugfs.sta.qos.name = NULL;
> 
> Enclose multi-line macros inside braces, or even better, inside
> 
> 	do {
> 		/* multi-lines */
> 	} while (0);

Remove the semicolon.



-- 
Greetings Michael.
