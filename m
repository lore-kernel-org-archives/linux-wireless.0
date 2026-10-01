Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B02236215E
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 07:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790839119; cv=none; b=sGxp9CVblTyiizLVextvGdgHOl1ZhutuDJM7LccY1wA2gmFnErFUDW7I/h2K3ZCaHQaaCXSChB0yZVHPWSZM8/I4uQuuBAl97q2rZmkkI1UvClDtgWgfPUDs99pAdZg+XXxcbxA9vnCxCzqXje1axVLqRK5c9Hhk+e1pwjac3Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790839119; c=relaxed/simple;
	bh=WH7hQfcmj5GQBZj88d306OKfQggBKeDcQQIJkpAwENg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f05JRbf0CplSD2I7bVPOU0jFw3SbxFTLnXcXufuU/O2E3F7/iU5/TDDryPjvWGjdYZXY4kmaaV6D0iY/lPFOLwRiOh/4r0Q8pxl4AV9m0llO60z2b9revW4SbzNQlg53zCKLo0AsuuZeSgAjBtUMllqVxtr00G7EA/1NY12SN20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HdtZoK8Z; arc=none smtp.client-ip=91.218.175.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HdtZoK8Z"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=WH7hQfcmj5GQBZj88d306OKfQggBKeDcQQIJkpAwENg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790839114; v=1; x=1791443914;
 b=HdtZoK8ZUoQJngz+NS8frnPcBcFfeV3zI8Rey8tC49tMYuirUE2bOmFI5bpl6qwInw76LHhh
 QNhrHSc3w7MBUplhNXwRim7VPOB6nbNavixUZXpl1Q+QgtEMV7MxMY9QCYyuRBC4mribr8LX5Pd
 RuQfjm6Z5G8qX+0mHXIxLbcY=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c2559732ab146b67;
	Thu, 01 Oct 2026 07:18:34 +0000
X-Mizu-Trace-ID: c2559732ab146b67
X-Migadu-Flow: FLOW_OUT
From: Luka Gejak <luka.gejak@linux.dev>
To: Mehmet Fide <mehmet.fide@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	mehmet.fide@screeningeagle.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luka Gejak <luka.gejak@linux.dev>
Subject: Re: [PATCH v2 2/2] wifi: rtw88: support channel switch in AP mode
Date: Thu,  1 Oct 2026 07:18:22 +0000
Message-ID: <20261001071822.17746-1-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260930074444.1991223-3-mehmet.fide@gmail.com>
References: <20260930074444.1991223-3-mehmet.fide@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026, Mehmet Fide wrote:

> @@ -1813,6 +1813,47 @@ void rtw_fw_update_beacon_work(struct work_struct *work)
> +	if (!ieee80211_beacon_cntdwn_is_complete(vif, 0)) {
> +		rtw_fw_download_rsvd_page(rtwdev);
> +		rtw_send_rsvd_page_h2c(rtwdev);
> +
> +		wiphy_delayed_work_queue(wiphy, &rtwdev->csa_beacon_work,
> +					                   usecs_to_jiffies(delay));

This work is not the only one that re-downloads the page. Every page download
fetches a beacon, through rtw_get_rsvd_page_skb():

	case RSVD_BEACON:
		skb_new = ieee80211_beacon_get_tim(hw, vif, &tim_offset, NULL, 0);
		rsvd_pkt->tim_offset = tim_offset;
		break;

and mac80211 moves the countdown on that fetch, not once per beacon that is
transmitted:

	if (beacon->cntdwn_counter_offsets[0]) {
		if (!is_template)
			ieee80211_beacon_update_cntdwn(vif, link->link_id);

		ieee80211_set_beacon_cntdwn(sdata, beacon, link);
	}

rtw_ops_set_tim() queues update_beacon_work:

	ieee80211_queue_work(hw, &rtwdev->update_beacon_work);

and the work itself re-downloads the page:

void rtw_fw_update_beacon_work(struct work_struct *work)
{
	struct rtw_dev *rtwdev = container_of(work, struct rtw_dev,
					                              update_beacon_work);

	mutex_lock(&rtwdev->mutex);
	rtw_fw_download_rsvd_page(rtwdev);
	rtw_send_rsvd_page_h2c(rtwdev);
	mutex_unlock(&rtwdev->mutex);
}

A station that wakes up in power save during the countdown is enough, so one
interval can move the count twice, for example 4 on air and then 2, and a fetch
that lands after the counter reached 1 makes mac80211 log "beacon TX faster than
countdown". Can the set_tim work skip the download while a switch is announced?
rtw_fw_csa_beacon_work() rebuilds the page one interval later, so the new TIM
still gets out and the countdown keeps one step per interval.

Best regards,
Luka Gejak
