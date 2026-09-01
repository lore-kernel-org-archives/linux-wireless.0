Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8031847989E
	for <linux-wireless@vger.kernel.org>; Tue,  1 Sep 2026 10:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788257947; cv=none; b=c8DyRPu3LD04tJ7aJNnnKD8ZZVttfWUPy/cxrpw/R0SbzedBai6TTNoi6YIxnhcSeLpro5ET/JTxIvMCg6T/VVJbVQ1kp6Zpr7XUSG6klZtMx+jx9g3k5cP6d+0/yo9XTC1GyfTzdXubJBHy8CkYvZ5fvC+8+UC7RhWJANatGzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788257947; c=relaxed/simple;
	bh=EIrNvUHDstHHjeFO3U3xOZlTlAPgkrzoxREHv2U3uN0=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=OeiZOpqb5tflTk1kVwaF0RPG9F32gImUbZbsZNRujcr+HDb75hs49m3/vUAcEmHohwH6PqJVk7EsFyMSCkbHTaUAvsLEvAk7y2+RXlzykcJOY9iD4M1vznVoxBNuZPzYQvYx7ROVGgvENCQln9S9kLec8VoZKOSFzrbwVPfBRa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=frvFdlTO; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="frvFdlTO"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2569aa5116so138822066b.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2026 03:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1788257943; x=1788862743; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/R2B4UIn9uyXdoZMfmtsPZpaGxOVNwVD5ZuxHGzJeSs=;
        b=frvFdlTOqgkCeW2YCZUfPilvQBCXd3N7umri5bdQa722FT9DT5tia80QY2a26O2crW
         Hdn4WstmCXvtJXAKql6MNWiUf+eRBL1c6tC0PrvTGHa3LgrM/dneD22FvH4G6VCQdTep
         ZgJTksz5hkMwn9KqttobQtKCsS7lVGvpduqid1wIiWTeqcvIpKEdEXtyDEo+xjfD68/Q
         bQAofkA+GQPvSE6Eb7Jhi+GB+NNEe7BUPXOCrR4ByvoHeNeVi775Z+jX9N13SxTjwoIo
         GTby0LiVgwKkIHvBgvrEHeSP34V/krX/plCXpkjgSjTlykVRtOmybrXoALO8y0NLIikr
         Ecbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788257943; x=1788862743;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/R2B4UIn9uyXdoZMfmtsPZpaGxOVNwVD5ZuxHGzJeSs=;
        b=BRla+VnHWMytgIeY419DnwwPrN0YEZ4gY3OirEpphVmhPfSSkGuvIV2ohMLlXdyPT7
         WFaJ5jKR7VYyfENvICbmsOd01i65vJL6mr9jzfKWgmZ7PQM5eJ/aQgNN753Czg4/3vwh
         yJa9aEXDpbJJ9GWB6+QImtwZkuKX2igwnqGcQPanLEbHAQwFPaO/ER/2N5vdMpg5cNTo
         B+HLqtemjbOS8OAEMqx9JZQeV45zSBEP0MdMIF9J06u+cS/pBn21Lw6flTfDCQ07HmXb
         YHa4pc1ByFDcz1tlbYEpHtK+kRU6bdw0pMW8+vFhkI20AoedvAk7stgSC1ITmOu6FEFj
         JFzw==
X-Forwarded-Encrypted: i=1; AHgh+RpkXkETF3rjTLnIJ8uooR1BKXcZY615Fn/e8MTN1oEU9wgNd3kzQ1F9JdxkB4d5GpuLrWUegcy1iyNpB4vDiQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lygsojZlxJ5Yok5W6muMgp+ox/TMmiGmUPBHw2Hb8c9K/s7Ify
	+4h6yrpa5g7PBcXnRYZft7QCOhaCqvQW6O4PzLoFEqCNKyeuLQFPZjeysLea4fc8fFQ=
