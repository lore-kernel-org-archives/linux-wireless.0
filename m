Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57808 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755733Ab1KWO3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:29:25 -0500
Message-ID: <4ECD032F.4040009@openwrt.org> (sfid-20111123_152928_229593_0AF777A1)
Date: Wed, 23 Nov 2011 21:29:03 +0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, Wilson Tsao <wtsao@qca.qualcomm.com>
Subject: Re: [PATCH 16/18] ath9k: make ath_reset non-static
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com> <1321978965-21684-17-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1321978965-21684-17-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-22 11:22 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> to be used by MCI specific changes
> 
> Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
> Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
NACK. ath_reset can no longer be called in tasklet context (which you
seem to be doing in the next patch).
Replace your ath_reset() call with:
  ieee80211_queue_work(sc->hw, &sc->hw_reset_work);

- Felix
