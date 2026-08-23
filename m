Received: from mta1.migadu.com (out-194.mta1.migadu.com [95.215.58.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317173C1406
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 06:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787464828; cv=none; b=G9PslRcVHd4S7F1ekA4jpCfCOlJHmj5xZWfso1MKEqhAHhOAc/KLeUu3IZf8pY8rQTfxcXKyL7JWui4nwumb4RwUvT4VIC6krmlaj39VC6r/u+ybxThHvQ+9RRMkGuOqd+WurMw+EejBKaLiIBBLfpPolPlTzX//apTSs8shqQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787464828; c=relaxed/simple;
	bh=5ydvNREy/S6XhUItg1kzql+IrCqtwCAIhDNNKVgDFBA=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=a8T4+Kd9O7X6VlTkjRgY5LgfyV5k52nphSgRYV8PfIu0KuzJtoq2BMoDX2HWhXA49orw6tV+rlbjasU6ku1NxCTTa6rjY8XBW+rTJ2Vc42S/GC/5n2/W/ntpm+NcJRbJpmGQplJvOQUYF+h0HQrTtdqAob9JtI42PRPm+3KaEyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HDBps3ua; arc=none smtp.client-ip=95.215.58.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HDBps3ua"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5ydvNREy/S6XhUItg1kzql+IrCqtwCAIhDNNKVgDFBA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787464821; v=1; x=1788069621;
 b=HDBps3uamePGfnuOgmkNy/yFD00WKY4fna3VEeJRZk8Zlm6siTXqXf7qdxL4A/IuNLSP2QP2
 GgU7Aryz/Z/3NVqlX1r7ZyVbWWAKZhDF9fqqC6SjqrFlzssh3asSe8ruI16MSQq+1SaWbrShQ5I
 wwo+CiZm2jj6NpVWLpu4m2RA=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (2a06:63c5:9b00:3900:6849:2575:4516:d712)
	by smtp.migadu.com with ESMTPS id 960ac8f5cdad782c;
	Sun, 23 Aug 2026 06:00:11 +0000
X-Mizu-Trace-ID: 960ac8f5cdad782c
X-Migadu-Flow: FLOW_OUT
Date: Sun, 23 Aug 2026 08:00:09 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: Re: [PATCH v7 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
User-Agent: Thunderbird for Android
In-Reply-To: <44120736-F50E-4AD0-A380-3CEBB6A2F7F4@linux.dev>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <44120736-F50E-4AD0-A380-3CEBB6A2F7F4@linux.dev>
Message-ID: <C16E411D-37A6-484C-80ED-593AA5596A1B@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 22, 2026 6:51:59 PM GMT+02:00, Luka Gejak <luka=2Egejak@linux=2Ed=
ev> wrote:
>On August 20, 2026 11:04:06 AM GMT+02:00, luka=2Egejak@linux=2Edev wrote:
>>From: Luka Gejak <luka=2Egejak@linux=2Edev>
>>
>>This is the first of two series adding support for the Realtek RTL8723B

=2E=2E=2E

>Nothing in this series changes=2E The rate is about one in 9200 wakes=2E
>
>Best regards,
>Luka Gejak

Follow up to the previous email:

The soak has run on since that mail=2E Over 110557 wakes there is now one
poll 3, still no poll 4, and four failures:

        poll0=3D158 poll1=3D110557 poll2=3D35 poll3=3D1 poll4=3D0 fails=3D=
4

So failures outnumber poll 3 successes, which makes the point stronger,
not weaker=2E The rate is about 1 in 27600 wakes rather than the 1 in
9200, which I quoted from the smaller sample=2E

Best regards,
Luka Gejak