X-Gm-Gg: AR+sD13kmPkFkdWb2tWgDVVRPA6IfSAlR5DeYZ4K6ErYJeJ9S/CaKJml0bEJR8eGHWN
	Ve5gFQ39kRQhSE0G6W3S4E1C4XpeLcGIZYHeKnnULUkioWPoa0K5K7YHDhuGHYnRWTV6/E3icKB
	32spwWcwq7Gp2ispS0rm+RPEUQBKF+zBMrm3N6S5xBD6AxaYV+ZIMM4iT1baYaL/NtQsHhQTJeR
	nUOuOdpsRLTSnt8O9cJJ68yZ5d8kVHrW6COjty8WDLvleY/cg8l0iLZKPbK8hReX8Lx8nk2+jTC
	2vrwqzNIdX4CmvOE2eYcNPY+reA5UsFb264EZdeIr1BaX6F1KhlL27K4JzJpDYD5tIStjZ5mrQV
	A8hbiShuhC5ayiviRZGcrdvdFwovouXDGa9XK6ZqmaJSzdP08YmI8YeNM+1QxECkwnbJJefZwhY
	lmL+/6FWOiGP9MFCVjnNCbycTwpMTGeLr2kTdhIdgou8S7xkJ51zw/7Mavnk4ux+ub4sr73UVxP
	x2Ny3pUUOKl0OCmpgQD0nMjF/DHw+skIw==
X-Received: by 2002:a17:907:3cc4:b0:c16:6dac:a008 with SMTP id a640c23a62f3a-c25b919fe0emr274723666b.8.1788257942589;
        Tue, 01 Sep 2026 03:19:02 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c255ee0b388sm549393466b.5.2026.09.01.03.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 03:19:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 01 Sep 2026 12:19:01 +0200
Message-Id: <DL3WJ9AX6P5Y.QS2RPHUIJWVL@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
 <linux-wireless@vger.kernel.org>, <ath11k@lists.infradead.org>, "Dmitry
 Baryshkov" <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: (subset) [PATCH v2 0/7] Enable Bluetooth and WiFi on Fairphone
 (Gen. 6)
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Bjorn Andersson" <andersson@kernel.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Alexander Koskovich" <AKoskovich@pm.me>, "Liam Girdwood"
 <lgirdwood@gmail.com>, "Mark Brown" <broonie@kernel.org>, "Bartosz
 Golaszewski" <brgl@kernel.org>, "Marcel Holtmann" <marcel@holtmann.org>,
 "Luiz Augusto von Dentz" <luiz.dentz@gmail.com>, "Balakrishna Godavarthi"
 <quic_bgodavar@quicinc.com>, "Rocky Liao" <quic_rjliao@quicinc.com>,
 "Johannes Berg" <johannes@sipsolutions.net>, "Jeff Johnson"
 <jjohnson@kernel.org>, "Luca Weiss" <luca.weiss@fairphone.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260403-milos-fp6-bt-wifi-v2-0-393322b27c5f@fairphone.com>
 <178820768635.1699313.4119708799289566517.b4-ty@kernel.org>
In-Reply-To: <178820768635.1699313.4119708799289566517.b4-ty@kernel.org>

Hi Bjorn,

On Mon Aug 31, 2026 at 10:21 PM CEST, Bjorn Andersson wrote:
>
> On Fri, 03 Apr 2026 15:52:46 +0200, Luca Weiss wrote:
>> Add the required bits to enable Bluetooth and WiFi on the Milos
>> SoC-based Fairphone (Gen. 6) smartphone.
>>=20
>>=20
>
> Applied, thanks!
>
> [3/7] dt-bindings: net: wireless: ath11k: Document WCN6755 WiFi
>       commit: e506d34e57236c41cebacc43e50f35f5b52dc675

Mostly checking in, are you planning to pick up the rest of the patches
from this series as well? PATCH 1/7 (PMU dt-bindings) have been picked
up already, and the bluetooth dt-bindings patch has an Acked-by since
June sou you can also pick that up as far as I understand it. Then only
dts is remaining which still appears to apply fine on latest -next.

Shall I resend, or can you pick them up from this v2?

Regards
Luca

>
> Best regards,

