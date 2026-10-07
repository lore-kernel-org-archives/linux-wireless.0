Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E744D492E41
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 11:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791373381; cv=none; b=uzB4w8z87NlxjNqEFpKqmv6n76rN+Ki7vMnpcThwJXnIvfdFMgM6wIb5SKYt0PStEEY6A+/TcoQ18Fm99IoOtMLZ53mr+nwwkYetUma7I/NaxKZqFJh5e/NNtkgWF1GkVQ+5qCQiLSXlu+bBKzjHkSm7OVChIBe9eNAMWQ9H+9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791373381; c=relaxed/simple;
	bh=VkAQ5FXt3jQ8CiSyMqGGK5KKhS1BKmpYpJP7xY2EjrA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M2mMBUt2w9jYXe71VVXNmsh1KUcwv77Q9cWGEgoqCK1ba/6Bcl5/AuisMTEBq/042YeAT/AAjf9sXF2ce1fIVVSjFOwnYg/eD3dgM7WqtrrWd0vIh1k0gsEsm2f/glfxQTgasOgdqiqUvoHT+WFCh/ClO6SFZsFa88zKB1z9CC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ossFhE2j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Wk/uwU0I; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ossFhE2j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Wk/uwU0I"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BVM9I3687881
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 11:42:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	p6hqW5/rFJFQA/00dhTDWu5js5aE9G0JpWJp/ftxyPU=; b=ossFhE2jchHW7/JU
	XSgMLbfv9mRDELVMH8mgKH6cs9HBny8UPw1NmJy2c5OakbnBh7GLXz6JRXc/YtYU
	AWB/3cRLwkU557qecyD1FNAt7zt2O+3DtLHuqbEzZ64zgGtt0T2aBKuukNkMC1Be
	PGy5g7kGjYVmuuVV8KLbXMxInw2xUbrxsunJu3FxRb0uHwMbhzJCYxLdrviEP1wr
	8/0zqu2zNv/QoIVR8fpuemAPmf54M5Hm1LSYMWbYauoCepuAD+zg0+SjK+LGH/12
	vzkN5bs6zvTsUrGmJYrM2Bj2PNyWRlKvqK5MpGQpUNGFSG14L6j0XkVIT77eENKr
	AzwExg==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h5mgr86k1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 11:42:36 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-39533bb224cso4671999a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 04:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791373356; x=1791978156; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p6hqW5/rFJFQA/00dhTDWu5js5aE9G0JpWJp/ftxyPU=;
        b=Wk/uwU0IfZBNZLDnKFPuS3raayz7HFMvO3IjS7SRJTq33r912ip66hVk+AjgtznXA6
         nHNkLSSLRywSrMvdENyI4zKrp4I09TiVr+YD+Juu0xtN9SqkqQpNeg6HAk494/gaIIG8
         eO82fGQqhEPAyWK0bEuHAUnWdXjvX1KURIanDFrhXDTgRxkWJYYw4cSTOtof52DgN9BG
         Levyd9SzyfNMdRQOEGG2mX2MbcBylzjmPgiPJXtFhiqU/EROT9TQmuLOIfdDOqgA0F+g
         s7s2E1Rew8Vz1n0cpVsvC5ffYavxyKLAWxw1N53N0JyOZGKkjJrs7LMkIe3Dgyyp0J3c
         aYfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791373356; x=1791978156;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p6hqW5/rFJFQA/00dhTDWu5js5aE9G0JpWJp/ftxyPU=;
        b=SjEeb2Wj+hQ4na8PF0hSGbiaJOXrTgPRqq67rpUo1X1FXH1YZgHSCwbugUsb9PFln6
         T0RLXPC8gkPd8CR1B30mdZfWMbgpYxSvtovr42gysGL3d29UKhcXy0O9BaDADuE4jGJC
         m54T/Vb2da9k4AWp/y/4U4rLuCcGvlRA5OgLGcTPvXDslwadL3jq8v31yc9jNwMhS7Xt
         wPr6QJasZ7bu8YbvXDsZSsSXBwc4Vl1tNX98H6Y6jPbVfhrWx9Si73bxiFPOuNyymJyp
         MxFc7ZgUSR49WtEJ5ez7eTQ3dRHWX1XkLo6+lbMC9hY0zBjpBCQqtDa7ISyade8Gh74Q
         vJ4g==
