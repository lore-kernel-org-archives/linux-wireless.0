Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36463 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229Ab2CTPyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 11:54:32 -0400
From: "Thiruvengadam, Aarthi" <athiruve@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v2] ath6kl: handle probe response from P2P device in P2P
 GO mode
Date: Tue, 20 Mar 2012 15:54:19 +0000
Message-ID: <EEF58C4275060743A995E9DD768A2A5227B4B27D@nasanexd02c.na.qualcomm.com> (sfid-20120320_165436_737152_5F3592E8)
References: <1331847296-2086-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
 <4F684247.6070800@qca.qualcomm.com>
In-Reply-To: <4F684247.6070800@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle,

According to the standard (section 7.2.3.9), SSID always follows the capability information in a probe response frame. So I think we should be ok as long as we check the buffer length.

Thanks,
Aarthi

-----Original Message-----
From: Valo, Kalle 
Sent: Tuesday, March 20, 2012 1:40 AM
To: Thiruvengadam, Aarthi
Cc: ath6kl-devel; linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath6kl: handle probe response from P2P device in P2P GO mode

On 03/15/2012 11:34 PM, Aarthi Thiruvengadam wrote:
> When the device is in P2P GO mode and in listen state, the correct 
> behavior is to see two different probe response frames - one from P2P 
> device and the other from GO. wpa_supplicant uses the same mechanism 
> to send the frame in both cases (ath6kl_mgmt_tx). For GO probe 
> response, ath6kl needs to call ath6kl_send_go_probe_resp (this will 
> add only WSC/P2P IEs and the rest of the IEs are filled in by the 
> firmware). That was done based on the nw_type == AP_NETWORK which 
> would work if P2P Device role were in a separate netdev. When P2P 
> Device and GO use the same netdev, ath6kl needs to use the special GO probe response case only if SSID is longer than P2P wildcard SSID.
> 
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
> Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

But I still have one question:

> +/* Check if SSID length is greater than DIRECT- */ static bool 
> +ath6kl_is_p2p_go_ssid(const u8 *buf, size_t len) {
> +	const struct ieee80211_mgmt *mgmt;
> +	mgmt = (const struct ieee80211_mgmt *) buf;
> +
> +	/* variable[1] contains the SSID tag length */
> +	if (buf + len >= &mgmt->u.probe_resp.variable[1] &&
> +	    (mgmt->u.probe_resp.variable[1] > P2P_WILDCARD_SSID_LEN)) {
> +		return true;

How do you know that it's SSID without checking the IE id from variable[0]? Is that guaranteed or something?

Kalle
