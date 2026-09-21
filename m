Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC97463B7C;
	Mon, 21 Sep 2026 09:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982828; cv=none; b=j54F9nBMCJ0oj14OkwjaIvegoyqZnYtNOs0H51Wqxl5E5P9F34sZFgJlDCDOyTS2rEt8njhmPTAdumYwOIEVtOmaEttQrH2qTimv+hKY0fcO5fOxmQ5K+3pWO6soEm8J6LiapU816t012D0fNKuxo9Rf2hQKWlH+srDXxcgOXQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982828; c=relaxed/simple;
	bh=v6JpBp3AArOdnsctwqjfY3ZCGJR9JA0h+WUyTMdr+WI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Lu/0q62QMKvnEHPFB/dbFp+ZQRij6V1cIBlla0vZ4UeCpLiwY6Rb8rzbmGcEn15AN8m2D6E+MhWn1OrXlX+oj22q9vBk4muI2fk0MmU+zsk00fXvCVxns2AgBk3BHf3gTbo9fZ8XCLeJhh59ilmmSQaluUw/Jeu+Ev0jjmeblvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SCPakuZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SCPakuZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1B31F000FF;
	Mon, 21 Sep 2026 09:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789982826;
	bh=HDN5tiTALp2HjdaynTUWOVRoE4KJy7qUfZYfcVAfO6M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SCPakuZ00OQvwOBru74VDnsKgxqtvVnrpR4I4DTicBqplzKxQ1/JHVYalVOy+fBXi
	 phx16fde0X+tPcXeoa0K3HI7/4FErzYLoUE19z7668esyTacgyXRl2vi0aqLXzrzny
	 xE3I9ulze6NBKfB8UUyrdOi+/sNT/7ZKDg+Yj4RTK2u9fr8JYKuMo1E5yCg0K9LYcX
	 9kFWWkaRbnDDmv8uANkCdutrg7zm6ZK2w1zE5nXsd6D3TjbJUPJmmDupo0zzl94mcR
	 vTNy3USx3CuoctNsxdOYI2NHDisLrB/u7y1ol6g+vlVg4HRks82m8D8b3NVJK4T08o
	 8wktRkjTt4ZAQ==
From: Srinivas Kandagatla <srini@kernel.org>
To: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
 Marcel Holtmann <marcel@holtmann.org>, 
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
 Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, 
 Rocky Liao <quic_rjliao@quicinc.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
 Heiner Kallweit <hkallweit1@gmail.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Saravana Kannan <saravanak@kernel.org>, 
 Christian Marangi <ansuelsmth@gmail.com>, 
 Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-wireless@vger.kernel.org, 
 ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org, 
 netdev@vger.kernel.org, daniel@makrotopia.org, 
 Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
 Christoph Hellwig <hch@lst.de>, 
 Piotr Kwapulinski <piotr.kwapulinski@intel.com>, 
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
References: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v10 00/10] Support for block device NVMEM
 providers
Message-Id: <178998281449.889291.7893229102394463283.b4-ty@kernel.org>
Date: Mon, 21 Sep 2026 10:26:54 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Thu, 06 Aug 2026 16:38:33 +0200, Loic Poulain wrote:
> On embedded devices, it is common for factory provisioning to store
> device-specific information, such as Ethernet or WiFi MAC addresses,
> in a dedicated area of an eMMC partition. This avoids the need for
> and additional EEPROM/OTP and leverages the persistence of eMMC.
> 
> One example is the Arduino UNO-Q, where the WiFi MAC address and the
> Bluetooth Device address are stored in the eMMC Boot1 partition.
> 
> [...]

Applied, thanks!

[04/10] nvmem: layouts: Support fixed-layout as the nvmem device node itself
        commit: 9c6cab93dcd47c3075d896c777567b9d8f813d18

Best regards,
-- 
Srinivas Kandagatla <srini@kernel.org>

