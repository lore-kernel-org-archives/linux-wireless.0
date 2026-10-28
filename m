Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211131;
	b=RPa4N9IpgevYmFi/VGmZKH4RzoDHh1gmx9vYsbZfdNjMY2xH9eP5uMu94b1YZp0rD3ny
	 ZClw9tUQjDgdpOfe8XeD0c8Gr1ua96K7I3256Hv8lfdtwuw7TvXwPVU6eWp9+lrlM+MKi
	 ldBvsNqAknSEFPCiMgX8X0SyfslybHVUJgjKJTQtvwhtV8vsAnRnIFlsEWIV91Ni9R2D/
	 uhuzTbDEfkLnp87PJC+tWhipqXrhvttQBBftqz486Q3GJHl2hJ+fpmFyO3BAMW44vrVWj
	 fNbKeRGaqLT/NdP+O6ICN5RM0N+SNlCkbI5MdhRRWDkN+0sAygj+gtaSklMtsL+Figw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Transfer-Encoding:Content-Type:Date:Message-Id:
	 Cc:Subject:From:To:X-Mailer:References:In-Reply-To;
	bh=zVJqOS1cNxeL6RKZm/wJV+026QQ3gHNzQvPgsK80tiQ=;
	b=knvnNRXCkrOLGxPYiKfepdEkekQSqMIb1HX3Wq3bSe7lPvPRLZZ7E6ronWyFVEgygLxf
	 HFdu2+DZlHEDF3nTRMQ137EZOq/hJQPiHuEYs5cAhYFc3t0bEL0nNInF+sP3K6EFwod+s
	 8r8vIvA+FvULGjHvxINUQqXHbUuGrTujQZwXcBvZvN3bVlctDh1uPz57dY54IcBPg2Az7
	 bkv9nlcAoZVh2WpQ9XhVcq6YOmPPrUZQtcL/a1heUrIWdbybQ4mqdfz6xdsRfUazUajBc
	 BPndzx5X3a8tsodmvthKR80SqcQPmZl7lqKxinNzKF/a8gmQJ/ItnycLESbDocsdL3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ygDzb6jz;
	arc=none smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB965606A958
	for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 18:12:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AB965606A958
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ygDzb6jz
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3adc4590de4so1121348a91.2
        for <linux-wireless@vger.kernel.org>; Wed, 28 Oct 2026 11:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793211130; x=1793815930; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zVJqOS1cNxeL6RKZm/wJV+026QQ3gHNzQvPgsK80tiQ=;
        b=ygDzb6jzFuhd7iVohnMdLqk4eRjbJKcUGuOLpRSQC1LbZeyC5fW7VrWUkvIn1hHIJ6
         1q/nkWh7paF6hKKzIhAzMAuRNs94oyOX1QXxy7o/ZpumLipN1U6iZX8XcZv9r+fBSuWt
         hJkGUJ4PE2YI12GiWATGUdbnGWvxa+t31dWM0+7q4ddI62Ognhw+WL4FyQI+zoh0j82K
         UlAWr7caCjsITHWQh9MQ+YBQVUCngzJ0PZU6YS4H3Wym1UmO0uPdy5RQkAzk5uuy56wi
         Z0YyvhndRvycn8TxLWmeLULSj/xbLEHYUpZxHqm8W/GFwE+XxUzOpCMJfVM5yBXLDc5P
         3SOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211130; x=1793815930;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zVJqOS1cNxeL6RKZm/wJV+026QQ3gHNzQvPgsK80tiQ=;
        b=P06fBoyIPds6ghP1HJ84bVmPyABTNc1VA97/DOHm9cics+jsrRI8rX+1AHO0WT5FpP
         5xR8hS0WFxplCS9W36z3WmfWc6T4hp8dJL/FMH5ZiZOZv/u+wziCr7ku7vdeuvKkaoMS
         RRwa9qCXemq1t7A6NnCFK51DiRMTUC6kZLCYPqpu93u+jmXlUFMVl05BhaEULBGjj9LQ
         HxeF3HQozNHpnGzdIM0b713vIpAxo8JsOt87y4Mh0jgqxRhrV0DhSpLhR/TQCtEEJqqp
         g8eS6IjHwUKNW4t8TGA/fmm+4LWOPsLD+0ANucoZdMR/d9XZvhbTCa/v8jgjGysZCxX1
         hcTA==
X-Forwarded-Encrypted: i=1; AKwUvByhPcY3591pBqgua83l7cETvy0FqAPwo2PjdUf1LdD+XrITBMr/C7hXvTbEer/lvevgX+O6+SRg9qk+V5z86g==@vger.kernel.org
X-Gm-Message-State: AFq9FYLaNkH0kmUBMHC5hvNWJ5PIYAvXuQmlhB44zJ4u6XG94M9saVvG
	fk8mmnHWztazADsd7t0GiTW4QbWgt4qIUBK0HbRMkG/DG4d6N3FzOzba
