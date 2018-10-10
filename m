Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8427C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 10:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A6AD214DA
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 10:40:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="I8y7yqrC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A6AD214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbeJJSBn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:01:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54442 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbeJJSBn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:01:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9AAYDUU034483;
        Wed, 10 Oct 2018 10:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=FFfbExxdFpsSj6T53pT+exEeeKDnLwGI5/HHrjrurdc=;
 b=I8y7yqrC/+ULgCvXSNdZxhpWNy41qp3C9kfVSL+z10H3+StmY65Qs0BxTQrVv6aGw/YK
 4FCeTBQK492b1AeersNcBaJ77uj9GtIaxanF5LTZdUz8dnf0YyvjDvy6jllENQwXl30+
 B+pmzn0VLZym6U5xmDaASQXAvo3ZHDZh06F8ZMR0K5BerABKMN9enYvFgNBp/IYsQMha
 4ogfJ/A9sXBXbALO7AXCErKwy4+X8+KFm+9WekjMz2agVvFnkO1lxbVxBtsvk+xjE3A0
 Tixma76gUhEqKhd1TgizJQXydZ7j8n2nIc4BK08rG+bypcJ6zgNYfyTsd2Q2rP+vZnx6 GQ== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2mxn0q34x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 10:40:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w9AAdxjR028026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Oct 2018 10:39:59 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9AAdxmt002609;
        Wed, 10 Oct 2018 10:39:59 GMT
Received: from mwanda (/197.232.248.111)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Oct 2018 10:39:58 +0000
Date:   Wed, 10 Oct 2018 13:39:52 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     sergey.matyukevich.os@quantenna.com
Cc:     linux-wireless@vger.kernel.org
Subject: [bug report] qtnfmac: cleanup and unify command error handling
Message-ID: <20181010103952.GA14986@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9041 signatures=668706
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=742
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810100109
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello Sergey Matyukevich,

The patch c6ed298ffe09: "qtnfmac: cleanup and unify command error
handling" from Oct 5, 2018, leads to the following static checker
warning:

	drivers/net/wireless/quantenna/qtnfmac/commands.c:132 qtnf_cmd_send_with_reply()
	warn: variable dereferenced before check 'resp' (see line 117)

drivers/net/wireless/quantenna/qtnfmac/commands.c
   112          ret = qtnf_trans_send_cmd_with_resp(bus, cmd_skb, &resp_skb);
   113          if (ret)
   114                  goto out;
   115  
   116          resp = (const struct qlink_resp *)resp_skb->data;
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   117          ret = qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
                                                  ^^^^
Dereference

   118                                            const_resp_size);
   119          if (ret)
   120                  goto out;
   121  
   122          /* Return length of variable part of response */
   123          if (response_skb && var_resp_size)
   124                  *var_resp_size = le16_to_cpu(resp->mhdr.len) - const_resp_size;
   125  
   126  out:
   127          if (response_skb)
   128                  *response_skb = resp_skb;
   129          else
   130                  consume_skb(resp_skb);
   131  
   132          if (!ret && resp)
                            ^^^^
This new check is not required.

   133                  return qtnf_cmd_resp_result_decode(le16_to_cpu(resp->result));
   134  
   135          pr_warn("VIF%u.%u: cmd 0x%.4X failed: %d\n",
   136                  mac_id, vif_id, le16_to_cpu(cmd->cmd_id), ret);
   137  
   138          return ret;
   139  }

regards,
dan carpenter
