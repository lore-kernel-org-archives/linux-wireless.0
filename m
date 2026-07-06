Received: from sendmail.purelymail.com (sendmail.purelymail.com [34.202.193.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA33383984
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.202.193.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783350426; cv=none; b=F5wWKy5sE+/w/mAx6MxPelchLv2j/LjEz+HZPpOlEOx5nhomwSIUzKxxmOiSZelxcmuWQnZbYwHZoK7fnlQngGdOf05gM82HTzCffwoxmgJhWWUlYyuep1YVynGvL4ENK65MQXC7yhNCgfMvnaagHr6SxSRrx4yyC/LhRZJZEhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783350426; c=relaxed/simple;
	bh=ObC9OwRxOMV1pm3KyljcyooxBRThvnIdSuo4lp1vHn0=;
	h=Content-Type:Date:Message-Id:To:Subject:Cc:From:Mime-Version:
	 References:In-Reply-To; b=XurknH5cV7/NBZBsXmmR6j/aFw+H9FWWFUfRlFNVHyoYL8a9z0IUa4AtjTi4/dR+nsBkuiUH59oGT2NfT6Xy34CMzCpREqI+1npfhvs/MJlAPIs3/FMj48KbZSli9oGHA67QpkphlkgOR+OSxhZWyCR2wH+p9NwVy4Zy9Hi9bE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rcpassos.me; spf=pass smtp.mailfrom=rcpassos.me; dkim=pass (2048-bit key) header.d=rcpassos.me header.i=@rcpassos.me header.b=Vf6itBlK; dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b=MSCw5BQP; arc=none smtp.client-ip=34.202.193.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rcpassos.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rcpassos.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rcpassos.me header.i=@rcpassos.me header.b="Vf6itBlK";
	dkim=pass (2048-bit key) header.d=purelymail.com header.i=@purelymail.com header.b="MSCw5BQP"
DKIM-Signature: a=rsa-sha256; b=Vf6itBlKxB6l6Us3jkVkauWXmLtgJRnbJ9tDT+Vv/54zNAdQpf54yjhOjlmp7/paoN1Jc79WG/tYAI0X5pB1GCDSRdAZPxqmYTGProrS8PnVxu2hklsA2BFtOztuwDO15ZL4InO+EbmHOIspfYF/3AS6gcbVhrNjbkV0JCBPvzvNM+5+nZLnAjuJHhbe/eEA0nh2EJNQqpIKxOBbdPTm1bMgz0o42XcDHTmZO+nF17ehb9hVyKK4xiJFe9jm5+ybHUyrdGsINA17RKcWdujWsSR4NMxUUEHNJfRyHFhK13A90OvSH9A10Bawqgyq8uWH9NtPfNKE2IiLDcQ7UeDJkA==; s=purelymail3; d=rcpassos.me; v=1; bh=ObC9OwRxOMV1pm3KyljcyooxBRThvnIdSuo4lp1vHn0=; h=Received:Date:To:Subject:From;
DKIM-Signature: a=rsa-sha256; b=MSCw5BQPA6Mk6wZnqLFNiT1f4+lYBoM8eot/AnknIv+g9XQ/s5OnQCMYiO5u1vAZzR4rHT+S4DYgVbDrjQLYKTSt3CktupbZ/LV0R7qFPnEGMlY/OiaqrxJCZ4P11RrQQIS0H0Ts1TiC+70/iMCGKCU5qwwyc7G/JmyS4eA12HnlQoe7qJzGU5OYqTzyUxnp9A6TF/MaMgFhAtLBi40kvJSzC+mKVOJGX4Har96I1azlbgY2FhU1eCcJJYbnMi4ASgBOPTrZJx+a4z3g27/v8mJ5kcVum8yOzOQGfjiCyZV/hor41nVbXOpxU2Ui7usVKw37ZhyWHKx72XTOr48jRA==; s=purelymail3; d=purelymail.com; v=1; bh=ObC9OwRxOMV1pm3KyljcyooxBRThvnIdSuo4lp1vHn0=; h=Feedback-ID:Received:Date:To:Subject:From;
Feedback-ID: 45355:7809:null:purelymail
X-Pm-Original-To: linux-wireless@vger.kernel.org
Received: by smtp.purelymail.com (Purelymail SMTP) with ESMTPSA id -1093595095;
          (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
          Mon, 06 Jul 2026 15:06:57 +0000 (UTC)
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Jul 2026 12:06:54 -0300
Message-Id: <DJRKYMIBYSWD.778JD1HG7W7S@rcpassos.me>
To: "JB Tsai" <jb.tsai@mediatek.com>, <nbd@nbd.name>, <lorenzo@kernel.org>
Subject: Re: [PATCH] wifi: mt76: mt7925: Fix unregister deadlock
Cc: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
 <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
 <Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
 <litien.chang@mediatek.com>, "Fei Shao" <fshao@google.com>
From: "Rafael Passos" <rafael@rcpassos.me>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: aerc 0.21.0
References: <20260630090610.586954-1-jb.tsai@mediatek.com>
In-Reply-To: <20260630090610.586954-1-jb.tsai@mediatek.com>

I was having issues with the MT7925 on the ASRock B850M with Bluetooth.
I tested this and other patches in my investigation.
My issue was a platform bug causing a failure in USB enumeration
before the driver path (unrelated to the patch).

I can confirm this patch does not introduce regressions on this platform.
I tested system power cycling and suspension, BT/Wifi adapter enable/disabl=
e,
and also modprobing in/out mt7925{e/u}
Patch applied on top of mailine (7.2 rc1).

Tested-by: Rafael Passos <rafael@rcpassos.me>

Thanks,
Rafael Passos
