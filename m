Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335B23D9523
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487163; cv=none; b=nF09RhNACeP/zf05sHo9xCvB0jN9PRyNBlmcXeztr39ic2EYV0kKwtB/on0qNF8k3YMiVgtZyD4P29iq1uC+VLVzR18kCV7LlN+yFrgNf+ue5Sn1k8tG3XvBhE7+dF0QfAc0yq58BBG1PhnAw2ygBb1wME/k1O2XRKv4r2gCLgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487163; c=relaxed/simple;
	bh=9twirzm5nktw8mCQZKCsisWF22u3KfRsBskDwndW4Kk=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nweak+nxBq7AMOG9WooGl8VKgccXsrzzJDliNreHNAoEbvyT2Zc4ybAUQmB/cdnaCyfmB+Lm3E3Ym7l1ByNc3trV23NJQiMgk4PuymWCmRwXctxCelF5wk+dTVHukfja2kWJglFxPi2hro1NzXCr0PHbLm9CvFf2GrWqYOWDXKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjb/dd+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjb/dd+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96181F0155D
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487161;
	bh=9twirzm5nktw8mCQZKCsisWF22u3KfRsBskDwndW4Kk=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=cjb/dd+51J8KLsvFQz1XCBr/Eh1elTDHf+94E8yxXnjPA5Myp3+d9527UZ63cP7DX
	 A/uoKegoL+ZNdNCEWYYyIKjekXBIQn+ciLwfj17ngQElOo0YP1TstGOhIa3UwLRfij
	 9RJ5sDQoLVxRcS5HEXowRGtJAUGRaCfTfuhjwJsOXK0kqIdRBuIAJRXaWOELobG7+p
	 RFrL3UjoS19yoc2drI2021i472x/CxOXQCElYIFZVtqMoP3Fu9NjZ8nKxH1sK1CCXA
	 ST31OZhhFcckXXFUZ5hsL05RIUGw79RMw7GKySri7MEgHiUGOWpmg/P+5Kc+w9jyAU
	 FyHv+39gTplaw==
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39c8dbf4f38so6443931fa.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:39:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrEMEbY5BE5bKG4w1Ot6IU7fM75U/tgWEsBB8t2wBmbli/dBqtO4X77ejtxHq5hog0FL3tZHUWka/5NyvKpTg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyaHV8BYpJId9fJidnS28EyIpTZ4TvmBVZDh9JrXQ1Ms4YrL0PR
	5lHbInqTS8HTBhcDnFRoWdcTQDMQ9Kwh9A4YnG5kZvMh8RdDN2FGZiSCqu5TtT6UsDEtNtNVFMX
	9yCmpwR1qyJqDSajgvs4yz3vKXOcE0xCf/Sx9de5QNw==
X-Received: by 2002:a2e:a806:0:b0:39a:fec6:efd0 with SMTP id
 38308e7fff4ca-39f7e3b70e1mr2581091fa.23.1785487160524; Fri, 31 Jul 2026
 01:39:20 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 31 Jul 2026 01:39:17 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 31 Jul 2026 01:39:17 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260730-block-as-nvmem-v9-1-f72935817dbf@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com> <20260730-block-as-nvmem-v9-1-f72935817dbf@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 01:39:17 -0700
X-Gmail-Original-Message-ID: <CAMRc=MdRd-FgAa+NMf-GZLi05G8PrGjD9LB2h7dQ=9iXiLh9sw@mail.gmail.com>
X-Gm-Features: AUfX_myHE9QF2TZrMuCq1Fl8GoUB-sokgcKRRxyeNwASqhiRSWL8Z59R0TWE-vo
Message-ID: <CAMRc=MdRd-FgAa+NMf-GZLi05G8PrGjD9LB2h7dQ=9iXiLh9sw@mail.gmail.com>
Subject: Re: [PATCH v9 01/10] dt-bindings: mmc: Document fixed-layout NVMEM
 provider support
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-wireless@vger.kernel.org, 
	ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org, 
	netdev@vger.kernel.org, daniel@makrotopia.org, Ulf Hansson <ulfh@kernel.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Berg <johannes@sipsolutions.net>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Balakrishna Godavarthi <quic_bgodavar@quicinc.com>, Rocky Liao <quic_rjliao@quicinc.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Heiner Kallweit <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>, 
	Saravana Kannan <saravanak@kernel.org>, Christian Marangi <ansuelsmth@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Jul 2026 18:00:31 +0200, Loic Poulain
<loic.poulain@oss.qualcomm.com> said:
> Allow an eMMC hardware partition node to describe an NVMEM layout so the
> partition can be exposed as an NVMEM provider. This lets a partition
> (e.g. an eMMC boot partition) store device-specific information such as a
> WiFi MAC address or a Bluetooth BD address and reference it through NVMEM
> cells.
>
> Accept "fixed-layout" as the partition node compatible, in addition to
> "fixed-partitions", so the layout can be described directly on the
> partition node.
>
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
