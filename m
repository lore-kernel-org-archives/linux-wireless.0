Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6551 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758871Ab2CTPMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 11:12:24 -0400
From: "Malinen, Jouni" <jouni@qca.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"Thiruvengadam, Aarthi" <athiruve@qca.qualcomm.com>
CC: ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath6kl: handle probe response from P2P device in P2P
 GO mode
Date: Tue, 20 Mar 2012 15:12:23 +0000
Message-ID: <CB8DEBD4.A1E6%jouni@qca.qualcomm.com> (sfid-20120320_161228_921673_D5F386F6)
In-Reply-To: <4F684247.6070800@qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 3/20/12 1:39 AM, "Kalle Valo" <kvalo@qca.qualcomm.com> wrote:

>On 03/15/2012 11:34 PM, Aarthi Thiruvengadam wrote:
>>+/* Check if SSID length is greater than DIRECT- */
>> +static bool ath6kl_is_p2p_go_ssid(const u8 *buf, size_t len)
>> +{
>> +	const struct ieee80211_mgmt *mgmt;
>> +	mgmt = (const struct ieee80211_mgmt *) buf;
>> +
>> +	/* variable[1] contains the SSID tag length */

>How do you know that it's SSID without checking the IE id from
>variable[0]? Is that guaranteed or something?

The information elements in Probe Response frames (and other management
frames for that matter) are in a fixed order, so the SSID element is
always in this location.

- Jouni

