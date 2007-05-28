Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759987AbXE1Bnp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2007 21:43:45 -0400
Date: Mon, 28 May 2007 09:43:16 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
Message-ID: <20070528014316.GA416@mail.intel.com>
Reply-To: yi.zhu@intel.com
References: <20070525115244.GA23364@mail.intel.com> <20070525092008.287b5ecd.randy.dunlap@oracle.com> <200705251826.04821.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200705251826.04821.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 25, 2007 at 06:26:04PM +0200, Michael Buesch wrote:
> On Friday 25 May 2007 18:20:08 Randy Dunlap wrote:
> > On Fri, 25 May 2007 19:52:44 +0800 Zhu Yi wrote:
> > 
> > >  net/mac80211/debugfs_netdev.c |  332 +++++++++++++++++++++++++++++++++++++++++
> > >  net/mac80211/ieee80211_i.h    |   33 ++++
> > >  2 files changed, 365 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
> > > index 9e39646..e0f77f9 100644
> > > --- a/net/mac80211/debugfs_netdev.c
> > > +++ b/net/mac80211/debugfs_netdev.c
> > 
> > > +#define DEBUGFS_QOS_DEL(name)						\
> > > +	debugfs_remove(sdata->debugfs.sta.qos.name);			\
> > > +	sdata->debugfs.sta.qos.name = NULL;
> > 
> > Enclose multi-line macros inside braces, or even better, inside
> > 
> > 	do {
> > 		/* multi-lines */
> > 	} while (0);
> 
> Remove the semicolon.

I'd agree. But the existed DEBUGFS_DEL one also needs to be changed.
Here is the patch against the "[PATCH 3/3] mac80211: debugfs support
for TSM and DLS"

Thanks,
-yi


>From 7886ec6ddcc25af5ba3d0284ea3ac7c99bb99da0 Mon Sep 17 00:00:00 2001
From: Zhu Yi <yi.zhu@intel.com>
Date: Mon, 28 May 2007 09:41:19 +0800
Subject: [PATCH 4/4] mac80211: use do { } while (0) for multi-line macros

Use do { } while (0) for multi-line macros

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/debugfs_netdev.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index e0f77f9..b9409ee 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -119,8 +119,10 @@ static const struct file_operations qos_ ##name## _ops = {		\
 		sdata, &qos_ ##name## _ops);
 
 #define DEBUGFS_QOS_DEL(name)						\
-	debugfs_remove(sdata->debugfs.sta.qos.name);			\
-	sdata->debugfs.sta.qos.name = NULL;
+	do {								\
+		debugfs_remove(sdata->debugfs.sta.qos.name);		\
+		sdata->debugfs.sta.qos.name = NULL;			\
+	} while (0)
 
 DEBUGFS_QOS_FILE(addts_11e, ieee80211_send_addts);
 DEBUGFS_QOS_FILE(addts_wmm, wmm_send_addts);
@@ -281,8 +283,10 @@ static const struct file_operations tsinfo_ ##_name## _ops = {		\
 				    sdata, &tsinfo_UP_ops);
 
 #define DEBUGFS_TSINFO_DEL(name)					\
-	debugfs_remove(sdata->debugfs.sta.tsinfo.name);			\
-	sdata->debugfs.sta.tsinfo.name = NULL;
+	do {								\
+		debugfs_remove(sdata->debugfs.sta.tsinfo.name);		\
+		sdata->debugfs.sta.tsinfo.name = NULL;			\
+	} while (0)
 
 DEBUGFS_TSINFO_FILE(TSID, 8, 15);
 DEBUGFS_TSINFO_FILE(DIR, 0, 3);
@@ -325,8 +329,10 @@ static const struct file_operations tspec_ ##name## _ops = {		\
 		0444, tspecd, sdata, &tspec_ ##name## _ops);
 
 #define DEBUGFS_TSPEC_DEL(name)						\
-	debugfs_remove(sdata->debugfs.sta.tspec.name);			\
-	sdata->debugfs.sta.tspec.name = NULL;
+	do {								\
+		debugfs_remove(sdata->debugfs.sta.tspec.name);		\
+		sdata->debugfs.sta.tspec.name = NULL;			\
+	} while (0)
 
 DEBUGFS_TSPEC_FILE(nominal_msdu_size);
 DEBUGFS_TSPEC_FILE(max_msdu_size);
@@ -569,9 +575,11 @@ static void add_files(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-#define DEBUGFS_DEL(name, type)\
-	debugfs_remove(sdata->debugfs.type.name);\
-	sdata->debugfs.type.name = NULL;
+#define DEBUGFS_DEL(name, type)					\
+	do {							\
+		debugfs_remove(sdata->debugfs.type.name);	\
+		sdata->debugfs.type.name = NULL;		\
+	} while (0)
 
 static void del_sta_files(struct ieee80211_sub_if_data *sdata)
 {
-- 
1.5.0.rc2.g73a2
