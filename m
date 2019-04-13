Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8651FC282CE
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 19:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 562782084D
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 19:28:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LyfPZikj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfDMT1y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 15:27:54 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38016 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbfDMT1y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 15:27:54 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3DJK93X011689;
        Sat, 13 Apr 2019 19:27:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=4SLUZEGuXWiirW6qhrP/P50mnCtGoDoQsaieJXYSPjc=;
 b=LyfPZikjcwKDoHv9AFXNa2aMhbtaEhB6b+31jZ4Bgv3ZfNJ8TUeCFLwUBUlBAJTrRfR0
 1ZF2HVLtxkkjMJkFTToT79KMyRIcAxLNoVngMHF7UfGjE8ljA2MDY4TmxvXnh9pp/aRV
 eqO+GGUb4ZOiymLVcd8tzNJjrxQRmkhpMWbOOhrWirXl5lZ74Kxg0QQXmk6URSjj9QPh
 s9psun/5l7dgCIM182onxqZHokV3Vf9LStwtWFPufy23+yToGYDQV6HR0IjiG6K+NF6A
 FiXsHd/RnWfH0qyCA3UCs5Oci15pA6J0v3R6TxGegk1y4j8e4aod41vRTICITJujxMNe SQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2ru59cstcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Apr 2019 19:27:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3DJQoUi184663;
        Sat, 13 Apr 2019 19:27:41 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2ru4vryx5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 13 Apr 2019 19:27:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x3DJRdtM027579;
        Sat, 13 Apr 2019 19:27:40 GMT
Received: from kadam (/197.157.34.181)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 13 Apr 2019 12:27:39 -0700
Date:   Sat, 13 Apr 2019 22:27:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mwifiex: check for null return from skb_copy
Message-ID: <20190413192729.GL6095@kadam>
References: <20190413161438.6376-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413161438.6376-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9226 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904130137
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9226 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904130137
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Apr 13, 2019 at 05:14:38PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> It is possible for skb_copy to return a null pointer and currently
> this will cause a null pointer dereference when the function
> mwifiex_uap_queue_bridged_pkt is called.  Fix this by checking for
> a null return from skb_copy and return -ENOMEM.
> 
> Addresses-Coverity: ("Dereference null return")
> Fixes: 838e4f449297 ("mwifiex: improve uAP RX handling")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> index 5ce85d5727e4..b262dc78d638 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> @@ -256,6 +256,8 @@ int mwifiex_handle_uap_rx_forward(struct mwifiex_private *priv,
>  
>  	if (is_multicast_ether_addr(ra)) {
>  		skb_uap = skb_copy(skb, GFP_ATOMIC);
> +		if (!skb_uap)
> +			return -ENOMEM;

I think we would want to free dev_kfree_skb_any(skb) before returning.

>  		mwifiex_uap_queue_bridged_pkt(priv, skb_uap);
>  	} else {
>  		if (mwifiex_get_sta_entry(priv, ra)) {

regards,
dan carpenter
