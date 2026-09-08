Received: from AM0PR83CU005.outbound.protection.outlook.com (mail-westeuropeazolkn19010018.outbound.protection.outlook.com [52.103.33.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AAD3EA66
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 00:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.33.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788828687; cv=fail; b=ri+2td/yirR/0YN7yRX25B4/bEEdzOqWQZzYZ22urHiJ33kkCelpWa6vlDqP83tJMaagQFShZfOp0rqH18YD520N8xsPhQQSyrp8AZgLxDRnvuOxj307nSdtlZQw06lHZwRiRBaD2Q71gp1NRjoEbY4xoHQOLz2sQJBLiwv5b9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788828687; c=relaxed/simple;
	bh=iezmoainxBQ9ZTzaULYPlC8Y2CdpnpKx3JB7skSHJlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TfbovP0dCdKHA8eNIbg0bObsNcWEBD2A9OAO6Npp85Uqn81u7YsAP5mU0ilTDpv2ifhMzrL0qzIvrd3F5ZGjEdSCQa9nMpF1yeCuyp/0xqvkOxQN4QaEFwdRXErweNicPI+OjpVIyBLVe3lqm9Sis0DCRIlY3I2wpfzTZOZl81o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=KHLkGVY6; arc=fail smtp.client-ip=52.103.33.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="KHLkGVY6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSog2mH457s3adYVNCRh8SsJ3jmxBSN0/SjkkH4Sm6KZvG8dlWH9YMX2CfKPsWzzIHdkmRbI6vstLSQUljC/ndrN8L0e++5zZOA1sArqjEiJfq6fiLhQlX6wjOXjIil4iDOn+zFMaiI8byYEgiXVjues9JCQB5eUankf4YyBCkX3Virv2NktnifIvMPFsEiQy283tGNT/BstGkIbs8UOWLc57NoQxP0I8448n6wC4OOC9Dcsrg0cavqcEgVDSx00YA+2kkYXg2Zqac9J68cJqWXMrs5Svhp4dMu/tVBEr5ReTVauuLNmo6clv4ybLoLIzjnIsdL0rOOfFBRtHPMIVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iezmoainxBQ9ZTzaULYPlC8Y2CdpnpKx3JB7skSHJlo=;
 b=ku83C9+6sIRSFHDpKAtQ/LJMyag8hyUI6X6KSuw+/5OilDnlq0QF/loeTkzYrBlloHRj/i54v3jNjtD/JYnE1xDyLSniDL14hEdgnf0AyPcui8ZnsHojU6dQUaRafGZXgyUVdg23NhGqUKeovp4uUtf0MvjgOLTeYTf1n8uqG8y7pcRJKdcHlkv3UAsV9txovfijg4hE6k5+Wb6VXCWmzAsMeBUIhePCHjrG94OCGtRwBc/mwa3kZCoEb1ifJ31pxc0fFuSL4c7Nt5vcqjHjsheIKW0JkBhHvtz8BK0uUNmgxJyItXZ7hg+XoaYjWch0/Nhj2wXywTlvPZK+rdmtgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iezmoainxBQ9ZTzaULYPlC8Y2CdpnpKx3JB7skSHJlo=;
 b=KHLkGVY61+7a6rjtzO9osBbVedsfs4Uw09vNnBZnMBoaorvBb3MbTc/9kehIm7/8Kl7f2iOA0G63Kdv0db2VjqzkgJU9Xc2b1n1ZJ0LEcCJxk0OWKt5lO4qgEfW/dqZjmA7hg49Be++GE9nJ70phqAdoSgNW25vVNypiDq6SdOd3ECggPShmSGsL+yDw9/5GRWwunNlpm8StAssYGuhuzWDw2jJsf9KkidpiFzhsDaUJg/r+Hq1a3upoKtVOaaMFT5ric3mR0QYPcxAcQtUiRyedi+1OkwKzxqN5RYTCb7QST67xpCbVPzU3lPcGv5za9Ye3x5XgXMtdpAQSnCkerw==
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:1d9::15)
 by DB4P251MB1022.EURP251.PROD.OUTLOOK.COM (2603:10a6:10:386::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 00:51:23 +0000
Received: from PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35]) by PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 ([fe80::fb91:30d8:e31d:1f35%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 00:51:23 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	Dan Callaghan <dan.callaghan@morsemicro.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arien Judge <arien.judge@morsemicro.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mm81x: validate n_channels in disabled channels response
Date: Tue,  8 Sep 2026 01:51:20 +0100
Message-ID:
 <PAXP251MB00103F102F6D1F2291979A0BC8B12@PAXP251MB0010.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <if3rynkyvmxep4jadpqvbxei2j4ta3tkm56yvpolwnxwv3bckc@mtax5yg5yugz>
References: <AS8P251MB00017F5BF791EA475A60A6CCC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM> <if3rynkyvmxep4jadpqvbxei2j4ta3tkm56yvpolwnxwv3bckc@mtax5yg5yugz>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0397.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:189::6) To PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:1d9::15)
X-Microsoft-Original-Message-ID:
 <20260908005120.114933-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXP251MB0010:EE_|DB4P251MB1022:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e1ad2e-9b08-4626-2deb-08df0d434d96
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|5072599009|25010399006|15080799012|25031999004|51005399006|12121999013|19110799012|23021999003|2604032031799003|24021099003|55001999006|37011999003|440099028|3412199025|26104999009|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DrU0VKhWyfcpzwb6wnQEJ42qTWEudKOcNptt3O5xX+6NXhy3E98NCFAuMINu?=
 =?us-ascii?Q?oaNMyoMrh4HWC3Ea39rPIl2dl30x87V9ySxLxDXF0hGaHswJAuAhXntjjwcT?=
 =?us-ascii?Q?bTwfpWE9QeNzjq+Rez3ypcICceeiIgyD2O4nOrleWtad0AtE0Z0TChROFqxM?=
 =?us-ascii?Q?q5JYYU5KCyZg4t8IT5ruvl5zlQLOpOtoXD5veFPY7amaGVmjHjObVWj5PoWd?=
 =?us-ascii?Q?j8MxO/6//8Pu7vr4WeoHc5jXggghmr0gX6mA9m+ib8seNhldrOc0N7IiGRDa?=
 =?us-ascii?Q?F3SXoE5HXwh7Q4UhSampHYpPVK4AM7NTBzG+rA+Hc3xTNF5boNtOLpKVb45Q?=
 =?us-ascii?Q?aGnJzN1O5upX1fbZuR8EJLd+br9KepK8tVFJ7SbZ9VEI4B49nyY+8b2volNG?=
 =?us-ascii?Q?gIc1UBQemybiahfHhfakmoJVLBJJDEzseViIJuzGbu0BER7m8rYU9DMshH0W?=
 =?us-ascii?Q?So0ldfrQKSxC4+fadd0xpqhpTsD1UpZBsa6XpTkyypqOoUVIudX1hnpVPGb9?=
 =?us-ascii?Q?ob2p1mkc7Tbh7dA86z0N+vpug6TOH9Nijx43u71ytp48brG2VhuFaaTV2XJg?=
 =?us-ascii?Q?gTtTRHk56qZSsmP+PDhosQeS93PKNEuuxJRXK1DNvdlCRko9YQMFJnbOjiz3?=
 =?us-ascii?Q?r8bHSoS6qCFv+wBGVIXbtMYxq2ijQcaU52C89S17AwUqhyC1jw+/ox7BxnRL?=
 =?us-ascii?Q?nhk5y++q/meOg1ZGrnjo8/5IuPwFv71XzoJIR99DTW7BjMXtF0jIqHaW3Bue?=
 =?us-ascii?Q?FCF+VJDGtPrN4do9I6v9fgMQK3wye8ETabftRVcGB/0TQYKMiQF4hUTQcZvH?=
 =?us-ascii?Q?nFeA/BEqnEjf/s247myAfWk6daeoPt6GAsChiSyYWJhvrHiXg3C1L5JQrDaU?=
 =?us-ascii?Q?F8Yr03f5FYdUzjxmE2PBVjHdZr7ng9GZAGz4ilkbC8xaNMIMsiSSdJTNfxeG?=
 =?us-ascii?Q?a7WMHPB1xpmpb8oTkpxRfpoi56kzD4NLPh/bzdPwuZrIW2YrmkCP3HBu5/hk?=
 =?us-ascii?Q?xw385zqp4DM/9y/4ZMUdP86ZrPvd07qhbssrQMzWCPBjSewBByl0apw09vw6?=
 =?us-ascii?Q?HlVLUWfUM4MScl5ozWATzzcjuNSwV17UyXQlaxhtwHie307MgPWMpm67oC0i?=
 =?us-ascii?Q?akbTX4rduR+y?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gJrm+/ubFVRu3GmUHfZro59J5yXy/eQfEQ61meYY4SwG5zAemyUpue3SBzx0?=
 =?us-ascii?Q?lH7I753RN3tAQtNTKzUAhBMrM0zXMylPS12mbpIVEjRtjUopd+MGUDM7Pbpn?=
 =?us-ascii?Q?f+afbxYxzbn05Ckwi6+yryYT9VfTwCntZ/2F2A/OQH9xFQ1sKw/S8HGAPwyR?=
 =?us-ascii?Q?ZdKJpEzQW1MBuPnx9CPVVnkdYNaqD0AIwCEBigVPS4phNGzJb+8DXO/0DUfO?=
 =?us-ascii?Q?1l7yTjWYx1cX6FZ0GiuhEf+Yti/RFJFOhGKtR4iOKFU5Xmn2y76E4U7us0mp?=
 =?us-ascii?Q?WpsvRlYxHuN34CogQetg8acsyfRIFhiAM6JK1AcUEMMs4vbHgUt00cmkqMhR?=
 =?us-ascii?Q?6JRgDx6vRfvhm/smYNf4bzpQMRsYwP195PwKlhF0pVPGifpSQ83mRz9T9UU/?=
 =?us-ascii?Q?x6XOt7bLRYMfXVL8G8W3rzO9AMNR5K9RYODa+8SwMFJ8+1i3zWrAoUVLH/Ba?=
 =?us-ascii?Q?RI493sVyXR1JDDhOUB3nDNbcFblgPInGUVahOgLUYN4qUj+XMa+Fn5kwpxHf?=
 =?us-ascii?Q?wqmhFzRBe/TO6/sRpPtCZqHdULGbmscb3VJF6IZozrKMp2QXPBABkSH+MCFO?=
 =?us-ascii?Q?Sx9ZTBOo2DqbzxhPDtYkM1hNjj3MBYy6SWIVd/jiUSYGtUqb+qAOzPRCmBMu?=
 =?us-ascii?Q?i7Z1r8p41Vvhei0oR0EaVR+aYN5Iz3t/vCJDH04Eo/IUCfI+E00JQGXT/HPr?=
 =?us-ascii?Q?1dN+ts4kfNu72VEFVQquK21w+b6Widqf9CoV5xEmCdcCfWFjdXPlpkBx/iEw?=
 =?us-ascii?Q?Zc3eggmDY19J+R9Dahp7V1N77hvhFlusAnHbfpxEFz4nzSOklKNb9OvaIlgI?=
 =?us-ascii?Q?tMpzY66Fxenp5MijtjRmTlF6p2hEr9i+DrelF6YGgLY5RP6bnwCZmvMtwdNR?=
 =?us-ascii?Q?I12zz2hW6i/G6pMscN7DhylmERZkwZhL58C0akBDRZ6+jen+8ZWYy11j+cyO?=
 =?us-ascii?Q?7cIytnFqNKBVu9Hj3Ck86KBkgXISM05y8TCzS2VR81uF90l+qOtaIVTWgDxq?=
 =?us-ascii?Q?mfhx+qMSOi3Mug8zsXLsuPHED/0q11IcWQeNbL7s/Th2q2dyNawyu2vx6Pm8?=
 =?us-ascii?Q?dE8yM9ffy1XvI+6bb7JYvYnEO/4eCI/ysNAE6WuTt0xls778tjKqfFaROZrs?=
 =?us-ascii?Q?vHqpeFvvdi+AHg1kFgbDcTCzGIqDYalEWBrTMS1DZz9CkdDhKze924otG0ai?=
 =?us-ascii?Q?WfRxkQyzLY1fT5tUH3kPgjWUfuP/Z1tmOnRIWKyepCI2QLZmWyKTjgAaGp31?=
 =?us-ascii?Q?4mu61CRKoV+glmBcSgeapMbe6t6eui8JV91rw9gFX8UyKJoxCSv4cKhHh+fr?=
 =?us-ascii?Q?S2PWHQGAL1EU2ZR95bjoIbgzrPRLsgj2WYB1li0qv935XmJlthf68hR5y7n5?=
 =?us-ascii?Q?0wEnwh+lkWZ2vdxVqF2aA26AafeULy3lUDZGK9A2qH6sOQRPSrpjx5b2ZRhd?=
 =?us-ascii?Q?RfYwXldLeXJ83OR2NyG5WEcFZf1pg207?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e1ad2e-9b08-4626-2deb-08df0d434d96
X-MS-Exchange-CrossTenant-AuthSource: PAXP251MB0010.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 00:51:22.9472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4P251MB1022

On Mon, Sep 07, 2026 at 05:36:38PM +1000, Lachlan Hodges wrote:
> This is not really helpful. The point here is we are validating
> the response length against the array size.

Understood, will drop that paragraph and describe it as validating the
response length against the array size.

> I'd prefer if you placed this before the Fixes: line and use
> Assisted-by: LLM instead.

Will do.

> Your v2 is based on v1 so it doesn't apply. Please respin v2 based on
> the wireless tree. Please also include in the subject the target tree,
> in this case wireless-next (i.e. PATCH wireless-next) so the NIPA
> bot runs.

Apologies for that. v3 will be a single patch based on wireless-next,
sent as [PATCH wireless-next v3], with the check kept where you asked
for it.

On Mon, Sep 07, 2026 at 01:54:39PM +1000, Lachlan Hodges wrote:
> Also since you are looking here, might want to change the uint that
> mm81x_cmd_get_disabled_channels takes to a u32 or something.

Happy to send that separately afterwards so it does not mix with the
fix.

Kind Regards

Aamir A.
