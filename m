Received: from hqu.edu.cn (hqu.edu.cn [210.34.240.11])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55815233D9E;
	Wed,  2 Sep 2026 03:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.34.240.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788318629; cv=none; b=u/YyC8Mxp7HENWBXc4dlsL9SNSeLnVp4rHKSQheJNa7jr9DlCJRm0qrtSfgLMfcKieiLQO2u2XR5hfgOyo/OVXNcc3eAfz2EcQMiYJRkemAC6HmL1pbUfOUNTD5ScMCbVerkKjFBTNK58QiPbO+D0JGEShmpHe5qleK60/Tc2JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788318629; c=relaxed/simple;
	bh=AB77XsQdsriKbwCAlK5XzXaIDIRNYIzlq679uph3np8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SBioKLyO2WE43ffFv070OGuw8ek0fzd3Wh2RLIRHtSuluDHjPXHZMofRJT33mw5F7cHX8+KQ2KXmV7ZmHeO6bZS/UQzMghvg+UdUxh0lSTsm6hrqMkg403D/2AqQ9o4GP8bjlFCrwXzuKZ8W5fHuiIkUZHt/ijhsS1YIWyw2CDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn; spf=pass smtp.mailfrom=stu.hqu.edu.cn; arc=none smtp.client-ip=210.34.240.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stu.hqu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stu.hqu.edu.cn
Received: from SEZPR04MB6172.apcprd04.prod.outlook.com (unknown [40.99.47.53])
	by cmweb (Coremail) with SMTP id C_Ai0gAnitmRk5dqHCgFAA--.10386S2;
	Wed, 02 Sep 2026 11:10:10 +0800 (CST)
From: "raspberrykan@stu.hqu.edu.cn" <raspberrykan@stu.hqu.edu.cn>
To: Ping-Ke Shih <pkshih@realtek.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject:
	=?big5?B?pl7OYDogW1BBVENIXSB3aWZpOiBydHc4ODogdXNlIGZpcm13YXJlIE1BQyBhZGRy?=
 =?big5?Q?ess_as_fallback?=
Thread-Topic: [PATCH] wifi: rtw88: use firmware MAC address as fallback
Thread-Index: AW5iLTMx9HndzhlEbyPaDR0qVnq+lN2wmJOAgAAM2kuAAAcfAIAAB6+t
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Wed, 2 Sep 2026 03:10:06 +0000
Message-ID:
	<SEZPR04MB61722B45AA7F211BF8E6BEA3FFB72@SEZPR04MB6172.apcprd04.prod.outlook.com>
References: <20260901124551.3921506-1-raspberrykan@stu.hqu.edu.cn>
 <4d1e5555bad84badba213f11b431c762@realtek.com>
 <SEZPR04MB617269B16E24E662180A7678FFB72@SEZPR04MB6172.apcprd04.prod.outlook.com>
 <57178758e2d9499c9582d4bcf821f2fe@realtek.com>
In-Reply-To: <57178758e2d9499c9582d4bcf821f2fe@realtek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-Exchange-Organization-SCL: -1
X-MS-TNEF-Correlator:
X-MS-Exchange-Organization-RecordReviewCfmType: 0
msip_labels:
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:C_Ai0gAnitmRk5dqHCgFAA--.10386S2
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYG7k0a2IF6FyUM7kC6x804xWl14x267AK
	xVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGw
	A2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j
	6r1xM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r1j6r4UM28EF7xvwVC2z280aVAFwI0_Gr
	0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r4UJwAS0I0E0xvYzxvE52x082IY62kv
	0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z2
	80aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4xvF2IEb7IF
	0Fy264kE64k0F24lFcxC0VAYjxAxZF0Ex2IqxwCY02Avz4vEIxC_Gr4l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UMVCEFcxC0VAYjxAxZFUvcSsGvfC2KfnxnUUI43ZEXa7IUn9Z2DUUUUU=
	=
X-CM-SenderInfo: ysvskiyqsqlko6vw3hxktxhvlgxou0/1tbiAQAQBGqVmGMDTgAIsU

PiBQbGVhc2Ugc2hhcmUgaXQgaW4gY29tbWl0IG1lc3NhZ2UuCgpTdXJlLiBJIHdpbGwgaW5jbHVk
ZSB0aGUgaGFyZHdhcmUgaW5mb3JtYXRpb24gaW4gdGhlIGNvbW1pdCBtZXNzYWdlCmluIHYzLCBz
aW5jZSBJIGhhZCBub3Qgc2VlbiB0aGlzIGVtYWlsIHdoZW4gcHJlcGFyaW5nIHYyLgoKPiBJIHNl
ZSB0aGUgdG9wIGNvbW1pdCBvZiBbMV0uIFRoZSBtYWNfcmV0IGlzIGFsc28gbWlzc2VkLiBIb3cg
Y2FuIHlvdQo+IHRlc3QgaXQ/CgpJIHRlc3RlZCBhbiBlYXJsaWVyIHZlcnNpb24gb24gYW5vdGhl
ciBrZXJuZWwgdHJlZSB3aGVyZSBgbWFjX3JldGAgd2FzCnVzZWQgdG8gaW5zcGVjdCB0aGUgZXJy
b3IgcmV0dXJuZWQgd2hlbiByZXRyaWV2aW5nIHRoZSBNQUMgYWRkcmVzcwpmYWlsZWQuIFdoZW4g
bW92aW5nIHRoZSBjaGFuZ2UgdG8gdGhpcyB0cmVlLCBJIG1pc3NlZCB0aGUgZGVjbGFyYXRpb24u
CgpJIGhhdmUgcmVtb3ZlZCB0aGUgdW5uZWNlc3NhcnkgdmFyaWFibGUgbm93IGFuZCB2ZXJpZmll
ZCB0aGF0CmBydHc4OC9tYWluLmNgIGlzIGFjdHVhbGx5IGNvbXBpbGVkLgoKU29ycnkgZm9yIHRo
ZSBvdmVyc2lnaHQuCgpCZXN0IHJlZ2FyZHMsCll1Q2hpYSBLYW4=

