Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FAC32B125
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 10:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789380323; cv=none; b=K6eQnB+T8K8ICN+IaQN45RS4ikPSdCycNrrE+M/MRqw33RahKAJeuY7aBzsKRvzxkpgB5UnMDZMY79A/hkEzP/Apn8u0zVypC2gQxOl8uRTmhJuKuIbqBT13fFMbmWinaLLS2vWxfZ9bRbnwTeAa9B/9XvErA1YhcuVQBjJvbHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789380323; c=relaxed/simple;
	bh=TsUsZpipKQY15g47quss9QPvlYvz3vO5lE8KKd+zR48=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BHDtq8F9LZI7SnmdL/ofb5wZYl7P2U/BQ9pYROgcJC8HC6tMojzcxY5//i6igNUeqAm6KtRXUhEWWI62CMAWHWILnYli8jZ31SzC+0iulrEmCzEb3QuxZCU6kOdeg2uat/1gEYeKNEqY5ehdU4w9yDkuzbnVKEp/yEZdrSG5gHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qm4VbOgu; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qm4VbOgu"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a60591ae54so3657992a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 03:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789380320; x=1789985120; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kdV7MpCqFBBDoAl1fI5Cn4kKwBdhMSx2A1efp4TasqU=;
        b=Qm4VbOguZ68J7qLE5t6Rtehb094rq9xClvOvzbheUpsmy+NvIY/APKQgs4OJEdG1Z0
         9xkJ++E1UWH/LVO2dML/xdkT9lxsmAMHQR2s/Fs4ac7NueejXKKs/IzA1CGkoLgYHB6w
         EHRRMlS9TZczakfYSBbmV54NIX/aGzrA2eqcp+WmhvDfm7E/fCZfHBN6OiYgTBjW6iwM
         0eMUG0c25hxao+uxDC+ci9AQPnJpnaaD3K4+dlIs3n+uh1CZuE/QiNEbDJRb+Zqa1fAM
         2ikTb6Bg6bOnCE9UfRYDzYrhqReUIe/T3aQeFp298CCHlCwgYQAsv2YesNFKOyguVi53
         b1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789380320; x=1789985120;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kdV7MpCqFBBDoAl1fI5Cn4kKwBdhMSx2A1efp4TasqU=;
        b=N7MRy+6fLV7zjT4jziPsG3ZLNHDjjnZP2/TeGvgGHwgmuA4rVjpEd22lpNlECFISFm
         bu8EQzkz3uvXrr5iBgNpc5fLbMKJbqdwfBy4qEofiq2WrRIhSgeobmPuj08YVXJLnWdr
         JtKG3blHhv6hqofn90HOHQ1YW+NPbQQfRKzmbwckJ90xzUOyfopZRS2OiShljurH0EQL
         4hf6q/EdCPhqGn7mshS1JveHOY29w3e2FuTmlbE4cYlOu5A3ya0x6TP4HkUi12y0fD32
         CywYuaeuJMdI1Dq1ons4jsJSSGEE3Ucidgh5Fz6Qmw3TihXNpP7iHjL1ulWWI3snjf7s
         JB0A==
X-Gm-Message-State: AFuF++lWgGZcRT+G5k9U6KmEsdKIik6qaGWniek7DHcYJRihJF3QV6Lq
	+VnIh1ggLFSPQFjtViMWCkIdWVvrxa15xl8od/GKixRhVS9t2zlDdI6h
X-Gm-Gg: AYBFou34K++VTaW1FCgqahWRrNM0JK60G63ATqeGe7eux1+4f9rnsEQ3sL1qvi31lKE
	WojFWwlaSWVXTiFZ3Z3+23oa9VBCiGVi7pYNb8I5FeeSsgu5Au50SVoXeDkRx7Kx8zdpcJFK4wN
	zn2qWjPoDxY296hn8n6s0iUoFErNNPYVOBYVZzWE0wOBbVvKNuiDj8h2SW602wmlx+jhzzjY0T8
	BZm2vKv4lRrUwNqvXqLwWphKptziQ4kW0iSzGgxgFPK0uUbtV4+xZ+yecyFFoaplLowyi4Xqjx7
	neSmIDeW56apoZRKNqwlBm1ShW8gqjnxbS9+kU7tr/S0tsFadXx5AblV9fW5NYOUG4uFKcSLiGj
	aIZS9EOqiai7lM+35u2fjaFA8bQ6xdr0FhLSiSq/3Jup01w80aF54N6Ww5OqB5pBSUFD1GZePRj
	g5IOo1gAXb9OoA+0oPeCH+EAsdnul7JmyutMc/KBiBwQM/wuZis6fTlshxjqNLzjC74R8m
X-Received: by 2002:a05:6402:42c6:b0:6a1:f7f4:200b with SMTP id 4fb4d7f45d1cf-6a9f625e907mr2473045a12.12.1789380319418;
        Mon, 14 Sep 2026 03:05:19 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9b58f8beesm3799962a12.8.2026.09.14.03.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 03:05:18 -0700 (PDT)
Date: Mon, 14 Sep 2026 13:05:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] wifi: nxp: add nxpwifi driver for IW61x
Message-ID: <aqfG28zBKNxH63HU@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Jeff Chen,

Commit 73b01e57ed3e ("wifi: nxp: add nxpwifi driver for IW61x") from
Jun 5, 2026 (linux-next), leads to the following Smatch static
checker warning:

	drivers/net/wireless/nxp/nxpwifi/main.c:627 _nxpwifi_fw_dpc()
	warn: missing error code 'ret'

