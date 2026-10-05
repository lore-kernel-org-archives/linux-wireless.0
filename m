Received: from mta1.migadu.com (out-227.mta1.migadu.com [95.215.58.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D35234BD7AE
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 17:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791221626; cv=none; b=SL2a6A+kCi/8lwbVD3V219dtxvdaWPLJQksAZLqdZQFogjqsXQ8nmJoDWKZO7XzOJKYueBa3dSF6nVW+7afSk1VxalZM09ZBcdX1ruDxXIoSTGkKUWURidyZ5NRQKFPE9mJunOSTZeT60sSH3vNBRh8831uq8T/8fM/Vz9l8kEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791221626; c=relaxed/simple;
	bh=hZPI6xg+2j+cDbxzGtdAVajNdJVUJX9FTCBBrQWwSo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5hDI3SDXZbAsNh/0QIss6PigkWwXpQQeAWhz3FhwA2m9wbEzsoDZcMvw973R3QUdiKg7rBLyCI8uFQ2pnKtKvspcxdDCJ6rEaHbwR90DwES//0Ffc9BhUpUUtCI9eICqp5cJ0r/OnbaP6VWw6EZXobuCQhwe7egaodswxHKl3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GVCYQRy9; arc=none smtp.client-ip=95.215.58.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GVCYQRy9"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=hZPI6xg+2j+cDbxzGtdAVajNdJVUJX9FTCBBrQWwSo8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791221621; v=1; x=1791826421;
 b=GVCYQRy9XPj2XYIpeKFs8/RMcYa23ynL5OCPGu3hGL/rf4CkSYMqOZuUg9g30jdB9z9S8JVt
 iGPKAZpFfaha/2UepkoKe+XQ3zdm0d30aoXrD5hhSdN+COb9JNR6oCVXACsYwdWRXIlFiizOyYV
 5uip3SoioYv1J3dbhzbWMsbM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id e7bfcf0250f15fff;
	Mon, 05 Oct 2026 17:33:41 +0000
X-Mizu-Trace-ID: e7bfcf0250f15fff
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	mehmet.fide@screeningeagle.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH v3 2/2] wifi: rtw88: support channel switch in AP mode
Date: Mon,  5 Oct 2026 17:33:26 +0000
Message-ID: <20261005173326.2306-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261005143523.130287-3-mehmet.fide@gmail.com>
References: <20261005143523.130287-3-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 05 Oct 2026, Mehmet Fide wrote:

> @@ -626,7 +652,8 @@ static int rtw_ops_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
> [...]
> -	if (rtw_get_lps_deep_mode(rtwdev) == LPS_DEEP_MODE_PG)
> +	if (rtw_get_lps_deep_mode(rtwdev) == LPS_DEEP_MODE_PG &&
> +	    !rtw_fw_csa_active(rtwdev))
>  		rtw_fw_download_rsvd_page(rtwdev);

The assoc change downloads the same page, and it is not guarded:

	if (changed & BSS_CHANGED_ASSOC) {
		rtw_vif_assoc_changed(rtwvif, conf);
		if (vif->cfg.assoc) {
			rtw_coex_connect_notify(rtwdev, COEX_ASSOCIATE_FINISH);

			rtw_fw_download_rsvd_page(rtwdev);

The page holds the beacon of the AP vif, and building it fetches that
beacon:

	case RSVD_BEACON:
		skb_new = ieee80211_beacon_get_tim(hw, vif, &tim_offset, NULL, 0);

mac80211 steps the countdown on that fetch, not once per transmitted
beacon:

	if (beacon->cntdwn_counter_offsets[0]) {
		if (!is_template)
			ieee80211_beacon_update_cntdwn(vif, link->link_id);

so an association during the countdown moves the count a second time in
the same interval. Can this download skip the page while a switch is
announced, the way set_key does?

> @@ -900,6 +945,13 @@ static int rtw_ops_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  	mutex_lock(&rtwdev->mutex);
> +
> +	rtw_iterate_vifs(rtwdev, rtw_csa_active_iter, &csa_active);
> +	if (csa_active) {
> +		mutex_unlock(&rtwdev->mutex);
> +		return -EBUSY;
> +	}

The hw scan check sits below the offload test, so with firmware without
scan offload the op returns before it:

	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_SCAN_OFFLOAD))
		return 1;

A return of one tells mac80211 to run the scan in software:

	if (hw_scan && rc == 1) {
		/*
		 * we can't fall back to software for P2P-GO
		 * as it must update NoA etc.
		 */
		if (ieee80211_vif_type_p2p(&sdata->vif) ==
				NL80211_IFTYPE_P2P_GO)
			return -EOPNOTSUPP;
		hw_scan = false;
		goto again;
	}

so the AP leaves the channel during the countdown anyway. Can the check
move above the feature test?

Best regards,
Luka Gejak
