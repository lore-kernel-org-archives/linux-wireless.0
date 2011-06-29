Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4529 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758097Ab1F2Xte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:34 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 089/119] staging: brcm80211: structure renaming in dhd.h
Date: Wed, 29 Jun 2011 16:47:53 -0700
Message-ID: <1309391303-22741-90-git-send-email-frankyl@broadcom.com> (sfid-20110630_015243_072977_D12CD51C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

structure have been renamed for consistency and the structure typedefs
have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |   16 ++++++++--------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |    6 ++++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |    6 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h  |    6 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |    2 +-
 5 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 77b381c..d69cee1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -595,19 +595,19 @@ typedef struct dhd_pub {
 
 } dhd_pub_t;
 
-typedef struct dhd_if_event {
+struct brcmf_if_event {
 	u8 ifidx;
 	u8 action;
 	u8 flags;
 	u8 bssidx;
-} dhd_if_event_t;
+};
 
-typedef struct {
+struct brcmf_timeout {
 	u32 limit;		/* Expiration time (usec) */
 	u32 increment;	/* Current expiration increment (usec) */
 	u32 elapsed;		/* Current elapsed time (usec) */
 	u32 tick;		/* O/S tick time (usec) */
-} dhd_timeout_t;
+};
 
 typedef struct {
 	uint event;
@@ -803,8 +803,8 @@ extern void brcmf_os_sdunlock_eventq(dhd_pub_t *pub);
 extern int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
 #endif				/* BCMDBG */
 
-extern void brcmf_timeout_start(dhd_timeout_t *tmo, uint usec);
-extern int brcmf_timeout_expired(dhd_timeout_t *tmo);
+extern void brcmf_timeout_start(struct brcmf_timeout *tmo, uint usec);
+extern int brcmf_timeout_expired(struct brcmf_timeout *tmo);
 
 extern int brcmf_ifname2idx(struct dhd_info *dhd, char *name);
 extern int brcmf_c_host_event(struct dhd_info *dhd, int *idx, void *pktdata,
@@ -843,7 +843,7 @@ extern void osl_assert(char *exp, char *file, int line);
 #endif  /* defined(BCMDBG) */
 
 /* Linux network driver ioctl encoding */
-typedef struct dhd_ioctl {
+struct brcmf_c_ioctl {
 	uint cmd;		/* common ioctl definition */
 	void *buf;		/* pointer to user buffer */
 	uint len;		/* length of user buffer */
@@ -851,7 +851,7 @@ typedef struct dhd_ioctl {
 	uint used;		/* bytes read or written (optional) */
 	uint needed;		/* bytes needed (optional) */
 	uint driver;		/* to identify target driver */
-} dhd_ioctl_t;
+};
 
 /* per-driver magic numbers */
 #define BRCMF_IOCTL_MAGIC		0x00444944
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 9b0ad44..de07526 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -360,7 +360,8 @@ exit:
 	return bcmerror;
 }
 
-int brcmf_c_ioctl(dhd_pub_t *drvr, dhd_ioctl_t *ioc, void *buf, uint buflen)
+int brcmf_c_ioctl(dhd_pub_t *drvr, struct brcmf_c_ioctl *ioc, void *buf,
+		  uint buflen)
 {
 	int bcmerror = 0;
 
@@ -790,7 +791,8 @@ brcmf_c_host_event(struct dhd_info *drvr_priv, int *ifidx, void *pktdata,
 	switch (type) {
 	case BRCMF_E_IF:
 		{
-			dhd_if_event_t *ifevent = (dhd_if_event_t *) event_data;
+			struct brcmf_if_event *ifevent =
+					(struct brcmf_if_event *) event_data;
 			DHD_TRACE(("%s: if event\n", __func__));
 
 			if (ifevent->ifidx > 0 &&
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 2135a64..2705ec0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -320,7 +320,7 @@ static void brcmf_late_resume(struct early_suspend *h)
  *              fatal();
  */
 
-void brcmf_timeout_start(dhd_timeout_t *tmo, uint usec)
+void brcmf_timeout_start(struct brcmf_timeout *tmo, uint usec)
 {
 	tmo->limit = usec;
 	tmo->increment = 0;
@@ -328,7 +328,7 @@ void brcmf_timeout_start(dhd_timeout_t *tmo, uint usec)
 	tmo->tick = 1000000 / HZ;
 }
 
-int brcmf_timeout_expired(dhd_timeout_t *tmo)
+int brcmf_timeout_expired(struct brcmf_timeout *tmo)
 {
 	/* Does nothing the first call */
 	if (tmo->increment == 0) {
@@ -1197,7 +1197,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 				    int cmd)
 {
 	dhd_info_t *drvr_priv = *(dhd_info_t **) netdev_priv(net);
-	dhd_ioctl_t ioc;
+	struct brcmf_c_ioctl ioc;
 	int bcmerror = 0;
 	int buflen = 0;
 	void *buf = NULL;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 4ac2cd1..c78ae94 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -53,7 +53,7 @@ extern int brcmf_proto_hdrpull(dhd_pub_t *, int *ifidx, struct sk_buff *rxp);
 
 /* Use protocol to issue ioctl to dongle */
 extern int brcmf_proto_ioctl(dhd_pub_t *dhd, int ifidx, struct brcmf_ioctl *ioc,
-			  void *buf, int len);
+			     void *buf, int len);
 
 /* Check for and handle local prot-specific iovar commands */
 extern int brcmf_proto_iovar_op(dhd_pub_t *dhdp, const char *name,
@@ -66,8 +66,8 @@ extern void brcmf_proto_dump(dhd_pub_t *dhdp, struct brcmu_strbuf *strbuf);
 /* Update local copy of dongle statistics */
 extern void brcmf_proto_dstats(dhd_pub_t *dhdp);
 
-extern int brcmf_c_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf,
-		     uint buflen);
+extern int brcmf_c_ioctl(dhd_pub_t *dhd_pub, struct brcmf_c_ioctl *ioc,
+			 void *buf, uint buflen);
 
 extern int brcmf_c_preinit_ioctls(dhd_pub_t *dhd);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 8607972..ab96d37 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -3130,7 +3130,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 {
 	dhd_bus_t *bus = dhdp->bus;
-	dhd_timeout_t tmo;
+	struct brcmf_timeout tmo;
 	uint retries = 0;
 	u8 ready, enable;
 	int err, ret = 0;
-- 
1.7.1


