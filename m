Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4868 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758893Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/83] staging: brcm80211: removed iovar layer from
 softmac
Date: Wed, 1 Jun 2011 13:44:47 +0200
Message-ID: <1306928768-7501-2-git-send-email-rvossen@broadcom.com> (sfid-20110601_134809_326251_F18BD025)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Softmac contained a redundant level of indirection, named
'iovar functionality'.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c |   17 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c    |  433 ++++------------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h    |    6 -
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h     |   23 +-
 4 files changed, 90 insertions(+), 389 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 6c6236c..3deb903 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -270,14 +270,14 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 
 	WL_LOCK(wl);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
-		if (wlc_iovar_setint
-		    (wl->wlc, "bcn_li_bcn", conf->listen_interval)) {
+		if (wlc_set_par(wl->wlc, IOV_BCN_LI_BCN, conf->listen_interval)
+		    < 0) {
 			wiphy_err(wiphy, "%s: Error setting listen_interval\n",
 				  __func__);
 			err = -EIO;
 			goto config_out;
 		}
-		wlc_iovar_getint(wl->wlc, "bcn_li_bcn", &new_int);
+		wlc_get_par(wl->wlc, IOV_BCN_LI_BCN, &new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
 		wiphy_err(wiphy, "%s: change monitor mode: %s (implement)\n",
@@ -289,14 +289,14 @@ static int wl_ops_config(struct ieee80211_hw *hw, u32 changed)
 			  "true" : "false");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		if (wlc_iovar_setint
-		    (wl->wlc, "qtxpower", conf->power_level * 4)) {
+		if (wlc_set_par(wl->wlc, IOV_QTXPOWER, conf->power_level * 4)
+				< 0) {
 			wiphy_err(wiphy, "%s: Error setting power_level\n",
 				  __func__);
 			err = -EIO;
 			goto config_out;
 		}
-		wlc_iovar_getint(wl->wlc, "qtxpower", &new_int);
+		wlc_get_par(wl->wlc, IOV_QTXPOWER, &new_int);
 		if (new_int != (conf->power_level * 4))
 			wiphy_err(wiphy, "%s: Power level req != actual, %d %d"
 				  "\n", __func__, conf->power_level * 4,
@@ -808,7 +808,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 
 	wl->pub->ieee_hw = hw;
 
-	if (wlc_iovar_setint(wl->wlc, "mpc", 0)) {
+	if (wlc_set_par(wl->wlc, IOV_MPC, 0) < 0) {
 		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
 			  unit);
 	}
@@ -821,8 +821,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 	wl->irq = irq;
 
 	/* register module */
-	wlc_module_register(wl->pub, NULL, "linux", wl, NULL, wl_linux_watchdog,
-			    NULL);
+	wlc_module_register(wl->pub, "linux", wl, wl_linux_watchdog, NULL);
 
 	if (ieee_hw_init(hw)) {
 		wiphy_err(wl->wiphy, "wl%d: %s: ieee_hw_init failed!\n", unit,
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 2425fda..c078ea0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -138,28 +138,6 @@ uint wl_msg_level =
 static struct wlc_info *wlc_info_dbg = (struct wlc_info *) (NULL);
 #endif
 
-/* IOVar table */
-
-/* Parameter IDs, for use only internally to wlc -- in the wlc_iovars
- * table and by the wlc_doiovar() function.  No ordering is imposed:
- * the table is keyed by name, and the function uses a switch.
- */
-enum {
-	IOV_MPC = 1,
-	IOV_RTSTHRESH,
-	IOV_QTXPOWER,
-	IOV_BCN_LI_BCN,		/* Beacon listen interval in # of beacons */
-	IOV_LAST		/* In case of a need to check max ID number */
-};
-
-const bcm_iovar_t wlc_iovars[] = {
-	{"mpc", IOV_MPC, (0), IOVT_BOOL, 0},
-	{"rtsthresh", IOV_RTSTHRESH, (IOVF_WHL), IOVT_UINT16, 0},
-	{"qtxpower", IOV_QTXPOWER, (IOVF_WHL), IOVT_UINT32, 0},
-	{"bcn_li_bcn", IOV_BCN_LI_BCN, (0), IOVT_UINT8, 0},
-	{NULL, 0, 0, 0, 0}
-};
-
 const u8 prio2fifo[NUMPRIO] = {
 	TX_AC_BE_FIFO,		/* 0    BE      AC_BE   Best Effort */
 	TX_AC_BK_FIFO,		/* 1    BK      AC_BK   Background */
@@ -255,8 +233,6 @@ static void wlc_watchdog(void *arg);
 static void wlc_watchdog_by_timer(void *arg);
 static u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate);
 static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg);
-static int wlc_iovar_rangecheck(struct wlc_info *wlc, u32 val,
-				const bcm_iovar_t *vi);
 static u8 wlc_local_constraint_qdbm(struct wlc_info *wlc);
 
 /* send and receive */
@@ -1401,10 +1377,6 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	/* 11n_disable nvram */
 	n_disabled = getintvar(pub->vars, "11n_disable");
 
-	/* register a module (to handle iovars) */
-	wlc_module_register(wlc->pub, wlc_iovars, "wlc_iovars", wlc,
-			    wlc_doiovar, NULL, NULL);
-
 	/*
 	 * low level attach steps(all hw accesses go
 	 * inside, no more in rest of the attach)
@@ -1774,9 +1746,6 @@ uint wlc_detach(struct wlc_info *wlc)
 		wlc->dumpcb_head = NULL;
 	}
 
-	/* Detach from iovar manager */
-	wlc_module_unregister(wlc->pub, "wlc_iovars", wlc);
-
 	while (wlc->tx_queues != NULL)
 		wlc_txq_free(wlc, wlc->tx_queues);
 
@@ -2819,48 +2788,11 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	return bcmerror;
 }
 
-/* Look up the given var name in the given table */
-static const bcm_iovar_t *wlc_iovar_lookup(const bcm_iovar_t *table,
-					   const char *name)
-{
-	const bcm_iovar_t *vi;
-	const char *lookup_name;
-
-	/* skip any ':' delimited option prefixes */
-	lookup_name = strrchr(name, ':');
-	if (lookup_name != NULL)
-		lookup_name++;
-	else
-		lookup_name = name;
-
-	for (vi = table; vi->name; vi++) {
-		if (!strcmp(vi->name, lookup_name))
-			return vi;
-	}
-	/* ran to end of table */
-
-	return NULL;		/* var name not found */
-}
-
-int wlc_iovar_getint(struct wlc_info *wlc, const char *name, int *arg)
-{
-	return wlc_iovar_op(wlc, name, NULL, 0, arg, sizeof(s32), IOV_GET,
-			    NULL);
-}
-
-int wlc_iovar_setint(struct wlc_info *wlc, const char *name, int arg)
-{
-	return wlc_iovar_op(wlc, name, NULL, 0, (void *)&arg, sizeof(arg),
-			    IOV_SET, NULL);
-}
-
 /*
- * register iovar table, watchdog and down handlers.
- * calling function must keep 'iovars' until wlc_module_unregister is called.
- * 'iovar' must have the last entry's name field being NULL as terminator.
+ * register watchdog and down handlers.
  */
-int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
-			const char *name, void *hdl, iovar_fn_t i_fn,
+int wlc_module_register(struct wlc_pub *pub,
+			const char *name, void *hdl,
 			watchdog_fn_t w_fn, down_fn_t d_fn)
 {
 	struct wlc_info *wlc = (struct wlc_info *) pub->wlc;
@@ -2871,9 +2803,7 @@ int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
 		if (wlc->modulecb[i].name[0] == '\0') {
 			strncpy(wlc->modulecb[i].name, name,
 				sizeof(wlc->modulecb[i].name) - 1);
-			wlc->modulecb[i].iovars = iovars;
 			wlc->modulecb[i].hdl = hdl;
-			wlc->modulecb[i].iovar_fn = i_fn;
 			wlc->modulecb[i].watchdog_fn = w_fn;
 			wlc->modulecb[i].down_fn = d_fn;
 			return 0;
@@ -2918,295 +2848,6 @@ static void wlc_wme_retries_write(struct wlc_info *wlc)
 	}
 }
 
-/* Get or set an iovar.  The params/p_len pair specifies any additional
- * qualifying parameters (e.g. an "element index") for a get, while the
- * arg/len pair is the buffer for the value to be set or retrieved.
- * Operation (get/set) is specified by the last argument.
- * interface context provided by wlcif
- *
- * All pointers may point into the same buffer.
- */
-int
-wlc_iovar_op(struct wlc_info *wlc, const char *name,
-	     void *params, int p_len, void *arg, int len,
-	     bool set, struct wlc_if *wlcif)
-{
-	int err = 0;
-	int val_size;
-	const bcm_iovar_t *vi = NULL;
-	u32 actionid;
-	int i;
-
-	if (!set && (len == sizeof(int)) &&
-	    !(IS_ALIGNED((unsigned long)(arg), (uint) sizeof(int)))) {
-		wiphy_err(wlc->wiphy, "wl%d: %s unaligned get ptr for %s\n",
-			  wlc->pub->unit, __func__, name);
-		return -ENOTSUPP;
-	}
-
-	/* find the given iovar name */
-	for (i = 0; i < WLC_MAXMODULES; i++) {
-		if (!wlc->modulecb[i].iovars)
-			continue;
-		vi = wlc_iovar_lookup(wlc->modulecb[i].iovars, name);
-		if (vi)
-			break;
-	}
-	/* iovar name not found */
-	if (i >= WLC_MAXMODULES) {
-		return -ENOTSUPP;
-	}
-
-	/* set up 'params' pointer in case this is a set command so that
-	 * the convenience int and bool code can be common to set and get
-	 */
-	if (params == NULL) {
-		params = arg;
-		p_len = len;
-	}
-
-	if (vi->type == IOVT_VOID)
-		val_size = 0;
-	else if (vi->type == IOVT_BUFFER)
-		val_size = len;
-	else
-		/* all other types are integer sized */
-		val_size = sizeof(int);
-
-	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
-
-	/* Do the actual parameter implementation */
-	err = wlc->modulecb[i].iovar_fn(wlc->modulecb[i].hdl, vi, actionid,
-					name, params, p_len, arg, len, val_size,
-					wlcif);
-	return err;
-}
-
-int
-wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi, void *arg, int len,
-		bool set)
-{
-	struct wlc_info *wlc = (struct wlc_info *) pub->wlc;
-	int err = 0;
-	s32 int_val = 0;
-
-	/* check generic condition flags */
-	if (set) {
-		if (((vi->flags & IOVF_SET_DOWN) && wlc->pub->up) ||
-		    ((vi->flags & IOVF_SET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? -EISCONN : -ENOLINK);
-		} else if ((vi->flags & IOVF_SET_BAND)
-			   && IS_MBAND_UNLOCKED(wlc)) {
-			err = -ENOMEDIUM;
-		} else if ((vi->flags & IOVF_SET_CLK) && !wlc->clk) {
-			err = -EIO;
-		}
-	} else {
-		if (((vi->flags & IOVF_GET_DOWN) && wlc->pub->up) ||
-		    ((vi->flags & IOVF_GET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? -EISCONN : -ENOLINK);
-		} else if ((vi->flags & IOVF_GET_BAND)
-			   && IS_MBAND_UNLOCKED(wlc)) {
-			err = -ENOMEDIUM;
-		} else if ((vi->flags & IOVF_GET_CLK) && !wlc->clk) {
-			err = -EIO;
-		}
-	}
-
-	if (err)
-		goto exit;
-
-	/* length check on io buf */
-	err = bcm_iovar_lencheck(vi, arg, len, set);
-	if (err)
-		goto exit;
-
-	/* On set, check value ranges for integer types */
-	if (set) {
-		switch (vi->type) {
-		case IOVT_BOOL:
-		case IOVT_INT8:
-		case IOVT_INT16:
-		case IOVT_INT32:
-		case IOVT_UINT8:
-		case IOVT_UINT16:
-		case IOVT_UINT32:
-			memcpy(&int_val, arg, sizeof(int));
-			err = wlc_iovar_rangecheck(wlc, int_val, vi);
-			break;
-		}
-	}
- exit:
-	return err;
-}
-
-/* handler for iovar table wlc_iovars */
-/*
- * IMPLEMENTATION NOTE: In order to avoid checking for get/set in each
- * iovar case, the switch statement maps the iovar id into separate get
- * and set values.  If you add a new iovar to the switch you MUST use
- * IOV_GVAL and/or IOV_SVAL in the case labels to avoid conflict with
- * another case.
- * Please use params for additional qualifying parameters.
- */
-int
-wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
-	    const char *name, void *params, uint p_len, void *arg, int len,
-	    int val_size, struct wlc_if *wlcif)
-{
-	struct wlc_info *wlc = hdl;
-	struct wlc_bsscfg *bsscfg;
-	int err = 0;
-	s32 int_val = 0;
-	s32 int_val2 = 0;
-	s32 *ret_int_ptr;
-	bool bool_val;
-	bool bool_val2;
-	wlc_bss_info_t *current_bss;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
-
-	bsscfg = NULL;
-	current_bss = NULL;
-
-	err = wlc_iovar_check(wlc->pub, vi, arg, len, IOV_ISSET(actionid));
-	if (err != 0)
-		return err;
-
-	/* convenience int and bool vals for first 8 bytes of buffer */
-	if (p_len >= (int)sizeof(int_val))
-		memcpy(&int_val, params, sizeof(int_val));
-
-	if (p_len >= (int)sizeof(int_val) * 2)
-		memcpy(&int_val2,
-		       (void *)((unsigned long)params + sizeof(int_val)),
-		       sizeof(int_val));
-
-	/* convenience int ptr for 4-byte gets (requires int aligned arg) */
-	ret_int_ptr = (s32 *) arg;
-
-	bool_val = (int_val != 0) ? true : false;
-	bool_val2 = (int_val2 != 0) ? true : false;
-
-	BCMMSG(wlc->wiphy, "wl%d: id %d\n", wlc->pub->unit, IOV_ID(actionid));
-	/* Do the actual parameter implementation */
-	switch (actionid) {
-	case IOV_SVAL(IOV_RTSTHRESH):
-		wlc->RTSThresh = int_val;
-		break;
-
-	case IOV_GVAL(IOV_QTXPOWER):{
-			uint qdbm;
-			bool override;
-
-			err = wlc_phy_txpower_get(wlc->band->pi, &qdbm,
-				&override);
-			if (err != 0)
-				return err;
-
-			/* Return qdbm units */
-			*ret_int_ptr =
-			    qdbm | (override ? WL_TXPWR_OVERRIDE : 0);
-			break;
-		}
-
-		/* As long as override is false, this only sets the *user* targets.
-		   User can twiddle this all he wants with no harm.
-		   wlc_phy_txpower_set() explicitly sets override to false if
-		   not internal or test.
-		 */
-	case IOV_SVAL(IOV_QTXPOWER):{
-			u8 qdbm;
-			bool override;
-
-			/* Remove override bit and clip to max qdbm value */
-			qdbm = (u8)min_t(u32, (int_val & ~WL_TXPWR_OVERRIDE), 0xff);
-			/* Extract override setting */
-			override = (int_val & WL_TXPWR_OVERRIDE) ? true : false;
-			err =
-			    wlc_phy_txpower_set(wlc->band->pi, qdbm, override);
-			break;
-		}
-
-	case IOV_GVAL(IOV_MPC):
-		*ret_int_ptr = (s32) wlc->mpc;
-		break;
-
-	case IOV_SVAL(IOV_MPC):
-		wlc->mpc = bool_val;
-		wlc_radio_mpc_upd(wlc);
-
-		break;
-
-	case IOV_GVAL(IOV_BCN_LI_BCN):
-		*ret_int_ptr = wlc->bcn_li_bcn;
-		break;
-
-	case IOV_SVAL(IOV_BCN_LI_BCN):
-		wlc->bcn_li_bcn = (u8) int_val;
-		if (wlc->pub->up)
-			wlc_bcn_li_upd(wlc);
-		break;
-
-	default:
-		wiphy_err(wlc->wiphy, "wl%d: %s: unsupported\n",
-			  wlc->pub->unit, __func__);
-		err = -ENOTSUPP;
-		break;
-	}
-
-	goto exit;		/* avoid unused label warning */
-
- exit:
-	return err;
-}
-
-static int
-wlc_iovar_rangecheck(struct wlc_info *wlc, u32 val, const bcm_iovar_t *vi)
-{
-	int err = 0;
-	u32 min_val = 0;
-	u32 max_val = 0;
-
-	/* Only ranged integers are checked */
-	switch (vi->type) {
-	case IOVT_INT32:
-		max_val |= 0x7fffffff;
-		/* fall through */
-	case IOVT_INT16:
-		max_val |= 0x00007fff;
-		/* fall through */
-	case IOVT_INT8:
-		max_val |= 0x0000007f;
-		min_val = ~max_val;
-		if (vi->flags & IOVF_NTRL)
-			min_val = 1;
-		else if (vi->flags & IOVF_WHL)
-			min_val = 0;
-		/* Signed values are checked against max_val and min_val */
-		if ((s32) val < (s32) min_val
-		    || (s32) val > (s32) max_val)
-			err = -EINVAL;
-		break;
-
-	case IOVT_UINT32:
-		max_val |= 0xffffffff;
-		/* fall through */
-	case IOVT_UINT16:
-		max_val |= 0x0000ffff;
-		/* fall through */
-	case IOVT_UINT8:
-		max_val |= 0x000000ff;
-		if (vi->flags & IOVF_NTRL)
-			min_val = 1;
-		if ((val < min_val) || (val > max_val))
-			err = -EINVAL;
-		break;
-	}
-
-	return err;
-}
-
 #ifdef BCMDBG
 static const char *supr_reason[] = {
 	"None", "PMQ Entry", "Flush request",
@@ -6353,3 +5994,71 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
 		wl_msleep(wlc->wl, 1);
 	}
 }
+
+int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int int_val)
+{
+	int err = 0;
+
+	switch (par_id) {
+	case IOV_BCN_LI_BCN:
+		wlc->bcn_li_bcn = (u8) int_val;
+		if (wlc->pub->up)
+			wlc_bcn_li_upd(wlc);
+		break;
+		/* As long as override is false, this only sets the *user*
+		   targets. User can twiddle this all he wants with no harm.
+		   wlc_phy_txpower_set() explicitly sets override to false if
+		   not internal or test.
+		 */
+	case IOV_QTXPOWER:{
+		u8 qdbm;
+		bool override;
+
+		/* Remove override bit and clip to max qdbm value */
+		qdbm = (u8)min_t(u32, (int_val & ~WL_TXPWR_OVERRIDE), 0xff);
+		/* Extract override setting */
+		override = (int_val & WL_TXPWR_OVERRIDE) ? true : false;
+		err =
+		    wlc_phy_txpower_set(wlc->band->pi, qdbm, override);
+		break;
+		}
+	case IOV_MPC:
+		wlc->mpc = (bool)int_val;
+		wlc_radio_mpc_upd(wlc);
+		break;
+	default:
+		err = -ENOTSUPP;
+	}
+	return err;
+}
+
+int wlc_get_par(struct wlc_info *wlc, enum wlc_par_id par_id, int *ret_int_ptr)
+{
+	int err = 0;
+
+	switch (par_id) {
+	case IOV_BCN_LI_BCN:
+		*ret_int_ptr = wlc->bcn_li_bcn;
+		break;
+	case IOV_QTXPOWER: {
+		uint qdbm;
+		bool override;
+
+		err = wlc_phy_txpower_get(wlc->band->pi, &qdbm,
+			&override);
+		if (err != 0)
+			return err;
+
+		/* Return qdbm units */
+		*ret_int_ptr =
+		    qdbm | (override ? WL_TXPWR_OVERRIDE : 0);
+		break;
+		}
+	case IOV_MPC:
+		*ret_int_ptr = (s32) wlc->mpc;
+		break;
+	default:
+		err = -ENOTSUPP;
+	}
+	return err;
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 0bb3784..193f73a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -898,12 +898,6 @@ extern void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec);
 
 extern bool wlc_timers_init(struct wlc_info *wlc, int unit);
 
-extern const bcm_iovar_t wlc_iovars[];
-
-extern int wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
-		       const char *name, void *params, uint p_len, void *arg,
-		       int len, int val_size, struct wlc_if *wlcif);
-
 #if defined(BCMDBG)
 extern void wlc_print_ies(struct wlc_info *wlc, u8 *ies, uint ies_len);
 #endif
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 88b0967..b3a79ab 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -370,6 +370,13 @@ typedef struct wl_rxsts {
 #define WL_RXS_NFRM_AMSDU_FIRST		0x00000004	/* first MSDU in A-MSDU */
 #define WL_RXS_NFRM_AMSDU_SUB		0x00000008	/* subsequent MSDU(s) in A-MSDU */
 
+enum wlc_par_id {
+	IOV_MPC = 1,
+	IOV_RTSTHRESH,
+	IOV_QTXPOWER,
+	IOV_BCN_LI_BCN		/* Beacon listen interval in # of beacons */
+};
+
 /* forward declare and use the struct notation so we don't have to
  * have it defined if not necessary.
  */
@@ -492,8 +499,6 @@ extern uint wlc_down(struct wlc_info *wlc);
 
 extern int wlc_set(struct wlc_info *wlc, int cmd, int arg);
 extern int wlc_get(struct wlc_info *wlc, int cmd, int *arg);
-extern int wlc_iovar_getint(struct wlc_info *wlc, const char *name, int *arg);
-extern int wlc_iovar_setint(struct wlc_info *wlc, const char *name, int arg);
 extern bool wlc_chipmatch(u16 vendor, u16 device);
 extern void wlc_init(struct wlc_info *wlc);
 extern void wlc_reset(struct wlc_info *wlc);
@@ -506,9 +511,6 @@ extern bool wlc_isr(struct wlc_info *wlc, bool *wantdpc);
 extern bool wlc_dpc(struct wlc_info *wlc, bool bounded);
 extern bool wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 				 struct ieee80211_hw *hw);
-extern int wlc_iovar_op(struct wlc_info *wlc, const char *name, void *params,
-			int p_len, void *arg, int len, bool set,
-			struct wlc_if *wlcif);
 extern int wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		     struct wlc_if *wlcif);
 extern bool wlc_aggregatable(struct wlc_info *wlc, u8 tid);
@@ -534,18 +536,15 @@ extern void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs);
 struct ieee80211_sta;
 extern void wlc_ampdu_flush(struct wlc_info *wlc, struct ieee80211_sta *sta,
 			    u16 tid);
+int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int val);
+int wlc_get_par(struct wlc_info *wlc, enum wlc_par_id par_id, int *ret_int_ptr);
 
 /* wlc_phy.c helper functions */
 extern void wlc_set_ps_ctrl(struct wlc_info *wlc);
 extern void wlc_mctrl(struct wlc_info *wlc, u32 mask, u32 val);
 
-/* ioctl */
-extern int wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi,
-			   void *arg,
-			   int len, bool set);
-
-extern int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
-			       const char *name, void *hdl, iovar_fn_t iovar_fn,
+extern int wlc_module_register(struct wlc_pub *pub,
+			       const char *name, void *hdl,
 			       watchdog_fn_t watchdog_fn, down_fn_t down_fn);
 extern int wlc_module_unregister(struct wlc_pub *pub, const char *name,
 				 void *hdl);
-- 
1.7.4.1