X-Gm-Message-State: AFq9FYIsrjxX3BcHpulhjzr1lN4X7lmHWkH7xvPHcHpeCHFnodvI5tAb
	SbC0zXqTfTHAa/xS/87ZaQL+O3QYfmWNFNhaiDeCCJQhOAbxPmEsjxI+J8G5ixVqcvLTO/JafUI
	FFWnvBrIrVYaIiyli+aKBWcKkyXf9XDJNni3bKqBiWs5M0ZHYmwL2CxI48gCjV3sDIvhV
X-Gm-Gg: AYBFou3rcDmrLApacB8eZWXvp8a6Zu/1hi2ytsELTCvGG7P7GjKM3cFKvdkmj+hIsOC
	SIeKhogV6gUIOY9/6wOo627lOnzfqIkNoi8fRIQcDTmVB9wnHkebcNaK387LHb+9BfMwrF924QW
	6n9fwEZ1mk+AwCnTzZ+G19mRGdBuj/WcCPKvRsHd/A2WJf27FWPNWp1oXhu2ZbP40RbKabwrFOW
	7rF697wf2VBnU6mZcyq5MmQ5mb6YdXf54og///MbLG5HXmf8BaqcpR4MTdz+VI3kejATb1xDNae
	Elml3dnUQ+0kO3bCaDUrEI4W7kfOEVhIGBzmFIoD2n5gQ9G5XElhW+bllZUsACQlHGfmWPdXkT6
	+lR3lcdiunq64fNCnvzOdGpxBWD4Hg5M1RiuJ3Zhx6c7M2RlR4vJqlpsx4y05qZQ7GtgFRN8/qS
	xgHPx1zCL0xJ/M0blU
X-Received: by 2002:a17:90a:e7ca:b0:3a4:b9de:87a1 with SMTP id 98e67ed59e1d1-3a8a1b8e207mr1765291a91.45.1791373355848;
        Wed, 07 Oct 2026 04:42:35 -0700 (PDT)
X-Received: by 2002:a17:90a:e7ca:b0:3a4:b9de:87a1 with SMTP id 98e67ed59e1d1-3a8a1b8e207mr1765269a91.45.1791373355392;
        Wed, 07 Oct 2026 04:42:35 -0700 (PDT)
Received: from [10.50.61.110] (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd0a58225b8sm1312614a12.2.2026.10.07.04.42.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 04:42:34 -0700 (PDT)
Message-ID: <1b8d82ce-a63f-4158-a767-693d0596b449@oss.qualcomm.com>
Date: Wed, 7 Oct 2026 17:12:30 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2 10/16] wifi: nl80211: Define attributes
 to pack SMD BSS Transition context
To: Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20260924-smd-v2-0-bb40094da1d4@oss.qualcomm.com>
 <20260924-smd-v2-10-bb40094da1d4@oss.qualcomm.com>
 <d1f53a596835f79580b2078a83820d98d795ae17.camel@sipsolutions.net>
Content-Language: en-US
From: Pooventhiran G <pooventhiran.g@oss.qualcomm.com>
In-Reply-To: <d1f53a596835f79580b2078a83820d98d795ae17.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX/P/juHt6sIQt
 niZKRtQyL5NG4cimeO7KoJXRxre6W8a1e58cyB8P+Am853ltpP2tIq8fE6IOHPmC5O7+yl5uWLs
 N0BdP9R46LMMaJJfTOl2z0IoZPX2eumJA6vLiK5aqz5U3VT8nguZVgrpF0rj3h37xpkeoHhB9yG
 5b1Ms84Zc5eu2AZABzBKzjFjg8D1k0JV+MQbJMGpoZkeE1LEFInANcO5wAsR6/85xXVnfW/EHGn
 Tsb4+TGL8i1lQGnm6QaLbLyNAIVpRzOVsEYfEDE8F+GPjt9PegzmtgelF+oYAlJB/zwdgiS/Imd
 IvDfSWO99EXOSmFTFgI33ijqxruaBkITAoSz8JQO/8N8gpxMxc8K/m3trRKF2qMP8pZk9RlxpZl
 2vhFgQbH+qtra+/kZ4VZNDYS1t9NpV0baD5lQJRib482kQarf0AWkRDe6UbThxNvMql+1squb95
 eww+AG0QMG8dNQ3rlfw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX8HkzTf7s4cSy
 lHPgG6x0JOp4QcGbyVlbgGsW4UB7eVKNUDYWRPQGymYYSZZdGsAD3I1wKSerq4rdaQ6OVHhtO+s
 IdJq1L7dPjVicfZ6SdNWyuJU1yrPMX8=
