Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=149.157.246.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793962882;
	b=Ia1X/yB7iMAlyG+gaSSWZA/Rx6f16j+4LeSHb4EnmkvZpex1l6XzWk7o5BJJg2DZrOTW
	 sRtC+BzF+kHrILJSFI5VMQ1RXp2p6H5wXJM9OANAgE4aLh191TV2qbxEkMoeQMHwiQxXv
	 bLVqHSiAr4lQQcjaCw+FnMSP4kpTvetw5Y/eVmLZLRy8udxdwv/UZbshJ35cGfJCsvblD
	 kRMkH3Qu19NZa0B93BRGTeKKtMpbIwdv9ontx5TfrbFRfxszSBtI7moONjEyHvhWYbdbm
	 BxmsY0ULP+ZmSRryHTK7a2MRSTyv2qF6jTRU/rQgdGcvIrwOqt74+VhVwrDkwO+3KNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793962882;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Subject:
	 Message-ID:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=CJNIDZYU3b5+2LJ4URJLMNqAIniYRVz5Zd3/noBlr8M=;
	b=Jg6wwv8RKLL2LIhLRY6KExJDsZeZr6NYsqgYMWCN0lx7mwjJW9kzLKRpNyQpc5Mu2TYt
	 BK5qETldKkhnjX+MQubyH3m3chJp+Pk2MWTv/eq3qUlJqH/vhL+shtwyZd7mPnTRr/1Zl
	 LmHYfAZ/7gOjTQRaVsVzM67J03Xoa1oPIQA9lMg7TTkmm00GextmfFOmPFKC/aVm1KBae
	 cBDZcXIGx6Iu2t1TMNNKRrUPVint+Dkd/GZelNbZydrSeTITtiSWiOtRt6x9PJaN4I5yd
	 adVfwxZFMEJcOUhrFRxHoErWAZDrodsTu4mes0Ku6XiryzBJSmX82pvAU1OpFWjwVgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cs.nuim.ie;
	spf=pass smtp.mailfrom=cs.nuim.ie;
	arc=none smtp.remote-ip=149.157.246.25
Received: from mta-srv-01.cs.nuim.ie (mta-srv-01.cs.nuim.ie [149.157.246.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4025D606A333
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 11:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4025D606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cs.nuim.ie
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.nuim.ie
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.nuim.ie;
 i=@cs.nuim.ie; q=dns/txt; s=selector1; t=1793962866; h=date : from :
 to : subject : message-id : mime-version : content-type : in-reply-to
 : from; bh=yz3vk8wboI1/YRq43UihLtOW4SQjw6SgJLNDWiYEgXw=;
 b=TDlKyLy0lvgXCUhEBCWboDohrOHaosBhMYStBJa/eo/aeM7uV7nDDt5uc7RGJt9U+cx3+
 U5dPervPLm24e1V5K2rVewntnL8wx5FuvRbphAyQ4R9MGS+bT++L3kbh7qDVx93YYdt/HWc
 dnTmtu87EYlOgZzllHbowtt1HhRFQQWS7txWNZjNTJElb0aHu+Yuel9QMqElZnMGzheXClf
 HyuT6mDsMPVIJf6OEoJdLSyKXDFDjoB+jVZtSbDymgf//ACjoQFXRpRkqNd2dRbanKvvP5p
 OzIGIeF9DhHz1V//TQ0U4R2els4QZ65jpP9b/Gb84bOGjIajox5GmTLdHTAQ==
Received: from port-kadr (port-kadr.cs.nuim.ie [149.157.248.96])
	by mta-srv-01.cs.nuim.ie (Postfix) with ESMTPS id 91F41600A5;
	Fri,  6 Nov 2026 11:01:06 +0000 (GMT)
Received: from barak by port-kadr with local (Exim 4.100.1)
	(envelope-from <barak@port-kadr.cs.nuim.ie>)
	id 1xPHgw-0000000Ag9X-241b;
	Fri, 06 Nov 2026 11:01:06 +0000
Date: Fri, 6 Nov 2026 11:01:06 +0000
From: Barak Pearlmutter <barak@cs.nuim.ie>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw88: extend USB TX report timeout to RTL8822BU
Message-ID: <au2zcmgiO7t35EZp@port-kadr.cs.nuim.ie>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531223349.5952-1-Volcomilluminated@airmail.cc>

I can confirm the "failed to get tx report from firmware" issue on an
RTL8822BU USB adapter and provide additional context about its impact.

Device:
  RTL88x2bu AC1200 USB WiFi adapter
  USB ID: 0bda:b812
  Driver: rtw88_8822bu (in-tree)
  Firmware: version 30.20.0, H2C version 14
  Kernel: 7.2.15+deb14-amd64 (Debian 13 / linux-image-amd64)
  Note: this is a Debian-patched kernel; Debian-specific patches may be
  relevant, though the rtw88 driver is unlikely to be heavily patched.

Symptoms observed:

1. Slow-fire mode (possibly normal operation): "failed to get tx report
   from firmware" appears roughly every 5 minutes during extended idle
   periods.  The link remains associated but throughput degrades.

2. Rapid-fire mode (fatal): The message appears multiple times per
   second.  The interface deauthenticates and does not recover without a
   USB reset of the device.

The rapid-fire mode is frequently triggered indirectly by a companion
Realtek Bluetooth adapter (0bda:a725, RTL8761BU) on the same host
entering its own failure loop after USB autosuspend (see separate report
to linux-bluetooth).  When the BT device is in a 2-second USB reset
storm, the WiFi "failed to get tx report" messages begin within seconds
and escalate to rapid-fire within ~20 minutes.

Workarounds currently applied:
  - USB autosuspend disabled for 0bda:b812:
      ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0bda",
        ATTRS{idProduct}=="b812", ATTR{power/autosuspend}="-1"
  - WiFi PSM disabled on interface up:
      ACTION=="add", SUBSYSTEM=="net", ATTRS{idVendor}=="0bda",
        ATTRS{idProduct}=="b812", RUN+="/usr/sbin/iw dev %k set power_save off"

These reduce but do not eliminate the slow-fire messages.  Extending the
TX report timeout as proposed in the referenced patch would address the
root cause.

Relevant log excerpt (slow-fire, link still up):

  kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
  [~5 minutes pass]
  kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
  [repeat]

Relevant log excerpt (rapid-fire leading to deauth):

  kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
  kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
  kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
  kernel: rtw88_8822bu 4-5:1.0: failed to get tx report from firmware
  kernel: wlx1cbfceb2abdb: deauthenticating from cc:2d:21:70:11:fd by local choice (Reason: 3=DEAUTH_LEAVING)
  kernel: usb 4-5: reset SuperSpeed USB device number 3 using xhci_hcd
  kernel: rtw88_8822bu 4-5:1.0: Firmware version 30.20.0, H2C version 14
  [reconnects after USB reset]

Happy to test a patched kernel or provide further information.

Barak Pearlmutter <barak@cs.nuim.ie>
