Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:51686 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937308AbeFSHxy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 03:53:54 -0400
Received: by mail-wm0-f51.google.com with SMTP id r15-v6so18215972wmc.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 00:53:54 -0700 (PDT)
Subject: Re: Research + questions on brcmfmac and support for monitor mode
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <986bbf4c-8fa1-4367-db9e-76a209594b81@gmail.com>
 <66e43eb5-2bc9-2ec3-af48-03248eecb727@gmail.com>
 <5B1E537F.2080502@broadcom.com>
 <CACna6rxa4+UEOs1FjQUGnHpFJn4n_TO6v=Vx3SqNA32QvzQEGQ@mail.gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B28B68F.8070505@broadcom.com> (sfid-20180619_095403_439944_8ADF53DC)
Date: Tue, 19 Jun 2018 09:53:51 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rxa4+UEOs1FjQUGnHpFJn4n_TO6v=Vx3SqNA32QvzQEGQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/19/2018 9:27 AM, Rafał Miłecki wrote:
> On Mon, 11 Jun 2018 at 12:48, Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 5/30/2018 1:52 PM, Rafał Miłecki wrote:
>>> I'm providing extra version info of tested firmware images as requested
>>> by Arend in another e-mail thread.
>>
>> Looking into our firmware repo it there are two flags, ie. WL_MONITOR
>> and WL_RADIOTAP. It seems both are set for firmware containing -stamon-
>> feature. Your list below confirms that. I still plan to add indication
>> for WL_RADIOTAP in the "cap" iovar, but a stamon feature check could be
>> used for older firmwares.
>
> I just checked wl.mk (it's an open source file) and found following line:
> WLFILES_SRC_HI += src/wl/sys/wlc_stamon.c
> not guarded by any ifeq.

wl.mk is used for NIC driver (softmac) so it is not used for fullmac 
firmware.

> It appears wlc_stamon.c is always being compiled in. Are you 100% sure
> that wlc_stamon.c depends & uses radiotap? Are you sure it's
> impossible to include stamon support without radiotap support?
>
> I'm asking because we're going to check "sta_monitor" iovar to find
> out if radiotap support is included. I'd like to be sure it's 100%
> reliable.

I have already created a patch for this (see below). I will submit it 
this week.

Regards,
Arend

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c 
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index f70fec6..67d7fc7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -207,6 +207,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
  	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
  	struct brcmf_pno_macaddr_le pfn_mac;
  	struct brcmf_gscan_config gscan_cfg;
+	struct brcmf_stamon_sta_config stamon_cfg;
  	u32 wowl_cap;
  	s32 err;

@@ -217,6 +218,20 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
  		brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
  					  "pfn_gscan_cfg",
  					  &gscan_cfg, sizeof(gscan_cfg));
+
+	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR) ||
+	    !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RADIOTAP)) {
+		ifp->fwil_fwerr = true;
+		memset(&stamon_cfg, 0, sizeof(stamon_cfg));
+		/* iovar requires IOVF_SET_UP so this fails either way */
+		err = brcmf_fil_iovar_data_set(ifp, "sta_monitor", &stamon_cfg,
+					       sizeof(stamon_cfg));
+		if (err != BRCMF_FW_UNSUPPORTED) {
+			ifp->drvr->feat_flags |= BRCMF_FEAT_MONITOR;
+			ifp->drvr->feat_flags |= BRCMF_FEAT_RADIOTAP;
+		}
+		ifp->fwil_fwerr = false;
+	}
  	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
  	if (drvr->bus_if->wowl_supported)
  		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
diff --git 
a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h 
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 4b29070..e42d296 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -963,4 +963,36 @@ struct brcmf_gscan_config {
  	struct brcmf_gscan_bucket_config bucket[1];
  };

+enum brcmf_stamon_cfg_cmd {
+        STAMON_CFG_CMD_DEL = 0,
+        STAMON_CFG_CMD_ADD = 1,
+        STAMON_CFG_CMD_ENB = 2,
+        STAMON_CFG_CMD_DSB = 3,
+        STAMON_CFG_CMD_CNT = 4,
+        STAMON_CFG_CMD_RSTCNT = 5,
+        STAMON_CFG_CMD_GET_STATS = 6,
+        STAMON_CFG_CMD_SET_MONTIME = 7
+};
+
+/**
+ * struct brcmf_stamon_sta_config - configuration data for sta monitor.
+ *
+ * @cmd: subcommand for this configuration (see @enum 
brcmf_stamon_cfg_cmd).
+ * @mac: mac address of sta for which @cmd is intended.
+ * @version: version of this configuration structure.
+ * @length: number of bytes following this field.
+ * @chanspec: not used ?
+ * @mon_time: time for which STA's are monitored (ms).
+ * @offchan_time: timer for which off-channel STA's are monitored.
+ */
+struct brcmf_stamon_sta_config {
+        __le32 cmd;
+        u8 mac[ETH_ALEN];
+        __le16 version;
+        __le16 length;
+        __le16 chanspec;
+        __le32 monitor_time;
+        __le32 offchan_time;
+};
+
  #endif /* FWIL_TYPES_H_ */
