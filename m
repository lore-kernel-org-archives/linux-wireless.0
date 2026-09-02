Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719212E738F
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788367993; cv=none; b=qcYZhNJoV+LmNUDiV5UmJxnFNzq6jHBq25dRuGntQ1XtOrOYfNnQ/rSwaqugVaPXooTe3bWxOeTsqDmb+YvKp//rig02OUz1QckK7q15JcPScTbB8TAH4l7OhV+fiEvxmiMwzdEA/AYxBh//9aH90ALr+CzpmYzT9ikpnCevFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788367993; c=relaxed/simple;
	bh=GWAQ9V73gfc7F0+e/ercpIjbCNvNbT215167is/E11w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YCWYtN+FthoLKYweeC4vRDGn9zAzcgR1mZUKJw6jcWbgGWPmZAbQkcOu5amdXKHSdq+sr7G3Zh8zHzpcTGUxgp0+EkYDJHUG/eWJrYCsxo/0FUUfkK/U/s69sdnG5GAc0wmtEt23+MlBckEj0CEZkAO/YDUwoEkJV3SURmJ80Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=fN9+GVYZ; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="fN9+GVYZ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788367989; x=1819903989;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GWAQ9V73gfc7F0+e/ercpIjbCNvNbT215167is/E11w=;
  b=fN9+GVYZUr/eKXqzxUhv+xdhAjVzuB5A19BpyQIbOKRm+1vKx5Ur/JHy
   7yKS8Rtgs9+swxiM4YlisXyhRjXIhhT2mhrpQvGi4q4tW/pbrhpAgea0x
   PB6w13EBRjkCOdn0uuz5xKdBh0BpE9DCeSLkrvcfaDPlyykuy8ii2D0/m
   4=;
X-CSE-ConnectionGUID: TDOj8AqDTBy6ylDaJ9ANuQ==
X-CSE-MsgGUID: NqL0vacdSMGPBJHTjUyLhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="145161168"
X-IronPort-AV: E=Sophos;i="6.25,258,1779141600"; 
   d="scan'208";a="145161168"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 18:53:07 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Wed, 2 Sep
 2026 18:53:07 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 18:53:05 +0200
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>
CC: <arend.vanspriel@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<gokulkumar.sivakumar@infineon.com>
Subject: [PATCH wireless-next v3 09/25] wifi: inffmac: add dev_cmd.c/h
Date: Wed, 2 Sep 2026 16:50:40 +0000
Message-ID: <20260902165057.456447-10-gokulkumar.sivakumar@infineon.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
References: <20260902165057.456447-1-gokulkumar.sivakumar@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MUCSE823.infineon.com (172.23.29.54) To
 MUCSE827.infineon.com (172.23.29.20)

Driver implementation of the Control path communication to the CP and WLAN
Firmware of the Device.

Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
---
 .../net/wireless/infineon/inffmac/dev_cmd.c   | 653 ++++++++++++
 .../net/wireless/infineon/inffmac/dev_cmd.h   | 969 ++++++++++++++++++
 2 files changed, 1622 insertions(+)
 create mode 100644 drivers/net/wireless/infineon/inffmac/dev_cmd.c
 create mode 100644 drivers/net/wireless/infineon/inffmac/dev_cmd.h

