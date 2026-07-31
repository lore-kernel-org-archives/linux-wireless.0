Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCCD3D7D67
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487253; cv=none; b=PFO8XZs1e8ag2LO4UM/k6MdOoW8jbCAurOy1DS4ZmKLFXKHoHZ0DYcxSxhSYv5WEWKteak2hcVuzHW5HHPML3K4KLCXlTvJOK6qB+S9+dB2BKfSPdoJUj/g7iSUKjqjfsMEQq5QbWdJxsNfd9v4qep+DrqHdJe1GWVsW9szJVJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487253; c=relaxed/simple;
	bh=xQJfCIYx7YtBoHGSdPxLID9UpP7U21GdSDr2MFYu7TQ=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rmyvTRA4M3R8NVwGVx/mzuCeyXHfhNUdc+VMvfUpONx/77ovcAdaS/AoeL2CXu4xvwJojX+ksUIyvIajIHaOXsOvKPY6ratPPj3+G3SFwXF10msEljl3k8e3F7qorKoBQ3JStIa8kc9qq2brxCRqDvca7RviDlMYjnWekSHSsZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aU7b6+lG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aU7b6+lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC811F00A3E
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785487251;
	bh=xQJfCIYx7YtBoHGSdPxLID9UpP7U21GdSDr2MFYu7TQ=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=aU7b6+lGFkvei3Qenni7Ts3ynzCIDnFCIEEq2DDi9fPD5q7FO86BbwGtuzu3sk+eI
	 fcApUNn7PlABHixqudHKWCU9e05d+voFJKxFZwMuU/KGnXQtQJMiQHkMZyGekWf6qB
	 6OJOEoLCTxZRR4lWfM+kAw4WmC50cAEGH0XlcIIxr0m9nSodeIjaHh8UbvsQ2w89t4
	 gvkurEsAFZuvDllBjDhfmkuH7ibapIBD8I9+h7cBLjxtrrIiVCIwYrVk6KLrqDDEQO
	 2rryHmYhquV5/ydU4cOEjxQz57WxQFYFkfbZhIp9tZRf2JxqSvEesNE7HW+RvuzNwx
	 3xzWVqM/YBguA==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-39f75e1e9d9so5250151fa.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 01:40:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpncmKQWGyixDHtjEJl4oNHEEmB2G2NC5qN8iPz3vIhcqIn7cAIZS482MbLAJAnrtV0nuNmLxcQ+mLCQObWWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YweOG5ceRGXURLhLZ59YWLymeD/Mh1LMLUn95bYGEKY8ghOGOc3
	/IIBJWEAlqTQmvmDPBeCtluCGM4QDZ1dtZEWbk0sSn7OLDRTbxTruvM3+7A4UulRwMI0z0vqCII
	pcTdu/m1g3G+AAJHF/Z8pqPzfwG83RUIrIwF6k669fQ==
X-Received: by 2002:a05:651c:a20d:20b0:39c:650c:454e with SMTP id
 38308e7fff4ca-39f7e352fbcmr1943041fa.13.1785487250229; Fri, 31 Jul 2026
 01:40:50 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 31 Jul 2026 01:40:48 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 31 Jul 2026 01:40:48 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260730-block-as-nvmem-v9-5-f72935817dbf@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com> <20260730-block-as-nvmem-v9-5-f72935817dbf@oss.qualcomm.com>
Date: Fri, 31 Jul 2026 01:40:48 -0700
X-Gmail-Original-Message-ID: <CAMRc=MdXFDFw_oHSGk5=RgLJAfTixuUNYTY62Dpcdb4nqcg7ig@mail.gmail.com>
X-Gm-Features: AUfX_my0BSuN_dmw9PAQ3RKVVzPb03vWf8SlnwYWcd8wsPsuOu4arihpRTxh5pc
Message-ID: <CAMRc=MdXFDFw_oHSGk5=RgLJAfTixuUNYTY62Dpcdb4nqcg7ig@mail.gmail.com>
Subject: Re: [PATCH v9 05/10] block: partitions: of: Attach partition fwnode
 to the block device
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

On Thu, 30 Jul 2026 18:00:35 +0200, Loic Poulain
<loic.poulain@oss.qualcomm.com> said:
> The OF partition parser reads offset, size and label from each
> "fixed-partitions" child node but does not associate that node with the
> resulting partition block device. As a result a partition has no
> of_node, unlike the whole-disk device which gets its firmware node via
> add_disk_fwnode().
>
> Carry the partition's device tree node through the parser and attach it
> to the partition's block device with device_set_node(), mirroring the
> whole-disk case. This lets consumers describe per-partition properties
> in the device tree (for example an NVMEM layout on a partition node) and
> look them up through the partition device.
>
> No functional change for existing users, partitions without a matching
> device tree node simply get a NULL fwnode.
>
> Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
> ---

Makes sense.

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
