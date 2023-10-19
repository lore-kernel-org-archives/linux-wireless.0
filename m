Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8585CDB483
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Oct 2023 15:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346091AbjJSPIV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Oct 2023 11:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345550AbjJSPIU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Oct 2023 11:08:20 -0400
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D74711B;
        Thu, 19 Oct 2023 08:08:19 -0700 (PDT)
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39JDpONf029879;
        Thu, 19 Oct 2023 15:08:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=TjzRtNcS/wYNDP+4iS5V2qa6tIiyodzJUbGVz2EJSVA=;
 b=fQ2qm6zyekabZfkFHxZV6oe9zAdZRia9aA7ci88sOI+pXlXkC0NtDssryc2oPpfuBwmm
 hA9JHWAffpoltmCKLuyGyulGyLUQP60sEAvUvs0bTQg7xcu7Jr8HcPKOvEpmJHsbCSjM
 FG+C7YJa2uINIQOC6nMGhGMn6twUtww6YCBhwkUFvxvaIGXrYO5X/LVlmaf3tc+Vr3gu
 mqrp84jCcSU4rnYov+myNTyXz8wqb7sb12N57XzQgtEmt5OGvY4w5J6m7OsoBDuiCuuV
 KQ80o/UG8uawW38eHGffo8W0kTXXHVihnUC/WoUMah/bE8ctrP4TATKVrOB8lJw0MjCj 4w== 
Received: from nalasppmta04.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ttcuv3h0h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 15:08:14 +0000
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
        by NALASPPMTA04.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 39JF8DvE012961
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Oct 2023 15:08:13 GMT
Received: from [10.48.241.70] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.39; Thu, 19 Oct
 2023 08:08:12 -0700
Message-ID: <4262a250-585b-4cee-80d0-3fd56af94cad@quicinc.com>
Date:   Thu, 19 Oct 2023 08:08:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] wifi: ath11k: fix dfs radar event locking
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Kalle Valo <kvalo@kernel.org>
CC:     Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
        <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
References: <20231019104211.13769-1-johan+linaro@kernel.org>
 <20231019104211.13769-3-johan+linaro@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <20231019104211.13769-3-johan+linaro@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: NuVRREd2tCqoe2Cn19_FuEZYRU2ak-lC
X-Proofpoint-GUID: NuVRREd2tCqoe2Cn19_FuEZYRU2ak-lC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_14,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxlogscore=473 spamscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310190127
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/19/2023 3:42 AM, Johan Hovold wrote:
> The ath11k active pdevs are protected by RCU but the DFS radar event
> handling code calling ath11k_mac_get_ar_by_pdev_id() was not marked as a
> read-side critical section.
> 
> Mark the code in question as an RCU read-side critical section to avoid
> any potential use-after-free issues.
> 
> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
> Cc: stable@vger.kernel.org      # 5.6
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>

