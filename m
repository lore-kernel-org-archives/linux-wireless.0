Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E6A25B095;
	Tue, 30 Jun 2026 07:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782803741; cv=none; b=G8b1mkuI5e+ZRVcKkNu+jQXhTxnBgWecx7Zg3WTEZC90uLxK3xiV6vEYH8klfXCH9IJleziAofwOGpbmqZkutbvn482vZXyItqdb2g7u9nyc5F5XNPfQc0vr0Wz3e9BU/YKHonGBQTbTuFqHx1iTEq63L5psqrdaMGd7N5AI9HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782803741; c=relaxed/simple;
	bh=GnO9bD3ZgPcNgROz+fl9CvWAy/mK5zHPiQRw9l6c9d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGOH3ADrUctsvSe950KAZ0w+2dRnrE336n+fDzIhqczAR8x4WrrUtJYh64gtSut8CKDgQ69phCyEQffrTT4IGl9g44mhLxk8vV4+dtZ7CKBRYJoZkaPsoRNuLulKkUhb+3uhn4NDJHdsK14ZgGTS6ujSsl27gDu7N4sFdDCn9G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKDSuYv8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKDSuYv8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560DB1F000E9;
	Tue, 30 Jun 2026 07:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782803740;
	bh=T/k1ZrhAw36H5Vuxbx4bV+2suHUP71UeTdDWtXeQdEA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FKDSuYv8LBMXE0Ju2uHUAG/jaiVWAXPk8pD0DsIIhY3WtzVnnUdlumGDmGIMs9yiO
	 ErpJA7PYwfcvJaBAaZmlB/EXjHGZo/SSmuVVtQanZsX82xmmD1A6/lFION2yxIbnQ0
	 pRMcqLXNr8wi+tm3eqP00ZPVsAhOenjTrw7ovz9xzPo6XjFTHvIJW3Eo1ZBjmDjIxG
	 dLa8CJJ14GULWVrvz+7M8WZnRoBg64yQ5fTQJtfuS8JeSqnV0Ykj/TSXo+X2xGDVeG
	 w0pgjz+F+h+4ebkQO2sDnVPRPbtGkSQ27dMKF3Dr9bY4CPK47zqdlDLaR750f2oCDF
	 u8pPSHN/GrzQg==
Date: Tue, 30 Jun 2026 09:15:33 +0200
From: Krzysztof Kozlowski <krzk@kernel.org>
To: George Moussalem <george.moussalem@outlook.com>
Cc: Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulfh@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	Saravana Kannan <saravanak@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, Philipp Zabel <p.zabel@pengutronix.de>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org, 
	linux-remoteproc@vger.kernel.org
Subject: Re: [PATCH v2 1/6] dt-bindings: net: bluetooth: Document Qualcomm
 IPQ5018 Bluetooth controller
Message-ID: <20260630-wondrous-lean-stoat-be0b9a@quoll>
References: <20260629-ipq5018-bluetooth-v2-0-02770f03b6bb@outlook.com>
 <20260629-ipq5018-bluetooth-v2-1-02770f03b6bb@outlook.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260629-ipq5018-bluetooth-v2-1-02770f03b6bb@outlook.com>

On Mon, Jun 29, 2026 at 05:01:44PM +0400, George Moussalem wrote:
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/clock/qcom,gcc-ipq5018.h>
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/reset/qcom,gcc-ipq5018.h>
> +
> +    bluetooth {

Don't send new versions while discussion is still going. I need to
repeat my question - what bus does that sit on?

Device nodes represent real devices. Real devices sit on a bus, usually.
Do you have here a bus?

> +      compatible = "qcom,ipq5018-bt";

Best regards,
Krzysztof

