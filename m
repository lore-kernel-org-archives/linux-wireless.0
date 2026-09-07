Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazolkn19010001.outbound.protection.outlook.com [52.103.32.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B12A2DCBF8
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 03:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.32.1
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788750629; cv=fail; b=HMutWx97Qw6oocf4OuhKGrlGdiJKsZletw0ChigbYq21UvdANg6CiEFpgX+37JRCNVewLF8snUcwGjVvtgI93yLCYynGBjHNaBE+7bbEV8NRnQi+IKb4+tAIs8bBP+Lkap21/iDhXoSAXhVi86erDAY0zQke+DMWqioRX6ItZ2o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788750629; c=relaxed/simple;
	bh=5UjSjhXqiMMJmurEm6q1JC2Q0mvYZJfEQIk5cmj2p6g=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=eb4x4ACAyMX/v22cBAq0z8gEgM1NvA02hChKq/2AF20ga5El9bgyNUaNj5iEgxrqZhZHmDG9F7NaE2zhKLu8azE0rp6pVwpxULlewSnTNah8qseFV6Cx0oLRjvcqfZQnWf29G1R8cNre9wwnUGbt+u1WSKMh5ze4M5rKJPQ9PCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=bYbqAiWU; arc=fail smtp.client-ip=52.103.32.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="bYbqAiWU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NvbdEUVxyMnkRnITlOrebhLTberUQTVW5RngUizVD0wSl73ooMrgK3001pQP88aO5Z6CAlSD7X50kEwAH0ine3RwVqUxIAHcHY92ukmnkVqig7Qcm/JPMNrtNxW1Ws7HqVgtOcXkP53MxUZurk2Kv4XWU2DxYAGZGD1oIbhK7V8m5WvOmQkww9RdMe4dVURTj+WIrbj0QCrMPrkHyqODTmsL/cbmZ9YDMC/EwVivFSowxVujEcvxDI9SmvZWencAeLJQ3yBR40XnO8EVVn+16BIokrGs07mpaBC5zshdUIWKRzuwG888iCCkPu3R87FRghezTB3YkXt8SsUuqmUKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3Xr7edN6I+548Zabn4pG5DS8CqVZ+BygLG8YAG5Uo4=;
 b=f9N5GSuHujtd8v6zZWGAlKoIfInJnALQbWp0OP2FnazTt0UJJsdN0aw2/GoZNIxiV1RYuNfvKN0HNVUKu0p3hEW6ueuMlMq/ApTtSFdrPJ9B2YEXQTxRrxbvVbO1Podq7XvocaH+QecMuNxeQcrKsPYqRl7saGID1307sgsDWh9Q+S0CKpIdxK5rZ6X07AtHWWmzU2sPtzvjqtD3TY4H2lgBs+aNDZtK9jU+UU1hoXkfpPut44bS1AjGpLwsAFECnR2fRfq4kI56BL69UyzyQvAdGkhaWQgCjP/KYr418/WOuMKXV9WKXRWlrIAKWxk+zUk6VqaIUasCGbrMMeFIBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Xr7edN6I+548Zabn4pG5DS8CqVZ+BygLG8YAG5Uo4=;
 b=bYbqAiWU8/LeOdFmZea2Zbac4WLlkVb+YuVF26hCj/xfgSSYtgOEHEBALXznyiQNjXuljYJaWCdk9G1tnv4jQ01L0UmrpG/SyCj711q8dbp1llqtZvIm0+k9Za3l3w/jCKIMmpGiBzhSdrsjaohm6kDbyWnnZL+lCnhA2/KNjt6XBYnSXX6aHs7G0CkbxlD4Wo9LfRfmwCVwVVDJh+T+MP4lBlXdq91u6kfA1iiQM/HfZDRSl7gVPQgHjFiY4EtvcoJPg8mXOy6MUFj/bC6afJVZIT8TPU93SVkODFpI9TSKMPpNGYj+6kXblt/tmKepV9vTwq5BmBCEd9ZoIMxioA==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AM9P251MB0110.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:415::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Mon, 7 Sep
 2026 03:10:25 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%6]) with mapi id 15.21.0382.014; Mon, 7 Sep 2026
 03:10:25 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: briannorris@chromium.org,
	francesco@dolcini.it,
	linux-wireless@vger.kernel.org
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>
Subject: [PATCH] wifi: mwifiex: validate sta_count in UAP sta list response
Date: Mon,  7 Sep 2026 03:10:22 +0000
Message-ID:
 <AS8P251MB000162EC4B1DE63ABB8EE90DC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0062.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:153::13) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260907031022.511789-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AM9P251MB0110:EE_