X-Proofpoint-ORIG-GUID: O-FKNv4uPZ-q85hLXIeTsi5uMGH7WXtr
X-Proofpoint-GUID: O-FKNv4uPZ-q85hLXIeTsi5uMGH7WXtr
X-Authority-Analysis: v=2.4 cv=OYkNnRTY c=1 sm=1 tr=0 ts=6ac6302c cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=Avq_DrN9Xaf3zyNzFDUA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610070046



On 10/02/2026 01:49 am, Johannes Berg wrote:
> On Thu, 2026-09-24 at 08:10 +0530, Pooventhiran G wrote:
>> Define nl80211 attributes and policies required to pack SMD BSS Transition
>> context along with NL80211_CMD_FRAME to be sent to userspace, and to set
>> and get the context during roaming via current AP MLD and roaming via
>> target AP MLD. Without these, userspace will not be able to transport the
>> context to the target AP MLD, program the context on the target AP MLD TX
>> and RX queues, nor fetch the context on behalf of the target AP MLD if
>> the ST Execution frame is sent directly to the target.
> 
> The commit subject and message don't really seem right - you're also
> adding all the commands.
> 

True, I will fix it.

>> + * @NL80211_CMD_SET_SMD_CTX: Set the SMD BSS Transition dynamic context for a
>> + *	non-AP MLD sent from the current AP MLD on the target AP MLD managed by
>> + *	an SMD-ME. This command carries %NL80211_ATTR_MLD_ADDR,
>> + *	%NL80211_ATTR_SMD_CTX_TYPE and %NL80211_ATTR_SMD_CTX.
> 
> This is a bit ... brief. Incomplete, I'd even say. How is it meant to
> work, e.g. this carries PN data which fundamentally maps to a key, so it
> seems the key must be there before it. Surely the station must be, and
> it must be in the right state (whichever that is) etc.
> 

I will update the documentation to mention the required STA state.

>> + * @NL80211_CMD_GET_SMD_CTX: Get the SMD BSS Transition dynamic context for a
>> + *	non-AP MLD associated to an AP MLD managed by an SMD-ME. This command
>> + *	carries %NL80211_ATTR_MLD_ADDR and %NL80211_ATTR_SMD_CTX_TYPE.
>> + * @NL80211_CMD_SMD_CTX_EVENT: Event reporting the collected SMD context
>> + *	(requested via %NL80211_CMD_GET_SMD_CTX) to userspace. It carries
>> + *	%NL80211_ATTR_MLD_ADDR, %NL80211_ATTR_SMD_CTX_TYPE, and
>> + *	%NL80211_ATTR_SMD_CTX.
> 
> Why would this be async?
> 

In ath12k implementation, firmware and hardware are queried to get these
information (SN, PN, etc.,) and the time to collate all these data across all
valid TIDs varies based on system loads. So, not to hold the NL socket for
(arbitrary) longer periods, I have made this asynchronous to cleanly report
back with all the required data once they are available.

>> + * @NL80211_SMD_CTX_ATTR_DRV_DATA: Optional (binary) driver-specific blob.
>> + *	Passed through nl80211 as a blob; parsed only at the driver layer of
>> + *	the current AP MLD and target AP MLD. First 3 bytes shall be driver OUI
>> + *	for the driver to parse as required.
> 
> That's just a vendor command through the back-door?
> 
> What do you envision this carries, and why couldn't that be defined
> properly? Is the intent to have some kind of optional data there, or
> would the target possibly refuse the operation if it's not present?
> 

Driver data had mgmt information and WinStartO equivalents. But I will move
these to generic definitions so that this can be eliminated.

> johannes