drivers/net/wireless/nxp/nxpwifi/main.c
    552 static int _nxpwifi_fw_dpc(const struct firmware *firmware, void *context)
    553 {
    554         int ret = 0;
    555         char fmt[64];
    556         struct nxpwifi_adapter *adapter = context;
    557         struct nxpwifi_fw_image fw;
    558         bool init_failed = false;
    559         struct wireless_dev *wdev;
    560         struct completion *fw_done = adapter->fw_done;
    561 
    562         if (!firmware) {
    563                 nxpwifi_dbg(adapter, ERROR,
    564                             "Failed to get firmware %s\n", adapter->fw_name);
    565                 ret = -EINVAL;
    566                 goto err_dnld_fw;
    567         }
    568 
    569         memset(&fw, 0, sizeof(struct nxpwifi_fw_image));
    570         adapter->firmware = firmware;
    571         fw.fw_buf = (u8 *)adapter->firmware->data;
    572         fw.fw_len = adapter->firmware->size;
    573 
    574         if (adapter->if_ops.dnld_fw)
    575                 ret = adapter->if_ops.dnld_fw(adapter, &fw);
    576         else
    577                 ret = nxpwifi_dnld_fw(adapter, &fw);
    578 
    579         if (ret)
    580                 goto err_dnld_fw;
    581 
    582         nxpwifi_dbg(adapter, MSG, "WLAN FW is active\n");
    583 
    584         /* Load optional calibration data */
    585         ret = request_firmware(&adapter->cal_data, cal_data_name, adapter->dev);
    586         if (ret) {
    587                 nxpwifi_dbg(adapter, INFO, "no %s, using default cal\n",
    588                             cal_data_name);
    589                 adapter->cal_data = NULL;
    590         }
    591 
    592         /* enable host interrupt after fw dnld is successful */
    593         if (adapter->if_ops.enable_int) {
    594                 ret = adapter->if_ops.enable_int(adapter);
    595                 if (ret)
    596                         goto err_dnld_fw;
    597         }
    598 
    599         ret = nxpwifi_init_fw(adapter);
    600         if (ret)
    601                 goto err_init_fw;
    602 
    603         maybe_quirk_fw_disable_ds(adapter);
    604 
    605         if (!adapter->wiphy) {
    606                 if (nxpwifi_register_cfg80211(adapter)) {
    607                         nxpwifi_dbg(adapter, ERROR,
    608                                     "cannot register with cfg80211\n");
    609                         goto err_init_fw;
    610                 }
    611         }
    612 
    613         if (nxpwifi_init_channel_scan_gap(adapter)) {
    614                 nxpwifi_dbg(adapter, ERROR,
    615                             "could not init channel stats table\n");
    616                 goto err_init_chan_scan;
    617         }
    618 
    619         rtnl_lock();
    620         /* Create station interface by default */
    621         wdev = nxpwifi_add_virtual_intf(adapter->wiphy, "mlan%d", NET_NAME_ENUM,
    622                                         NL80211_IFTYPE_STATION, NULL);
    623         if (IS_ERR(wdev)) {
    624                 nxpwifi_dbg(adapter, ERROR,
    625                             "cannot create default STA interface\n");
    626                 rtnl_unlock();

ret = PTR_ERR(wdev);

--> 627                 goto err_add_intf;
    628         }
    629 
    630         wdev = nxpwifi_add_virtual_intf(adapter->wiphy, "uap%d", NET_NAME_ENUM,
    631                                         NL80211_IFTYPE_AP, NULL);
    632         if (IS_ERR(wdev)) {
    633                 nxpwifi_dbg(adapter, ERROR,
    634                             "cannot create AP interface\n");

ret = PTR_ERR(wdev);

    635                 rtnl_unlock();
    636                 goto err_add_intf;
    637         }
    638 
    639         rtnl_unlock();
    640 
    641         nxpwifi_drv_get_driver_version(adapter, fmt, sizeof(fmt) - 1);
    642         nxpwifi_dbg(adapter, MSG, "driver_version = %s\n", fmt);
    643         adapter->is_up = true;
    644         goto done;
    645 
    646 err_add_intf:
    647         vfree(adapter->chan_stats);
    648 err_init_chan_scan:
    649         wiphy_unregister(adapter->wiphy);
    650         wiphy_free(adapter->wiphy);
    651 err_init_fw:
    652         if (adapter->if_ops.disable_int)
    653                 adapter->if_ops.disable_int(adapter);
    654 err_dnld_fw:
    655         nxpwifi_dbg(adapter, ERROR,
    656                     "info: %s: unregister device\n", __func__);
    657         if (adapter->if_ops.unregister_dev)
    658                 adapter->if_ops.unregister_dev(adapter);
    659 
    660         set_bit(NXPWIFI_SURPRISE_REMOVED, &adapter->work_flags);
    661         nxpwifi_terminate_workqueue(adapter);
    662 
    663         if (adapter->hw_status == NXPWIFI_HW_STATUS_READY) {
    664                 pr_debug("info: %s: shutdown nxpwifi\n", __func__);
    665                 nxpwifi_shutdown_drv(adapter);
    666                 nxpwifi_free_cmd_buffers(adapter);
    667         }
    668 
    669         init_failed = true;
    670 done:
    671         if (adapter->cal_data) {
    672                 release_firmware(adapter->cal_data);
    673                 adapter->cal_data = NULL;
    674         }
    675         if (adapter->firmware) {
    676                 release_firmware(adapter->firmware);
    677                 adapter->firmware = NULL;
    678         }
    679         if (init_failed)
    680                 nxpwifi_free_adapter(adapter);
    681 
    682         /* Tell all current and future waiters we're finished */
    683         complete_all(fw_done);
    684 
    685         return ret;
    686 }

This email is a free service from the Smatch-CI project [smatch.sf.net].

regards,
dan carpenter
