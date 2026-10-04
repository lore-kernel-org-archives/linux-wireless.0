Received: from mail-yw1-f226.google.com (mail-yw1-f226.google.com [209.85.128.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6414239AD3B
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791133628; cv=none; b=qDWC2eOwtj7pFwGnvrgDRtd2GiCpqPiZn8/SutaV/EfQ53qTls7bE605NSQLHJTdVjdqq/Z6PiJxXsQGhqzpSUTXLDYC1XkISUdlKR1aulKPDijsmFPio0NxkLwZgDHpb+CrIybH3b7dEqDrFzGSJhNdOii5gDfQVgKCh4UH5xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791133628; c=relaxed/simple;
	bh=OaAGxpPZexR6MyHBBVyckzT+rR4fO+d68d30SXtglZ0=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=dfOAa0WX+6cPqLkHjlbv5oclLrfIac9cfJnCcg06W3ADnlTXN/eXP4phKoxCwnnM1706XzEO1UnVEjqgFcRqBDL2wN3oxrFzttUL22annDQJuVEcJuBvsMzu8lsTmEOnInH7h1K+/czO1QFmU6naUaAVBYl2YyOKvpb9oeX6Hn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Nzz4Anwp; arc=none smtp.client-ip=209.85.128.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Nzz4Anwp"
Received: by mail-yw1-f226.google.com with SMTP id 00721157ae682-8aea7b7ca0cso494987b3.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 10:07:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791133626; x=1791738426;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tk+Gtt99hoarKyP0vohBXkdpiLY0JgLAZUcS9Y0MMUo=;
        b=QKgSfohpnXlvnPUDH3vGFEVnGN0deWJ9R+O3HBPFYMVWGi3v2N5U45MGsBrw3ttASy
         QQCdkkUKlkC5oUGSW/BvePMVEKX1Ih3Ghs4SG5PPRWIJ8FJjBMIXsN4XkLOlx6MmLJ9v
         +nhCugywg2tlLAAhbpQB8eod8jRGRrMgXnQu0QTi1IBNQf7ufTOmft8e8ZvsocGhSlLG
         4QlMa2x2VH+0qQHtOqQ2koiPIVsyT1Z9tu7T+PdrNQtZRUi21Pn6U/OjIm5CZD393a1G
         tlJ3skLgHkSOjX5qkxgce7M/qxtRrg32eiKPdN71mtpHwmunR+af1dbLWMok3ex3Bhb/
         TL/w==
X-Gm-Message-State: AFq9FYL1otyKLlTd4Yw3AI5ewZn3TTBrOjpgZixnhsrGHIirtH7Bf8Us
	QU+Pirvyms+a73lqK2zsvfz0kmJ4wf/BS75uSZruWyNqDHkAhLqNHFRitjtCjctBcspE8XDkNfV
	D3GQQzxvgw9dbHE1jGtVolpIVzAEGazX3A8d4slzW1obKHl2i6reQ91h+f4UEaoH8otLnJe5Cwb
	2RAhya8Y+unTeW6BSLgFuDH/NmxdPTH3eygvxAr14JB315R5aOLbrTvXJhrifZN32jMgNJsmNMS
	S1JmjkB4ID4xSueool2+uxHgRyx
X-Gm-Gg: AYBFou3SIEu4NWYkoRodIv/HZTzGxD4F3nEOL7w5LqOFgAi15QXwKaaQ1OkqMbyYGP3
	y/iaiGHqehRr9mWJb/qP5Mje943KvafSBFov2uxxPrby0Sqtgz7DXp0yW7kIdNUp1J5u90fySdQ
	y5kIljQiOu4tod5gxcWbrpRXosBxvjq7O8XL7K5JgXXihWoHJrh7wLWb4ODQ+wnY37hOingTobe
	Fr1yBufsXbAuW5QPm5bqaoOinbGrd3AwURXCBRxzEs5iPx0p3nzE0Y4w78lfrk73F4FFF5mKoXi
	3cdzk7k+l4bHtb64KFazy8TvH692I09QJrr5SPjmyeku5K3Cpn1wCmcUhQta3frHFZJK5ahrbuk
	2VQ6dJA7TbxBMYROcrtvrmgjZRGndaFQ4w4HWKlTZeg6kZMhDTxKPFW9tfn0qOy04lfJlpE+mAP
	3j1QW2DUXXr38W8AxvMNfm6o1HBIlNpQUW7iYH7uXZDQ==
X-Received: by 2002:a05:690e:11c3:b0:677:bbbe:e50b with SMTP id 956f58d0204a3-677bbbee84cmr1733928d50.25.1791133626149;
        Sun, 04 Oct 2026 10:07:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-677c1bee20dsm879053d50.35.2026.10.04.10.07.05
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 10:07:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-91961d4b31bso16452896d6.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791133625; x=1791738425; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tk+Gtt99hoarKyP0vohBXkdpiLY0JgLAZUcS9Y0MMUo=;
        b=Nzz4Anwpr4nyl9lr//JL/U5RPemMFmcdndIZIw5RUyz6c9C2bZFePRXGyndBPWuNaG
         9DuchsKg3xCxjj6EBf6Z5zmzcF8eLEXaNqsdlXn1YnJwiA7E86BHlH5U5KNdt3/lfnBt
         08xtYoUIsjdEVJY2VrlkbCLDSD5aHjs27J9hM=
X-Received: by 2002:a05:6214:2406:b0:917:a646:7fa2 with SMTP id 6a1803df08f44-917c007b625mr176709846d6.21.1791133625110;
        Sun, 04 Oct 2026 10:07:05 -0700 (PDT)
X-Received: by 2002:a05:6214:2406:b0:917:a646:7fa2 with SMTP id 6a1803df08f44-917c007b625mr176709306d6.21.1791133624551;
        Sun, 04 Oct 2026 10:07:04 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-917e0c17b8esm67871456d6.43.2026.10.04.10.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2026 10:07:03 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Nathan Chancellor <nathan@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>
Date: Sun, 04 Oct 2026 19:07:01 +0200
Message-ID: <1a107e21b08.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <1a107d87260.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
References: <20260916064454.GA3635613@ax162>
 <1a107d87260.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
User-Agent: AquaMail/2.7.0 (build: 200700061)
Subject: Re: -Wconstant-conversion in drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

resending...


Op 16 september 2026 08:45:59 schreef Nathan Chancellor <nathan@kernel.org>:

> Hi Arend,
>
> After [1] landed in clang main, I am seeing the following warning
> (turned error with CONFIG_WERROR=y / W=e):
>
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:224:18: error: 
> implicit conversion from 'int' to 's8' (aka 'signed char') changes value 
> from 128 to -128 [-Werror,-Wconstant-conversion]
> 224 |         {0, 0, 0, 0, 0, 128},
> |         ~               ^~~
>
> As far as I can tell, this has been present since the original commit
> that added brcm80211 to the tree
>
> a9533e7ea3c4 ("Staging: Add initial release of brcm80211 - Broadcom 802.11n 
> wireless LAN driver.")
>
> based on my reading of drivers/staging/brcm80211/phy/wlc_phy_n.c. Should
> this final value be changed to -128 or should there be some other fix?

To be honest I don't know. If I looked at the proprietary driver code that 
table entry is still there with exactly the same values. So to be type 
correct while preserving the same value it should be -128. However, looking 
at the table entry struct it is an index so that sounds odd.

Regards,
Arend



