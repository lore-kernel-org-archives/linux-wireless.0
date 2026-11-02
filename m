Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793580546;
	b=fF1ZnfazAa4PAvSfd/olqOWDOXqX5+W+pT4CFg27uEvS6SRma/hNoFieSi3xPCKOV/Y7
	 iXqQgvglzDyT23o6S3en2Z0DYFvXDbgLh9tMRNOepXPVVquCB1PiwgRudIwFNrlodzLvd
	 sKuLNbCCC/rGQ8mi2zWlz60I35BOUPGA9LDwp5vPSfEObLCYbieomIOH+cdOIBtmF22th
	 TPvjEKMKgBAfaF3n3AL3TTW1Zb1Z84WTidSCovzJiZrzq1PWqNFoyf+1I/E4pKeUCbRNI
	 zfRE29E+OHygeh6lfAILMx8KxTI7gTh+AamAji5Sp/RJjag+nMAZpzcKBv3L1172GVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793580546;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=AxLijxCHhlhY2faPDuw/HBU0+yy89FEV9COVq1aaz44=;
	b=FiYtnt1cY4Cupks3Cs4KXVA1JzK5BF5qbILOW3r49HcAWTaElYMJy9ueFwzGqW1fzgGA
	 nLI4jtYpI5hDOxfmbcVS3IZCmjkk4JlYmC0qPAgFpBLTXrMrKptxiiREdBhl1l6SnC/06
	 2o8Q7+hYW4hDXcQsDbt+mN1R/HF/xok4hKVMZ52U8VGC3CiD19DygO5NpKngas/FCkg8v
	 Qk2J1o4fChBJE9XhtUz2dRTNuLwDB/Z3RGceq4CI1mlVd78v5UhztGOnbX1+kCzmDBzZM
	 QxcFYV85Q5QzzESVk79Ue6BcDmlg7HFGb1GPYsKMmMNZKSaH0uoQWM+BXGOKerxNhHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=gompa.dev;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332B7606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 00:49:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 332B7606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gompa.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5365f9a04c5so44142961cf.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 16:49:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793580545; x=1794185345;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AxLijxCHhlhY2faPDuw/HBU0+yy89FEV9COVq1aaz44=;
        b=CfprApx6CDyc4eO8NbMqMch52XlJYBZWROVOtqKjjhBY9ukR+aZyCK526kEzc608a0
         oNUJkmFH75qfEWWWnQ1rj2Rye/G6Mh0zs9YWqdEiHoDchSq0vw7N3Hnlj55byLIMm/gF
         FIPEDbzV5q3J7LSG2VKzYxO1Z9PP3/Rj9hzsvno+h14a4ke/4tfKEZH44bukfjsl6ICd
         cID9pmUAIWgQPWnnOCfZv3ZUoa9H4nrQTC0R7bmqmUMY48lfwEtzLW5hZGlQMe0EySwR
         Tjt+Clm4r/UVpmmQQh4DMXfZfYxuuFGxhR2FcTPuaf2eMb9w8hroRSyznAc4WdWHC1YI
         6opQ==
X-Forwarded-Encrypted: i=1; AKwUvBzvrNSiPCxf8BJRjJ8P0IgDpl/8+AuLFMWyYuZWhdocCtSJljYwCFPGzm69Jc2zAHrGzpRquJDnEF0+9oEyJQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIiUNOascu6vB3Cl2zooyid78Ft5DpP01nno3B7AiO/R2P4YRDF
	7tYDgGJwHTFYZ5LSr7nXY8+Cig0Nw+RE++N4l+CRN8DrwjzB/SbVoODZbcfbjo//
X-Gm-Gg: AYBFou08qsEAUQG2xoeAu+t3vjmfRK1mDEtikTZSBTQ+SswJOAWpF0zXxaadTlis2rT
	TirxfgkAaiMxvwZ3b4aRvbOFdkS6+X8SPVzkeoBzVfWfQlFkmMU/HkDAb6F863es83W3ZHDoLZa
	q9CXzPq01Td2etitOpCVwcWVcwdbeBgTlKI4LQ1Qqcj8fOwnDiU3cSevtd3G+xGo9jMihP7YqVx
	HgIpq6jPy4qDN1p2o6IK26z8SkZFm52DxkotbvdxL7XwW1kGyqm2cQUd/peSQ38I80txJX3bJaZ
	ULkDBlRq6gIgcjigfYhWzs2FtdrvA8j3BgJXFlPpeaUjSDJHlEgQtLjYp7tQnt0TirqgwpTzHvo
	qFAOo8mLEbRjurh+2g9GP3xqjCPG532f6Pc5sFQg+vNtaQd8vhUMKb0mFVKGqkAMqbFqETkp2x7
	e6L7Ur0yuIBFmL/FbESSjeT4jn7KJWFL7xeMol71EGfbkykq4hvfLlUXocRKAA4Z0YTuhRCZzuu
	fnJc7Me3/H60Es1cc+UBfVfSc7C7gXMe5Dm41voP894nDoYbKPNrOeWueSGUtLSxjy1zOrWFbkM
	7+jo6DLmF1M25ZDJnGiBYa27WV4yXCpDkc+OlUICkZo0t4+JWbXi/gpCH39DXlReVgKgzxqkGTm
	JndAizf6cnlPkCJ65dclhtIeRtPbdPvY5xEoEf2dxyQsA27V+nWy7rL4OLfhDG6Xl+krdNQ9lLL
	tteE9qrH6VqbgF1393zaSY
