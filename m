Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0D32C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 07:47:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8023D2083C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 07:47:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mPO3fg3j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8023D2083C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbeJAOYV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 10:24:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54206 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728593AbeJAOYV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 10:24:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w917cp5X060631;
        Mon, 1 Oct 2018 07:47:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=0nlet9YtVgmvuppyyTfZUes3Ci5lg84BqoN/lPbffvI=;
 b=mPO3fg3jgjUtPGRHHP/Rma9kin/DLhCyfQTw2HLDco2gEDGA4nts2BIPiOXniPyJ/PqD
 BXBgjATolRdy6v1yE6oSAGkUlZ5i/Ml6pVtHIDHrY6z0i3f+lhsUq48c3bCw2/gdU1mU
 Fg2TiYbF5Kjr4lR3/SSksz7hfeMSjKvXlcPEsN/IrKAXO3iOhcIa/iq5jrSPRHhUSnHR
 gZxDJ7SXnRfbt+62H69a9mqSVWiCeZ/azTSn+UkvJr+cE0XVMbNnVganOhpTwSlRt5xf
 ObYDiOfMcOBGlooIZna25knMn9JwYUazVQmmzgAisuwUoklxCllTymEZtO/6LbraTmCy 2Q== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2mt1bpn9ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Oct 2018 07:47:51 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w917ljPH003098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Oct 2018 07:47:45 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w917liNj020018;
        Mon, 1 Oct 2018 07:47:44 GMT
Received: from mwanda (/197.232.248.111)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Oct 2018 00:47:43 -0700
Date:   Mon, 1 Oct 2018 10:47:34 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, gregkh@linuxfoundation.org,
        ganesh.krishna@microchip.com, adham.abozaeid@microchip.com,
        aditya.shankar@microchip.com
Subject: Re: [PATCH v3 00/29] staging: wilc1000: avoid static variables and
 cleanup changes
Message-ID: <20181001074734.w766omhed4ri3zuy@mwanda>
References: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1537856624-22157-1-git-send-email-ajay.kathat@microchip.com>
User-Agent: NeoMutt/20170609 (1.8.3)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9032 signatures=668707
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=948
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810010080
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Sep 25, 2018 at 11:53:15AM +0530, Ajay Singh wrote:
> This patch series contains changes to avoid the use of static variables.
> Cleanup changes to fix some checkpatch issues and return void for
> function if their return value is not used.
> Also deleted 'wilc_debugfs.c' file as it's not used.
> 
> Changes since v2:
>    Included Joe's suggestion for patch#28
>     - replaced previous patch with an improved version(refactor code)
> 
> Changes since v1:
>    Address Dan's comment for patch#29
>     - return the correct error for failure in the second iteration

Btw, I hate re-reviewing patches and I know everyone hates sending them.
If someone complains about a 28/29 or a 29/29, then you can just ask
Greg to apply the first 27 and redo the others in a follow on patchset.

regards,
dan carpenter