X-Gm-Gg: AYBFou2xIcHt6t6WSMV/rqtdkrCB8yAknQeIoiwMgASziL1fyZtd3339tBHDeS6Ojyn
	lYVu0cj4MXSqWwwhq3L95WfnRblxt9QNo/ByUGHMsqCRJxMYfpZrp9YYZ7/njP76yDkaO2aYiRQ
	ZvN6CPqY8Zu5EKuNH3GpMjhSbejvke5HXomdp7pu0qaZ4bQnHjjnzmgBtvlEl6uFDbuGft7tEPN
	77Hh07HGsXlnGin4/MxFWa0g6181V/SwiTaTtSqM+1iIgzd1T6Vbz9L8P3usaU6o8+ArMZSjnRd
	D9M1UqCseFOe9YikDK7rwy+tV68dpIIYHV1z+Mqlp3p8S8bIh+14mDYf2UmJuAlQAkn7hQh6EWe
	FO5wj/Gn35R1PJLDlK4lM5urngflGlTWOkDppmcwiFpjtQcpJywtsQqOPNrXaswJ2nAn5I6XJDF
	4KFL6KWtLcXmRfMw/F0EN+ta/GzPz44kOMG2+SFD9fjx80xXExSQIqwlZKiWVUL0n3Fb5/mCm7v
	oqG4k4IYRZ9P7gFpVJJgqZZm9mBC8+xE20LDqC+MvQAkYysHvgulA8tgYsTAbQZASWCDblET1Jl
	NUu1PHKwbfMhlvf/IHn0tae0ZOYzIpehlUevKxUf7YDcpNYVKLAEEkHzvyMTAcdESeUUOVJE4Cg
	cJJsO7jllhvhNpbrCsATnwOEAhkAEv3Iam8y4y/to2luwHG2rJc93RY1u781UU9DgTLAHnRE7X8
	ME4g==
X-Received: by 2002:a17:90b:2541:b0:3ac:80de:44e8 with SMTP id 98e67ed59e1d1-3ae582c2b65mr2312390a91.43.1793211129947;
        Wed, 28 Oct 2026 11:12:09 -0700 (PDT)
Received: from localhost ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae6e7ac878sm536684a91.4.2026.10.28.11.12.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 11:12:09 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 28 Oct 2026 11:12:08 -0700
Message-Id: <DMGOAJTSLTRX.3NHOMSGMQXH1X@gmail.com>
Cc: <johannes@sipsolutions.net>, <arend.vanspriel@broadcom.com>,
 <b43-dev@lists.infradead.org>
Subject: Re: [PATCH wireless-next 0/5] b43: N-PHY: fix calibrations on rev7+
 (BCM43228)
From: "Rosen Penev" <rosenp@gmail.com>
To: "Luca Casati" <luk00casati@gmail.com>, <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261026181543.77763-1-luk00casati@gmail.com>
In-Reply-To: <20261026181543.77763-1-luk00casati@gmail.com>

On Mon Oct 26, 2026 at 11:15 AM PDT, Luca Casati wrote:
> On a BCM43228 (14e4:4359, N-PHY rev 16, radio 2057 rev 9) b43
> associates but transmits poorly: high retry counts and low rates.
> Comparing mmiotraces of b43 and the proprietary wl driver
> (6.30.223.271) on the same card, together with brcmsmac, turned up
> several bugs in the N-PHY calibration code:
>
>  1. The TX tone sample table was loaded as all zeros, so every
>     tone-based calibration ran without a signal.
>  2. TX IQ/LO calibration: inverted busy poll, reversed final copy,
>     and missing rev7+ cleanup that left TX dead after a cal.
>  3. RSSI calibration: wrong VCM written on rev7+, wrong distance
>     formula, wrong rounding of negative offsets.
>  4. 2057 RC calibration: the first run was polled before it started,
>     leaving SCAP at 0 and the TX low-pass filter detuned.
>  5. A missing field in the rev7 TX_PU RF override.
>
> After these, the register writes for the cals match wl's on this card.
>
> Patches 4 and 5 and the cleanup parts of patch 2 only affect rev7+.
> Patch 1, the poll and final-copy fixes in patch 2, and the
> distance/rounding fixes in patch 3 also change code that runs on older
> N-PHYs (rev3+); I could only test rev 16, so testing on other N-PHY
> cards would be welcome.
>
> Tested on the BCM43228 only (2.4 GHz, 11g/HT20), on v7.0; the series
> also applies to wireless-next. Throughput to the internet went from
> about 5.7/4.1 to 11.1/5.2 Mbit/s down/up, with fewer TX retries. That
> number is limited by the line and noisy, so take it as a rough
> indication; wl reaches 21-32 Mbit/s down on the same setup, so there
> is more to do (PAPD and TX power control on rev7+).
>
> Comments and changelogs refer to wl where the fix was checked against
> its register writes. If citing the proprietary driver is not
> acceptable here, I am happy to reword them.
>
> The bugs were found and the fixes drafted with the help of an AI
> coding assistant (Claude Opus 5.5), working from the mmiotrace diffs
> between b43 and wl and from brcmsmac. I reviewed and tested every
> patch on the hardware above.
I'll just comment here instead of the individual patches.

For all of these, Fixes: tags are appropriate. They help linux-stable
pick them up. Meaning that wireless, instead of wireless-next is the
more appropriate place for them.

The whole Assisted-by thing is deprecated. It is no longer desired to
advertize such a thing in individual commits. It's fine for a cover
letter.
>
> Luca Casati (5):
>   b43: N-PHY: fix the TX tone sample table
>   b43: N-PHY: fix TX IQ/LO calibration
>   b43: N-PHY: fix rev3+ RSSI calibration
>   b43: N-PHY: wait for the first 2057 RC calibration run
>   b43: N-PHY: add the missing override to the rev7 TX_PU command
>
>  drivers/net/wireless/broadcom/b43/phy_n.c | 120 +++++++++++++++++++---
>  1 file changed, 106 insertions(+), 14 deletions(-)
>
>
> base-commit: 028ef9c96e96197026887c0f092424679298aae8