X-Received: by 2002:a05:622a:30c:b0:537:af99:b562 with SMTP id d75a77b69052e-542b742ceabmr130301781cf.47.1793580545051;
        Sun, 01 Nov 2026 16:49:05 -0800 (PST)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com. [209.85.219.46])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54311f7e5fcsm72679321cf.15.2026.11.01.16.49.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Nov 2026 16:49:04 -0800 (PST)
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c7a0c1617so43062646d6.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 16:49:04 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzyLxndxvZLvQ+gaY+tqkVMdc/rSwQu3XhVhbmKOchxovsIN+0WYxCcBMKUo2YuI8pzKyEclSiY4MKC70Vjlw==@vger.kernel.org
X-Received: by 2002:a05:6830:3e03:b0:814:b62d:3122 with SMTP id
 46e09a7af769-85d365b1f81mr6135908a34.22.1793580185285; Sun, 01 Nov 2026
 16:43:05 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
In-Reply-To: <20260925-brcm4388-submit-v1-0-b5cbc2cde2fb@gmail.com>
From: Neal Gompa <neal@gompa.dev>
Date: Sun, 1 Nov 2026 19:42:28 -0500
X-Gmail-Original-Message-ID: <CAEg-Je918POdPr-=6Dzpdkx_i+Hv4wxv5-8A3MUDEqC8SA59NA@mail.gmail.com>
X-Gm-Features: AclHuK_r7QD-EGzh5icdkxVPJ8YDU4Pcq4HDNCl7O8hh8I3jnfCORQFhQybBRTw
Message-ID: <CAEg-Je918POdPr-=6Dzpdkx_i+Hv4wxv5-8A3MUDEqC8SA59NA@mail.gmail.com>
Subject: Re: [PATCH 00/13] wifi: brcmfmac: Add BCM4388 support
To: michael.reeves077@gmail.com
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>, 
	Pieter-Paul Giesberts <pieterpg@broadcom.com>, "Franky Lin (Zhenhui)" <frankyl@broadcom.com>, 
	Mathy Vanhoef <vanhoefm@gmail.com>, Kalle Valo <kvalo@kernel.org>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, linux-wireless@vger.kernel.org, 
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	asahi@lists.linux.dev, Hector Martin <marcan@marcan.st>, 
	Daniel Berlin <dberlin@dberlin.org>, Janne Grunau <j@jannau.net>, linux-kernel@vger.kernel.org, 
	Hante Meuleman <meuleman@broadcom.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 25, 2026 at 9:49=E2=80=AFAM Michael Reeves via B4 Relay
<devnull+michael.reeves077.gmail.com@kernel.org> wrote:
>
> The Broadcom BCM4388 chipset requires new PCIe initialization and
> firmware interfaces. Add support for these interfaces to brcmfmac to
> enable basic station operation.
>
> This series adds:
> - Signed firmware loading and mailbox transport
> - Fixes for chip identification and firmware capability matching
> - Versioned scan and join requests, and extended PMK payloads
> - Updated event mask handling
>
> These changes include work by Hector Martin and Daniel Berlin from Asahi
> Linux, refactored where needed for upstream inclusion.
>
> The series provides basic station support only. 6 GHz support is planned
> for a follow-up patchset after this lands. The driver retains legacy
> interfaces for older firmware.
>
> Tested on an Apple M3 MacBook Air (J613):
> - Device boot and network scanning
> - 5 GHz WPA2-PSK association and DHCP
> - Bidirectional TCP traffic
>
> Testing required separate Apple PCIe and devicetree patches, as well as
> Janne Grunau's port-authorization fix [1].
>
> [1] https://lore.kernel.org/linux-wireless/20260915-brcmfmac-4way-handsha=
ke-offload-authenticated-event-v2-1-fbb9cc7ac177@jannau.net/
>
> ---
> Daniel Berlin (1):
>       wifi: brcmfmac: Support versioned scan parameter layouts
>
> Hector Martin (6):
>       wifi: brcmfmac: Support newer PCIe core startup and interrupts
>       wifi: brcmfmac: Negotiate PCIe mailbox transport with firmware
>       wifi: brcmfmac: Load signed PCIe firmware images
>       wifi: brcmfmac: Accept newer BSS information versions
>       wifi: brcmfmac: Support versioned join requests
>       wifi: brcmfmac: Add BCM4388 support
>
> Michael Reeves (6):
>       wifi: brcmfmac: pcie: Report the detected chip ID to the bus
>       wifi: brcmfmac: Match complete firmware capability names
>       wifi: brcmfmac: Fall back to RSSI-only default join preferences
>       wifi: brcmfmac: Use event_msgs_ext for event masks
>       wifi: brcmfmac: Handle larger firmware band lists
>       wifi: brcmfmac: Handle extended PMK command payloads
>
>  .../wireless/broadcom/brcm80211/brcmfmac/Makefile  |   1 +
>  .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |   9 +
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 368 +++++++-------
>  .../wireless/broadcom/brcm80211/brcmfmac/chip.c    |  36 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  |  27 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  18 +
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 124 ++++-
>  .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   2 +
>  .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    | 130 ++++-
>  .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |   1 +
>  .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 141 +++++-
>  .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  65 ++-
>  .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.h  |   9 +-
>  .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 560 +++++++++++++++=
++----
>  .../broadcom/brcm80211/brcmfmac/scan_param.c       | 416 +++++++++++++++
>  .../broadcom/brcm80211/brcmfmac/scan_param.h       |  13 +
>  .../broadcom/brcm80211/include/brcm_hw_ids.h       |   2 +
>  .../broadcom/brcm80211/include/chipcommon.h        |   5 +
>  19 files changed, 1593 insertions(+), 339 deletions(-)
> ---
> base-commit: 42a9fb3382fc2573e92f41d203b095d9a372cfc9
> change-id: 20260925-brcm4388-submit-5cb8d3e6d6a5
>

Works for me and looks good.

Reviewed-by: Neal Gompa <neal@gompa.dev>


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