diff --git a/drivers/net/wireless/infineon/inffmac/dev_cmd.c b/drivers/net/wireless/infineon/inffmac/dev_cmd.c
new file mode 100644
index 000000000000..1ea01f66239e
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/dev_cmd.c
@@ -0,0 +1,653 @@
+// SPDX-License-Identifier: ISC
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+/**
+ * Device/Dongle Control Interface. In this module the support functions
+ * are located to set and get variables to and from the Device.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+
+#include "main.h"
+#include "utils.h"
+#include "debug.h"
+#include "dev_cmd.h"
+#include "bus_proto.h"
+
+#define MAX_HEX_DUMP_LEN	64
+#define MAX_CMD_RESEND		3
+
+#ifdef DEBUG
+static const char * const inff_fwcmd_errstr[] = {
+	"INFE_OK",
+	"INFE_ERROR",
+	"INFE_BADARG",
+	"INFE_BADOPTION",
+	"INFE_NOTUP",
+	"INFE_NOTDOWN",
+	"INFE_NOTAP",
+	"INFE_NOTSTA",
+	"INFE_BADKEYIDX",
+	"INFE_RADIOOFF",
+	"INFE_NOTBANDLOCKED",
+	"INFE_NOCLK",
+	"INFE_BADRATESET",
+	"INFE_BADBAND",
+	"INFE_BUFTOOSHORT",
+	"INFE_BUFTOOLONG",
+	"INFE_BUSY",
+	"INFE_NOTASSOCIATED",
+	"INFE_BADSSIDLEN",
+	"INFE_OUTOFRANGECHAN",
+	"INFE_BADCHAN",
+	"INFE_BADADDR",
+	"INFE_NORESOURCE",
+	"INFE_UNSUPPORTED",
+	"INFE_BADLEN",
+	"INFE_NOTREADY",
+	"INFE_EPERM",
+	"INFE_NOMEM",
+	"INFE_ASSOCIATED",
+	"INFE_RANGE",
+	"INFE_NOTFOUND",
+	"INFE_WME_NOT_ENABLED",
+	"INFE_TSPEC_NOTFOUND",
+	"INFE_ACM_NOTSUPPORTED",
+	"INFE_NOT_WME_ASSOCIATION",
+	"INFE_SDIO_ERROR",
+	"INFE_DONGLE_DOWN",
+	"INFE_VERSION",
+	"INFE_TXFAIL",
+	"INFE_RXFAIL",
+	"INFE_NODEVICE",
+	"INFE_NMODE_DISABLED",
+	"INFE_NONRESIDENT",
+	"INFE_SCANREJECT",
+	"INFE_USAGE_ERROR",
+	"INFE_IOCTL_ERROR",
+	"INFE_SERIAL_PORT_ERR",
+	"INFE_DISABLED",
+	"INFE_DECERR",
+	"INFE_ENCERR",
+	"INFE_MICERR",
+	"INFE_REPLAY",
+	"INFE_IE_NOTFOUND",
+};
+
+static const char *inff_fwcmd_get_errstr(u32 err)
+{
+	if (err >= ARRAY_SIZE(inff_fwcmd_errstr))
+		return "(unknown)";
+
+	return inff_fwcmd_errstr[err];
+}
+#else
+static const char *inff_fwcmd_get_errstr(u32 err)
+{
+	return "";
+}
+#endif /* DEBUG */
+
+static s32
+inff_cpcmd_data(struct inff_if *ifp, u32 cmd, void *data, u32 len, bool set)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err, cperr;
+	u8 resend_cnt = 1;
+
+	if (drvr->bus_if->state != INFF_BUS_UP) {
+		iphy_err(drvr, "bus is down. we have nothing to do.\n");
+		return -EIO;
+	}
+
+	if (data)
+		len = min_t(uint, len, INFF_DCMD_MAXLEN);
+
+	do {
+		if (set)
+			err = inff_proto_set_cpcmd(drvr, ifp->ifidx, cmd,
+						   data, len, &cperr);
+		else
+			err = inff_proto_query_cpcmd(drvr, ifp->ifidx, cmd,
+						     data, len, &cperr);
+		if (!err || resend_cnt > MAX_CMD_RESEND)
+			break;
+
+		inff_err("cmd error %d, resend cmd count %d\n", err, resend_cnt++);
+	} while (true);
+
+	if (err) {
+		inff_dbg(DEVCMD, "Failed: error=%d\n", err);
+	} else if (cperr < 0) {
+		inff_dbg(DEVCMD, "CP Command error: %s (%d)\n",
+			 inff_fwcmd_get_errstr((u32)(-cperr)), cperr);
+		err = -EBADE;
+	}
+	if (ifp->fwil_fwerr)
+		return cperr;
+
+	return err;
+}
+
+s32
+inff_cpcmd_data_set(struct inff_if *ifp, u32 cmd, void *data, u32 len)
+{
+	s32 err;
+
+	mutex_lock(&ifp->drvr->proto_block);
+
+	inff_dbg(DEVCMD, "ifidx=%d, cmd=%d, len=%d\n", ifp->ifidx, cmd, len);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	err = inff_cpcmd_data(ifp, cmd, data, len, true);
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+s32
+inff_cpcmd_data_get(struct inff_if *ifp, u32 cmd, void *data, u32 len)
+{
+	s32 err;
+
+	mutex_lock(&ifp->drvr->proto_block);
+	err = inff_cpcmd_data(ifp, cmd, data, len, false);
+
+	inff_dbg(DEVCMD, "ifidx=%d, cmd=%d, len=%d, err=%d\n", ifp->ifidx, cmd,
+		 len, err);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+static s32
+inff_fwcmd_data(struct inff_if *ifp, u32 cmd, void *data, u32 len, bool set)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err, fwerr;
+	u8 resend_cnt = 1;
+
+	if (drvr->bus_if->state != INFF_BUS_UP) {
+		iphy_err(drvr, "bus is down. we have nothing to do.\n");
+		return -EIO;
+	}
+
+	if (data)
+		len = min_t(uint, len, INFF_DCMD_MAXLEN);
+
+	do {
+		if (set)
+			err = inff_proto_set_fwcmd(drvr, ifp->ifidx, cmd,
+						   data, len, &fwerr);
+		else
+			err = inff_proto_query_fwcmd(drvr, ifp->ifidx, cmd,
+						     data, len, &fwerr);
+		if (!err || resend_cnt > MAX_CMD_RESEND)
+			break;
+
+		inff_err("cmd error %d, resend cmd count %d\n", err, resend_cnt++);
+	} while (true);
+
+	if (err) {
+		inff_dbg(DEVCMD, "Failed: error=%d\n", err);
+	} else if (fwerr < 0) {
+		inff_dbg(DEVCMD, "Firmware error: %s (%d)\n",
+			 inff_fwcmd_get_errstr((u32)(-fwerr)), fwerr);
+		err = -EBADE;
+	}
+	if (ifp->fwil_fwerr)
+		return fwerr;
+
+	if (err && resend_cnt == MAX_CMD_RESEND) {
+		if (drvr->bus_reset.func)
+			schedule_work(&drvr->bus_reset);
+	}
+	return err;
+}
+
+s32
+inff_fwcmd_data_set(struct inff_if *ifp, u32 cmd, void *data, u32 len)
+{
+	s32 err;
+
+	mutex_lock(&ifp->drvr->proto_block);
+
+	inff_dbg(DEVCMD, "ifidx=%d, cmd=%d, len=%d\n", ifp->ifidx, cmd, len);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	err = inff_fwcmd_data(ifp, cmd, data, len, true);
+
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+s32
+inff_fwcmd_data_get(struct inff_if *ifp, u32 cmd, void *data, u32 len)
+{
+	s32 err;
+
+	mutex_lock(&ifp->drvr->proto_block);
+
+	inff_dbg(DEVCMD, "ifidx=%d, cmd=%d, len=%d\n", ifp->ifidx, cmd,
+		 len);
+
+	err = inff_fwcmd_data(ifp, cmd, data, len, false);
+
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+s32
+inff_fwcmd_int_set(struct inff_if *ifp, u32 cmd, u32 data)
+{
+	s32 err;
+	__le32 data_le = cpu_to_le32(data);
+
+	mutex_lock(&ifp->drvr->proto_block);
+	inff_dbg(DEVCMD, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, data);
+	err = inff_fwcmd_data(ifp, cmd, &data_le, sizeof(data_le), true);
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+static u32
+inff_create_iovar(const char *name, const char *data, u32 datalen,
+		  char *buf, u32 buflen)
+{
+	u32 len;
+
+	len = strlen(name) + 1;
+
+	if ((len + datalen) > buflen)
+		return 0;
+
+	memcpy(buf, name, len);
+
+	/* append data onto the end of the name string */
+	if (data && datalen)
+		memcpy(&buf[len], data, datalen);
+
+	return len + datalen;
+}
+
+s32
+inff_fwcmd_iovar_data_set(struct inff_if *ifp, const char *name,
+			  const void *data, u32 len)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	inff_dbg(DEVCMD, "ifidx=%d, name=%s, len=%d\n", ifp->ifidx, name, len);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	buflen = inff_create_iovar(name, data, len, drvr->proto_buf,
+				   sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = inff_fwcmd_data(ifp, INFF_C_SET_VAR,
+				      drvr->proto_buf, buflen, true);
+	} else {
+		err = -EPERM;
+		iphy_err(drvr, "Creating iovar failed\n");
+	}
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32
+inff_fwcmd_iovar_data_get(struct inff_if *ifp, const char *name,
+			  void *data, u32 len)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	inff_dbg(DEVCMD, "ifidx=%d, name=%s, len=%d\n", ifp->ifidx, name, len);
+
+	buflen = inff_create_iovar(name, data, len, drvr->proto_buf,
+				   sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = inff_fwcmd_data(ifp, INFF_C_GET_VAR,
+				      drvr->proto_buf, buflen, false);
+		if (err == 0)
+			memcpy(data, drvr->proto_buf, len);
+	} else {
+		err = -EPERM;
+		iphy_err(drvr, "Creating iovar failed\n");
+	}
+
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32
+inff_fwcmd_iovar_int_set(struct inff_if *ifp, const char *name, u32 data)
+{
+	__le32 data_le = cpu_to_le32(data);
+
+	return inff_fwcmd_iovar_data_set(ifp, name, &data_le, sizeof(data_le));
+}
+
+s32
+inff_fwcmd_iovar_int_get(struct inff_if *ifp, const char *name, u32 *data)
+{
+	__le32 data_le = cpu_to_le32(*data);
+	s32 err;
+
+	err = inff_fwcmd_iovar_data_get(ifp, name, &data_le, sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	return err;
+}
+
+static u32
+inff_create_bsscfg(s32 bsscfgidx, const char *name, char *data, u32 datalen,
+		   char *buf, u32 buflen)
+{
+	const s8 *prefix = "bsscfg:";
+	s8 *p;
+	u32 prefixlen;
+	u32 namelen;
+	u32 iolen;
+	__le32 bsscfgidx_le;
+
+	if (bsscfgidx == 0)
+		return inff_create_iovar(name, data, datalen, buf, buflen);
+
+	prefixlen = strlen(prefix);
+	namelen = strlen(name) + 1; /* length of iovar  name + null */
+	iolen = prefixlen + namelen + sizeof(bsscfgidx_le) + datalen;
+
+	if (buflen < iolen) {
+		inff_err("buffer is too short\n");
+		return 0;
+	}
+
+	p = buf;
+
+	/* copy prefix, no null */
+	memcpy(p, prefix, prefixlen);
+	p += prefixlen;
+
+	/* copy iovar name including null */
+	memcpy(p, name, namelen);
+	p += namelen;
+
+	/* bss config index as first data */
+	bsscfgidx_le = cpu_to_le32(bsscfgidx);
+	memcpy(p, &bsscfgidx_le, sizeof(bsscfgidx_le));
+	p += sizeof(bsscfgidx_le);
+
+	/* parameter buffer follows */
+	if (datalen)
+		memcpy(p, data, datalen);
+
+	return iolen;
+}
+
+s32
+inff_fwcmd_bsscfg_data_set(struct inff_if *ifp, const char *name,
+			   void *data, u32 len)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	inff_dbg(DEVCMD, "ifidx=%d, bsscfgidx=%d, name=%s, len=%d\n", ifp->ifidx,
+		 ifp->bsscfgidx, name, len);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	buflen = inff_create_bsscfg(ifp->bsscfgidx, name, data, len,
+				    drvr->proto_buf, sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = inff_fwcmd_data(ifp, INFF_C_SET_VAR,
+				      drvr->proto_buf, buflen, true);
+	} else {
+		err = -EPERM;
+		iphy_err(drvr, "Creating bsscfg failed\n");
+	}
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32
+inff_fwcmd_bsscfg_data_get(struct inff_if *ifp, const char *name,
+			   void *data, u32 len)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	buflen = inff_create_bsscfg(ifp->bsscfgidx, name, data, len,
+				    drvr->proto_buf, sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = inff_fwcmd_data(ifp, INFF_C_GET_VAR,
+				      drvr->proto_buf, buflen, false);
+		if (err == 0)
+			memcpy(data, drvr->proto_buf, len);
+	} else {
+		err = -EPERM;
+		iphy_err(drvr, "Creating bsscfg failed\n");
+	}
+	inff_dbg(DEVCMD, "ifidx=%d, bsscfgidx=%d, name=%s, len=%d, err=%d\n",
+		 ifp->ifidx, ifp->bsscfgidx, name, len, err);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32
+inff_fwcmd_bsscfg_int_get(struct inff_if *ifp, const char *name, u32 *data)
+{
+	__le32 data_le = cpu_to_le32(*data);
+	s32 err;
+
+	err = inff_fwcmd_bsscfg_data_get(ifp, name, &data_le,
+					 sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	return err;
+}
+
+static int inff_fwcmd_xtlv_header_size(u16 opts)
+{
+	int len = (int)offsetof(struct inff_xtlv, data);
+
+	if (opts & INFF_XTLV_OPTION_IDU8)
+		--len;
+	if (opts & INFF_XTLV_OPTION_LENU8)
+		--len;
+
+	return len;
+}
+
+static int inff_fwcmd_xtlv_data_size(int dlen, u16 opts)
+{
+	int hsz;
+
+	hsz = inff_fwcmd_xtlv_header_size(opts);
+	if (opts & INFF_XTLV_OPTION_ALIGN32)
+		return roundup(dlen + hsz, 4);
+
+	return dlen + hsz;
+}
+
+static void inff_fwcmd_xtlv_pack_header(struct inff_xtlv *xtlv, u16 id, u16 len,
+					const u8 *data, u16 opts)
+{
+	u8 *data_buf;
+	u16 mask = INFF_XTLV_OPTION_IDU8 | INFF_XTLV_OPTION_LENU8;
+
+	if (!(opts & mask)) {
+		u8 *idp = (u8 *)xtlv;
+		u8 *lenp = idp + sizeof(xtlv->id);
+
+		put_unaligned_le16(id, idp);
+		put_unaligned_le16(len, lenp);
+		data_buf = lenp + sizeof(u16);
+	} else if ((opts & mask) == mask) { /* u8 id and u8 len */
+		u8 *idp = (u8 *)xtlv;
+		u8 *lenp = idp + 1;
+
+		*idp = (u8)id;
+		*lenp = (u8)len;
+		data_buf = lenp + sizeof(u8);
+	} else if (opts & INFF_XTLV_OPTION_IDU8) { /* u8 id, u16 len */
+		u8 *idp = (u8 *)xtlv;
+		u8 *lenp = idp + 1;
+
+		*idp = (u8)id;
+		put_unaligned_le16(len, lenp);
+		data_buf = lenp + sizeof(u16);
+	} else if (opts & INFF_XTLV_OPTION_LENU8) { /* u16 id, u8 len */
+		u8 *idp = (u8 *)xtlv;
+		u8 *lenp = idp + sizeof(u16);
+
+		put_unaligned_le16(id, idp);
+		*lenp = (u8)len;
+		data_buf = lenp + sizeof(u8);
+	} else {
+		WARN(true, "Unexpected xtlv option");
+		return;
+	}
+
+	if (opts & INFF_XTLV_OPTION_LENU8) {
+		WARN_ON(len > 0x00ff);
+		len &= 0xff;
+	}
+
+	if (data)
+		memcpy(data_buf, data, len);
+}
+
+u32 inff_fwcmd_pack_xtlv(u16 id, char *data, u32 len,
+			 char **buf, u16 *buflen)
+{
+	u32 iolen;
+
+	iolen = inff_fwcmd_xtlv_data_size(len, INFF_XTLV_OPTION_ALIGN32);
+
+	if (iolen > *buflen) {
+		WARN(true, "xtlv buffer is too short");
+		return 0;
+	}
+
+	inff_fwcmd_xtlv_pack_header((void *)*buf, id, len, data,
+				    INFF_XTLV_OPTION_ALIGN32);
+
+	*buf = *buf + iolen;
+	*buflen -= iolen;
+	return iolen;
+}
+
+static u32 inff_create_xtlv(const char *name, u16 id, char *data, u32 len,
+			    char *buf, u32 buflen)
+{
+	u32 iolen;
+	u32 nmlen;
+
+	nmlen = strlen(name) + 1;
+	iolen = nmlen + inff_fwcmd_xtlv_data_size(len, INFF_XTLV_OPTION_ALIGN32);
+
+	if (iolen > buflen) {
+		inff_err("buffer is too short\n");
+		return 0;
+	}
+
+	memcpy(buf, name, nmlen);
+	inff_fwcmd_xtlv_pack_header((void *)(buf + nmlen), id, len, data,
+				    INFF_XTLV_OPTION_ALIGN32);
+
+	return iolen;
+}
+
+s32 inff_fwcmd_xtlv_data_set(struct inff_if *ifp, const char *name, u16 id,
+			     void *data, u32 len)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	inff_dbg(DEVCMD, "ifidx=%d, name=%s, id=%u, len=%u\n", ifp->ifidx, name,
+		 id, len);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	buflen = inff_create_xtlv(name, id, data, len,
+				  drvr->proto_buf, sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = inff_fwcmd_data(ifp, INFF_C_SET_VAR,
+				      drvr->proto_buf, buflen, true);
+	} else {
+		err = -EPERM;
+		iphy_err(drvr, "Creating xtlv failed\n");
+	}
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32 inff_fwcmd_xtlv_data_get(struct inff_if *ifp, const char *name, u16 id,
+			     void *data, u32 len)
+{
+	struct inff_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	buflen = inff_create_xtlv(name, id, data, len,
+				  drvr->proto_buf, sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = inff_fwcmd_data(ifp, INFF_C_GET_VAR,
+				      drvr->proto_buf, buflen, false);
+		if (err == 0)
+			memcpy(data, drvr->proto_buf, len);
+	} else {
+		err = -EPERM;
+		iphy_err(drvr, "Creating bsscfg failed\n");
+	}
+	inff_dbg(DEVCMD, "ifidx=%d, name=%s, id=%u, len=%u, err=%d\n",
+		 ifp->ifidx, name, id, len, err);
+	inff_dbg_hex_dump(INFF_MSGLVL_ON(DEVCMD), data,
+			  min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
diff --git a/drivers/net/wireless/infineon/inffmac/dev_cmd.h b/drivers/net/wireless/infineon/inffmac/dev_cmd.h
new file mode 100644
index 000000000000..22bf99c824e6
--- /dev/null
+++ b/drivers/net/wireless/infineon/inffmac/dev_cmd.h
@@ -0,0 +1,969 @@
+/* SPDX-License-Identifier: ISC */
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Copyright (c) 2025-2026, Infineon Technologies AG, or an affiliate of Infineon Technologies AG.
+ * All rights reserved.
+ */
+
+#ifndef INFF_DEV_CMD_H
+#define INFF_DEV_CMD_H
+
+#include <linux/if_ether.h>
+#include <linux/byteorder/generic.h>
+#include "debug.h"
+
+/*******************************************************************************
+ * Dongle command codes that are interpreted by firmware
+ ******************************************************************************/
+#define INFF_C_GET_VERSION			1
+#define INFF_C_UP				2
+#define INFF_C_DOWN				3
+#define INFF_C_SET_PROMISC			10
+#define INFF_C_GET_RATE			12
+#define INFF_C_GET_INFRA			19
+#define INFF_C_SET_INFRA			20
+#define INFF_C_GET_AUTH			21
+#define INFF_C_SET_AUTH			22
+#define INFF_C_GET_BSSID			23
+#define INFF_C_GET_SSID			25
+#define INFF_C_SET_SSID			26
+#define INFF_C_TERMINATED			28
+#define INFF_C_GET_CHANNEL			29
+#define INFF_C_SET_CHANNEL			30
+#define INFF_C_GET_SRL				31
+#define INFF_C_SET_SRL				32
+#define INFF_C_GET_LRL				33
+#define INFF_C_SET_LRL				34
+#define INFF_C_GET_RADIO			37
+#define INFF_C_SET_RADIO			38
+#define INFF_C_GET_PHYTYPE			39
+#define INFF_C_SET_KEY				45
+#define INFF_C_GET_REGULATORY			46
+#define INFF_C_SET_REGULATORY			47
+#define INFF_C_SET_PASSIVE_SCAN		49
+#define INFF_C_SCAN				50
+#define INFF_C_SCAN_RESULTS			51
+#define INFF_C_DISASSOC			52
+#define INFF_C_REASSOC				53
+#define INFF_C_SET_ROAM_TRIGGER		55
+#define INFF_C_SET_ROAM_DELTA			57
+#define INFF_C_GET_BCNPRD			75
+#define INFF_C_SET_BCNPRD			76
+#define INFF_C_GET_DTIMPRD			77
+#define INFF_C_SET_DTIMPRD			78
+#define INFF_C_SET_COUNTRY			84
+#define INFF_C_GET_PM				85
+#define INFF_C_SET_PM				86
+#define INFF_C_GET_REVINFO			98
+#define INFF_C_GET_CURR_RATESET		114
+#define INFF_C_GET_AP				117
+#define INFF_C_SET_AP				118
+#define INFF_C_SET_SCB_AUTHORIZE		121
+#define INFF_C_SET_SCB_DEAUTHORIZE		122
+#define INFF_C_GET_RSSI			127
+#define INFF_C_GET_WSEC			133
+#define INFF_C_SET_WSEC			134
+#define INFF_C_GET_PHY_NOISE			135
+#define INFF_C_GET_BSS_INFO			136
+#define INFF_C_GET_GET_PKTCNTS			137
+#define INFF_C_GET_BANDLIST			140
+#define INFF_C_SET_SCB_TIMEOUT			158
+#define INFF_C_GET_ASSOCLIST			159
+#define INFF_C_GET_UP				162
+#define INFF_C_GET_PHYLIST			180
+#define INFF_C_SET_SCAN_CHANNEL_TIME		185
+#define INFF_C_SET_SCAN_UNASSOC_TIME		187
+#define INFF_C_SCB_DEAUTHENTICATE_FOR_REASON	201
+#define INFF_C_SET_ASSOC_PREFER		205
+#define INFF_C_GET_VALID_CHANNELS		217
+#define INFF_C_GET_FAKEFRAG                    218
+#define INFF_C_SET_FAKEFRAG			219
+#define INFF_C_GET_KEY_PRIMARY			235
+#define INFF_C_SET_KEY_PRIMARY			236
+#define INFF_C_SET_SCAN_PASSIVE_TIME		258
+#define INFF_C_GET_VAR				262
+#define INFF_C_SET_VAR				263
+#define INFF_C_SET_WSEC_PMK			268
+
+#define INFF_FW_BADARG				2
+#define INFF_FW_UNSUPPORTED			23
+
+/* Special OHD IOCTL definitions
+ * These ioctls carrying SDPCM_OHD_CHANNEL in swheader
+ * and will not be passed on to the firmware and is not
+ * exposed to WL_TOOL. It will be consumed by OHD.
+ */
+#define NON_WLC_ACW74XX_OHD_IOCTL_BASE    1000
+#define ACW74XX_OHD_IOCTL_GET_SHARED_INFO (NON_WLC_ACW74XX_OHD_IOCTL_BASE + 1)
+#define ACW74XX_OHD_IOCTL_GET_CREDIT_INFO (NON_WLC_ACW74XX_OHD_IOCTL_BASE + 2)
+/* end of Special OHD IOCTL */
+
+#define INFF_FIL_ACTION_FRAME_SIZE	1800
+
+#define INFF_AF_PARAM_V2_FW_MAJOR 13
+#define INFF_AF_PARAM_V2_FW_MINOR 2
+
+#define INFF_AUTH_STATUS_V2_FW_MAJOR 13
+#define INFF_AUTH_STATUS_V2_FW_MINOR 3
+
+#define	INFF_BSS_INFO_VER_109	109 /* curr ver of inff_bss_info_le struct */
+#define	INFF_BSS_INFO_VER_110	110
+
+#define INFF_BSS_RSSI_ON_CHANNEL	0x0004
+
+#define INFF_STA_INF        0x00000001	/* Running a Infineon driver */
+#define INFF_STA_WME        0x00000002	/* WMM association */
+#define INFF_STA_NONERP     0x00000004	/* No ERP */
+#define INFF_STA_AUTHE      0x00000008	/* Authenticated */
+#define INFF_STA_ASSOC      0x00000010	/* Associated */
+#define INFF_STA_AUTHO      0x00000020	/* Authorized */
+#define INFF_STA_WDS        0x00000040	/* Wireless Distribution System */
+#define INFF_STA_WDS_LINKUP 0x00000080	/* WDS traffic/probes flowing properly */
+#define INFF_STA_PS         0x00000100	/* STA is in power save mode from AP's viewpoint */
+#define INFF_STA_APSD_BE    0x00000200	/* APSD delv/trigger for AC_BE is default enabled */
+#define INFF_STA_APSD_BK    0x00000400	/* APSD delv/trigger for AC_BK is default enabled */
+#define INFF_STA_APSD_VI    0x00000800	/* APSD delv/trigger for AC_VI is default enabled */
+#define INFF_STA_APSD_VO    0x00001000	/* APSD delv/trigger for AC_VO is default enabled */
+#define INFF_STA_N_CAP      0x00002000	/* STA 802.11n capable */
+#define INFF_STA_SCBSTATS   0x00004000	/* Per STA debug stats */
+#define INFF_STA_AMPDU_CAP  0x00008000	/* STA AMPDU capable */
+#define INFF_STA_AMSDU_CAP  0x00010000	/* STA AMSDU capable */
+#define INFF_STA_MIMO_PS    0x00020000	/* mimo ps mode is enabled */
+#define INFF_STA_MIMO_RTS   0x00040000	/* send rts in mimo ps mode */
+#define INFF_STA_RIFS_CAP   0x00080000	/* rifs enabled */
+#define INFF_STA_VHT_CAP    0x00100000	/* STA VHT(11ac) capable */
+#define INFF_STA_WPS        0x00200000	/* WPS state */
+#define INFF_STA_DWDS_CAP   0x01000000	/* DWDS CAP */
+#define INFF_STA_DWDS       0x02000000	/* DWDS active */
+
+/* size of inff_scan_params not including variable length array */
+#define INFF_SCAN_PARAMS_FIXED_SIZE	64
+#define INFF_SCAN_PARAMS_V2_FIXED_SIZE	72
+
+/* version of inff_scan_params structure */
+#define INFF_SCAN_PARAMS_VERSION_V2	2
+
+/* masks for channel and ssid count */
+#define INFF_SCAN_PARAMS_COUNT_MASK	0x0000ffff
+#define INFF_SCAN_PARAMS_NSSID_SHIFT	16
+
+/* scan type definitions */
+#define INFF_SCANTYPE_DEFAULT		0xFF
+#define INFF_SCANTYPE_ACTIVE		0
+#define INFF_SCANTYPE_PASSIVE		1
+
+#define INFF_WSEC_MAX_PSK_LEN		32
+#define INFF_WSEC_PMK_LEN_SUITEB_192   48
+#define INFF_WSEC_MAX_PMK_LEN		64	/* SUITE-B-192's PMK is 48 bytes */
+#define	INFF_WSEC_PASSPHRASE		BIT(0)
+
+#define INFF_WSEC_MAX_SAE_PASSWORD_LEN 128
+
+/* primary (ie tx) key */
+#define INFF_PRIMARY_KEY		BIT(1)
+#define DOT11_BSSTYPE_ANY		2
+#define INFF_ESCAN_REQ_VERSION		1
+#define INFF_ESCAN_REQ_VERSION_V2	2
+
+#define INFF_MAXRATES_IN_SET		16	/* max # of rates in rateset */
+
+/* OBSS Coex Auto/On/Off */
+#define INFF_OBSS_COEX_AUTO		(-1)
+#define INFF_OBSS_COEX_OFF		0
+#define INFF_OBSS_COEX_ON		1
+
+#define CMD_MASK        0x00FFFFFF
+#define CMD_TYPE_MASK   0xFF000000
+#define CMD_TYPE_SHIFT  24
+
+#define CMD_TYPE_CP     0
+#define CMD_TYPE_WL     1
+
+enum {
+	INFF_CP_C_MAC		 = 1,   /* Get MAC address, Set not ready */
+	INFF_CP_C_IPv4		 = 2,   /* Get IPv4 address, Set not ready */
+	INFF_CP_C_GATEWAY_IP	 = 3,   /* Get gateway address, Set not ready */
+	INFF_CP_C_NETMASK	 = 4,   /* Get netmask address, Set not ready */
+	INFF_CP_C_AP_INFO	 = 5,   /* Get AP SSID/BSSID/channel/RSSI, Set not ready */
+	INFF_CP_C_IP_INFO	 = 6,   /* Get IPv4/gateway/netmask address, Set not ready */
+	INFF_CP_C_SCAN		 = 7,   /* Set to trigger Wi-Fi scan, Get not support */
+	INFF_CP_C_CONNECT	 = 8,   /* Set to trigger Wi-Fi connect, Get not support */
+	INFF_CP_C_DISCONNECT	 = 9,   /* Set to trigger Wi-Fi disconnect, Get not support */
+	INFF_CP_C_PING		 = 10,  /* Set to trigger ICMP ping, Get not support */
+	INFF_CP_C_AT_CMD	 = 11,  /* Set to send AT command to chip, Get not support */
+	INFF_CP_C_MSG_LEVEL	 = 12,  /* Set to msg level to chip, Get not support */
+	INFF_CP_C_DFU		 = 13,  /* Set to download cp image through SDIO, Get not support */
+	INFF_CP_C_IPv6		 = 14,  /* Get IPv6 link local address, Set not support */
+	INFF_CP_C_SAP_MAC	 = 15,  /* Get MAC address of SoftAP, Set not ready */
+	INFF_CP_C_START_SAP	 = 16,  /* Set Soft-AP Start, Get not ready */
+	INFF_CP_C_STOP_SAP	 = 17,  /* Set Soft-AP Stop, Get not ready */
+
+	/* Driver Get/Set */
+	INFF_CP_C_REG_APP	 = 1001,  /* Set to register task, Get not support */
+	INFF_CP_C_DEREG_APP	 = 1002,  /* Set to deregister task, Get not support */
+	INFF_CP_C_EVENT		 = 1003,  /* Get event, Set not support */
+	INFF_CP_C_REG_MONITOR	 = 1004,  /* Set to register monitor task, Get not support */
+	INFF_CP_C_DEREG_MONITOR	 = 1005,  /* Set to deregister monitor task, Get not support */
+	INFF_CP_C_MONITOR_EVENT	 = 1006,  /* Get monitor event, Set not support */
+};
+
+#define INFF_COUNTRY_BUF_SZ		4
+#define INFF_ANT_MAX			4
+
+#define INFF_MAX_ASSOCLIST		128
+
+#define INFF_TXBF_SU_BFE_CAP		BIT(0)
+#define INFF_TXBF_MU_BFE_CAP		BIT(1)
+#define INFF_TXBF_SU_BFR_CAP		BIT(0)
+#define INFF_TXBF_MU_BFR_CAP		BIT(1)
+
+#define	INFF_MAXPMKID			16	/* max # PMKID cache entries */
+#define INFF_NUMCHANNELS		64
+
+#define INFF_MCSSET_LEN		16
+
+#define INFF_RSN_KCK_LENGTH		16
+#define INFF_RSN_KEK_LENGTH		16
+#define INFF_RSN_REPLAY_LEN		8
+
+#define INFF_MFP_NONE			0
+#define INFF_MFP_CAPABLE		1
+#define INFF_MFP_REQUIRED		2
+
+#define INFF_VHT_CAP_MCS_MAP_NSS_MAX	8
+
+#define INFF_HE_CAP_MCS_MAP_NSS_MAX	8
+
+#define INFF_PMKSA_VER_2		2
+#define INFF_PMKSA_VER_3		3
+#define INFF_PMKSA_NO_EXPIRY		0xffffffff
+
+#define INFF_EXTAUTH_START	1
+#define INFF_EXTAUTH_ABORT	2
+#define INFF_EXTAUTH_FAIL	3
+#define INFF_EXTAUTH_SUCCESS	4
+
+/* mchan configuration (ap timeslot : sta timeslot)*/
+#define INFF_MCHAN_CONF_DEFAULT	0 /* mchan_algo=2 (25ms:25ms) */
+#define INFF_MCHAN_CONF_VEDIO 1 /* mchan_algo=5 (29ms:21ms) */
+#define INFF_MCHAN_CONF_AUDIO 2 /* mchan_algo=1, mchan_bw=32 (68ms:32ms) */
+/* mchan algo in dongle */
+#define INFF_MCHAN_DEFAULT_ALGO 0
+#define INFF_MCHAN_BANDWIDTH_ALGO 1
+#define INFF_MCHAN_SI_ALGO 2
+#define INFF_MCHAN_DYNAMIC_BW_ALGO 3
+#define INFF_MCHAN_ALTERNATE_SWITCHING 4
+#define INFF_MCHAN_ASYMMETRIC_SI_ALGO 5
+#define INFF_MCHAN_BANDWIDTH_VAL 32
+
+/* Values for PM */
+#define INFF_PM_OFF 0
+#define INFF_PM_MAX 1
+#define INFF_PM_FAST 2
+
+/* MAX_CHUNK_LEN is the maximum length for data passing to firmware in each
+ * ioctl. It is relatively small because firmware has small maximum size input
+ * playload restriction for ioctls.
+ */
+#define MAX_CHUNK_LEN			1400
+
+#define DLOAD_HANDLER_VER		1	/* Downloader version */
+#define DLOAD_FLAG_VER_MASK		0xf000	/* Downloader version mask */
+#define DLOAD_FLAG_VER_SHIFT		12	/* Downloader version shift */
+
+#define DL_BEGIN			0x0002
+#define DL_END				0x0004
+
+#define DL_TYPE_CLM			2
+
+/* inf type(id), length, value with w/16 bit id/len. The structure below
+ * is nominal, and is used to support variable length id and type. See
+ * xtlv options below.
+ */
+struct inff_xtlv {
+	__le16 id;
+	__le16 len;
+	u8 data[];
+};
+
+#define INFF_WL_CNT_XTLV_SLICE_IDX		256
+#define INFF_IOVAR_XTLV_BEGIN		4
+#define INFF_XTLV_TYPE_SIZE		2
+#define INFF_XTLV_TYPE_LEN_SIZE		4
+
+/* Macro to calculate packing factor with scalar 4 in a xTLV */
+#define INFF_XTLV_PACKING_FACTOR(args)	({ \
+	typeof(args) _args = (args); \
+	((_args) % 4 == 0 ? 0 : (4 - ((_args) % 4))); \
+	})
+
+enum inff_xtlv_option {
+	INFF_XTLV_OPTION_ALIGN32 = BIT(0),
+	INFF_XTLV_OPTION_IDU8 = BIT(1),
+	INFF_XTLV_OPTION_LENU8 = BIT(2),
+};
+
+/* join preference types for join_pref iovar */
+enum inff_join_pref_types {
+	INFF_JOIN_PREF_RSSI = 1,
+	INFF_JOIN_PREF_WPA,
+	INFF_JOIN_PREF_BAND,
+	INFF_JOIN_PREF_RSSI_DELTA,
+};
+
+struct inff_fwcmd_chan_info_le {
+	__le32 hw_channel;
+	__le32 target_channel;
+	__le32 scan_channel;
+};
+
+struct inff_fwcmd_action_frame_le {
+	u8	da[ETH_ALEN];
+	__le16	len;
+	__le32	packet_id;
+	u8	data[INFF_FIL_ACTION_FRAME_SIZE];
+};
+
+struct inff_fwcmd_af_params_le {
+	__le32					channel;
+	__le32					dwell_time;
+	u8					bssid[ETH_ALEN];
+	u8					pad[2];
+	struct inff_fwcmd_action_frame_le	action_frame;
+};
+
+struct inff_fwcmd_af_params_v2_le {
+	__le16					version;
+	__le16					length;
+	__le32					channel;
+	__le32					dwell_time;
+	u8					bssid[ETH_ALEN];
+	u8					band;
+	u8					pad[1];
+	struct inff_fwcmd_action_frame_le	action_frame;
+};
+
+struct inff_fwcmd_bss_enable_le {
+	__le32 bsscfgidx;
+	__le32 enable;
+};
+
+struct inff_fwcmd_bwcap_le {
+	__le32 band;
+	__le32 bw_cap;
+};
+
+/* BSS info structure
+ * Applications MUST CHECK ie_offset field and length field to access IEs and
+ * next bss_info structure in a vector (in struct inff_scan_results)
+ */
+struct inff_bss_info_le {
+	__le32 version;		/* version field */
+	__le32 length;		/* byte length of data in this record,
+				 * starting at version and including IEs
+				 */
+	u8 BSSID[ETH_ALEN];
+	__le16 beacon_period;	/* units are Kusec */
+	__le16 capability;	/* Capability information */
+	u8 SSID_len;
+	u8 SSID[32];
+	u8 bcnflags;	/* additional flags w.r.t. beacon */
+	struct {
+		__le32 count;   /* # rates in this set */
+		u8 rates[16]; /* rates in 500kbps units w/hi bit set if basic */
+	} rateset;		/* supported rates */
+	__le16 chanspec;	/* chanspec for bss */
+	__le16 atim_window;	/* units are Kusec */
+	u8 dtim_period;	/* DTIM period */
+	u8 accessnet;	/* from beacon interwork IE (if bcnflags) */
+	__le16 RSSI;		/* receive signal strength (in dBm) */
+	s8 phy_noise;		/* noise (in dBm) */
+
+	u8 n_cap;		/* BSS is 802.11N Capable */
+
+	u8 he_cap;			/* BSS is he capable */
+	u8 padding1;
+	__le32 nbss_cap;	/* 802.11N BSS Capabilities (based on HT_CAP_*): */
+
+	u8 ctl_ch;		/* 802.11N BSS control channel number */
+	u8 padding2[3];
+	__le16 vht_rxmcsmap;	/* VHT rx mcs map (802.11ac IE, VHT_CAP_MCS_MAP_*) */
+	__le16 vht_txmcsmap;	/* VHT tx mcs map (802.11ac IE, VHT_CAP_MCS_MAP_*) */
+
+	u8 flags;		/* flags */
+	u8 vht_cap;		/* BSS is vht capable */
+	u8 padding3[2];		/* Reserved for expansion of BSS properties */
+	u8 basic_mcs[INFF_MCSSET_LEN];	/* 802.11N BSS required MCS set */
+
+	__le16 ie_offset;	/* offset at which IEs start, from beginning */
+	u8 padding4[2];
+	__le32 ie_length;	/* byte length of Information Elements */
+	__le16 SNR;		/* average SNR of during frame reception */
+
+		__le16 vht_mcsmap;	/* STA's Associated vhtmcsmap */
+	__le16 vht_mcsmap_prop;	/* STA's Associated prop vhtmcsmap */
+	__le16 vht_txmcsmap_prop;	/* prop VHT tx mcs prop */
+	__le32 he_mcsmap;	/* STA's Associated hemcsmap */
+	__le32 he_rxmcsmap;	/* HE rx mcs map */
+	__le32 he_txmcsmap;	/* HE tx mcs map */
+	__le32 timestamp[2];	/* Beacon Timestamp for FAKEAP req */
+
+	/* v110 */
+	/* Eht parameters in bss info
+	 */
+	u8 eht_cap;	/* BSS is eht capable */
+	u8 eht_20monly;	/* BSS is 20M only capable */
+	u8 ml_cap;	/* BSS is ML capable */
+	u8 linkid;	/* Link id(if ML capable) */
+	__le32 eht_txrxnssmap;	/* EHT txrx nss map */
+	__le32 eht_mcsnssmap;	/* EHT device nss map */
+	u8 mld_mac_address[ETH_ALEN];	/* MLD mac address(if ML capable) */
+
+	/* Add new fields here */
+	/* variable length Information Elements */
+};
+
+struct inff_rateset_le {
+	/* # rates in this set */
+	__le32 count;
+	/* rates in 500kbps units w/hi bit set if basic */
+	u8 rates[INFF_MAXRATES_IN_SET];
+};
+
+struct inff_ssid_le {
+	__le32 SSID_len;
+	unsigned char SSID[IEEE80211_MAX_SSID_LEN];
+};
+
+struct inff_scan_params_le {
+	struct inff_ssid_le ssid_le;	/* default: {0, ""} */
+	u8 bssid[ETH_ALEN];	/* default: bcast */
+	s8 bss_type;		/* default: any,
+				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
+				 */
+	u8 scan_type;	/* flags, 0 use default */
+	__le32 nprobes;	  /* -1 use default, number of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	__le32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	__le32 home_time;	/* -1 use default, dwell time for the
+				 * home channel between channel scans
+				 */
+	__le32 channel_num;	/* count of channels and ssids that follow
+				 *
+				 * low half is count of channels in
+				 * channel_list, 0 means default (use all
+				 * available channels)
+				 *
+				 * high half is entries in struct inff_ssid
+				 * array that follows channel_list, aligned for
+				 * s32 (4 bytes) meaning an odd channel count
+				 * implies a 2-byte pad between end of
+				 * channel_list and first ssid
+				 *
+				 * if ssid count is zero, single ssid in the
+				 * fixed parameter portion is assumed, otherwise
+				 * ssid in the fixed portion is ignored
+				 */
+	union {
+		__le16 padding;	/* Reserve space for at least 1 entry for abort
+				 * which uses an on stack inff_scan_params_le
+				 */
+		DECLARE_FLEX_ARRAY(__le16, channel_list);	/* chanspecs */
+	};
+};
+
+struct inff_scan_params_v2_le {
+	__le16 version;		/* structure version */
+	__le16 length;		/* structure length */
+	struct inff_ssid_le ssid_le;	/* default: {0, ""} */
+	u8 bssid[ETH_ALEN];	/* default: bcast */
+	s8 bss_type;		/* default: any,
+				 * DOT11_BSSTYPE_ANY/INFRASTRUCTURE/INDEPENDENT
+				 */
+	u8 pad;
+	__le32 scan_type;	/* flags, 0 use default */
+	__le32 nprobes;		/* -1 use default, number of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	__le32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	__le32 home_time;	/* -1 use default, dwell time for the
+				 * home channel between channel scans
+				 */
+	__le32 channel_num;	/* count of channels and ssids that follow
+				 *
+				 * low half is count of channels in
+				 * channel_list, 0 means default (use all
+				 * available channels)
+				 *
+				 * high half is entries in struct inff_ssid
+				 * array that follows channel_list, aligned for
+				 * s32 (4 bytes) meaning an odd channel count
+				 * implies a 2-byte pad between end of
+				 * channel_list and first ssid
+				 *
+				 * if ssid count is zero, single ssid in the
+				 * fixed parameter portion is assumed, otherwise
+				 * ssid in the fixed portion is ignored
+				 */
+	union {
+		__le16 padding;	/* Reserve space for at least 1 entry for abort
+				 * which uses an on stack inff_scan_params_v2_le
+				 */
+		DECLARE_FLEX_ARRAY(__le16, channel_list);	/* chanspecs */
+	};
+};
+
+struct inff_scan_results {
+	u32 buflen;
+	u32 version;
+	u32 count;
+	struct inff_bss_info_le bss_info_le[];
+};
+
+struct inff_escan_params_le {
+	__le32 version;
+	__le16 action;
+	__le16 sync_id;
+	union {
+		struct inff_scan_params_le params_le;
+		struct inff_scan_params_v2_le params_v2_le;
+	};
+};
+
+struct inff_escan_result_le {
+	__le32 buflen;
+	__le32 version;
+	__le16 sync_id;
+	__le16 bss_count;
+	struct inff_bss_info_le bss_info_le;
+};
+
+#define WL_ESCAN_RESULTS_FIXED_SIZE (sizeof(struct inff_escan_result_le) - \
+	sizeof(struct inff_bss_info_le))
+
+/* used for association with a specific BSSID and chanspec list */
+struct inff_assoc_params_le {
+	/* 00:00:00:00:00:00: broadcast scan */
+	u8 bssid[ETH_ALEN];
+	/* 0: all available channels, otherwise count of chanspecs in
+	 * chanspec_list
+	 */
+	__le32 chanspec_num;
+	/*
+	 * list of chanspecs. Currently, driver only uses 1 chanspec here.
+	 * Can convert this into a flexible array to support multiple
+	 * chanspecs.
+	 */
+	__le16 chanspec_list;
+};
+
+/**
+ * struct join_pref params - parameters for preferred join selection.
+ *
+ * @type: preference type (see enum inff_join_pref_types).
+ * @len: length of bytes following (currently always 2).
+ * @rssi_gain: signal gain for selection (only when @type is RSSI_DELTA).
+ * @band: band to which selection preference applies.
+ *	This is used if @type is BAND or RSSI_DELTA.
+ */
+struct inff_join_pref_params {
+	u8 type;
+	u8 len;
+	u8 rssi_gain;
+	u8 band;
+};
+
+/* used for join with or without a specific bssid and channel list */
+struct inff_join_params {
+	struct inff_ssid_le ssid_le;
+	struct inff_assoc_params_le params_le;
+};
+
+/*
+ * wifi connect structure
+ */
+struct inff_cp_connect_le {
+	u8     ssid_length;                       /* SSID length                     */
+	char   ssid[IEEE80211_MAX_SSID_LEN + 1];  /* SSID of the access point        */
+	__le32    security_type;                     /* WiFi security type              */
+	char   password[PMK_MAX_LEN - 1];         /* Length of WIFI password         */
+	u8     macaddr[ETH_ALEN];                 /* MAC Address of the access point */
+	u8     band;                              /* WiFi band of access point       */
+	__le32    ip_address;                        /* static IP address               */
+	__le32    gateway;                           /* static gateway                  */
+	__le32    netmask;                           /* static netmask                  */
+	__le32    option;                            /* join option                     */
+	__le32    channel;                           /* WiFi channel number             */
+} __packed;
+
+/* scan params for extended join */
+struct inff_join_scan_params_le {
+	u8 scan_type;		/* 0 use default, active or passive scan */
+	__le32 nprobes;		/* -1 use default, nr of probes per channel */
+	__le32 active_time;	/* -1 use default, dwell time per channel for
+				 * active scanning
+				 */
+	__le32 passive_time;	/* -1 use default, dwell time per channel
+				 * for passive scanning
+				 */
+	__le32 home_time;	/* -1 use default, dwell time for the home
+				 * channel between channel scans
+				 */
+};
+
+/* extended join params */
+struct inff_ext_join_params_le {
+	struct inff_ssid_le ssid_le;	/* {0, ""}: wildcard scan */
+	struct inff_join_scan_params_le scan_le;
+	struct inff_assoc_params_le assoc_le;
+};
+
+/**
+ * struct inff_auth_req_status_le - external auth request and status update
+ *
+ * @flags: flags for external auth status
+ * @peer_mac: peer MAC address
+ * @ssid_len: length of ssid
+ * @ssid: ssid characters
+ * @pmkid: PMKSA identifier
+ */
+struct inff_auth_req_status_le {
+	__le16 flags;
+	u8 peer_mac[ETH_ALEN];
+	__le32 ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 pmkid[WLAN_PMKID_LEN];
+};
+
+struct inff_auth_req_status_info_le_v2 {
+	__le16  version;
+	__le16  len;
+	__le16  flags;
+	u8 peer_mac[ETH_ALEN];/* peer mac address */
+	__le32 ssid_len;
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 pmkid[WLAN_PMKID_LEN];
+	struct inff_bss_info_le bss_info_le[];
+};
+
+/**
+ * struct inff_mf_params_le - management frame parameters for mgmt_frame iovar
+ *
+ * @version: version of the iovar
+ * @dwell_time: dwell duration in ms
+ * @len: length of frame data
+ * @frame_control: frame control
+ * @channel: channel
+ * @da: peer MAC address
+ * @bssid: BSS network identifier
+ * @packet_id: packet identifier
+ * @data: frame data
+ */
+struct inff_mf_params_le {
+	__le32 version;
+	__le32 dwell_time;
+	__le16 len;
+	__le16 frame_control;
+	__le16 channel;
+	u8 da[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
+	__le32 packet_id;
+	u8 data[] __counted_by_le(len);
+};
+
+/* Used to get specific STA parameters */
+struct inff_scb_val_le {
+	__le32 val;
+	u8 ea[ETH_ALEN];
+};
+
+/* channel encoding */
+struct inff_channel_info_le {
+	__le32 hw_channel;
+	__le32 target_channel;
+	__le32 scan_channel;
+};
+
+struct inff_sta_info_le {
+	__le16 ver;		/* version of this struct */
+	__le16 len;		/* length in bytes of this structure */
+	__le16 cap;		/* sta's advertised capabilities */
+	__le32 flags;		/* flags defined below */
+	__le32 idle;		/* time since data pkt rx'd from sta */
+	u8 ea[ETH_ALEN];		/* Station address */
+	__le32 count;			/* # rates in this set */
+	u8 rates[INFF_MAXRATES_IN_SET];	/* rates in 500kbps units */
+						/* w/hi bit set if basic */
+	__le32 in;		/* seconds elapsed since associated */
+	__le32 listen_interval_inms; /* Min Listen interval in ms for STA */
+
+	/* Fields valid for ver >= 3 */
+	__le32 tx_pkts;	/* # of packets transmitted */
+	__le32 tx_failures;	/* # of packets failed */
+	__le32 rx_ucast_pkts;	/* # of unicast packets received */
+	__le32 rx_mcast_pkts;	/* # of multicast packets received */
+	__le32 tx_rate;	/* Rate of last successful tx frame */
+	__le32 rx_rate;	/* Rate of last successful rx frame */
+	__le32 rx_decrypt_succeeds;	/* # of packet decrypted successfully */
+	__le32 rx_decrypt_failures;	/* # of packet decrypted failed */
+
+	/* Fields valid for ver >= 4 */
+	__le32 tx_tot_pkts;    /* # of tx pkts (ucast + mcast) */
+	__le32 rx_tot_pkts;    /* # of data packets recvd (uni + mcast) */
+	__le32 tx_mcast_pkts;  /* # of mcast pkts txed */
+	__le64 tx_tot_bytes;   /* data bytes txed (ucast + mcast) */
+	__le64 rx_tot_bytes;   /* data bytes recvd (ucast + mcast) */
+	__le64 tx_ucast_bytes; /* data bytes txed (ucast) */
+	__le64 tx_mcast_bytes; /* # data bytes txed (mcast) */
+	__le64 rx_ucast_bytes; /* data bytes recvd (ucast) */
+	__le64 rx_mcast_bytes; /* data bytes recvd (mcast) */
+	s8 rssi[INFF_ANT_MAX];   /* per antenna rssi */
+	s8 nf[INFF_ANT_MAX];     /* per antenna noise floor */
+	__le16 aid;                    /* association ID */
+	__le16 ht_capabilities;        /* advertised ht caps */
+	__le16 vht_flags;              /* converted vht flags */
+	__le32 tx_pkts_retry_cnt;      /* # of frames where a retry was
+					* exhausted.
+					*/
+	__le32 tx_pkts_retry_exhausted; /* # of user frames where a retry
+					 * was exhausted
+					 */
+	s8 rx_lastpkt_rssi[INFF_ANT_MAX]; /* Per antenna RSSI of last
+					   * received data frame.
+					   */
+	/* TX WLAN retry/failure statistics:
+	 * Separated for host requested frames and locally generated frames.
+	 * Include unicast frame only where the retries/failures can be counted.
+	 */
+	__le32 tx_pkts_total;          /* # user frames sent successfully */
+	__le32 tx_pkts_retries;        /* # user frames retries */
+	__le32 tx_pkts_fw_total;       /* # FW generated sent successfully */
+	__le32 tx_pkts_fw_retries;     /* # retries for FW generated frames */
+	__le32 tx_pkts_fw_retry_exhausted;     /* # FW generated where a retry
+						* was exhausted
+						*/
+	__le32 rx_pkts_retried;        /* # rx with retry bit set */
+	__le32 tx_rate_fallback;       /* lowest fallback TX rate */
+
+	union {
+		struct {
+			struct {
+				/* # rates in this set */
+				__le32 count;
+				/* rates in 500kbps units w/hi bit set if basic */
+				u8 rates[INFF_MAXRATES_IN_SET];
+				/* supported mcs index bit map */
+				u8 mcs[INFF_MCSSET_LEN];
+				/* supported mcs index bit map per nss */
+				__le16 vht_mcs[INFF_VHT_CAP_MCS_MAP_NSS_MAX];
+			} rateset_adv;
+		} v5;
+
+		struct {
+			__le32 rx_dur_total;	/* total user RX duration (estimated) */
+			__le16 chanspec;	/** chanspec this sta is on */
+			__le16 pad_1;
+			struct {
+				__le16 version;					/* version */
+				__le16 len;					/* length */
+				/* # rates in this set */
+				__le32 count;
+				/* rates in 500kbps units w/hi bit set if basic */
+				u8 rates[INFF_MAXRATES_IN_SET];
+				/* supported mcs index bit map */
+				u8 mcs[INFF_MCSSET_LEN];
+				/* supported mcs index bit map per nss */
+				__le16 vht_mcs[INFF_VHT_CAP_MCS_MAP_NSS_MAX];
+				/* supported he mcs index bit map per nss */
+				__le16 he_mcs[INFF_HE_CAP_MCS_MAP_NSS_MAX];
+			} rateset_adv;		/* rateset along with mcs index bitmap */
+			__le16 wpauth;		/* authentication type */
+			u8 algo;		/* crypto algorithm */
+			u8 pad_2;
+			__le32 tx_rspec;	/* Rate of last successful tx frame */
+			__le32 rx_rspec;	/* Rate of last successful rx frame */
+			__le32 wnm_cap;		/* wnm capabilities */
+		} v7;
+	};
+};
+
+struct inff_chanspec_list {
+	__le32	count;		/* # of entries */
+	__le32  element[];	/* variable length uint32 list */
+};
+
+/*
+ * INFF_E_PROBRESP_MSG
+ * INFF_E_ACTION_FRAME_RX_COMPLETE
+ */
+struct inff_rx_mgmt_data {
+	__be16	version;
+	__be16	chanspec;
+	__be32	rssi;
+	__be32	mactime;
+	__be32	rate;
+};
+
+/**
+ * struct inff_fwcmd_country_le - country configuration structure.
+ *
+ * @country_abbrev: null-terminated country code used in the country IE.
+ * @rev: revision specifier for ccode. on set, -1 indicates unspecified.
+ * @ccode: null-terminated built-in country code.
+ */
+struct inff_fwcmd_country_le {
+	char country_abbrev[INFF_COUNTRY_BUF_SZ];
+	__le32 rev;
+	char ccode[INFF_COUNTRY_BUF_SZ];
+};
+
+/**
+ * struct inff_rev_info_le - device revision info.
+ *
+ * @vendorid: PCI vendor id.
+ * @deviceid: device id of chip.
+ * @radiorev: radio revision.
+ * @chiprev: chip revision.
+ * @corerev: core revision.
+ * @boardid: board identifier (usu. PCI sub-device id).
+ * @boardvendor: board vendor (usu. PCI sub-vendor id).
+ * @boardrev: board revision.
+ * @driverrev: driver version.
+ * @ucoderev: microcode version.
+ * @bus: bus type.
+ * @chipnum: chip number.
+ * @phytype: phy type.
+ * @phyrev: phy revision.
+ * @anarev: anacore rev.
+ * @chippkg: chip package info.
+ * @nvramrev: nvram revision number.
+ */
+struct inff_rev_info_le {
+	__le32 vendorid;
+	__le32 deviceid;
+	__le32 radiorev;
+	__le32 chiprev;
+	__le32 corerev;
+	__le32 boardid;
+	__le32 boardvendor;
+	__le32 boardrev;
+	__le32 driverrev;
+	__le32 ucoderev;
+	__le32 bus;
+	__le32 chipnum;
+	__le32 phytype;
+	__le32 phyrev;
+	__le32 anarev;
+	__le32 chippkg;
+	__le32 nvramrev;
+};
+
+/**
+ * struct inff_wlc_version_le - firmware revision info.
+ *
+ * @version: structure version.
+ * @length: structure length.
+ * @epi_ver_major: EPI major version
+ * @epi_ver_minor: EPI minor version
+ * @epi_ver_rc: EPI rc version
+ * @epi_ver_incr: EPI increment version
+ * @wlc_ver_major: WLC major version
+ * @wlc_ver_minor: WLC minor version
+ */
+struct inff_wlc_version_le {
+	__le16 version;
+	__le16 length;
+
+	__le16 epi_ver_major;
+	__le16 epi_ver_minor;
+	__le16 epi_ver_rc;
+	__le16 epi_ver_incr;
+
+	__le16 wlc_ver_major;
+	__le16 wlc_ver_minor;
+};
+
+/**
+ * struct inff_dload_data_le - data passing to firmware for downloading
+ * @flag: flags related to download data.
+ * @dload_type: type of download data.
+ * @len: length in bytes of download data.
+ * @crc: crc of download data.
+ * @data: download data.
+ */
+struct inff_dload_data_le {
+	__le16 flag;
+	__le16 dload_type;
+	__le32 len;
+	__le32 crc;
+	u8 data[];
+};
+
+/**
+ * struct inff_pktcnt_le - packet counters.
+ *
+ * @rx_good_pkt: packets (MSDUs & MMPDUs) received from this station
+ * @rx_bad_pkt: failed rx packets
+ * @tx_good_pkt: packets (MSDUs & MMPDUs) transmitted to this station
+ * @tx_bad_pkt: failed tx packets
+ * @rx_ocast_good_pkt: unicast packets destined for others
+ */
+struct inff_pktcnt_le {
+	__le32 rx_good_pkt;
+	__le32 rx_bad_pkt;
+	__le32 tx_good_pkt;
+	__le32 tx_bad_pkt;
+	__le32 rx_ocast_good_pkt;
+};
+
+/**
+ * struct inff_gtk_keyinfo_le - GTP rekey data
+ *
+ * @kck: key confirmation key.
+ * @kek: key encryption key.
+ * @replay_counter: replay counter.
+ */
+struct inff_gtk_keyinfo_le {
+	u8 kck[INFF_RSN_KCK_LENGTH];
+	u8 kek[INFF_RSN_KEK_LENGTH];
+	u8 replay_counter[INFF_RSN_REPLAY_LEN];
+};
+
+s32 inff_cpcmd_data_set(struct inff_if *ifp, u32 cmd, void *data, u32 len);
+s32 inff_cpcmd_data_get(struct inff_if *ifp, u32 cmd, void *data, u32 len);
+
+s32 inff_fwcmd_data_set(struct inff_if *ifp, u32 cmd, void *data, u32 len);
+s32 inff_fwcmd_data_get(struct inff_if *ifp, u32 cmd, void *data, u32 len);
+s32 inff_fwcmd_int_set(struct inff_if *ifp, u32 cmd, u32 data);
+
+s32 inff_fwcmd_iovar_data_set(struct inff_if *ifp, const char *name,
+			      const void *data, u32 len);
+s32 inff_fwcmd_iovar_data_get(struct inff_if *ifp, const char *name,
+			      void *data, u32 len);
+s32 inff_fwcmd_iovar_int_set(struct inff_if *ifp, const char *name, u32 data);
+s32 inff_fwcmd_iovar_int_get(struct inff_if *ifp, const char *name, u32 *data);
+
+s32 inff_fwcmd_bsscfg_data_set(struct inff_if *ifp, const char *name,
+			       void *data, u32 len);
+s32 inff_fwcmd_bsscfg_data_get(struct inff_if *ifp, const char *name,
+			       void *data, u32 len);
+s32 inff_fwcmd_bsscfg_int_get(struct inff_if *ifp, const char *name, u32 *data);
+
+s32 inff_fwcmd_xtlv_data_get(struct inff_if *ifp, const char *name, u16 id,
+			     void *data, u32 len);
+u32 inff_fwcmd_pack_xtlv(u16 id, char *data, u32 len,
+			 char **buf, u16 *buflen);
+s32 inff_fwcmd_xtlv_data_set(struct inff_if *ifp, const char *name, u16 id,
+			     void *data, u32 len);
+s32 inff_fwcmd_xtlv_data_get(struct inff_if *ifp, const char *name, u16 id,
+			     void *data, u32 len);
+
+#endif /* INFF_DEV_CMD_H */
-- 
2.43.0

