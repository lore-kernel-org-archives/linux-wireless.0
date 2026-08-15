Received: from out203-205-221-190.mail.qq.com (out203-205-221-190.mail.qq.com [203.205.221.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7DE4218AA
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 15:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786806784; cv=none; b=G3LPJ74BZIum3+UUOr7QBMqYEcCvqDPLfm/snu535Jl2iJjHN0AOiwWCC8Hh1mkT0RpsK6/U3UW0RJmo3qGP+AYAwwiFsb8dVY+RzP2kRPsFGnapIMICPw8uaoOHHRvHdDGTupoZAh2qQEwmexyK5bL5Am2wEfJWu2nIb5U4HsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786806784; c=relaxed/simple;
	bh=AvUuJ7lkE7TwcW1JrjcMnNCY7EGTZcDTXB6tLhSmFZE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version:Content-Type; b=Rdvdg47zwVHDo0Acca/9SWHXDr/CVRukszMBC4/++DXPrjr9unc33Ln/xCrsCVx7RP63u3SS99G+MgOSW+Dsi8dhcaOLcaW2Gv3xTObn5qwUyaW09eWShyiedfnzOu3BFM1yUwWzhPm5stWOHUECap38eaGido/fD94hbu9mDaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=o4Usye67; arc=none smtp.client-ip=203.205.221.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="o4Usye67"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1786806777;
	bh=FZKulgw6Epf238NDoYfOuRcBGDo3h5LDiPkO20LU4FE=;
	h=From:To:Cc:Subject:Date;
	b=o4Usye67paOGyeillslaRTrmw3QYCkpOuOCZ8xXHXs/PQnlcu07z+RpV9PkBsWTmJ
	 FRri4UWUdlYpUab1PpIJSZmGv0Jl4YEt/psRQKtGbPVE3EdpF054r/3bo8avkxqFYp
	 EMzmr3zxYv0C7MavOQkL9XL38w6cEe+p9evNUDRE=
Received: from linux-wireless-email.txt ([117.155.170.226])
	by newxmesmtplogicsvrszb51-1.qq.com (NewEsmtp) with SMTP
	id 336A1449; Sat, 15 Aug 2026 23:12:54 +0800
X-QQ-mid: xmsmtpt1786806774ty3mwbais
Message-ID: <tencent_CA929E144EEEC926E8CFF32B18ED3A26A907@qq.com>
X-QQ-XMAILINFO: M6rEOT/Vq/kGbSVX8Tun/ehPY5f3k9dt+2ra/7xvtYWMlORQZ8cGf8AXluONzF
	 eltVOfjmXBwo63Jm1dDHlx0iaMH3HFz/MWAeRK3tJ0jnaf2QPwT0jRm3VcxeLgoaOWPcpuae4ARZ
	 mrlbbhJotlvveQygKU1tpdnoKOYjyeBxdHVsCXItv7NAzfoK6ROykc85b1TSo6OZHDwd+ztCh393
	 WjdHCEwmkq+QxKCYInK0aVTvgicdVerDm0doEGksnZhH030OpPr2eUnJsr5S6uhWc7CvJjYImT0j
	 H9+zLqL8nxY0BgVuCLlRAkScgWX1x4YtwrEyaoHsCKvrRKiEdW/uZ0eBisb2+ZKRyFUsmAkssjtk
	 Nv35ZqJ0wMrQtJvRkS6FZae+7coXLQ123aZZfX0/TcDQc+l5ZxjbkfHeagAs/SwcXDScmNTUAXcK
	 52P2ujU3CQAmB0DAl3qE3XwKrVrgh14S3fFzPXQ0HHmVwmzU7T7fr2RmXauvw62NdgMwtpcTXgtm
	 vCqSnOuABKpYzAUL31JH15CigXsRhRCJb2nzuhyYVFJi301WZNYSHGyRMMvoG0jsYddAAcc4S1Ym
	 yJSIXNZFb6mgwvBtQspSeYPLMzedq3Q4XSBpjmCm6HpuvcEP2j4BfSV+tJEm8QQmg8hbTOWCcetz
	 yupDLmc3ZD0DRJS4CHnFdmDAH6AYwLN6WKCG3tG617tXBpnajVmnfzQnvdetdGC0vRYvNjKVmNY6
	 y0Kb4zWiooIfGzVBh6qhkCQ/pvMUrbLrOOvtbIJEHaiY6bWtnSYK/jBPJFn/No19VZjFQflpcE2E
	 Dt0E+AEjevc4Vzmj+yM8PjNyAI2P2eQifwyudfPx5SDLqHlbf1BFC85RXSeLqQAyojCfrqWrxHbN
	 1bw1cRvHXwf5+4q6Foqa+/LQ5gv1WCtsTQsherrRcsB/j3xCbx1dghpoe0n3JHioiiovavQdaNB4
	 tuJUgLzzsN6EqxgcCLnyq+B7rkHvHTBXRpoApfea0sEStuaD2qGF1YK3nx3CLVNWyE0GsYwUCugM
	 WIp2Jetu2b5qAD+kQlZm5vLhdlh9v3iV5tjlbTVSVj+dasssKK3M5GTYXG3YbHjH2ApjCsCh+yLX
	 WUzRNyrccSggEBQBrD/1CLxgFWhMVUf0NNqrvTpdpX41IUC0b389QO10PVt/3d0gRati8n5S9nLw
	 z3bs4=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: autumnshiu <autumnshiu@foxmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@kernel.org, ath11k@lists.infradead.org
Subject: [PATCH] wifi: ath11k: fix QCN6122 UNII-3 channels 149-165 disabled
Date: Sat, 15 Aug 2026 23:07:38 +0800
X-OQ-MSGID: <pz-l8-unii3-1786806458770268849-1000@autumn-NucBox-K6.local>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The QCN6122 firmware reports high_5ghz_chan without the UNII-3 band
(5725-5850 MHz, channels 149-165). ath11k_mac_setup_channels_rates()
passes this value to ath11k_mac_update_ch_list(), which marks every
channel above high_5ghz_chan as IEEE80211_CHAN_DISABLED.

As a result channels 149-165 (including 5745 MHz, channel 149) are
disabled on QCN6122 even though the board-2.bin BDF contains the
UNII-3 frequencies and the regulatory domain covers them. This also
truncates the wpa_supplicant freq_list, so a 5 GHz STA can never
scan or associate on those channels.

Clamp high_5ghz_chan to the standard 5.8 GHz upper bound (5825 MHz,
channel 165) for QCN6122, matching what the hardware and BDF
actually support.

Tested on a CMCC PZ-L8 (IPQ5018 + QCN6122) with the 5 GHz radio as
STA and AP on channel 149/HE80.

Patch authored by V4Pro (DeepSeek Harness), tested and submitted by
autumnshiu.

Signed-off-by: autumnshiu <autumnshiu@foxmail.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -10172,6 +10172,15 @@ static int ath11k_mac_setup_channels_rates(struct ath11k *ar,
 	reg_cap = &ar->ab->hal_reg_cap[ar->pdev_idx];
 	temp_reg_cap = reg_cap;
 
+	/* QCN6122 firmware omits the UNII-3 band (5725-5850 MHz, channels
+	 * 149-165) from high_5ghz_chan, which makes the driver mark those
+	 * channels IEEE80211_CHAN_DISABLED. Clamp it to the standard 5.8 GHz
+	 * upper bound so channels 149-165 remain usable.
+	 */
+	if (ar->ab->hw_rev == ATH11K_HW_QCN6122_HW10 &&
+	    reg_cap->high_5ghz_chan < 5825)
+		reg_cap->high_5ghz_chan = 5825;
+
 	if (supported_bands & WMI_HOST_WLAN_2G_CAP) {
 		channels = kmemdup(ath11k_2ghz_channels,
 				   sizeof(ath11k_2ghz_channels),

