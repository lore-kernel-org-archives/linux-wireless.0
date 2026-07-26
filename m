Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5CE1F0991;
	Sun, 26 Jul 2026 09:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785057675; cv=none; b=Re4PdXJJxSJrBNvEiuOF9GGK7+N3FK3vBTW3eNNd0QjPqWLH+41KK1mt7aPZSCF5kVOPuWN7bGN4i0I+QaOJoUJ7aW7pWkwgHVDlEf5JsLlkU6Wb9EzVfMs04TiI/3kyl7V82tXSkYkm2E16r16hTK533hPS9IAhmKkEd7KDlGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785057675; c=relaxed/simple;
	bh=PJtBNKiZ4wauRJjjYtBlCloepfrvopLttaaYgfsnM5w=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=ACqspXEEawAVRc+2gLn/PSHZNFsr/AAoiqTzMD3x4bBnVZ95v3jiQQsfrF8KU7kt0BMmcbtB29H6N8qCej80ZkNzhe6sr3470aPI6bLnFF02riH/fHyt8ke1iGlSxo6rcJYr7PTtNUFV7z8B5wslr+0tjsLP+i+2SshKu++tfTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr; spf=pass smtp.mailfrom=green-communications.fr; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=green-communications.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=green-communications.fr
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue107
 [213.165.67.119]) with ESMTPSA (Nemesis) id 1MDgtl-1weKme3p1r-000lf1; Sun, 26
 Jul 2026 11:21:04 +0200
Message-ID: <59c03ab1-ec4a-411b-9b7e-8183ecf3e02b@green-communications.fr>
Date: Sun, 26 Jul 2026 11:20:19 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Subject: Re: hang during shutdown in next-20260722+ with MT7925
To: Bert Karwatzki <spasswolf@web.de>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
 linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
 ryder.lee@mediatek.com, lorenzo@kernel.org, legale.legale@gmail.com,
 sean.wang@mediatek.com, shayne.chen@mediatek.com
References: <20260724151419.26014-1-spasswolf@web.de>
Content-Language: en-US
In-Reply-To: <20260724151419.26014-1-spasswolf@web.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:YkaLUQRnQpOLN4saW7gtxN0iECkBhOeIdmrMmQyPakcaBIy8w2l
 dgyAhS7XzWQ5Xb+/xYQB251/45AQp6rmEpiQQYCAxLW+9+589tUc/CHOvFEwE1xYdvEzXvC
 nHg5N+dUDpbaL5Y/JPPEP55BywSGCqNC51Lc60KcnlHzDTJndAksJ2a6s9y0u3UJS9to0/D
 Ms8ywZc9gFQbhXJ0itnxQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cNN+Cfr+jCw=;SwGoFsJmdGgSqerCrBs6lchC6BV
 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
 La6jZzpsaMmpWEDV1N2E=

On 7/24/26 17:14, Bert Karwatzki wrote:
> Since next-20260722 my debian sid system hangs when shutting down or
> rebooting (No error message when monitoring the shutdown process via
> netconsole). I bisected the error to commit
> 13b7e6a96a00 ("wifi: mt76: Disable napi when removing device")
> and reverting this commit in next-20260723 makes shutting down or
> rebooting work normally again.

You can probably reproduce the problem with more logs by just unloading
the mt7925 module. I'm on vacation on a half-broken laptop, but try this
patch:

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 4e734f4f65d1..f606c0a8ad29 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -50,8 +50,6 @@ static void mt7925e_unregister_device(struct
mt792x_dev *dev)
     cancel_work_sync(&dev->reset_work);
     cancel_work_sync(&dev->init_work);
     mt76_unregister_device(&dev->mt76);
-    mt76_for_each_q_rx(&dev->mt76, i)
-        napi_disable(&dev->mt76.napi[i]);
     cancel_delayed_work_sync(&pm->ps_work);
     cancel_delayed_work_sync(&dev->mlo_pm_work);
     cancel_work_sync(&pm->wake_work);

