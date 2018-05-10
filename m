Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0066.outbound.protection.outlook.com ([104.47.42.66]:47232
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756828AbeEJIvJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 04:51:09 -0400
Date: Thu, 10 May 2018 11:50:53 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH v2 1/3] wireless-drivers: Dynamically allocate struct
 station_info
Message-ID: <20180510085052.oscm2ezf4k6p2kwf@bars> (sfid-20180510_105117_028466_1DDF2ECC)
References: <152590211357.13924.18408619969539206421.stgit@alrua-kau>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <152590211357.13924.18408619969539206421.stgit@alrua-kau>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Toke and all,

> Since the addition of the TXQ stats to cfg80211, the station_info struct
> has grown to be quite large, which results in warnings when allocated on
> the stack. Fix the affected places to do dynamic allocations instead.
> 
> Fixes: 52539ca89f36 ("cfg80211: Expose TXQ stats and parameters to userspace")
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> ---
>  drivers/net/wireless/ath/ath6kl/main.c             |   14 ++++++----
>  drivers/net/wireless/ath/wil6210/debugfs.c         |   22 ++++++++++-----
>  drivers/net/wireless/ath/wil6210/wmi.c             |   19 ++++++++-----
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         |   18 ++++++++----
>  drivers/net/wireless/marvell/mwifiex/uap_event.c   |   25 +++++++++++------
>  drivers/net/wireless/quantenna/qtnfmac/event.c     |   29 +++++++++++++-------
>  6 files changed, 82 insertions(+), 45 deletions(-)

Thanks for taking care of this. As for qtnfmac part, there are two
more EINVALs returned during payload processing. So they should be
modified as well to avoid memleaks. Here is a fixup on top of your
patch:

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index 969b6fc7128a..16617c44f81b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -78,15 +78,19 @@ qtnf_event_handle_sta_assoc(struct qtnf_wmac *mac, struct qtnf_vif *vif,
 		tlv_value_len = le16_to_cpu(tlv->len);
 		tlv_full_len = tlv_value_len + sizeof(struct qlink_tlv_hdr);
 
-		if (tlv_full_len > payload_len)
-			return -EINVAL;
+		if (tlv_full_len > payload_len) {
+			ret = -EINVAL;
+			goto out;
+		}
 
 		if (tlv_type == QTN_TLV_ID_IE_SET) {
 			const struct qlink_tlv_ie_set *ie_set;
 			unsigned int ie_len;
 
-			if (payload_len < sizeof(*ie_set))
-				return -EINVAL;
+			if (payload_len < sizeof(*ie_set)) {
+				ret = -EINVAL;
+				goto out;
+			}
 
 			ie_set = (const struct qlink_tlv_ie_set *)tlv;
 			ie_len = tlv_value_len -

Regards,
Sergey
