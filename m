Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5BB443E38;
	Tue, 15 Sep 2026 07:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789456301; cv=none; b=KLvhzKd6m33VRglK4pkyZFk7B1ZZOvGOxeW8nvJAKepGnQw2keTHC46pXiH7n8qZQEsSCmgTEua1nLnXkRsP6Qcbfni9pIkdrCqtAEBvmXFqWLmJXGCvey1+zOKqYSGjuiuirRujr9dn5W4tnycDktLIwvOoJgJpNONvCIWUsdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789456301; c=relaxed/simple;
	bh=2ehmnUofZbTdLc1u5yR/J6v+urGofaLLn0RAmXhFd9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDE3/rPjrkYqLOdZ2OJDwu3g8o5GwWwvxw2egoUjc1L8ce2UpQZMkVdyng6o9Xn2V9QPIo4cNqtZRUhKE7CyKoqAkIWwGfhXmagea7AbXaoxLk1SB2FsRWRSENkxMe7X0lp9QAlF5ghNpnrmwr7uzvZfgONZNXllh372jmmk054=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marmottus.net; spf=pass smtp.mailfrom=marmottus.net; dkim=pass (2048-bit key) header.d=marmottus.net header.i=@marmottus.net header.b=Ice7pvFc; arc=none smtp.client-ip=217.70.183.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marmottus.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marmottus.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marmottus.net header.i=@marmottus.net header.b="Ice7pvFc"
Received: by mail.gandi.net (Postfix) with ESMTPSA id 3C2A71F47F;
	Tue, 15 Sep 2026 07:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marmottus.net;
	s=gm1; t=1789456296; h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=/k+y3LoBfQZyu4Fn8UExwUdQIbMcggqcKxO9y+XqHO0=;
	b=Ice7pvFcBVgU+jIYOKrOoCHCoGn8cZe1IovgDa3pZN6T0Tg2l4ujy8yUg3wJp3bDNH97Ms
	orM8nKgxTmqnnmHTYTECrvTp78lX2KbS4pjy4zmUdniUkCf/D9VWuW6WFhoGoQYlGr47pT
	VCTcH94RwppT5Puvepm8gtOD8T4YfCQ5Fkn5BQuniv+NLGtancWXAOILM08rYJDK4icBqy
	/Z1ZeGt+OmRiDD1WS3Xx6lzOfbJtEplccp48s88bTu5V6t3hcx72jl+jTdb43HQXBBlJ2G
	q7rE2ENfs0pUXI8q9tevsgqtpTDRCJtxL8v0lo50RClXcgKvdAtAwnqvUBiRjA==
Date: Tue, 15 Sep 2026 09:11:31 +0200
From: Arthur Crepin Leblond <arthur@marmottus.net>
To: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Cc: Manivannan Sadhasivam <mani@kernel.org>, linux-arm-msm@vger.kernel.org,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>, Denis Kenzior <denkenz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Andy Gross <agross@kernel.org>, linux-kernel@vger.kernel.org,
	mhi@lists.linux.dev, linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org, ath12k@lists.infradead.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v7 12/15] net: qrtr: mhi: Report endpoint id in sysfs
Message-ID: <20260915071131.GA30612@marmottus.net>
Reply-To: arthur@marmottus.net
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915054207.2513877-13-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260915054207.2513877-13-juha-matti.tilli@iki.fi>
X-GND-Sasl: arthur@marmottus.net
X-GND-Score: -100
X-GND-Cause: dmFkZTGFzgp8DpaceHJXsLAY9igazZeLQ/Fb6nk/Zr+ipgXP7EdxuXSxa9lVDbKYEYekx2BahP04hh/UrfivTn9rNoAad/Ihbj1N8SKUiFDGm4QJMUcWFIP1SD5NWpovXOlLm3nzzJ+obYoPfs1i9jCQCcL/YPO7L6JxSZ4RjmvNJIDylGwDBDMWyfMqT6ULwSpNIY5g4ZxkdNQC4ndb70firUg16CnCPEFui1j9O1Rxt4fvlhU9XsUsW9gIIEqgGlikLVBc/V6kTPao3l+ipIJ+Abn+I5aGYA33UnXdhq2uBu9KiYninSq5SUbgvE97pS0cJaovjY7CKRYzbvX1MZDbi9NHfC3qQxjGZHlKJRaFi20WDHCYpFFYSzwQEtAkZEkF2NLmpv3OOpj3vEa4hJLgCC1g249wkPnivMuZXKCBaoLzUGUsZ9jRwAtdyaE+Gi9Wo5j2Iog+76+ejo4Q7A+TKckc5iTxz9VEuKMrVPV6Sf8xBjuq/Dwz4dVAU8gpx8RhKxxmyYVYI4yC4XYJnmFNqhjm4P2FTG50un8qTWskfdnAeX/VFhYiDPp6chbdqGiqQ7qsvggyEg0aIviPpu3J7pTId1vNiRB9fv8jrWg7fjqMLhub0jBHpSDha0ZtUIlUjQbGJ0oVKHxrnfD3sCR8Ae6jxh3B6AVgUXj5DJXESVePvg
X-GND-State: clean

On Tue, Sep 15, 2026 at 08:42:04AM +0300, Juha-Matti Tilli wrote:
>+static ssize_t endpoint_show(struct device *dev,
>+			     struct device_attribute *attr, char *buf)
>+{
>+	struct qrtr_mhi_dev *qdev = dev_get_drvdata(dev);
>+
>+	return sprintf(buf, "%u\n", qdev->ep.id);
>+}
>+
>+static DEVICE_ATTR_RO(endpoint);

I think you could use sysfs_emit instead of sprintf.

https://docs.kernel.org/filesystems/sysfs.html#reading-writing-attribute-data

Arthur
