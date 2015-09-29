Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:37203 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbI2XLB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 19:11:01 -0400
Date: Wed, 30 Sep 2015 09:10:38 +1000
From: James Cameron <quozl@laptop.org>
To: PaX Team <pageexec@freemail.hu>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	re.emese@gmail.com, spender@grsecurity.net
Subject: Re: question about potential integer truncation in
 mwifiex_set_wapi_ie and mwifiex_set_wps_ie
Message-ID: <20150929231038.GG8613@us.netrek.org> (sfid-20150930_011105_814118_0251A296)
References: <560AAC78.14106.6193CAA9@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <560AAC78.14106.6193CAA9@pageexec.freemail.hu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 29, 2015 at 05:21:28PM +0200, PaX Team wrote:
> hi all,
> 
> in drivers/net/wireless/mwifiex/sta_ioctl.c the following functions
> 
> 	mwifiex_set_wpa_ie_helper
> 	mwifiex_set_wapi_ie
> 	mwifiex_set_wps_ie
> 
> can truncate the incoming ie_len argument from u16 to u8 when it gets
> stored in mwifiex_private.wpa_ie_len, mwifiex_private.wapi_ie_len and
> mwifiex_private.wps_ie_len, respectively. based on some light code
> reading it seems a length value of 256 is valid (IEEE_MAX_IE_SIZE and
> MWIFIEX_MAX_VSIE_LEN seem to limit it) and thus would get truncated
> to 0 when stored in those u8 fields. the question is whether this is
> intentional or a bug somewhere.

i agree, while there is a test to ensure ie_len is not greater than
256, there is a possibility that it will be exactly 256, which means
256 bytes will be given to memcpy but
mwifiex_private.{wpa,wapi,wps}_ie_len will be zero.

i suggest changing the lengths to u16.  not tested.

diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index fe12560..b66e9a7 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -512,14 +512,14 @@ struct mwifiex_private {
 	struct mwifiex_wep_key wep_key[NUM_WEP_KEYS];
 	u16 wep_key_curr_index;
 	u8 wpa_ie[256];
-	u8 wpa_ie_len;
+	u16 wpa_ie_len;
 	u8 wpa_is_gtk_set;
 	struct host_cmd_ds_802_11_key_material aes_key;
 	struct host_cmd_ds_802_11_key_material_v2 aes_key_v2;
 	u8 wapi_ie[256];
-	u8 wapi_ie_len;
+	u16 wapi_ie_len;
 	u8 *wps_ie;
-	u8 wps_ie_len;
+	u16 wps_ie_len;
 	u8 wmm_required;
 	u8 wmm_enabled;
 	u8 wmm_qosinfo;

-- 
James Cameron
http://quozl.linux.org.au/
