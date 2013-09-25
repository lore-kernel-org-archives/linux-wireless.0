Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58543 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825Ab3IYXK4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 19:10:56 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 25 Sep 2013 16:10:47 -0700
Subject: RE: [patch] mwifiex: potential integer underflow in
 mwifiex_ret_wmm_get_status()
Message-ID: <477F20668A386D41ADCC57781B1F70430F45077E52@SC-VEXCH1.marvell.com> (sfid-20130926_011059_944907_0AE8AC9B)
References: <20130925085729.GC6661@elgon.mountain>
 <477F20668A386D41ADCC57781B1F70430F45077CDA@SC-VEXCH1.marvell.com>
 <20130925182359.GV6247@mwanda>
In-Reply-To: <20130925182359.GV6247@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for your comments.

> > I think we can change the 'resp_len' variable type to a signed integer
> > to fix this issue.
> 
> No, that doesn't work because the comparison against sizeof() get's
> promoted to size_t.  In other words, negative values still count as
> large positive values.

You are right. The negative value counts as a large positive number while comparing against sizeof().
I can add a "const int hdr_size" variable to store the value of sizeof(...) and compare resp_len to hdr_size. The "sizeof(...)" has been used multiple times in this function, so I think it's worth adding a variable for it.


diff --git a/drivers/net/wireless/mwifiex/wmm.c b/drivers/net/wireless/mwifiex/wmm.c
index 95fa359..c97df5a 100644
--- a/drivers/net/wireless/mwifiex/wmm.c
+++ b/drivers/net/wireless/mwifiex/wmm.c
@@ -707,10 +707,10 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
                               const struct host_cmd_ds_command *resp)
 {
        u8 *curr = (u8 *) &resp->params.get_wmm_status;
-       uint16_t resp_len = le16_to_cpu(resp->size), tlv_len;
+       int resp_len = le16_to_cpu(resp->size), tlv_len;
        int valid = true;
-
        struct mwifiex_ie_types_data *tlv_hdr;
+       const int hdr_size = sizeof(tlv_hdr->header);
        struct mwifiex_ie_types_wmm_queue_status *tlv_wmm_qstatus;
        struct ieee_types_wmm_parameter *wmm_param_ie = NULL;
        struct mwifiex_wmm_ac_status *ac_status;
@@ -718,7 +718,7 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
        dev_dbg(priv->adapter->dev, "info: WMM: WMM_GET_STATUS cmdresp received: %d\n",
                resp_len);

-       while ((resp_len >= sizeof(tlv_hdr->header)) && valid) {
+       while (resp_len >= hdr_size && valid) {
                tlv_hdr = (struct mwifiex_ie_types_data *) curr;
                tlv_len = le16_to_cpu(tlv_hdr->header.len);

@@ -772,8 +772,8 @@ int mwifiex_ret_wmm_get_status(struct mwifiex_private *priv,
                        break;
                }

-               curr += (tlv_len + sizeof(tlv_hdr->header));
-               resp_len -= (tlv_len + sizeof(tlv_hdr->header));
+               curr += tlv_len + hdr_size;
+               resp_len -= tlv_len + hdr_size;
        }

        mwifiex_wmm_setup_queue_priorities(priv, wmm_param_ie);


Thanks,
Bing