X-MS-Office365-Filtering-Correlation-Id: c8195feb-6953-4251-1ad6-08df0c8d8f9d
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|19110799012|23021999003|25031999004|2604032031799003|15080799012|51005399006|37011999003|55001999006|24021099003|41001999006|5062599005|25010399006|5072599009|40105399003|2607281247196008|3412199025|440099028|26104999009|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bcVHRZocOTrQikpk1jlMkeAN1lkiq6bTIGoQW7rfY2x+u9wlDP8qSmbhyv/U?=
 =?us-ascii?Q?ER6HP6FdGgl7I7IyCiH2KTuTSLIz+EzmDtrm+rxMJ1I6YpkupuNFmSQbAAbw?=
 =?us-ascii?Q?m/KslUgteggoKLAo5U36X1C3sle0kI79dWTTMwrk5LKU3VZBXhaY4RJmR7tG?=
 =?us-ascii?Q?BPDXMNjksFXuTUyfxDGlD5PqNkrdgKJ3Qi9x1Jg3qPWJmIPNSYz6fhyY5HHn?=
 =?us-ascii?Q?wH/GdwEHkGjh7OzBqTG3n1KjVhJ+D6fVQS2HJLnbXEsfW3G/VCD1BzkBQER0?=
 =?us-ascii?Q?Om248gBkguIEDXnvcP4kljud+p+GX7IrXxXEXkelzBsXytA3Xw8Ho3+zczXp?=
 =?us-ascii?Q?ilJDYLyX1JAzvYrpbTC3e/zoEP46spSo+JvdIDhY6PLNuKb/OrKCvvp5FEcZ?=
 =?us-ascii?Q?rVB0QR/m2x2Uu8BmzXcPdpC+89xNzN+rMiZrjh6yvYO2AQSZdXNWDlQBTfXQ?=
 =?us-ascii?Q?0bORyMbh+kDxfh5Fl2Hf1QOO/sJlTWIpSUJ4kL/fii0hmjYWatDYRy7ILv4m?=
 =?us-ascii?Q?gAd76sdc7swNND+MnzZY2OKuarSqT8hK2Bs6xhUInNOuFOjUuCUiREj8HD1N?=
 =?us-ascii?Q?TO00wxvZ3zXkI7ayLPqLmRuMoFlHU9o2hBwpBv8d9w6eoporsm20Rf6VDxWR?=
 =?us-ascii?Q?SL9XRioH/UwSdEGQcs21Q8DWZuEUGSjFeW/ukWor3hgOXcJL1FPHXszUIhfC?=
 =?us-ascii?Q?b1Mpmb73VlFzdMUx1NjBZk6gd0Z/Rt6G9eGff2vG5B4kc266LwewM829JPuh?=
 =?us-ascii?Q?+hTm8E/c975I/fKOcbsLuQRGa5DFzteXbm/DCKimR7BrPSoA04cfXbZafy18?=
 =?us-ascii?Q?vwtK9U/R2ikQEJToZzoyLjdfnabmH0ZROpCC/JJ5dopTPlcJLiMZyXdmjv1o?=
 =?us-ascii?Q?rT7CBzztM+n+j7iW7J5NAVTHrLhWIbGX8UYGUqsIT6Qtng2qpxFzVHl9kyPh?=
 =?us-ascii?Q?DOaYvLUHvaELd9e/aAs8+naVTSqRLNoFn3lRakS9C/ImKBLJM7fjfMoUefAF?=
 =?us-ascii?Q?Eg/hBdNtOuEfAN60brQ83b3UWYkkKtiX/6tbsvZe4qPh7YEBGhR73qYXFotO?=
 =?us-ascii?Q?MwOPqr7h1nT8jNnlJij+iX18vuWbagDnfMhdwoegf2EIIUK99UvfrxghjrP4?=
 =?us-ascii?Q?PrGf9xa1ydAhHScD7rLYiR95vAjoDrnTO+mWo0gcs8jibytq3f/+L8A=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vtJ2m8BaukD2jI1Y4zDuC0ehxf8WWahhm3y5sZ82qTJgDfc9mkuVpe4gQoAp?=
 =?us-ascii?Q?u0z3XE52VqrBF8U7epY82XPxienDq4djMqv1aATAdPFYn8/uxbOEcsN7dANR?=
 =?us-ascii?Q?vonbxROp6X1MURVWcXuE1GGbN/W5/U0vWO1HJTLxgfqroKe+jLQsmALhgdlk?=
 =?us-ascii?Q?DclAUtPjFmVLVhhnEqFUx/nu9H+pD1CvzrcOQ7CBBZ/kNuzRubxfBIH2aKLR?=
 =?us-ascii?Q?71ajiDsZp8ynZGFR10O8ywrNIo8Po6eLeEqb4DwDWIRQGjGDraxSdLNLl7NW?=
 =?us-ascii?Q?m8wf11i/fiLBiC+I3mjsrQiv+PdnSU82MouqbgcqPBF5YwCCgDKWBcOIwsG5?=
 =?us-ascii?Q?eGgR+gijnw0KeXvMiZvAKUD8XIIlB6RccVz/ZZEAkIjytSeuIcbIqTyLRAuf?=
 =?us-ascii?Q?+O9MDUedG+HRDtiS2JUkrWjpHpp0cXMvo4BuonxOseoXBvtuCP3sxdfEnMDL?=
 =?us-ascii?Q?XZ3xGwdrihh3tMjNcWNLeSJMzsZum5cUaswqQ/ef4Dmtn6OLQCd/j3B0AjsL?=
 =?us-ascii?Q?uQ2xWHKDgybMYEt1GXhz1txpbGrrRrWWCvu5b3rnOtuHy6jjxb7wWobVMacj?=
 =?us-ascii?Q?fjR5pyrKGbYcybKuLaU2yrf+wnQy3Fm4gzrj5U4EMH7O46vk7AmCAA+nGfo8?=
 =?us-ascii?Q?5roqdlxdJb0elcDaJTrkEEfAlgpscRV05eTKiclFSVikGi9oz/YNkmxgVwuQ?=
 =?us-ascii?Q?DAYopA/YCQRd5cVrKIQT681tAtijmnCbM6qjUT5T5bjiVkzXJWaj4Td5qAh0?=
 =?us-ascii?Q?l30eL4ArQvGDMBXre4a4YBtUSmFTkH09QvmEEYx4HB/J9C4Mry9Ab3k7pJjJ?=
 =?us-ascii?Q?ectWuzoEUFFy05olLVgMq8K6n0BIMGJTsDHvLfbJAz/Vw9mRYIfh0ms4k3/7?=
 =?us-ascii?Q?cBwzqvTKodB2QwuXFh7pDiY7WjlvZUcR/9+6HDADqNMaseNQUzInwkt2wQnu?=
 =?us-ascii?Q?du+IunhbVmwkEC3yh7hoCrjoyDs9RVUTBwkety3naxSPF4EUsuTm42QXMyf1?=
 =?us-ascii?Q?EDIDeSDVoPRMPChAex3I31FpZx2ESSSn8SRRYnW7DXMohvlB575nabo5Xv08?=
 =?us-ascii?Q?g4bx4cxuGdhxUly1fDXiCtlWNqf89RYr3R6DpKVXOPzkCWk4cAx/kQkt24nG?=
 =?us-ascii?Q?yGGYJHHryFPyZAg7mRlLF6Cn1Sts5FQHmD/ZDL/ysH1E+7vFopolgLHJQ0gU?=
 =?us-ascii?Q?c98OY58iRUgtYWvpUNWN0yEZ+aLkPVf928xcFVHvnMyFycDxHHeWLm+BR8rx?=
 =?us-ascii?Q?RM+vut0fqmLOK+0DjZZ+xdmRAdsni0mqht465/G3ZwKDE/dLoYlxWiyeS2i7?=
 =?us-ascii?Q?5L8ruMmCcnJascr9zumXwQf941NdvGPjjqkWogF4ZttzmaU2GhyGL9GZpC1q?=
 =?us-ascii?Q?ep8p8gfmkU9LdC1CBdHwiN3vnhKvxrg43bZK//AaxxwJCuEXyVXv4mRU3KQq?=
 =?us-ascii?Q?6ANg5ag1dNXHx8OB2ifcDMkYAYJcSRaZ?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: c8195feb-6953-4251-1ad6-08df0c8d8f9d
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2026 03:10:25.1464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P251MB0110

