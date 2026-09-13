Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FA43630AC
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 19:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.168.131
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789327398; cv=fail; b=i61UgItNANbVZ21aRc7spuN//uJDJtynckTysXMRQ9Lrp88lvT48z4WcceKN990VoSJcqd9E78y2VHeCVbfi3RWxROhbpEONaQJF/KhBr8JKQFeBK78K1yZ5dwcNeOXBFSRwvCiYz9S6G4qfDAzo2quIbuL6keENHAOZ22aXFsE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789327398; c=relaxed/simple;
	bh=FaLCO11dTncwjIZwCKlXabizearGHJpuyJ9jqMO+gOA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CYuukEO67TvwrgJHVkqekR93Q6OwI9Mdf0PSPHkmmpuNkn3Bgn0dlhxBd3UQOwBFZh7pktJQpGPTA5joMre9cKEqg+nyFj8Mg1aXnWbrrhGIiwCG6fvpoyju4FdvCAeTqd6lUr/JBlHyzkQZwzmNFcVBefWL3KKD9y0Cm+mcghc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=qti.qualcomm.com; spf=pass smtp.mailfrom=qti.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=e5ZkUa0q; arc=fail smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=qti.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qti.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="e5ZkUa0q"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68DI2xcd2451596;
	Sun, 13 Sep 2026 19:23:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	lxNekezyLcu5xJ6kD+UgrX6A5jIrDkQmcd+DkSxkCXA=; b=e5ZkUa0qvmxg9zxt
	4q1LvDksBhMh5YrzN9mWK4ewjVx3RQnj0r38zK+639rQjD6mFvENDRVA8QLj+iAp
	zAWmV1fXFvRKQT0KGobNeTzgrKLq+FxFGrnrA3cThymbSQ1x0j0O6sOGLiw8wNC3
	41MbjGRvAx+agMB9siWLW5PIyLMGCrXjC4/egpVClEjYYFSc9jlJlqNmRD79XCkP
	J33mxvWlvVWx1PhJ7oUntdiU4fJIDCfjKRqEd+18wAb0jURfC2POXmUQ80M8skGD
	lWxbYon7rs2YNdQpW71a89CXM9xhZ+GIl1VwaounnTSA8gFJdccKktW+CFdbe/nY
	ko6HWQ==
