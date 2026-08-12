Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF44E3AE6FB
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 08:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786522765; cv=none; b=SiS0/flsdd+Jop9lBkRhR2evJjVa262MISy0oodhxXb2qBezWxu1fdRBoVPSVpPRsatevOVuPNTdhMmRZjNlM3H94ThusKLDqikqOKFyQjdtSrJ4uaZgpCjJX7OBDJNkOYA3LOUBBQ2M5G2Ck/AMdha3FzV2JOo//uvX40fSZQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786522765; c=relaxed/simple;
	bh=tWK0X1iTDmr25ZHj8biE6gJ2te45XVM0qyKOz1086bQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ghfYOnyncdZr9BYqV4esPmDPWRTnnCFEC21DDQ4T5CTtksIPmQymemBEbblnRpYAj0Ek4iq+KgtdfWVHP1W8/3F3BGfoad02ydW1oXDccZpCWBuYus+LhCo3iYj6ybfSffJGE5G4Sr1kQGLi1jXlVC+U6hjhXtPRNm2Svhhm4Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iT8UQqjJ; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iT8UQqjJ"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47ddf7b09e5so626381f8f.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 01:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786522762; x=1787127562; darn=vger.kernel.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H5Dr9h3cDgpz66DSrF0V7NHklXRELPtJp5mRBEYzBLM=;
        b=iT8UQqjJ7AW3GBu3FBNuaE2+Fbm6SX5t/2HjRsIhzACYPD25RK05475C6HcxyqD4vm
         GKsZicEKXOb/iEi/4g2hsKjne0s8ZpOdTsPJhuMfwqE+ETELb9hADJhJc14Dyn8viqij
         J7+1UIJx4uUZfZkdop+g4e/TXkuCjKXP/1txeVViikSvu8blZ1uJRpUb1QKg/EUrIYiT
         5Xob5C+AKToVeYUF+ZjwMmta6OaLqt6awNx60Ql3IOoDYLc6/ExLaYPe2fprRXc9bxrJ
         3beIX8UWrDgLiVR8AxMkGMYTCbbwbeJ4/V03QD9hEbGdwjGQIdbLiIv7CKcfgzPn4TWH
         ZDHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786522762; x=1787127562;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H5Dr9h3cDgpz66DSrF0V7NHklXRELPtJp5mRBEYzBLM=;
        b=RZaaI0ZZ/kmzgFqkOuHqZbGrAt+6y4QCjMrTcaG32Or7SXOwELhLFsRTnLg7McLxCo
         pUBc4hDqCiJe0kjuDAv4Rl5SgKjihKDw02oPakj/JOvG4KuuYgSYQZj/WebKafcsKaS+
         U8SHvGN7zY7TVUQR691nh9VCR1Vs2NA/TWxDhtA2QkIios753DBtof7mTowJ6CBx1rHR
         byRZov9YsO3r68neUpcaRN2vB3tqg6xKEWyyhwVmigVl37NnO20adZHxJOSU1smEIIB4
         9smptrB4u2sDZ4KGj+4As2KV+ITOWahZP2SOfjCpkO69HJPYUjfM6iBJ5LO8VP4YFiPm
         sGPQ==
X-Gm-Message-State: AOJu0YyyjndfxfA1xS9ttyWqOPKGY/8Yv0KclbGC3gpIe2QJVoa9szZ6
	FG4Q6wV6PkiokL26z4p9UkZ75/wxr17xqCYVWHBSG7Cmfj8qHKaJkQ+E
X-Gm-Gg: AR+sD13ChTJL+tehuZI0VjaOcpVddJXuQ4P5+xPvPGXVrW9aSzgdAbJDxFZRqNPEpfL
	dHKG+8+cVdb3rGJa8SyR+xf5kctkI9ga8R3jSMI1EK6pOAYQHDCrHDpRuitT7iqH8/Tq7kBY/gg
	mBOPuU1JGedrDlKf3pLiKEN3fFW2EO3lUE030eolZ1EH1rnssB1dzwNMMdafglL1pmdQuEuM1x7
	LGZ2toROdi9VYbStou4WLwh+HEEIbIuSfF2xQLC6H1bKOOkIzxhaUhGtaDwjy9Ke0OP1fTK77+o
	G0M4YnCf1tcs8Xxl4/WNMi8Ozzr0DKOmazk8lXI1XgITPQ/oKewE/fbh1mkiVi7G34ECIhJRvsD
	paUWR78TtmwJUUS9mlO1SG3lbSGw6ebXxVMTBG6g2lroNpR8WXq3m82igRkT4hM0Kpv+ufJf2ke
	y05JC0iFnvORhkmkdl5/+2Jjt+88hS37Ac7By7j/4mn9cIoklVnsi/WVWZ
X-Received: by 2002:a05:6000:2405:b0:480:d9:ee6d with SMTP id ffacd0b85a97d-48152c62f17mr3724966f8f.19.1786522761668;
        Wed, 12 Aug 2026 01:19:21 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48150c057f0sm5207345f8f.9.2026.08.12.01.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 01:19:21 -0700 (PDT)
Date: Wed, 12 Aug 2026 11:19:17 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: linux-wireless@vger.kernel.org
Subject: [bug report] wifi: nxp: add nxpwifi driver for IW61x
Message-ID: <anwshVbQWXXHTJpa@stanley.mountain>
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
	warn: missing error code here? 'IS_ERR()' failed. 'ret' = '0'

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

error code not set.

    610                 }
    611         }
    612 
    613         if (nxpwifi_init_channel_scan_gap(adapter)) {
    614                 nxpwifi_dbg(adapter, ERROR,
    615                             "could not init channel stats table\n");
    616                 goto err_init_chan_scan;

not set.
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
--> 627                 goto err_add_intf;


not set.

    628         }
    629 
    630         wdev = nxpwifi_add_virtual_intf(adapter->wiphy, "uap%d", NET_NAME_ENUM,
    631                                         NL80211_IFTYPE_AP, NULL);
    632         if (IS_ERR(wdev)) {
    633                 nxpwifi_dbg(adapter, ERROR,
    634                             "cannot create AP interface\n");
    635                 rtnl_unlock();
    636                 goto err_add_intf;

error code not set.

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