mwifiex_ret_uap_sta_list() iterates over sta_count entries
from the firmware response without checking that the response
buffer is large enough to contain them. A firmware response
with a large sta_count can cause out-of-bounds reads beyond
the command response buffer.

Validate that the response size can accommodate the claimed
number of station info entries before iterating.

Fixes: b21783e94e20 ("mwifiex: add sta_list firmware command")
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
---
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 85512f526c5f..7ae1efe46256 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -974,10 +974,16 @@ static int mwifiex_ret_uap_sta_list(struct mwifiex_private *priv,
 	struct host_cmd_ds_sta_list *sta_list =
 		&resp->params.sta_list;
 	struct mwifiex_ie_types_sta_info *sta_info = (void *)&sta_list->tlv;
+	u16 sta_count = le16_to_cpu(sta_list->sta_count);
 	int i;
 	struct mwifiex_sta_node *sta_node;
 
-	for (i = 0; i < (le16_to_cpu(sta_list->sta_count)); i++) {
+	if (le16_to_cpu(resp->size) <
+	    S_DS_GEN + sizeof(*sta_list) +
+	    sta_count * sizeof(*sta_info))
+		return -EINVAL;
+
+	for (i = 0; i < sta_count; i++) {
 		sta_node = mwifiex_get_sta_entry(priv, sta_info->mac);
 		if (unlikely(!sta_node))
 			continue;
-- 
2.43.0