Received: from dm2pr0701cu001.outbound.protection.outlook.com (mail-dm2pr0701cu00102.outbound.protection.outlook.com [40.93.13.66])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gmy9d3y8n-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 13 Sep 2026 19:23:09 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v6OTvOWL9sbhMEWbPX2kqsxDoE3TmYmeEEBtpNvP3RxJqMgPLPhKLFYo3Sa1wz0iFio/HC0VH/m8Umxz98Dj2K0q1fwwGL/B61Q8MrS6JyPPjhtUivNfujc5CsKl/0/3bIPYXuedXWAN9lYTSJAAzM5pMETitjQjSqig5lXmOpF7kzy0M/tOA9pp8ovaFs7QB+fCrjjuAQiDiFNtU/e0Qxt9Vpz//nNfaMsRf3AlzJ3oGHauO7MvgZz1I9NkH096xhPI4MNih8mcwKJF/AUenCxv8PrA8vA9SoPcJfotZQSjbPbku3Y9TKHlsccYTFMtmrRhEB3DoFDpo0S10VtLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxNekezyLcu5xJ6kD+UgrX6A5jIrDkQmcd+DkSxkCXA=;
 b=xPoyVlTpQTOp59oCqMfKAdM9dsg3T0oamWVpEzPh4I+0CdJeCxHakyOxYHymX2+F5lIy4u+MOmCN97oLNniLwg5MwPS7m90FzVOf3P2Q5CYbyvzzuOwyuZI3iUKjBr5LYm+PtpfgB0A5amcitgPOrmopmubFEn4azeBtwcSR0OI2A5nusO/exsA1g/MA40HcGk6jwR+quxR4Q0EPmj6CFHqWssdB85D35KsfYGu5yHgr2fsq1WXfzGYl/5TvJtdNGl2f4SVs0o7ie+JtVLD2rXsIzbRAXqpJVQcBJNTTw/oPGIcbS6e2tok5/DW21JBlQ/UNKKzxdmHvVT9zaAi+Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from CH0PR02MB8168.namprd02.prod.outlook.com (2603:10b6:610:10d::23)
 by BN0PR02MB7871.namprd02.prod.outlook.com (2603:10b6:408:14a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Sun, 13 Sep
 2026 19:23:04 +0000
Received: from CH0PR02MB8168.namprd02.prod.outlook.com
 ([fe80::6012:2c19:932f:67ec]) by CH0PR02MB8168.namprd02.prod.outlook.com
 ([fe80::6012:2c19:932f:67ec%6]) with mapi id 15.21.0406.007; Sun, 13 Sep 2026
 19:23:04 +0000
From: Vivek Chettri <vchettri@qti.qualcomm.com>
To: "nbd@nbd.name" <nbd@nbd.name>,
        Bhagavathi Perumal S
	<bhagavathi.pillai@oss.qualcomm.com>,
        "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ripan.deuri@oss.qualcomm.com" <ripan.deuri@oss.qualcomm.com>,
        "vivek.chettri@oss.qualcomm.com" <vivek.chettri@oss.qualcomm.com>
Subject: Re: [RFC PATCH 00/15] wifi: SCS and MSCS
Thread-Topic: [RFC PATCH 00/15] wifi: SCS and MSCS
Thread-Index: AQHdQFv4JUaCsa2HCkycMgzO3BpUL7bGRQuAgAahvxU=
Date: Sun, 13 Sep 2026 19:23:04 +0000
Message-ID:
 <CH0PR02MB8168357184D7A6354A24A338F1BC2@CH0PR02MB8168.namprd02.prod.outlook.com>
References:
 <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
 <4c3aee64-d289-4648-9520-edb6518b3d13@oss.qualcomm.com>
 <6ed64b95-57a3-42a2-9280-c98978382fa6@nbd.name>
In-Reply-To: <6ed64b95-57a3-42a2-9280-c98978382fa6@nbd.name>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR02MB8168:EE_|BN0PR02MB7871:EE_
x-ms-office365-filtering-correlation-id: b7ceb936-bd9d-49ed-1965-08df11cc6f11
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|10070799003|376014|11063799006|4143699003|56012099006|6133799003|3023799007|10067099003|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 LJJ7s3jnQxQpy/SG2HA7YjW5mZVFVOl+dkqERMQbK8Zu07xIoGk8qjPHwjdDxoFJYk4oDPHZOn54rJAOiYWIrIVVv3NIQgM2BmgPalmTiVJwF57MQYY7RXZLk9byyNWF+ZZSn1FHrw2BBrIS1jqA4uVz/21qm5wfPN1MxJhuBXEKxZ13AEShxiULAx09Hj4LLXEPzT9PYPtGM0YhZosUI6HCQOG83qrc6HV4NQrxPdvqUyvYTsT4j1MCPz5ELKPEgrvmwRS2rbaI+6wzyKA+CbzHj56OSNr6UOL+k6fzyoSi0qVVjHkN4yHve4pIQPzXZmQIBlrT0aU2D5iZA9zKrJMjfm3DvHProD1srs7LVUBZif+7lKpWeJvY9zKTYRIKx+y7WFvBp4RA+F2YhtIEpalel0PpK5/z9BHsI3xeOnRQyUks3y7zzsrQmow/6o5KAmTSdMoEJhQ5myoE8esRpAwJ9860vNG6Dcqb05Onw9vtafyV2KI5JwYj6phK6Zl3u9mkP3nGyGLC27kbsZLJ34LOPilQLaC+MYZeEzRh+WOeYV3qt+0iHGtJHYkRzULwHeQ0uKKOGLZlCiIHST311mpuJIDTAY/UlQ5oA2LU0uNwLKnfc+W2al/Kipi1vdVntYsfK+aA/X1cIEemCYjuVQCPXyt2p2CQFnOVUeZjEjNOQC/4uqAdaKSOMjFwszx0hLfqKHIvvBvGI5rGki+6ERN90yaMbyOviyHqhZqOBCE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8168.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(10070799003)(376014)(11063799006)(4143699003)(56012099006)(6133799003)(3023799007)(10067099003)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?FMyoLjtCpQv93R1by25ijtpwiuyrod9AcUaHf73GQ1/sgza+3PS3XMrw?=
 =?Windows-1252?Q?V2N+hlZVaQWUP5s4xzl38UHksKJS6Y4rnlC2Xeii3GZitDil2KygQyFv?=
 =?Windows-1252?Q?qtVOzenZpKNK7J1nGRWpILuuDRZTAKG3ImL13Wgt5y8no643UFF4XNom?=
 =?Windows-1252?Q?WzvaPrBoFdFFRNp0YF1nlSGrLZ//yF056po5iM1qCTq4QvjOhpUdYygU?=
 =?Windows-1252?Q?mVZFbxARf2M0S4sQn5S+MOncTpg40oRwKh8+kGuAy4Pc1cKb1GhQvFHZ?=
 =?Windows-1252?Q?h5OcbXK52aG644ShEpdY7y7jVLRyx4ypVLDsJZEwDcORaut17HeetqLc?=
 =?Windows-1252?Q?OQ81ANviAldl+mA6I0Zpz8xTsRZaq8uqOPpz6kkKL5mNOfGFDBvZMSzr?=
 =?Windows-1252?Q?AE8XDGomEbXAkUTHyRwAuZrtMQSo/VWlejQ5+cPW72c00Td+RMR2nPch?=
 =?Windows-1252?Q?z/DyD7J2bW4ThIl4lbWPwEioB5G5oc98sI1fP6wzWoIrBU0zcEoxHbfs?=
 =?Windows-1252?Q?YvmBz8n1SsyZaocyy4zMPkfXGrmr3bWFMM4v1u57jhU+IocTkNE8+sTh?=
 =?Windows-1252?Q?BSDdbSkis3kFPVTrGrH8ZlDieDLaSvIse1xBoZo2S4dya8f7pOlfiKLf?=
 =?Windows-1252?Q?+LNxUruq9cfPlK3uGm6LcwNBmQyK0+IvKgRAJ98JnKoas4PEKzKWu81o?=
 =?Windows-1252?Q?x18gA8v/UsILgjiVqlkdWcGwpUIJNMVDbrlkMcUeje1Jx7htZ3ssHwpT?=
 =?Windows-1252?Q?Ewz1obeC6oRSY0MifJ5HTWlyWYglnBs+7YrheK2SeMcdXdsc65f2yC8O?=
 =?Windows-1252?Q?I86OMaD6rTn1tZHmkDGBhplwiGnZwmzMOSIX1kfB13wj2dc0G3FHtywb?=
 =?Windows-1252?Q?M7FHCBVarD7n+djiZFB5ASgR4bO6yBxPQr+qjlSlORSvJyJXUiya6o6t?=
 =?Windows-1252?Q?yNuoY9gS6w9kChFsxk3xaH4VN3rIKDj40R/4D+0RVhpmmdIgd0OPsuwL?=
 =?Windows-1252?Q?fgyT04MmB6dO1aOdphJR4WcOT0V3TZLUdcJD9GYI9xMwS5wbqioJUF0I?=
 =?Windows-1252?Q?NcF82npgt9mlrgJ2JV83U6BEHp8kLFSWE1tJc4JrXkNNsRBoFshx8gAH?=
 =?Windows-1252?Q?To4btao2JEPBkspj4UWeJZG+Rnr7PlgNdo8YjVwDcjGFbvBrROtyOuIj?=
 =?Windows-1252?Q?toasmGPogY3hQoOyOn4nv+TeC6ZBwzlzPujMEw0kbEV3IIzj4VqgGU+j?=
 =?Windows-1252?Q?ZjuZMQlxT3xMZ0jq8soS7x7SmIZ6O/cOY+G3vE99SaJeNLRHquCVX75u?=
 =?Windows-1252?Q?D/TWFgFB12Sim5W8tRYTLGYDZyE7Atk6NwuXL5g1OdBOdhv5lvcrm7qx?=
 =?Windows-1252?Q?MVCAvzcqxMJwTXirf1XcI9zTP2OHdsHsCzGZFUp4VLjAbMAJ1NHBrAZe?=
 =?Windows-1252?Q?2vfibGq/vucuLtZw+qAGYtFJX9ZCj7AaF2PjZSMKr90QeE/fFfzaQezT?=
 =?Windows-1252?Q?5KebDtl2uxxqCYZ0hk1PqXIzdsYAPl2+t+355G5qgqhvOOCouXm7Zt61?=
 =?Windows-1252?Q?QI3scsRRCe/27lQ2J+i6ZmL/CHc3t1ohD93TmFB4iBOhvzZdOgZdjWdO?=
 =?Windows-1252?Q?x/0sHZpZnlL3uFQ/0rRyUhcm5gAypSonAFNpOphpAGc024VkbGGQ3ou1?=
 =?Windows-1252?Q?1IjCzswVRQramr37iW2wUygWSx6+QXoEPw6acO4f/UhXxcUUQ4RzOuqr?=
 =?Windows-1252?Q?xxyCKxGut1qUzmXBJgan+J26b3dKfhUCxUaG5ptE3Ls8dGudg5OP0d5P?=
 =?Windows-1252?Q?Hqol2CleBAMdQaOMZ0r9HW9RJF4GdrfPVfZ/zf17RC/GbYDjtVlzcwNV?=
 =?Windows-1252?Q?wxZgh1SfMyII7RQB1Odph9xQtUBvWMjHdTmYWWhgWp1qTxwG5ogfh21f?=
 =?Windows-1252?Q?iwcxbwAR?=
x-ms-exchange-antispam-messagedata-1: 12a5d3GRkZcP2A==
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	ipUSKU5gnYXMefV8bpIDyL+Zjcg+zzbDHC04COvvzgON42kNW9GCSU6BtxWzjc63gdAOXoygl/mMZNy2PAsxw7xmjkwXnZukys/uzw/0QCz9fUq4LIHNynGyvaGQBoD5MQ5LyLM3B38b+GqlVuQMK6F06cO+qmt02AyKG1x/u/b40uHp9ErtsE3tpGIPYMA/rsnOtQhe0/wIx/oEs7/rQLdNeF3NLLm5dlPhapNd8eg2qIWKuSpSoNA8TMmf/f9ucTm7U1GCFEfVdwP5AAQt6GsUyJwDEhPq6s7UXNtAc/WfPv9JMf6b6+m9r5eJGKf5hxNvrY5Ad2s6Dmds+sH/eg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jSV7JIuIq7v6DGDd0I0bjF/jWiwJoGy/DP9ktCBxWPy8i6gujCImNqRTSEgXzYT6JH42YoZGkhfYA3u0vc8yt7nW+jKmPFwem0TXQ+Yx51xfGoryPKOC1iWUZtZEK4TF0AFgvutWWCGb8EfRXWoJVa2jpTQ3Yty+0EA9oNxkZY3UEay6EDoJBbu6ynbZ068coZ2R27wtRBwZ1YYavO0DDzJ28LDoE01pKMVY+FUIlPFZ2+CyYH2FsmqYUqWIw7yzkd1UXZRenvixEmGAXLA1W62esfJsdaaUfZ3RcC6W3VJiI1bCWhPCT2Z7htxgdWUjhimqzKvYnNxdsG8P/0LY7EWQiOWyPbrx57EYM33CnSpxTKCRWGRMxK+G2CP6BpgJpcBaG5iCTStBUjbYqie15GWFebXb9WqbpvDqOrCGuLnB6cCF/94Ca5is6s5g2oWITqMnVsWDZpM84RxDAqRn9HGeGzsBgXOyEJJdzMSIcSiWGWT4pEfinkJXGx6UjYJqr6oeiuy4K50+x5B2XYbe070tkpvE8qwoXrdKaFgbvUmo+uMa4hXIS4kWXAIvlkHkYx+laDwf2HMWzhUSmwcZIlG/1mD8HcjWzeJpvz/5errTCMA9Xz4dtRVR1muLsiUO
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8168.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ceb936-bd9d-49ed-1965-08df11cc6f11
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2026 19:23:04.3661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZ78pVoV/PwLWP+Mj6Zh6/tuL8jjL1VH8J1NamEzqaKbCJ0yAr5bZJP/3Wo92Iz5YFAy9Mg0vO5jgAOCpUnxYwdmGSKCqizEmusc8hM/V2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR02MB7871
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEzMDI3NCBTYWx0ZWRfXzIO/BoQSRUJB
 pU1zaG3ef3NhSaOPZlD/fRJzx/D49Iqiy0fQeYBq2Yhly7OcduG+rRvXUeWrEg0rNRo/0zzTWh7
 RD72bsrPx5imM5trxKykcFA720SDQv4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEzMDI3NCBTYWx0ZWRfX3idUoxXXi+MU
 8BraOUndb/y3hkeldx6okPJEwHb7tGcG0vaP81KtCa1XZSTjCyG2wwnr8eQ5Fv0yp+kRCWXLR7H
 ekWtvoAGv+YUTnNTTnvJe0cHBhVzl0rAzRPC2Lf6d3RGyG25yntZ0qhy7wwp0UCS9rE8mqd2DN6
 abr/N/30zFqQJlTJF5y95tbJ/lefZgkqEGjHwsXGO4WBO2eJCqDx7w7qWsQ2BO5gWkFke6G0OrG
 N7lCYEtblwIfS7B31kbPst+hO7fhNditZTsyVEk7HNlpJ3gSHsI+cOurcV30Ww/k2LdLGrIz4XU
 0ewC2Y29H23cWOU1Vb9H8lb8ySdaEzvcx0z6zYKeNPYVfCdeoogMkvc92fQo1JO1EqmysaajcBv
 hfVqq3r1U47sTCq8CRbFQ1Gn0NdmoY816NjT2JPuI2Uj2tWUUC6gMD/GRwh9D681vN+0x+8qkX2
 NK0tFfPnAnzHmz/VDMg==
X-Authority-Analysis: v=2.4 cv=IOSXmQvG c=1 sm=1 tr=0 ts=6aa6f81d cx=c_pps
 a=7uB9oqvJVKmA46VAnYT5EA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=N659UExz7-8A:10
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8 a=VwQbUJbxAAAA:8 a=stkexhm8AAAA:8
 a=zxbfjR-CBfEypLlSRUIA:9 a=pILNOxqGKmIA:10 a=pIW3pCRaVxJDc-hWtpF8:22
X-Proofpoint-ORIG-GUID: AHsGoS9EW9qN4JzJLJ-3oPv6y2wBZFCD
X-Proofpoint-GUID: AHsGoS9EW9qN4JzJLJ-3oPv6y2wBZFCD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-13_06,2026-09-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 clxscore=1011
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609130274

Hi,=0A=
=0A=
The preference for reusing existing packet-classification infrastructure is=
 driven by the need to have a centralized policy management and policy fram=
ework that operates across both software and hardware-offloaded forwarding =
paths, rather than introducing a separate classifier within the WLAN stack.=
=0A=
=0A=
1. Centralized QoS and Policy Management=0A=
=0A=
   A centralized policy management framework provides the following advanta=
ges:=0A=
=0A=
   =95 A centralized policy database enables end-to-end QoS policy enforcem=
ent across=0A=
     different forwarding paths, improving manageability and policy visibil=
ity=0A=
     throughout the system.=0A=
=0A=
   =95 SCS/MSCS policies represent only one source of policy management.=0A=
     Administrators may also configure firewall, QoS, or other policies tha=
t must=0A=
     coexist with negotiated WLAN policies.=0A=
=0A=
   =95 Centralized policy management provides clear visibility into the int=
eraction=0A=
     between administrator-defined policies and dynamically negotiated SCS/=
MSCS=0A=
     policies, making conflicts easier to detect and manage.=0A=
=0A=
   =95 Implementing packet prioritization independently within mac80211 can=
 introduce=0A=
     policy conflicts or ambiguous precedence when administrator-defined Qo=
S=0A=
     policies overlap with SCS/MSCS-derived priorities.=0A=
=0A=
   =95 A common policy framework helps ensure consistent behavior across so=
ftware=0A=
     forwarding, bridging, routing, and hardware-offloaded data paths.=0A=
=0A=
2. Policy Framework: Considerations and Challenges=0A=
=0A=
   A policy framework should help ensure consistent behavior across softwar=
e=0A=
   forwarding, bridging, routing, and hardware-offloaded data paths.=0A=
=0A=
   The policy framework can be realized using either nftables or tc-flower.=
=0A=
   Both approaches provide a persistent and centralized repository for traf=
fic=0A=
   classification and policy enforcement, but differ in integration complex=
ity,=0A=
   feature scope, and deployment model.=0A=
=0A=
   Common Capabilities: nftables and tc-flower=0A=
=0A=
   =95 Both nftables and tc-flower maintain centralized rule databases for =
traffic=0A=
     classification and policy enforcement.=0A=
=0A=
   =95 For software-forwarded traffic, both solutions require flow lookups =
against=0A=
     installed rules and therefore have broadly comparable classification=
=0A=
     overhead.=0A=
=0A=
   =95 Both mechanisms can serve as the policy enforcement layer for=0A=
     SCS/MSCS-derived traffic policies.=0A=
=0A=
   Advantages of nftables=0A=
=0A=
   =95 nftables provides a unified framework for firewalling, traffic=0A=
     classification, and QoS policy marking.=0A=
=0A=
   =95 nftables can support both software and hardware-accelerated forwardi=
ng=0A=
     paths and can be extended to additional offload scenarios with minimal=
=0A=
     architectural changes.=0A=
=0A=
   =95 Existing support for nftables-based policy handling in hostapd reduc=
es=0A=
     integration effort and leverages infrastructure that is already availa=
ble=0A=
     and upstream-ready.=0A=
=0A=
     The implementation is done using libmnl, which avoids licensing=0A=
     incompatibility between hostapd (BSD-3-Clause) and libnftnl (GPLv2).=
=0A=
     This approach was also reviewed with Jouni.=0A=
=0A=
   =95 Using nftables allows SCS/MSCS policies to be integrated into a broa=
der,=0A=
     system-wide policy framework rather than introducing a WLAN-specific=
=0A=
     policy engine.=0A=
=0A=
   =95 Using nftables can also facilitate scalability by allowing these rul=
es to=0A=
     be applied at software acceleration decision-making stages. For exampl=
e,=0A=
     the NFT rule can be cleanly integrated into NFT flow tables as well.=
=0A=
=0A=
   Challenges with a tc-flower-based Approach=0A=
=0A=
   =95 A tc-flower solution would require substantial additional implementa=
tion=0A=
     for rule programming from hostapd.=0A=
=0A=
   =95 tc-flower typically requires qdisc configuration (at a minimum, a cl=
sact=0A=
     pseudo qdisc) before classification rules can be installed and enforce=
d.=0A=
=0A=
3. Summary=0A=
=0A=
   =95 The primary role of SCS/MSCS handling within the WLAN subsystem shou=
ld be=0A=
     to negotiate and manage QoS policies between the AP and STA.=0A=
=0A=
   =95 Packet classification and policy enforcement should be delegated to =
a=0A=
     centralized policy framework such as nftables, which is already design=
ed=0A=
     to manage system-wide traffic policies.=0A=
=0A=
   =95 The WLAN driver remains responsible for mapping classified traffic t=
o the=0A=
     appropriate transmission priorities and ensuring the negotiated QoS=0A=
     behavior is achieved across the data path.=0A=
=0A=
Also, what is the plan for supporting repeaters and backend devices?=0A=
=0A=
Thanks!=0A=
Vivek.=0A=
=0A=
________________________________________=0A=
From: Felix Fietkau <nbd@nbd.name>=0A=
Sent: Wednesday, September 9, 2026 7:25 PM=0A=
To: Bhagavathi Perumal S <bhagavathi.pillai@oss.qualcomm.com>; linux-wirele=
ss@vger.kernel.org <linux-wireless@vger.kernel.org>=0A=
Cc: johannes@sipsolutions.net <johannes@sipsolutions.net>; ripan.deuri@oss.=
qualcomm.com <ripan.deuri@oss.qualcomm.com>; Vivek Chettri <vchettri@qti.qu=
alcomm.com>=0A=
Subject: Re: [RFC PATCH 00/15] wifi: SCS and MSCS=0A=
=0A=
=0A=
WARNING: This email originated from outside of Qualcomm. Please be wary of =
any links or attachments, and do not enable macros.=0A=
=0A=
=0A=
=0A=
Hi,=0A=
=0A=
=0A=
=0A=
thanks for your feedback. Comments below.=0A=
=0A=
=0A=
=0A=
On 09.09.26 15:05, Bhagavathi Perumal S wrote:=0A=
=0A=
> SCS and MSCS are primarily mechanisms for negotiating QoS treatment=0A=
=0A=
> between an AP and a STA. A negotiated policy consists of:=0A=
=0A=
>=0A=
=0A=
> 1.a traffic classifier, such as the applicable TCLAS or flow parameters; =
and=0A=
=0A=
>=0A=
=0A=
> 2.the QoS treatment to apply to matching traffic, such as the User=0A=
=0A=
> Priority/TID and, where applicable, other QoS characteristics.=0A=
=0A=
>=0A=
=0A=
> The classifier and the QoS treatment should be considered separately=0A=
=0A=
> from the protocol state.=0A=
=0A=
=0A=
=0A=
I'm not sure I agree. From my understanding of the standard, acceptance=0A=
=0A=
and lifetime of the classifier data and the QoS characteristics must be=0A=
=0A=
considered together. If applying characteristics fails, the full=0A=
=0A=
descriptor (including its classifier information) must be rejected.=0A=
=0A=
Handling this together in one place seems beneficial.=0A=
=0A=
> The protocol state needs to be maintained so that the AP can validate=0A=
=0A=
> requests, generate the appropriate responses,=0A=
=0A=
>=0A=
=0A=
> handle updates and deletions, and associate the policy with the correct=
=0A=
=0A=
> STA and link.=0A=
=0A=
>=0A=
=0A=
> For IP traffic, classification is based primarily on L3/L4 information=97=
=0A=
=0A=
> for example, IPv4/IPv6 addresses, protocol, ports, DSCP, and related=0A=
=0A=
> flow attributes.=0A=
=0A=
>=0A=
=0A=
> Linux already provides mature packet-classification mechanisms through=0A=
=0A=
> netfilter/nftables, conntrack, flow tables, and vendor-specific flow-=0A=
=0A=
> offload infrastructure.=0A=
=0A=
>=0A=
=0A=
> These mechanisms can classify the traffic and attach the required QoS=0A=
=0A=
> information(TID or additional QoS attributes) for mac80211 and the=0A=
=0A=
> vendor driver to consume.=0A=
=0A=
>=0A=
=0A=
> Therefore, the packet-classification implementation does not need to be=
=0A=
=0A=
> duplicated in mac80211.=0A=
=0A=
>=0A=
=0A=
> mac80211 should not independently reimplement a second L3/L4 classifier=
=0A=
=0A=
> when the same classification can already be performed by the networking=
=0A=
=0A=
> stack or by an accelerated data path.=0A=
=0A=
=0A=
=0A=
=A0From my perspective, it's not as simple as that. Re-implementation is=0A=
=0A=
perfectly acceptable if the part that's being re-implemented is not a=0A=
=0A=
good fit for the use case and if the end result is more functional and=0A=
=0A=
less complex.=0A=
=0A=
I believe this to be the case here. Consider the following data points:=0A=
=0A=
=0A=
=0A=
In my implementation, net/wireless/scs.c (which implements the full=0A=
=0A=
classifier) is 586 lines of code.=0A=
=0A=
net/mac80211/scs.c, which handles glue for maintaining the data=0A=
=0A=
structures and the outer classifier call is less than 400 lines.=0A=
=0A=
=0A=
=0A=
In the hostapd implementation from QSDK 14, the nft.c glue code alone=0A=
=0A=
(which is just one part of the classifier related code) is ~1350 lines.=0A=
=0A=
robust_av.c (which is ~2060 lines) adds even more classifier related code.=
=0A=
=0A=
=0A=
=0A=
With that in mind, reusing nft already seems significantly more complex=0A=
=0A=
than a narrowly scoped classifier implementation written specifically=0A=
=0A=
for SCS/MSCS.=0A=
=0A=
=0A=
=0A=
> mac80211 may still need to own the wireless-specific policy state and=0A=
=0A=
> provide an interface for:=0A=
=0A=
>=0A=
=0A=
>=A0 1. installing, updating, and removing a negotiated SCS/MSCS policy;=0A=
=0A=
>=A0 2. associating the policy with a particular STA;=0A=
=0A=
>=A0 3. reporting whether the policy was accepted, rejected, or could not b=
e=0A=
=0A=
>=A0=A0=A0=A0 enforced; and=0A=
=0A=
>=A0 4. handling station disassociation, policy update, and teardown.=0A=
=0A=
>=0A=
=0A=
> The actual packet matching can then remain in the existing packet-=0A=
=0A=
> classification infrastructure.=0A=
=0A=
>=0A=
=0A=
> This avoids duplicating classifier logic in mac80211 and allows the same=
=0A=
=0A=
> policy to be used consistently for both software and accelerated paths.=
=0A=
=0A=
=0A=
=0A=
So far the only working upstream acceleration path from Ethernet to WLAN=0A=
=0A=
is for MTK hardware. Having written (though not yet published) an=0A=
=0A=
implementation to handle SCS/MSCS for offloaded flows, I can tell you=0A=
=0A=
that it's much more straightforward to do this in the kernel based on my=0A=
=0A=
series. It allows handling both netfilter based flows (L3 routed) and L2=0A=
=0A=
bridge offloaded flows via tc-flower consistently in the same way.=0A=
=0A=
=0A=
=0A=
Especially the L2 tc-flower offload case would be hard to handle with=0A=
=0A=
your nft based proposal in a way that handles runtime flow updates well.=0A=
=0A=
=0A=
=0A=
> If CPU overhead is a concern, it should be evaluated using profiling=0A=
=0A=
> data. In particular, the evaluation should compare:=0A=
=0A=
>=0A=
=0A=
>=A0 1. classification with and without SCS/MSCS rules;=0A=
=0A=
>=A0 2. the first-packet/flow-learning cost;=0A=
=0A=
>=A0 3. the per-packet cost after flow establishment;=0A=
=0A=
>=A0 4. the number of active rules and stations; and=0A=
=0A=
>=A0 5. the effect of conntrack, nftables flow tables, and hardware offload=
.=0A=
=0A=
>=A0 6. For hardware-accelerated paths, the packet-classification framework=
=0A=
=0A=
>=A0=A0=A0=A0 can notify or program the accelerator when a matching flow is=
 learned.=0A=
=0A=
=0A=
=0A=
Again, not as simple as that. There's inherent cost to using an=0A=
=0A=
implementation that uses dynamic dispatch and is written for a lot of=0A=
=0A=
different use cases, vs a static fixed-purpose classifier.=0A=
=0A=
=0A=
=0A=
> This architecture keeps the protocol and wireless-specific policy=0A=
=0A=
> handling in the Wi-Fi stack=0A=
=0A=
>=0A=
=0A=
> while reusing the existing Linux networking and flow-offload=0A=
=0A=
> infrastructure for L3/L4 classification.=0A=
=0A=
>=0A=
=0A=
> It avoids duplicate classification logic and provides a clear path for=0A=
=0A=
> both software and hardware-accelerated data paths.=0A=
=0A=
I don't see the clear path for the hardware-accelerated data path at=0A=
=0A=
all. Could you elaborate?=0A=
=0A=
=0A=
=0A=
- Felix=0A=
=0A=
