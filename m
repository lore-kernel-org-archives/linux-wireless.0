Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76FD3F9294
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791560040; cv=none; b=a61QRqdMwj7/dnh/NkeH8GGUAJjmLrJhQxg0+NTHfeBb8BYplKIuESB1m6wleyS7h+WeG4EwZko08F0/+uTqkpyn3alAQhtPovyjbRrqIei6g3kK93ksTLNIXs/PJmlUrTfriT9hY091VuCSj9GUOJeWZoAJSs/kj+2gr4n7XHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791560040; c=relaxed/simple;
	bh=n/NzbpOSR98LD7NIhdW6/HMkUVUpaovwUvRlXeZLHbo=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=rDs0LkR4axJi8BCfUZwILv4IC5M3xcX7WbJDitxMNMfNepljLn0gntNy1HZAnvBdeFXHYHlGF6DiEFDl24voxM21FtPzvPl9kL1hlZaQ0qx3Qmb3l8HhYHNvIUDUpQgxom9R8a5QQYcDQiNrug9UzD5POokFlmVbDBRVmB3w91M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ch0n9HhP; arc=none smtp.client-ip=95.215.58.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ch0n9HhP"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=n/NzbpOSR98LD7NIhdW6/HMkUVUpaovwUvRlXeZLHbo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791560036; v=1; x=1792164836;
 b=ch0n9HhPNpKYpRuYvMF4LH9gmQo8+3L5ZlGYJ9ZlkixW1d3pw8Ff0uKmDc9u2HbPnOFvym4c
 GDLk8eYdeOfIHwT1oRXZwWHqPkGC7Xl1VRSXC3KQbP2+3yS7SBUQHXKg61/c18L1r8aSdUqaLM1
 noxg6/k7TIYa/XXBHc7okLBc=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1de585663ba371b8;
	Fri, 09 Oct 2026 15:33:56 +0000
X-Mizu-Trace-ID: 1de585663ba371b8
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 09 Oct 2026 17:33:50 +0200
Message-Id: <DM0F103PEZKZ.3BTGPMVOEZAUC@linux.dev>
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>, "Luka Gejak"
 <luka.gejak@linux.dev>, "Ping-Ke Shih" <pkshih@realtek.com>
Cc: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 "Michael Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <d95aacb8-0032-4d6c-b847-3103afbc3124@gmail.com>
In-Reply-To: <d95aacb8-0032-4d6c-b847-3103afbc3124@gmail.com>

On Fri Oct 9, 2026 at 2:40 PM CEST, Bitterblue Smith wrote:
> On 06/10/2026 16:06, Luka Gejak wrote:
>> Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
>> power sequences, the efuse layout, the RF and IQ calibration, and the
>> chip specific coexistence handling.
[...]
>> +{
>> +	/*
>> +	 * The 8723B PHY status does not report the channel, so we must
>> +	 * mark it invalid to allow mac80211/rtw88 to parse it from the IE
>> +	 * during scanning.
>> +	 */
>> +	pkt_stat->channel_invalid =3D true;
>
> After testing RTL8723BU for a bit, I think this is wrong.
>
> mac80211 thinks there is massive beacon loss when connected to a network
> with 40 MHz channel width, but phy_info in debugfs shows that beacons are
> being received. The beacons are handed over to mac80211 with a wrong
> frequency in struct ieee80211_rx_status. In my case, the correct frequenc=
y
> is 2472 MHz, but after rtw_update_rx_freq_from_ie() the frequency is set
> to 2462 MHz. mac80211 is probably discarding the beacons because of this.
> Removing this line fixes the problem.
>
> I think channel_invalid is only for chips which do hardware scan offload
> (RTL8822C). With the chips that only do software scanning the driver
> should always know what channel it's on and rtw_update_rx_freq_from_ie()
> is not needed.
>

You are right, and thanks for chasing this down.

The assignment causes it. With channel_invalid set, the frequency handed
to mac80211 comes from rtwdev->hal.current_channel, which
rtw_update_channel() sets to the center channel rather than the primary.
At 40 MHz those differ, so mac80211 drops the beacon in
ieee80211_rx_beacon_freq_valid(). Data frames are not checked, so
traffic keeps flowing and only beacon loss builds up.

On the RTL8723BS I could not reproduce it, because there the update is a
no-op. rtw_sdio_rx_skb() copies the status into skb->cb before it calls
rtw_update_rx_freq_for_invalid() and never copies it back, so the change
is discarded. usb.c and pci.c call it before their memcpy into skb->cb,
which is why you see it on the RTL8723BU. With the SDIO path made to
apply it I got your symptom exactly (2452 instead of 2462, beacon rx 0,
beacon loss 26, while rtw88 still counted the beacons), and removing
channel_invalid put it back to 2462 with no beacon loss.

I will send a patch removing the assignment and the comment above it.

Best regards,
Luka Gejak
